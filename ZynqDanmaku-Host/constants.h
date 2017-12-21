#ifndef CONSTANTS_H__
#define CONSTANTS_H__ 

// layer info
#define MAX_WIDTH       2000
#define MAX_HEIGHT      256
#define MAX_TEXT_LEN    512

#define SLIDING_LAYER_ROWS 5
#define SLIDING_LAYER_COLS 5
#define NUM_STATIC_LAYER 5

// screen info
#define MAX_SCREEN_HEIGHT 1100

// special colors
#define PXL_HSYNC (0xe)
#define PXL_VSYNC (0xf)
#define PXL_BLANK (0xd)

// parameters
#define FONT_FILE_PATH "SourceHanSansCN-Bold.otf"
#define CYCLE_PER_DANMU    384
#define DURATION           300

#define MAX_IMG_SIZE ((((MAX_WIDTH + 2) * MAX_SCREEN_HEIGHT) + 3) & (~3))
#define FRAME_BUFFER_SIZE MAX_IMG_SIZE
#define NUM_FRAME_BUFFER 7
#define NUM_RENDER_SG_DESC (1<<12)

#define PERPH_ADDR_BASE 0x40000000
#define PERPH_ADDR_SPAN 0x03000000

#define IP_CDMA_OFFSET    0x00200000
#define IP_AXI_DMA_OFFSET 0x00400000
#define IP_AXI_PIO_OFFSET 0x01200000
#define IP_SYS_CTL_OFFSET 0x02000000
#define IP_TIMETAG_OFFSET 0x02010000

//GPIO number for DMA irq
// #define IRQ_AXIDMA     (896+2)
// #define IRQ_AXICDMA    (896+3)

//UIO number for DMA irq
#define IRQ_AXIDMA     (0)
#define IRQ_AXICDMA    (1)

#define OVERLAY_ASSOCIATE_CPU 1

#endif