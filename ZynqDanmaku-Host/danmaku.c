#define _GNU_SOURCE
#include "danmaku_driver.h"

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <assert.h>
#include <stdbool.h>
#include <wchar.h>
#include <locale.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>
#include <signal.h>
#include <limits.h>
#include <time.h>
#include <stdatomic.h>

#include <ft2build.h>
#include FT_FREETYPE_H

#include <gpiod.h>

#include "render.h"
#include "ring.h"
#include "constants.h"

// #define OVERLAY_PROFILING_PRINT
// #define RENDER_PROFILING_PRINT

pthread_mutex_t render_overlay_mutex;
pthread_cond_t  render_overlay_cv;

typedef char inp_char_t;

struct gpiod_chip *gpio_context;
DANMAKU_HW_HANDLE hDriver;
gpointer render_instance;
PangoContext *render_context;

int edge; // edge in pixel for each character
int screen_width; // screen width in pixels
int screen_height; // screen height in pixels
int img_size;
volatile atomic_int render_running, sigint;
volatile atomic_int button_ip_click, start_image_capture;

uint8_t *blank_screen;
uint32_t blank_screen_phy;

uint8_t *image_captured;
uint32_t image_captured_phy;

struct gpiod_line *gpio_center_btn, *gpio_imgcap_en;
struct timespec last_btn_change;
int last_btn_value;

int strlen_utf8_c(char *s) {
   int i = 0, j = 0;
   while (s[i]) {
     if ((s[i] & 0xc0) != 0x80) j++;
     i++;
   }
   return j;
}

void intHandler(int dummy) {
    render_running = 0;
    sigint = 1;
}

char PrintPixel(uint8_t n)
{
    switch (n) {
        case PXL_HSYNC:
            return 'H';
            break;
        case PXL_VSYNC:
            return 'V';
            break;
        case PXL_BLANK:
            return 'B';
            break;
        default:
            return '0' + n;
    }
}

void PrintBuf(uint8_t* buf)
{
    for (int i = 0; i < img_size; i++) {
        fprintf(stderr, "%c", PrintPixel(buf[i]));
    }
}

// fill map with blank color
void FillBlank(uint8_t map[][MAX_WIDTH * 2], int head, int len)
{
    assert(head + len <= MAX_WIDTH * 2);
    for (int i = 0; i < MAX_HEIGHT; i++) {
        for (int j = head; j < head + len; j++) {
            map[i][j] = PXL_BLANK;
        }
    }
}

// ==========================
// Font map interfaces.
bool InitFontMap()
{
    const PangoViewer *view = &pangoft2_viewer;
    render_instance = view->create (view);
    render_context = view->get_context (render_instance);
    return true;
}

void ClearFontMap()
{
    const PangoViewer *view = &pangoft2_viewer;
    g_object_unref (render_context);
    view->destroy (render_instance);
}

void WriteFontMap(uint8_t map[][MAX_WIDTH * 2], inp_char_t *text, int len, int* out_width)
{
    static uint8_t map1[MAX_HEIGHT][MAX_WIDTH * 2];
    const PangoViewer *view = &pangoft2_viewer;
    for (int i = 0; i < edge; i++) {
        for (int j = 0; j < edge * len; j++) {
            map[i][j] = PXL_BLANK;
            map1[i][j] = PXL_BLANK;
        }
    }

    int color = rand() % 8; // valid color: 0x0 ~ 0x7
    // printf("color selected: %d\n", color);
    int reverse = color ^ 7;

    render_setopt_text(text);

    gpointer surface;
    int width=1, height=1;
    surface = view->create_surface (render_instance, width, height);
    view->render (render_instance, surface, render_context, &width, &height, NULL);
    view->destroy_surface (render_instance, surface);
    surface = view->create_surface (render_instance, width, height);
    view->render (render_instance, surface, render_context, &width, &height, NULL);
    printf("render: %dx%d\n", width, height);

    *out_width = MIN(width, MAX_WIDTH);

    FT_Bitmap *bitmap = (FT_Bitmap *) surface;
    for (int i = 0; i < edge; ++i)
    {
        for (int j = 0; j < *out_width; ++j)
        {
            map1[i][j] = i>=height || *(bitmap->buffer + i * bitmap->pitch + j) >= 128 ? PXL_BLANK : color;
        }
    }
    view->destroy_surface (render_instance, surface);
    for (int i = 0; i < edge; i++) {
        for (int j = 0; j < *out_width; j++) {
            if (map1[i][j] == color) {
                map[i][j] = map1[i][j];
            } else if (
                (i + 1 < edge && map1[i + 1][j] == color) ||
                (j + 1 < len * edge && map1[i][j + 1] == color) ||
                (i - 1 > 0 && map1[i - 1][j] == color) ||
                (j - 1 > 0 && map1[i][j - 1] == color)
            ) {
                map[i][j] = reverse;
            }
        }
    }
}


