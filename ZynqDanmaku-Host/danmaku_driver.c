#include "danmaku_driver.h"
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pthread.h>
#include <poll.h>

#include "constants.h"

// #define REG_OFF32(base, number) ((volatile uint32_t*)((uintptr_t)(base)+4*(number)))
#define REG_OFF(base, off) ((volatile uint32_t*)((uintptr_t)(base)+(off)))

#define XILDMA_CONTROL_REGISTER 0x00
#define XILDMA_STATUS_REGISTER 0x04
#define XILDMA_CURDESC 0x08
#define XILDMA_TAILDESC 0x10
#define XILDMA_START_ADDRESS 0x18
#define XILDMA_LENGTH 0x28

#define XILDMA_S2MM_OFFSET 0x30

#define SYSCTL_RES_REGISTER 0x00
#define SYSCTL_FIFO_SIZE_REGISTER 0x04
#define SYSCTL_FIFO_MIN_REGISTER 0x08

#define FIFO_DMA_ADDRESS_REG 0x00
#define FIFO_DMA_LENGTH_REG  0x04
#define FIFO_DMA_CONTROL_REG 0x08
#define FIFO_DMA_RESP_REG    0x0C
#define FIFO_DMA_STATUS_REG  0x10

typedef struct descriptor_t{
    uint32_t next_desc;
    uint32_t next_desc_msb;
    uint32_t src_addr;
    uint32_t src_addr_msb;
    uint32_t dest_addr;
    uint32_t dest_addr_msb;
    uint32_t control;
    uint32_t status;
    uint32_t padding[8];
}desc_t;

typedef struct{
    int irqline[2];
    struct pollfd pollfds[2];
}irq_handler_t;

typedef struct{
    int fd_devmem;
    int fd_udmabuf0;
    int fd_udmabuf1;
    size_t sz_udmabuf0;
    uintptr_t uaddr_perph_base;
    uintptr_t uaddr_fb;
    uintptr_t paddr_fb;
    size_t sz_dyn_area;
    uintptr_t uaddr_dyn_area;
    uintptr_t paddr_dyn_area;
    size_t sz_allocated;

    int head_desc, tail_desc;
    desc_t* uaddr_desc_base;
    desc_t* paddr_desc_base;

    irq_handler_t irq_handler;
}driver_ctx;

static void DanmakuHW_DMA_Init(driver_ctx* h);

int
ratelimit_printf (const char *format, ...)
{
    va_list arg;
    int done;
    time_t now = time(0);
    static time_t last_called = 0;

    if(now - last_called < 1)
        return 0;
    last_called = now;

    va_start (arg, format);
    done = vfprintf (stdout, format, arg);
    va_end (arg);

    return done;
}

void start_udmabuf(void)
{
    // system("rmmod udmabuf");
    system("modprobe udmabuf udmabuf0=17825792 udmabuf1=67108864");
    system("echo 6 >/sys/class/udmabuf/udmabuf1/sync_mode");
}

void wait_on_irq(driver_ctx* ctx, uint32_t irq)
{
    assert(0<=irq && irq<2);
    int32_t enable = 1;
    write(ctx->irq_handler.irqline[irq], &enable, sizeof(enable)); //Enable IRQ

    int32_t info;
    size_t nb;
    nb = read(ctx->irq_handler.irqline[irq], &info, sizeof(info));
    if (nb == sizeof(info)) {
        /* Do something in response to the interrupt. */
        // printf("UIO %d Interrupt #%u!\n", irq, info);
    }

}

int setup_irq_handler(driver_ctx* ctx)
{
    system("modprobe uio_pdrv_genirq of_id=\"linux,uio_pdrv_genirq\"");
    ctx->irq_handler.irqline[0] = open("/dev/uio0", O_RDWR);
    if(ctx->irq_handler.irqline[0]<0){
        perror("open /dev/uio0");
        return -1;
    }
    ctx->irq_handler.irqline[1] = open("/dev/uio1", O_RDWR);
    if(ctx->irq_handler.irqline[1]<0){
        perror("open /dev/uio1");
        close(ctx->irq_handler.irqline[0]);
        return -1;
    }
    for (int i = 0; i < 2; ++i)
    {
        ctx->irq_handler.pollfds[i].fd = ctx->irq_handler.irqline[i];
        ctx->irq_handler.pollfds[i].events = POLLIN;
    }
    return 0;
}

