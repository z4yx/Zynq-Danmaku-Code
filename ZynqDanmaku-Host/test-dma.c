#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/mman.h>

#define TEST_LENGTH 2075760

#define MM2S_CONTROL_REGISTER 0x00
#define MM2S_STATUS_REGISTER 0x04
#define MM2S_CURDESC 0x08
#define MM2S_TAILDESC 0x10
#define MM2S_START_ADDRESS 0x18
#define MM2S_LENGTH 0x28

#define S2MM_CONTROL_REGISTER 0x30
#define S2MM_STATUS_REGISTER 0x34
#define S2MM_DESTINATION_ADDRESS 0x48
#define S2MM_LENGTH 0x58

struct sg_desc_t
{
    uint32_t next_desc;
    uint32_t next_desc_msb;
    uint32_t address;
    uint32_t address_msb;
    uint32_t reserved1[2];
    uint32_t control;
    uint32_t status;
    uint32_t app[5];
    uint32_t reserved2[3];
};

void dma_set(volatile unsigned int* dma_virtual_address, int offset, unsigned int value) {
    dma_virtual_address[offset>>2] = value;
}

unsigned int dma_get(volatile unsigned int* dma_virtual_address, int offset) {
    return dma_virtual_address[offset>>2];
}

void dma_s2mm_status(unsigned int* dma_virtual_address) {
    unsigned int status = dma_get(dma_virtual_address, S2MM_STATUS_REGISTER);
    printf("Stream to memory-mapped status (0x%08x@0x%02x):", status, S2MM_STATUS_REGISTER);
    if (status & 0x00000001) printf(" halted"); else printf(" running");
    if (status & 0x00000002) printf(" idle");
    if (status & 0x00000008) printf(" SGIncld");
    if (status & 0x00000010) printf(" DMAIntErr");
    if (status & 0x00000020) printf(" DMASlvErr");
    if (status & 0x00000040) printf(" DMADecErr");
    if (status & 0x00000100) printf(" SGIntErr");
    if (status & 0x00000200) printf(" SGSlvErr");
    if (status & 0x00000400) printf(" SGDecErr");
    if (status & 0x00001000) printf(" IOC_Irq");
    if (status & 0x00002000) printf(" Dly_Irq");
    if (status & 0x00004000) printf(" Err_Irq");
    printf("\n");
}

void dma_s2mm_dump_reg(unsigned int* dma_virtual_address) {
    printf("Stream to memory-mapped control (0x%08x@0x%02x):\n", dma_get(dma_virtual_address, S2MM_CONTROL_REGISTER), S2MM_CONTROL_REGISTER);
    printf("Stream to memory-mapped status (0x%08x@0x%02x):\n", dma_get(dma_virtual_address, S2MM_STATUS_REGISTER), S2MM_STATUS_REGISTER);
}

void dma_mm2s_status(unsigned int* dma_virtual_address) {
    unsigned int status = dma_get(dma_virtual_address, MM2S_STATUS_REGISTER);
    printf("Memory-mapped to stream status (0x%08x@0x%02x):", status, MM2S_STATUS_REGISTER);
    if (status & 0x00000001) printf(" halted"); else printf(" running");
    if (status & 0x00000002) printf(" idle");
    if (status & 0x00000008) printf(" SGIncld");
    if (status & 0x00000010) printf(" DMAIntErr");
    if (status & 0x00000020) printf(" DMASlvErr");
    if (status & 0x00000040) printf(" DMADecErr");
    if (status & 0x00000100) printf(" SGIntErr");
    if (status & 0x00000200) printf(" SGSlvErr");
    if (status & 0x00000400) printf(" SGDecErr");
    if (status & 0x00001000) printf(" IOC_Irq");
    if (status & 0x00002000) printf(" Dly_Irq");
    if (status & 0x00004000) printf(" Err_Irq");
    printf("\n");
}

void dma_mm2s_dump_reg(unsigned int* dma_virtual_address) {
    printf("Memory-mapped to stream control (0x%08x@0x%02x)\n", dma_get(dma_virtual_address, MM2S_CONTROL_REGISTER), MM2S_CONTROL_REGISTER);
    printf("Memory-mapped to stream status (0x%08x@0x%02x)\n", dma_get(dma_virtual_address, MM2S_STATUS_REGISTER), MM2S_STATUS_REGISTER);
    printf("Memory-mapped to stream cur (0x%08x@0x%02x)\n", dma_get(dma_virtual_address, MM2S_CURDESC), MM2S_CURDESC);
    printf("Memory-mapped to stream tail (0x%08x@0x%02x)\n", dma_get(dma_virtual_address, MM2S_TAILDESC), MM2S_TAILDESC);
}

int dma_mm2s_sync(unsigned int* dma_virtual_address) {
    unsigned int mm2s_status =  dma_get(dma_virtual_address, MM2S_STATUS_REGISTER);
    while(/*!(mm2s_status & 1<<12) ||*/ !(mm2s_status & 3) ){
        // dma_s2mm_status(dma_virtual_address);
        // dma_mm2s_status(dma_virtual_address);

        mm2s_status =  dma_get(dma_virtual_address, MM2S_STATUS_REGISTER);
    }
    return 0;
}