// ==========================
// Sliding layer: slide from right to left.
typedef struct {
    int x, y; // left top point
    int width; // width
    int ppc; // pixels sliding per cycle
    bool enable;

    uint8_t (*map)[MAX_WIDTH * 2]; // pixel map (color for each pixel)
    uint8_t (*map_phy)[MAX_WIDTH * 2]; //physical address of pixel map
} sliding_layer_t;


void InitSliding(sliding_layer_t *s, int y)
{
    s->enable = false;
    s->y = y;
    DanmakuHW_AllocRenderBuf(hDriver, (uintptr_t*)&s->map, (uintptr_t*)&s->map_phy, MAX_HEIGHT*(MAX_WIDTH*2));
}

void SlidingNextCycle(sliding_layer_t *s)
{
    if (!s->enable) {
        return;
    }

    s->x -= s->ppc;
    if (s->x < -s->width) {
        s->enable = false;
    }
}

void SlidingSetDanmu(sliding_layer_t *s, inp_char_t *text, int len)
{
    assert(!s->enable);

    WriteFontMap(s->map, text, len, &s->width);
    s->enable = true;
    s->x = screen_width;
    s->ppc = 1 + ((s->width + screen_width) / CYCLE_PER_DANMU);
}

// write one sliding layer
void SlidingWritePixels(uint8_t *dst, sliding_layer_t *s)
{
    if (!s->enable) {
        return;
    }

    int y = edge * s->y;
    uint32_t line_base = y * (screen_width + 2);
    int xfrom = s->x;
    int xto = s->x + s->width - 1;
    int src_x = 0;
    if(xfrom >= screen_width || xto < 0 || xto<xfrom)
        return;
    if(xfrom < 0){
        src_x = -xfrom;
        xfrom = 0;
    }
    if(xto >= screen_width) xto = screen_width-1;
    for (int i = 0; i < edge; i++) {
        uint32_t addr_xfrom = (line_base + xfrom);
        uint32_t addr_xto = (line_base + xto);
        while(render_running && DanmakuHW_RenderStartDMA(hDriver, (uintptr_t)&dst[addr_xfrom], (uintptr_t)&s->map_phy[i][src_x], addr_xto - addr_xfrom + 1)<0)
            DanmakuHW_WaitForRenderDMA(hDriver);
        line_base += (screen_width + 2);
    }
}