DANMAKU_HW_HANDLE DanmakuHW_Open(void)
{
    char attr[1024]={0};
    unsigned int  fd, tmp, udmabuf0_size, udmabuf0_phys;
    unsigned int  udmabuf1_size, udmabuf1_phys;
    start_udmabuf();
    if ((fd  = open("/sys/class/udmabuf/udmabuf0/size", O_RDONLY)) != -1) {
        read(fd, attr, 1024);
        udmabuf0_size = strtoul(attr, NULL, 0);
        printf("udmabuf0 size: %#x\n", udmabuf0_size);
        close(fd);
    }else{
        fprintf(stderr, "Failed to get udmabuf0 size\n");
        return NULL;
    }
    if ((fd  = open("/sys/class/udmabuf/udmabuf0/phys_addr", O_RDONLY)) != -1) {
        read(fd, attr, 1024);
        udmabuf0_phys = strtoul(attr, NULL, 0);
        printf("udmabuf0 phys_addr: %#x\n", udmabuf0_phys);
        close(fd);
    }else{
        fprintf(stderr, "Failed to get udmabuf0 phys_addr\n");
        return NULL;
    }
    if ((fd  = open("/sys/class/udmabuf/udmabuf1/size", O_RDONLY)) != -1) {
        read(fd, attr, 1024);
        udmabuf1_size = strtoul(attr, NULL, 0);
        printf("udmabuf1 size: %#x\n", udmabuf1_size);
        close(fd);
    }else{
        fprintf(stderr, "Failed to get udmabuf1 size\n");
        return NULL;
    }
    if ((fd  = open("/sys/class/udmabuf/udmabuf1/phys_addr", O_RDONLY)) != -1) {
        read(fd, attr, 1024);
        udmabuf1_phys = strtoul(attr, NULL, 0);
        printf("udmabuf1 phys_addr: %#x\n", udmabuf1_phys);
        close(fd);
    }else{
        fprintf(stderr, "Failed to get udmabuf1 phys_addr\n");
        return NULL;
    }

    driver_ctx* ctx = (driver_ctx*)malloc(sizeof(driver_ctx));
    if(!ctx){
        perror("malloc");
        return NULL;
    }

    ctx->paddr_fb = udmabuf0_phys;
    ctx->sz_udmabuf0 = udmabuf0_size;
    ctx->paddr_dyn_area = udmabuf1_phys;
    ctx->sz_dyn_area = udmabuf1_size;
    ctx->sz_allocated = 0;
    if(FRAME_BUFFER_SIZE*NUM_FRAME_BUFFER > ctx->sz_udmabuf0){
        fprintf(stderr, "frame buffer exceeded udmabuf0 size\n");
        goto free_ctx;
    }

    ctx->fd_devmem = open("/dev/mem", O_RDWR | O_SYNC);
    if(ctx->fd_devmem<0){
        perror("open /dev/mem");
        goto free_ctx;
    }

    ctx->fd_udmabuf0 = open("/dev/udmabuf0", O_RDWR);
    if(ctx->fd_udmabuf0<0){
        perror("open /dev/udmabuf0");
        goto fail_close_devmem;
    }

    ctx->fd_udmabuf1 = open("/dev/udmabuf1", O_RDWR);
    if(ctx->fd_udmabuf1<0){
        perror("open /dev/udmabuf1");
        goto fail_close_udmabuf0;
    }

    ctx->uaddr_perph_base = 
        (uintptr_t)mmap(NULL, PERPH_ADDR_SPAN, PROT_READ | PROT_WRITE, 
                        MAP_SHARED, ctx->fd_devmem, PERPH_ADDR_BASE);
    if((int)ctx->uaddr_perph_base == -1){
        perror("mmap /dev/mem");
        goto fail_close_udmabuf1;
    }
    printf("uaddr_perph_base: %#lx\n", ctx->uaddr_perph_base);

    ctx->uaddr_fb = 
        (uintptr_t)mmap(NULL, ctx->sz_udmabuf0, PROT_READ | PROT_WRITE, 
                        MAP_SHARED, ctx->fd_udmabuf0, 0);
    if((int)ctx->uaddr_fb == -1){
        perror("mmap /dev/udmabuf0");
        goto fail_unmap_devmem;
    }
    printf("uaddr_fb: %#lx\n", ctx->uaddr_fb);
    ctx->uaddr_dyn_area = 
        (uintptr_t)mmap(NULL, ctx->sz_dyn_area, PROT_READ | PROT_WRITE, 
                        MAP_SHARED, ctx->fd_udmabuf1, 0);
    if((int)ctx->uaddr_dyn_area == -1){
        perror("mmap /dev/udmabuf1");
        goto fail_unmap_udmabuf0;
    }

    if(setup_irq_handler(ctx) < 0)
        goto fail_unmap_udmabuf1;

    assert(sizeof(desc_t) == 64);
    // Reserve space for DMA descriptors
    ctx->head_desc = ctx->tail_desc = 0;
    ctx->uaddr_desc_base = (desc_t*)ctx->uaddr_dyn_area;
    ctx->paddr_desc_base = (desc_t*)ctx->paddr_dyn_area;
    ctx->uaddr_dyn_area += NUM_RENDER_SG_DESC*sizeof(desc_t);
    ctx->paddr_dyn_area += NUM_RENDER_SG_DESC*sizeof(desc_t);

    DanmakuHW_DMA_Init(ctx);

    return (DANMAKU_HW_HANDLE)ctx;

fail_unmap_udmabuf1:
    munmap((void*)ctx->uaddr_dyn_area, ctx->sz_dyn_area);
fail_unmap_udmabuf0:
    munmap((void*)ctx->uaddr_fb, ctx->sz_udmabuf0);
fail_unmap_devmem:
    munmap((void*)ctx->uaddr_perph_base, PERPH_ADDR_SPAN);
fail_close_udmabuf1:
    close(ctx->fd_udmabuf1);
fail_close_udmabuf0:
    close(ctx->fd_udmabuf0);
fail_close_devmem:
    close(ctx->fd_devmem);
free_ctx:
    free(ctx);
    return NULL;
}
const char* DanmakuHW_GetFPGABuildTime(DANMAKU_HW_HANDLE h)
{
    driver_ctx* ctx = (driver_ctx*)h;
    //USR_ACCESS IP
    uintptr_t timetag_base = ctx->uaddr_perph_base+IP_TIMETAG_OFFSET;
    static char dt_string[20]; //should be static
    uint32_t Date = *(uint32_t*)timetag_base;
    uint32_t Time = *(uint32_t*)(timetag_base+4);
    assert(((uint64_t)Time<<32|Date) >= REQUIRED_MIN_HARDWARE_VER);
    assert(((uint64_t)Time<<32|Date) <= REQUIRED_MAX_HARDWARE_VER);
    snprintf(dt_string, sizeof(dt_string)-1, "%02d-%d-%d %02d:%02d:%02d",
        0xff&(Date>>16),0xff&(Date>>8),0xff&(Date),
        0xff&(Time>>16),0xff&(Time>>8),0xff&(Time));
    return dt_string;
}
void DanmakuHW_DestroyRenderBuf(DANMAKU_HW_HANDLE h)
{
    driver_ctx* ctx = (driver_ctx*)h;
    ctx->sz_allocated = 0;
}
void DanmakuHW_AllocRenderBuf(DANMAKU_HW_HANDLE h, uintptr_t *uaddr, uintptr_t *paddr, uint32_t length)
{
    driver_ctx* ctx = (driver_ctx*)h;
    if (ctx->sz_allocated + length > ctx->sz_dyn_area)
    {
        fprintf(stderr, "DanmakuHW_AllocRenderBuf: no enough space\n");
        exit(1);
    }
    *uaddr = ctx->uaddr_dyn_area + ctx->sz_allocated;
    *paddr = ctx->paddr_dyn_area + ctx->sz_allocated;
    ctx->sz_allocated += length;
}
uintptr_t DanmakuHW_GetFrameBuffer(DANMAKU_HW_HANDLE h, int buf_index)
{
    driver_ctx* ctx = (driver_ctx*)h;
    assert(buf_index >= 0 && buf_index < NUM_FRAME_BUFFER);
    return ctx->paddr_fb+buf_index*FRAME_BUFFER_SIZE;
}
static void DanmakuHW_DMA_Init(driver_ctx* ctx)
{
    uintptr_t cdma_csr = ctx->uaddr_perph_base+IP_CDMA_OFFSET;
    // uintptr_t dma_csr = ctx->uaddr_perph_base+IP_AXI_DMA_OFFSET;
    uintptr_t dma_s2mm_csr = ctx->uaddr_perph_base+IP_AXI_DMA_OFFSET+XILDMA_S2MM_OFFSET;
    *REG_OFF(cdma_csr, XILDMA_CONTROL_REGISTER) = 1<<2; //reset
    // *REG_OFF(dma_csr, XILDMA_CONTROL_REGISTER) = 1<<2; //reset
    *REG_OFF(dma_s2mm_csr, XILDMA_CONTROL_REGISTER) = 1<<2; //reset
    usleep(100);
    *REG_OFF(cdma_csr, XILDMA_CONTROL_REGISTER) = 0x15008; //enable SG
    // *REG_OFF(dma_csr, XILDMA_CONTROL_REGISTER) = 0x15001; //RS=1
    *REG_OFF(dma_s2mm_csr, XILDMA_CONTROL_REGISTER) = 0x15001; //RS=1
}
void DanmakuHW_RenderFlush(DANMAKU_HW_HANDLE h)
{
    driver_ctx* ctx = (driver_ctx*)h;
    if(DanmakuHW_RenderDMAIdle(h) && ctx->head_desc != ctx->tail_desc){

        int last_desc = ctx->tail_desc-1;
        if(last_desc < 0)
            last_desc = NUM_RENDER_SG_DESC-1;
        // printf("%d~%d\n", ctx->head_desc, last_desc);

        uintptr_t dma_csr = ctx->uaddr_perph_base+IP_CDMA_OFFSET;
        uint32_t status = *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER);
        if(status & 0x770){
            ratelimit_printf("%s error - status=%x\n", __func__, status);
        }
        // printf("status before %x\n", status);
        *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER) = status; //Clear flags
        *REG_OFF(dma_csr, XILDMA_CURDESC) = (uintptr_t)(ctx->paddr_desc_base+ctx->head_desc);
        // *REG_OFF(dma_csr, XILDMA_CONTROL_REGISTER) = 0xf000; //Control
        *REG_OFF(dma_csr, XILDMA_TAILDESC) = (uintptr_t)(ctx->paddr_desc_base+last_desc);
        status = *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER);
        // printf("status after %x\n", status);

        ctx->head_desc = ctx->tail_desc; //clear descriptor buffer
    }
}
int DanmakuHW_RenderStartDMA(DANMAKU_HW_HANDLE h,uintptr_t dst, uintptr_t src, uint32_t length)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t dma_csr = ctx->uaddr_perph_base+IP_CDMA_OFFSET;

    int next = (ctx->tail_desc+1)%NUM_RENDER_SG_DESC;
    if(next == ctx->head_desc //overflow
            || (!DanmakuHW_RenderDMAIdle(h) 
                && (uintptr_t)(ctx->paddr_desc_base+next) == *REG_OFF(dma_csr, XILDMA_CURDESC))){
        ratelimit_printf("render DMA full, 0x%x\n",*REG_OFF(dma_csr, XILDMA_STATUS_REGISTER));
        return -1;
    }
    assert((uintptr_t)(ctx->paddr_desc_base+ctx->tail_desc)+sizeof(desc_t) <= ctx->paddr_dyn_area);
    assert((uintptr_t)(ctx->paddr_desc_base+next)+sizeof(desc_t) <= ctx->paddr_dyn_area);
    assert(src >= ctx->paddr_dyn_area);
    assert(dst+length <= ctx->paddr_fb+ctx->sz_udmabuf0);
    //build descriptor
    // printf("%s: [%u]%p->%p\n", __func__, length, src, dst);
    ctx->uaddr_desc_base[ctx->tail_desc].next_desc = (uintptr_t)(ctx->paddr_desc_base+next);
    ctx->uaddr_desc_base[ctx->tail_desc].src_addr = src;
    ctx->uaddr_desc_base[ctx->tail_desc].dest_addr = dst;
    ctx->uaddr_desc_base[ctx->tail_desc].control = (length & (1<<23)-1);
    ctx->uaddr_desc_base[ctx->tail_desc].status = 0;
    ctx->tail_desc = next;

    DanmakuHW_RenderFlush(h);

    return 0;
}
int DanmakuHW_RenderDMAIdle(DANMAKU_HW_HANDLE h)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t dma_csr = ctx->uaddr_perph_base+IP_CDMA_OFFSET;
    return ((*REG_OFF(dma_csr, XILDMA_STATUS_REGISTER) & 2) == 2);
}
int DanmakuHW_WaitForRenderDMA(DANMAKU_HW_HANDLE h)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t dma_csr = ctx->uaddr_perph_base+IP_CDMA_OFFSET;
    uint32_t wr_clear = *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER);
    *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER) = wr_clear;
    if((*REG_OFF(dma_csr, XILDMA_STATUS_REGISTER) & 2) == 2)
        return 0;
    wait_on_irq(ctx,IRQ_AXICDMA);
    wr_clear = *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER);
    *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER) = wr_clear;
    return 0;
}
uint32_t DanmakuHW_RenderDMAStatus(DANMAKU_HW_HANDLE h)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t dma_csr = ctx->uaddr_perph_base+IP_CDMA_OFFSET;
    return *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER);
}
int DanmakuHW_FrameBufferTxmit(DANMAKU_HW_HANDLE h, int buf_index, int tag, uint32_t length)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t dma_csr = ctx->uaddr_perph_base+IP_FIFO_SGDMA_OFFSET;

    assert(tag >= 0 && tag < DMA_TAG_SIZE);
    assert(buf_index >= 0 && buf_index < NUM_FRAME_BUFFER);
    assert(length <= FRAME_BUFFER_SIZE);
    assert((length & 0x7) == 0);

    if((*REG_OFF(dma_csr, FIFO_DMA_CONTROL_REG) & 1) == 1){
        // DMA Unavailable: descriptor FIFO full
        // Should not occur in normal operation
        return -1;
    }

    uint32_t status = *REG_OFF(dma_csr, FIFO_DMA_RESP_REG);
    if(status & 0x70){
        ratelimit_printf("%s error status=%x tag=%x\n", __func__, status&0xf, status&0xf0);
    }

    // *REG_OFF(dma_csr, FIFO_DMA_STATUS_REG) = 0xff; // clear flags
    *REG_OFF(dma_csr, FIFO_DMA_ADDRESS_REG) = DanmakuHW_GetFrameBuffer(h, buf_index); //Read Address
    *REG_OFF(dma_csr, FIFO_DMA_LENGTH_REG) = length; //Length
    *REG_OFF(dma_csr, FIFO_DMA_CONTROL_REG) = tag<<1 | 1; //Control
    return 0;
}
int DanmakuHW_ClearResponse(DANMAKU_HW_HANDLE h)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t dma_csr = ctx->uaddr_perph_base+IP_FIFO_SGDMA_OFFSET;
    *REG_OFF(dma_csr, FIFO_DMA_RESP_REG) = 0; //write any value to clear response register
}
int DanmakuHW_ResponseOfOverlay(DANMAKU_HW_HANDLE h, bool *ok, bool *err, int *tag)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t dma_csr = ctx->uaddr_perph_base+IP_FIFO_SGDMA_OFFSET;
    uint32_t resp = *REG_OFF(dma_csr, FIFO_DMA_RESP_REG);
    *ok = !!(resp & 0x80);
    *err = !!(resp & 0x70);
    *tag = (resp & 0xf);
    return 0;
}
void DanmakuHW_GetFrameSize(DANMAKU_HW_HANDLE h, unsigned int* height, unsigned int* width)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t sfr = ctx->uaddr_perph_base+IP_SYS_CTL_OFFSET;
    uint32_t resolution = *REG_OFF(sfr, SYSCTL_RES_REGISTER);
    *height = resolution&0xffff;
    *width = (resolution>>16)&0xffff;
}
void DanmakuHW_GetFIFOUsage(DANMAKU_HW_HANDLE h, unsigned int* size)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t sfr = ctx->uaddr_perph_base+IP_SYS_CTL_OFFSET;
    *size = *REG_OFF(sfr, SYSCTL_FIFO_SIZE_REGISTER);
    // *REG_OFF(sfr, SYSCTL_FIFO_MIN_REGISTER) = 0; //write anything to reset minimum record
}
int DanmakuHW_ImageCapture(DANMAKU_HW_HANDLE h, uint32_t addr, uint32_t length)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t dma_csr = ctx->uaddr_perph_base+IP_AXI_DMA_OFFSET+XILDMA_S2MM_OFFSET;

    assert((length & 0x7) == 0);

    // printf("%s: %p %u\n",
    //     __func__, DanmakuHW_GetFrameBuffer(h, buf_index), length);
    // printf("%s: status=%x\n", __func__, *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER));
    uint32_t status = *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER);
    if(status & 0x70){
        ratelimit_printf("%s error - status=%x\n", __func__, status);
    }

    *REG_OFF(dma_csr, XILDMA_STATUS_REGISTER) = status; //Clear flags
    // *REG_OFF(dma_csr, XILDMA_CONTROL_REGISTER) = 0xf001; //Control
    *REG_OFF(dma_csr, XILDMA_START_ADDRESS) = addr; //Read Address
    *REG_OFF(dma_csr, XILDMA_LENGTH) = length; //Length
    return 0;
}
int DanmakuHW_ImgCapDMAIdle(DANMAKU_HW_HANDLE h)
{
    driver_ctx* ctx = (driver_ctx*)h;
    uintptr_t dma_csr = ctx->uaddr_perph_base+IP_AXI_DMA_OFFSET+XILDMA_S2MM_OFFSET;
    return (*REG_OFF(dma_csr, XILDMA_STATUS_REGISTER) & 2) == 2;
}
