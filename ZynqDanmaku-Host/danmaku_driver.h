#ifndef DANMAKU_DRIVER_H__
#define DANMAKU_DRIVER_H__ 

#include <ctype.h>
#include <stdint.h>

typedef void* DANMAKU_HW_HANDLE;

DANMAKU_HW_HANDLE DanmakuHW_Open(void);
int DanmakuHW_FrameBufferTxmit(DANMAKU_HW_HANDLE h, int buf_index, uint32_t length);
int DanmakuHW_PendingTxmit(DANMAKU_HW_HANDLE h);
uintptr_t DanmakuHW_GetFrameBuffer(DANMAKU_HW_HANDLE h, int buf_index);
void DanmakuHW_GetFrameSize(DANMAKU_HW_HANDLE h, unsigned int* height, unsigned int* width);
void DanmakuHW_RenderFlush(DANMAKU_HW_HANDLE h);
int DanmakuHW_RenderStartDMA(DANMAKU_HW_HANDLE h,uintptr_t dst, uintptr_t src, uint32_t length);
int DanmakuHW_RenderDMAIdle(DANMAKU_HW_HANDLE h);
uint32_t DanmakuHW_RenderDMAStatus(DANMAKU_HW_HANDLE h);
void DanmakuHW_AllocRenderBuf(DANMAKU_HW_HANDLE h,uintptr_t *uaddr, uintptr_t *paddr, uint32_t length);
int DanmakuHW_WaitForRenderDMA(DANMAKU_HW_HANDLE h);
int DanmakuHW_WaitForPendingTxmit(DANMAKU_HW_HANDLE h);
int DanmakuHW_ImageCapture(DANMAKU_HW_HANDLE h, uint32_t addr, uint32_t length);
int DanmakuHW_PendingImgCap(DANMAKU_HW_HANDLE h);

#endif