void InitBlankScreen(void)
{
    uint32_t offset = 0;
    DanmakuHW_AllocRenderBuf(hDriver, (uintptr_t*)&blank_screen, &blank_screen_phy, img_size);
    for (int i = 0; i < screen_height; i++) {
        for (int j = 0; j < screen_width; j++) {
            blank_screen[offset++] = 0x10 | PXL_BLANK;
        }
        if (i < screen_height - 1) {
            blank_screen[offset++] = PXL_HSYNC;
            blank_screen[offset++] = PXL_HSYNC;
        }
    }
    // fill blank until reach img_size
    while (offset < img_size) {
        blank_screen[offset++] = 0x10 | PXL_BLANK;
    }

    // fill last two with VSYNC
    blank_screen[img_size - 1] = PXL_VSYNC;
    blank_screen[img_size - 2] = PXL_VSYNC;

}
// clear screen
void ClearScreen(uint8_t *dst)
{
    int blocks = 8;
    int blk_size = img_size/blocks;
    /*
    for (int i = blocks-1; i >= 0; --i)
    {
        while(render_running && DanmakuHW_RenderStartDMA(hDriver, dst+blk_size*i, blank_screen_phy+blk_size*i, blk_size)<0)
        pthread_yield();
        // usleep(100);
    }
    if(img_size%blocks!=0){
        while(render_running && DanmakuHW_RenderStartDMA(hDriver, dst+blk_size*blocks, blank_screen_phy+blk_size*blocks, img_size%blocks)<0)
        pthread_yield();
    }
    */
    while(render_running && DanmakuHW_RenderStartDMA(hDriver, (uintptr_t)dst, blank_screen_phy, img_size)<0)
        DanmakuHW_WaitForRenderDMA(hDriver);
}   


// ==========================
// Static layer: leaving on the first row on screen.
typedef struct {
    bool enable; // whether to enable static layer
    int counter;
    int valid_len; // actual length (in pixels) after setting text
    int y;

    uint8_t (*map)[MAX_WIDTH * 2]; // pixel map (color for each pixel)
    uint8_t (*map_phy)[MAX_WIDTH * 2]; //physical address of pixel map
} static_layer_t;

void InitStatic(static_layer_t *s, int y)
{
    s->y = y;
    s->enable = false;
    s->counter = 0;
    DanmakuHW_AllocRenderBuf(hDriver, (uintptr_t*)&s->map, (uintptr_t*)&s->map_phy, MAX_HEIGHT*(MAX_WIDTH*2));
    FillBlank(s->map, 0, MAX_WIDTH * 2);
}

void ForceStaticSetDanmu(static_layer_t *s, inp_char_t *text, int len)
{
    // set
    WriteFontMap(s->map, text, len, &s->valid_len);
    s->enable = true;
    s->counter = 0;
}

bool StaticSetDanmu(static_layer_t *s, inp_char_t *text, int len)
{
    if (s->enable) {
        return false;
    }
    // set
    ForceStaticSetDanmu(s, text, len);
    return true;
}

void StaticNextCycle(static_layer_t *s)
{
    if (s->enable) {
        ++s->counter;
        if (s->counter >= DURATION) {
            s->enable = false;
        }
    }
}

void StaticWritePixels(uint8_t *dst, static_layer_t *s)
{
    if (!s->enable) {
        return;
    }

    int y = edge * s->y;
    uint32_t line_base = y * (screen_width + 2);
    int xfrom;
    if (screen_width > s->valid_len) {
        xfrom = (screen_width - s->valid_len) / 2;
    } else {
        xfrom = 0;
    }
    int xto = xfrom + s->valid_len - 1;
    if(xfrom >= screen_width || xto < 0 || xto<xfrom)
        return;
    if(xfrom < 0) xfrom = 0;
    if(xto >= screen_width) xto = screen_width-1;
    for (int i = 0; i < edge; i++) {
        uint32_t addr_xfrom = (line_base + xfrom);
        uint32_t addr_xto = (line_base + xto);
        while(render_running && DanmakuHW_RenderStartDMA(hDriver, (uintptr_t)&dst[addr_xfrom], (uintptr_t)&s->map_phy[i][0], addr_xto - addr_xfrom + 1)<0)
            DanmakuHW_WaitForRenderDMA(hDriver);
        line_base += (screen_width + 2);
    }
}


// global layers
sliding_layer_t sliding_layers[SLIDING_LAYER_ROWS][SLIDING_LAYER_COLS];
static_layer_t static_layers[NUM_STATIC_LAYER];

// temporary buffer for stdin
inp_char_t input_buf[MAX_TEXT_LEN];