int dma_s2mm_sync(unsigned int* dma_virtual_address) {
    unsigned int s2mm_status = dma_get(dma_virtual_address, S2MM_STATUS_REGISTER);
    while(/*!(s2mm_status & 1<<12) ||*/ !(s2mm_status & 3)){
        // dma_s2mm_status(dma_virtual_address);
        // dma_mm2s_status(dma_virtual_address);

        s2mm_status = dma_get(dma_virtual_address, S2MM_STATUS_REGISTER);
    }
    return 0;
}

void memdump(void* virtual_address, int byte_count) {
    char *p = virtual_address;
    int offset;
    for (offset = 0; offset < byte_count; offset++) {
        printf("%02x", p[offset]);
        if (offset % 4 == 3) { printf(" "); }
    }
    printf("\n");
}

void start_udmabuf(void)
{
    // system("rmmod udmabuf");
    system("modprobe udmabuf udmabuf0=16777216 udmabuf1=67108864");
    system("echo 5 >/sys/class/udmabuf/udmabuf1/sync_mode");
}

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
}driver_ctx;


driver_ctx* DanmakuHW_Open(void)
{
    char attr[1024]={0};
    unsigned int  fd, tmp, udmabuf0_size, udmabuf0_phys;
    unsigned int  udmabuf1_size, udmabuf1_phys;
    start_udmabuf();
    if ((fd  = open("/sys/class/udmabuf/udmabuf0/size", O_RDONLY)) != -1) {
        read(fd, attr, 1024);
        udmabuf0_size = strtoul(attr, NULL, 0);
        printf("udmabuf0 size: %p\n", udmabuf0_size);
        close(fd);
    }else{
        fprintf(stderr, "Failed to get udmabuf0 size\n");
        return NULL;
    }
    if ((fd  = open("/sys/class/udmabuf/udmabuf0/phys_addr", O_RDONLY)) != -1) {
        read(fd, attr, 1024);
        udmabuf0_phys = strtoul(attr, NULL, 0);
        printf("udmabuf0 phys_addr: %p\n", udmabuf0_phys);
        close(fd);
    }else{
        fprintf(stderr, "Failed to get udmabuf0 phys_addr\n");
        return NULL;
    }
    if ((fd  = open("/sys/class/udmabuf/udmabuf1/size", O_RDONLY)) != -1) {
        read(fd, attr, 1024);
        udmabuf1_size = strtoul(attr, NULL, 0);
        printf("udmabuf1 size: %p\n", udmabuf1_size);
        close(fd);
    }else{
        fprintf(stderr, "Failed to get udmabuf1 size\n");
        return NULL;
    }
    if ((fd  = open("/sys/class/udmabuf/udmabuf1/phys_addr", O_RDONLY)) != -1) {
        read(fd, attr, 1024);
        udmabuf1_phys = strtoul(attr, NULL, 0);
        printf("udmabuf1 phys_addr: %p\n", udmabuf1_phys);
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

    ctx->fd_udmabuf0 = open("/dev/udmabuf0", O_RDWR);
    if(!ctx->fd_udmabuf0){
        perror("open /dev/udmabuf0");
        goto fail_close_devmem;
    }

    ctx->fd_udmabuf1 = open("/dev/udmabuf1", O_RDWR);
    if(!ctx->fd_udmabuf1){
        perror("open /dev/udmabuf1");
        goto fail_close_udmabuf0;
    }
    ctx->uaddr_fb = 
        (uintptr_t)mmap(NULL, ctx->sz_udmabuf0, PROT_READ | PROT_WRITE, 
                        MAP_SHARED, ctx->fd_udmabuf0, 0);
    if((int)ctx->uaddr_fb == -1){
        perror("mmap /dev/udmabuf0");
        goto fail_unmap_devmem;
    }
    printf("uaddr_fb: %p\n", ctx->uaddr_fb);
    ctx->uaddr_dyn_area = 
        (uintptr_t)mmap(NULL, ctx->sz_dyn_area, PROT_READ | PROT_WRITE, 
                        MAP_SHARED, ctx->fd_udmabuf1, 0);
    if((int)ctx->uaddr_dyn_area == -1){
        perror("mmap /dev/udmabuf1");
        goto fail_unmap_udmabuf0;
    }
    printf("uaddr_dyn_area: %p\n", ctx->uaddr_dyn_area);

    return ctx;

fail_unmap_udmabuf0:
    munmap((void*)ctx->uaddr_fb, ctx->sz_udmabuf0);
fail_unmap_devmem:
    // munmap((void*)ctx->uaddr_perph_base, PERPH_ADDR_SPAN);
fail_close_udmabuf1:
    close(ctx->fd_udmabuf1);
fail_close_udmabuf0:
    close(ctx->fd_udmabuf0);
fail_close_devmem:
    // close(ctx->fd_devmem);
    return NULL;
}

#define PXL_HSYNC (0xe)
#define PXL_VSYNC (0xf)
#define PXL_BLANK (0xd)
void InitBlankScreen(uint8_t* blank_screen, int screen_height, int screen_width)
{
    uint32_t offset = 0;
    int img_size = (((screen_width + 2) * screen_height) + 3) & (~3);
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

int main() {
    driver_ctx* ctx = DanmakuHW_Open();
    int dh = open("/dev/mem", O_RDWR | O_SYNC); // Open /dev/mem which represents the whole physical memory
    unsigned int* virtual_address = mmap(NULL, 65535, PROT_READ | PROT_WRITE, MAP_SHARED, dh, 0x40400000); // Memory map AXI Lite register block
    // unsigned int* virtual_source_address  = mmap(NULL, 65535, PROT_READ | PROT_WRITE, MAP_SHARED, dh, 0x0e000000); // Memory map source address
    // unsigned int* virtual_destination_address = mmap(NULL, 65535, PROT_READ | PROT_WRITE, MAP_SHARED, dh, 0x0f000000); // Memory map destination address
    unsigned int* virtual_source_address = ctx->uaddr_fb;
    // unsigned int* virtual_destination_address = ctx->uaddr_dyn_area;

    // virtual_source_address[0]= 0x11223344; // Write random stuff to source block
    InitBlankScreen(virtual_source_address,1080,1920);
    // memset(virtual_destination_address, 0, TEST_LENGTH); // Clear destination block

    // printf("Source memory block:      "); memdump(virtual_source_address, TEST_LENGTH);
    // printf("Destination memory block: "); memdump(virtual_destination_address, TEST_LENGTH);

    dma_mm2s_status(virtual_address);

    printf("Resetting DMA\n");
    // dma_set(virtual_address, S2MM_CONTROL_REGISTER, 4);
    dma_set(virtual_address, MM2S_CONTROL_REGISTER, 4);
    // dma_s2mm_status(virtual_address);
    dma_mm2s_status(virtual_address);

    printf("Halting DMA\n");
    // dma_set(virtual_address, S2MM_CONTROL_REGISTER, 0);
    dma_set(virtual_address, MM2S_CONTROL_REGISTER, 0);
    // dma_s2mm_status(virtual_address);
    dma_mm2s_status(virtual_address);

    struct sg_desc_t *u_desc = (void*) ctx->uaddr_dyn_area;
    struct sg_desc_t *p_desc = (void*) ctx->paddr_dyn_area;
    for (int i = 0; i < 180; ++i)
    {
        memset(&u_desc[i], 0, sizeof(struct sg_desc_t));
        u_desc[i].next_desc = p_desc+i+1;
        u_desc[i].address = ctx->paddr_fb;
        u_desc[i].control = (3<<26) | TEST_LENGTH;
        u_desc[i].status = 0;
    }
    printf("desc.next_desc=%x\n",u_desc->next_desc);
    printf("desc.address=%x\n",u_desc->address);
    printf("desc.control=%x\n",u_desc->control);
    printf("desc.status=%x\n",u_desc->status);

    // printf("Writing destination address\n");
    // dma_set(virtual_address, S2MM_DESTINATION_ADDRESS, ctx->paddr_dyn_area); // Write destination address
    // dma_s2mm_status(virtual_address);

    // printf("Writing source address...\n");
    // dma_set(virtual_address, MM2S_START_ADDRESS, ctx->paddr_fb); // Write source address
    // dma_mm2s_status(virtual_address);

    // printf("Starting S2MM channel with all interrupts masked...\n");
    // dma_set(virtual_address, S2MM_CONTROL_REGISTER, 0xf001);
    // dma_s2mm_status(virtual_address);

    dma_set(virtual_address, MM2S_CURDESC, p_desc);

    printf("Starting MM2S channel with all interrupts masked...\n");
    dma_set(virtual_address, MM2S_CONTROL_REGISTER, 0xf001);
    dma_mm2s_status(virtual_address);

    dma_set(virtual_address, MM2S_TAILDESC, p_desc+179);
    dma_mm2s_status(virtual_address);

    // printf("Writing S2MM transfer length...\n");
    // dma_set(virtual_address, S2MM_LENGTH, TEST_LENGTH);
    // dma_s2mm_status(virtual_address);

    // printf("Writing MM2S transfer length...\n");
    // dma_set(virtual_address, MM2S_LENGTH, TEST_LENGTH);
    // dma_mm2s_status(virtual_address);

    // dma_s2mm_dump_reg(virtual_address);
    dma_mm2s_dump_reg(virtual_address);

    printf("Waiting for MM2S synchronization...\n");
    dma_mm2s_sync(virtual_address);

    dma_mm2s_dump_reg(virtual_address);

    printf("desc.next_desc=%x\n",u_desc->next_desc);
    printf("desc.address=%x\n",u_desc->address);
    printf("desc.control=%x\n",u_desc->control);
    printf("desc.status=%x\n",u_desc->status);

    // printf("Waiting for S2MM sychronization...\n");
    // dma_s2mm_sync(virtual_address); // If this locks up make sure all memory ranges are assigned under Address Editor!

    // dma_s2mm_status(virtual_address);
    dma_mm2s_status(virtual_address);

    // printf("Destination memory block: "); memdump(virtual_destination_address, TEST_LENGTH);
}