// ==========================
// Main render process.
bool InsertSliding(inp_char_t *buf_sliding)
{
    int len = strlen_utf8_c(buf_sliding);
    for (int i = 0; i < SLIDING_LAYER_ROWS; i++) {
        for (int j = 0; j < SLIDING_LAYER_COLS; j++) {
            if (!sliding_layers[i][j].enable) {
                bool conflict = false;
                for (int k = 0; k < SLIDING_LAYER_COLS; k++) {
                    if (j != k && sliding_layers[i][k].enable && sliding_layers[i][k].x +
                        sliding_layers[i][k].width > screen_width) {
                        conflict = true;
                        break;
                    }
                }
                if (!conflict) {
                    SlidingSetDanmu(&sliding_layers[i][j], buf_sliding, len);
                    // printf("inserted into sliding layer (%d, %d), len=%d\n", i, j, len);
                    return true;
                }
            }
        }
    }

    return false;
}

bool InsertStatic(inp_char_t *buf_static)
{
    int len = strlen_utf8_c(buf_static);
    for (int i = 0; i < NUM_STATIC_LAYER; i++) {
        if (StaticSetDanmu(&static_layers[i], buf_static, len)) {
            // printf("inserted into static layer %d, len=%d\n", i, len);
            return true;
        }
    }

    int c = rand() % NUM_STATIC_LAYER;
    ForceStaticSetDanmu(&static_layers[c], buf_static, len);
    // printf("force inserted into static layer %d, len=%d\n", c, len);
    return true;
}

#define QUEEN_SIZE 4096

typedef struct {
    inp_char_t str[QUEEN_SIZE][MAX_TEXT_LEN];
    int head;
    int tail;
} queen_t;

void InitQueen(queen_t *queen)
{
    queen->head = 0;
    queen->tail = 0;
}

bool Fetch(queen_t *queen, inp_char_t *dst)
{
    if (queen->tail == queen->head) {
        return false;
    }

    strcpy(dst, queen->str[queen->head]);
    return true;
}

void Pop(queen_t *queen)
{
    if (queen->tail - queen->head > 0) {
        queen->head++;
    }
}

void ClearQueen(queen_t *queen)
{
    int len = queen->tail - queen->head;
    for (int i = 0; i < len; i++) {
        strcpy(queen->str[i], queen->str[queen->head + i]);
    }
    queen->head = 0;
    queen->tail = len;
}

void Push(queen_t *queen, const inp_char_t *src)
{
    if (queen->tail >= QUEEN_SIZE) {
        ClearQueen(queen);
    }
    strcpy(queen->str[queen->tail++], src);
}

queen_t sliding_queen, static_queen;

void BtnEventHandle(void)
{
    if(button_ip_click){
        button_ip_click = 0;
        const char* cmd[] = {"ip a s dev eth0 |grep inet", "ip r |grep default", "ip -6 r |grep default"};
        int line_limit = 2;
        for (int i = 0; i < sizeof(cmd)/sizeof(cmd[0]); ++i)
        {
            FILE * out = popen(cmd[i],"r");
            if(!out)
                continue;
            for(int j=0;j<line_limit && !feof(out);j++){
                const char *p = input_buf;
                if(!fgets(input_buf, MAX_TEXT_LEN, out))
                    break;
                while(*p!='\0' && *p<=' ')p++;
                printf("got '%s'\n", p);
                if(strlen(p)>8)
                    Push(&static_queen, p);
                else
                    break;
            }
            pclose(out);
        }
    }
}
void RenderOnce(uint8_t* buf)
{
    ClearScreen(buf);


    // save danum
    inp_char_t *ret = fgets(input_buf, MAX_TEXT_LEN, stdin);
    if (ret == NULL) {
        // printf("nothing fetched\n");
        BtnEventHandle();
    } else {
        printf("->%s",ret);
        // fputws(input_buf + 1, stdout);
        // int len = strlen_utf8_c(input_buf + 1);
        // printf("codes:");
        // for (int i = 1; i < len; i++) {
            // printf("%d ", input_buf[i]);
        // }
        // printf("\n");
        // printf("type: %d\n", input_buf[0]);
        int l = strlen(ret);
        if(l > 1 && ret[l-1] < ' ')
            ret[l-1]='\0'; //remove \n
        switch (input_buf[0]) {
            case '0':
                Push(&sliding_queen, input_buf + 1);
                break;
            case '1':
                Push(&static_queen, input_buf + 1);
                break;
            default:
                fprintf(stderr, "unknown type: %c\n", input_buf[0]);
                break;
        }
    }

    // fetch danmu
    inp_char_t tmp[MAX_TEXT_LEN];

    bool r = Fetch(&sliding_queen, tmp);
    if (r && InsertSliding(tmp)) {
        // printf("fetch from sliding queen:\n");
        // fputws(tmp, stdout);
        Pop(&sliding_queen);
    }

    r = Fetch(&static_queen, tmp);
    if (r && InsertStatic(tmp)) {
        // printf("fetch from static queen:\n");
        // fputws(tmp, stdout);
        Pop(&static_queen);
    }

    // apply a cycle
    for (int i = 0; i < SLIDING_LAYER_ROWS; i++) {
        for (int j = 0; j < SLIDING_LAYER_COLS; j++) {
            SlidingNextCycle(&sliding_layers[i][j]);
        }
    }
    for (int i = 0; i < NUM_STATIC_LAYER; i++) {
        StaticNextCycle(&static_layers[i]);
    }

    // render
    int offset = 0;
    for (int i = 0; i < SLIDING_LAYER_ROWS; i++) {
        for (int j = 0; j < SLIDING_LAYER_COLS; j++) {
            SlidingWritePixels(buf, &sliding_layers[i][j]);
        }
    }
    for (int i = 0; i < NUM_STATIC_LAYER; i++) {
        StaticWritePixels(buf, &static_layers[i]);
    }
}

int ResolutionChanged(int locked_thres)
{
    static uint32_t height_locked,width_locked,count_locked;
    uint32_t height,width;
    DanmakuHW_GetFrameSize(hDriver, &height, &width);
    if(height!=height_locked || width!=width_locked){
        printf("screen changed: %d * %d, count_locked(last) = %d\n", width, height, count_locked);
        height_locked = height;
        width_locked = width;
        count_locked = 0;
    }else{
        if(count_locked < 10000) // limited count_locked
            count_locked ++;
    }
    if(count_locked == locked_thres && (height!=screen_height || width!=screen_width)){
        printf("locked: %d * %d\n", width, height);
        return 1;
    }
    return 0;
}

struct deque_t EmptyBufQ, FilledBufQ;

void Render()
{
    struct timespec begin, end;
    pthread_mutex_lock(&render_overlay_mutex);
    DequeInit(&EmptyBufQ);
    DequeInit(&FilledBufQ);
    for(int i=0; i<NUM_FRAME_BUFFER-1; i++)
        DequePushBack(&EmptyBufQ, i);
    for(int i=0; i<NUM_FRAME_BUFFER; i++)
        ClearScreen((void*)DanmakuHW_GetFrameBuffer(hDriver, i));
    DanmakuHW_RenderFlush(hDriver);
    while(!DanmakuHW_RenderDMAIdle(hDriver))
        DanmakuHW_WaitForRenderDMA(hDriver);
    printf("render running\n");
    render_running = 1;
    while (render_running) {
        int idx;
        //Keep at least one empty buffer for safety
        // while(render_running && DequeSize(&EmptyBufQ) <= 1)
        //     pthread_yield();
        // if(!render_running)
        //     break;
#ifdef RENDER_PROFILING_PRINT
        clock_gettime(CLOCK_MONOTONIC, &begin);
#endif

        while(render_running && (idx = DequeFront(&EmptyBufQ)) == -1)
            pthread_yield();
        if(!render_running)
            break;
        // fprintf(stderr,"render %d\n", idx);
        DequePopFront(&EmptyBufQ);

        void* fb = (void*)DanmakuHW_GetFrameBuffer(hDriver, idx);
#ifdef RENDER_PROFILING_PRINT
        clock_gettime(CLOCK_MONOTONIC, &end);
        printf("render got %d, %lf\n", 
            idx, end.tv_sec - begin.tv_sec + 1e-9*(end.tv_nsec - begin.tv_nsec));
        begin = end;
#endif
        RenderOnce((uint8_t*)fb);
        while(render_running && !DanmakuHW_RenderDMAIdle(hDriver))
            DanmakuHW_WaitForRenderDMA(hDriver);
        if(!render_running)
            break;
        DanmakuHW_RenderFlush(hDriver);
        while(render_running && !DanmakuHW_RenderDMAIdle(hDriver))
            DanmakuHW_WaitForRenderDMA(hDriver);
        if(!render_running)
            break;
#ifdef RENDER_PROFILING_PRINT
        clock_gettime(CLOCK_MONOTONIC, &end);
        printf("render %d done, %lf\n", 
            idx, end.tv_sec - begin.tv_sec + 1e-9*(end.tv_nsec - begin.tv_nsec));
#endif
        DequePushBack(&FilledBufQ, idx);
    }
    render_running = 0;
    pthread_mutex_unlock(&render_overlay_mutex);
}

void SetCPUAffinity(void)
{
   int s, j;
   cpu_set_t cpuset;
   pthread_t thread;

   thread = pthread_self();

   CPU_ZERO(&cpuset);
   CPU_SET(OVERLAY_ASSOCIATE_CPU, &cpuset);

   s = pthread_setaffinity_np(thread, sizeof(cpu_set_t), &cpuset);
   if (s != 0)
       perror("pthread_setaffinity_np");

   /* Check the actual affinity mask assigned to the thread */

   s = pthread_getaffinity_np(thread, sizeof(cpu_set_t), &cpuset);
   if (s != 0)
       perror("pthread_getaffinity_np");

   printf("Set returned by pthread_getaffinity_np() contained:\n");
   for (j = 0; j < CPU_SETSIZE; j++)
       if (CPU_ISSET(j, &cpuset))
           printf("    CPU %d\n", j);

}

void *Thread4Overlay(void *t) 
{
    struct timespec begin, end;
    int idx;
    int last_cnt=0;
    struct timespec last_stamp,stamp;
    int tag2idx[DMA_TAG_SIZE];
    int tag_cmplt = 0, tag_submitted = 0, n_in_dma = 0;
    int prev_cmplt_idx = -1;

    while(!render_running){
        if(sigint)
            return 0;
        pthread_yield();
    }
    printf("Thread4Overlay started\n");

    // Wait until original pixel data consumed
    for (int fifosize = 1; fifosize > 0; usleep(10000))
    {
        DanmakuHW_GetFIFOUsage(hDriver, &fifosize);
    }

    SetCPUAffinity();

    printf("Waiting for the first rendered frame\n");
    while(render_running && (idx = DequeFront(&FilledBufQ)) == -1)
        pthread_yield();
    if(!render_running) return 0;
    // fprintf(stderr,"get buf %d\n", idx);
    DequePopFront(&FilledBufQ);

    printf("Thread4Overlay loop begin\n");
    DanmakuHW_ClearResponse(hDriver);
    memset(tag2idx, -1, sizeof(tag2idx));
    clock_gettime(CLOCK_MONOTONIC, &last_stamp);

    for(int frame_cnt=1,dup_cnt=0;render_running;frame_cnt++){

        n_in_dma++;
        tag_submitted = (tag_submitted+1)%DMA_TAG_SIZE;
        tag2idx[tag_submitted] = idx;
        // fprintf(stderr,"in [%d] %d\n", tag_submitted, idx);
        DanmakuHW_FrameBufferTxmit(hDriver, idx, tag_submitted, img_size);

        if(n_in_dma >= NUM_OVERLAY_SUBMITTED){
            // Now, there are quite a lot of frames inside the FIFO of DMA
            // Wait until a least one of them completed
#ifdef OVERLAY_PROFILING_PRINT
            int min_waterlevel = INT_MAX;
            clock_gettime(CLOCK_MONOTONIC, &begin);
#endif
            bool ok, err;
            int tag;
            for(;render_running;pthread_yield()){
#ifdef OVERLAY_PROFILING_PRINT
                int fifosize;
                DanmakuHW_GetFIFOUsage(hDriver, &fifosize);
                // if(fifosize < 1000)
                //     printf("!fifo %d\n", fifosize);
                if(fifosize < min_waterlevel)
                    min_waterlevel = fifosize;
#endif

                DanmakuHW_ResponseOfOverlay(hDriver, &ok, &err, &tag);
                if(!ok && !err)
                    continue;
                if(tag != tag_cmplt)
                    break;
            }
            if(!render_running)
                break;
#ifdef OVERLAY_PROFILING_PRINT
            clock_gettime(CLOCK_MONOTONIC, &end);
            printf("overlay done, %d %lf\n", 
                min_waterlevel, end.tv_sec - begin.tv_sec + 1e-9*(end.tv_nsec - begin.tv_nsec));
#endif
            do{
                tag_cmplt = (tag_cmplt+1)%DMA_TAG_SIZE;
                // fprintf(stderr,"out[%d] %d\n", tag_cmplt, tag2idx[tag_cmplt]);
                assert(tag2idx[tag_cmplt] != -1);

                if(tag2idx[tag_cmplt] != prev_cmplt_idx && prev_cmplt_idx != -1){
                    // fprintf(stderr,"put buf %d\n", prev_cmplt_idx);
                    DequePushBack(&EmptyBufQ, prev_cmplt_idx);
                }
                prev_cmplt_idx = tag2idx[tag_cmplt];
                tag2idx[tag_cmplt] = -1;
                n_in_dma--;

            }while(tag_cmplt != tag);
        }

        //Keep at least one filled buffer
        if(DequeSize(&FilledBufQ) > 1){
            //render done, switching buffer

            idx = DequeFront(&FilledBufQ);
            assert(idx != -1);
            // fprintf(stderr,"get buf %d\n", idx);
            DequePopFront(&FilledBufQ);

        }else{
            dup_cnt++;
            printf("dup  -----  %d/%d\n", dup_cnt, frame_cnt);
        }

    }
    return 0;
}

void InitBtnDetect(void)
{
    gpio_center_btn = gpiod_chip_find_line(gpio_context, "btn-center");
    int ret = gpiod_line_request_input(gpio_center_btn, "danmaku");
    if(ret){
        printf("gpiod_line_request_input failed for btn-center\n");
    }
    last_btn_value = 0;
}

void BtnDetect(void)
{
    int value_now = gpiod_line_get_value(gpio_center_btn);
    if(value_now < 0)
        return;

    if(value_now != last_btn_value){
        struct timespec now;
        clock_gettime(CLOCK_MONOTONIC, &now);
        printf("center button %d->%d\n", last_btn_value, value_now);
        if(last_btn_value == 1){
            double diff = now.tv_sec - last_btn_change.tv_sec + 1e-9*(now.tv_nsec - last_btn_change.tv_nsec);
            printf("press time %.2lfs\n", diff);
            if(diff >= 2){
                start_image_capture = 1;
            }else if(diff >= 0.04){
                button_ip_click = 1;
            }
        }
        last_btn_value = value_now;
        last_btn_change = now;
    }
}

void InitImgCap(void)
{
    gpio_imgcap_en = gpiod_chip_find_line(gpio_context, "imgcap_start");
    int ret = gpiod_line_request_output(gpio_imgcap_en, "danmaku", 0);
    if(ret){
        printf("gpiod_line_request_output failed for imgcap_start\n");
    }
    DanmakuHW_AllocRenderBuf(hDriver, (uintptr_t*)&image_captured, &image_captured_phy, MAX_SCREEN_HEIGHT*MAX_WIDTH & ~7);
}

void DoImgCap(void)
{
    DanmakuHW_ImageCapture(hDriver, image_captured_phy, screen_width*screen_height);
    gpiod_line_set_value(gpio_imgcap_en, 1);
    usleep(100);
    gpiod_line_set_value(gpio_imgcap_en, 0);
    usleep(40000);
    while(!DanmakuHW_ImgCapDMAIdle(hDriver))
        pthread_yield();
    printf("imgcap done\n");
    FILE* fdbgimg = fopen("/tmp/captured.bin", "w");
    fwrite(image_captured, 1, screen_width*screen_height, fdbgimg);
    fclose(fdbgimg);
}

void SubMain()
{
    pthread_attr_t attr;
    pthread_t overlay_thread;

    DanmakuHW_GetFrameSize(hDriver, &screen_height, &screen_width);

    if (screen_width < 100 || screen_height < 100
        || screen_width%4!=0 || screen_height%4!=0) {
        if(screen_width!=0 && screen_height !=0)
            printf("unsupported size %d * %d detected\n", screen_width, screen_height);
        usleep(200000);
        return;
    }
    printf("screen: %d * %d\n", screen_width, screen_height);

    printf("DanmakuHW_RenderDMAStatus: %x\n", DanmakuHW_RenderDMAStatus(hDriver));
    printf("DanmakuHW_RenderDMAIdle: %x\n", DanmakuHW_RenderDMAIdle(hDriver));

    DanmakuHW_DestroyRenderBuf(hDriver);

    img_size = (((screen_width + 2) * screen_height) + 3) & (~3);

    edge = screen_width / 20;
    render_setopt_dpi(edge*4);

    InitQueen(&sliding_queen);
    InitQueen(&static_queen);

    int y = 0;
    for (int i = 0; i < SLIDING_LAYER_ROWS; i++) {
        for (int j = 0; j < SLIDING_LAYER_COLS; j++) {
            InitSliding(&sliding_layers[i][j], y);
        }
        y++;
    }
    for (int i = 0; i < NUM_STATIC_LAYER; i++) {
        InitStatic(&static_layers[i], i);
    }
    InitBlankScreen();
    InitFontMap();
    printf("character: %d * %d\n", edge, edge);

    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    pthread_create(&overlay_thread, &attr, Thread4Overlay, NULL);

    printf("begin rendering\n");
    signal(SIGINT, intHandler);
    Render();

    // pthread_kill(overlay_thread, SIGINT);
    pthread_join(overlay_thread, NULL);
    pthread_attr_destroy(&attr);

    ClearFontMap();
}

void* systask(void* _)
{
    for(;;){
        usleep(10000);
        if(ResolutionChanged(7)){
            render_running = 0;
        }
        BtnDetect();
        if(start_image_capture){
            DoImgCap();
            start_image_capture = 0;
        }
    }
}

int main()
{
    pthread_t systask_thread;
    pthread_mutex_init(&render_overlay_mutex, NULL);
    pthread_cond_init (&render_overlay_cv, NULL);

    setvbuf(stdout, NULL, _IOLBF, 0); //set stdout as line buffer
    printf("starting danmaku...\n");

    hDriver = DanmakuHW_Open();
    if (!hDriver) {
        fprintf(stderr, "DanmakuHW_Open failed\n");
        exit(1);
    }
    printf("driver opened\n");

    printf("FPGA Build: %s\n", DanmakuHW_GetFPGABuildTime(hDriver));
    gpio_context = gpiod_chip_open_by_label("/amba_pl/gpio@41200000");
    if(!gpio_context){
        printf("gpio controller not found\n");
        exit(1);
    }
    InitImgCap();
    InitBtnDetect();

    // enable UTF-8
    setlocale(LC_ALL, "");

    #if !GLIB_CHECK_VERSION(2,35,0)
    g_type_init ();
    #endif

    // set stdin as non-blocked
    int flags = fcntl(STDIN_FILENO, F_GETFL, 0);
    if (fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK) != 0) {
        exit(1);
    }

    pthread_create(&systask_thread, NULL, systask, NULL);


    while (!sigint) {
        SubMain();
    }

    pthread_kill(systask_thread, SIGTERM);

    /* Clean up and exit */
    pthread_mutex_destroy(&render_overlay_mutex);
    pthread_cond_destroy(&render_overlay_cv);
    pthread_exit(NULL);
    return 0;
}
