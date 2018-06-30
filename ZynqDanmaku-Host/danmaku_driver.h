#ifndef DANMAKU_DRIVER_H__
#define DANMAKU_DRIVER_H__ 

#include <ctype.h>
#include <stdint.h>
#include <stdbool.h>

typedef void* DANMAKU_HW_HANDLE;

DANMAKU_HW_HANDLE DanmakuHW_Open(void);
const char* DanmakuHW_GetFPGABuildTime(DANMAKU_HW_HANDLE h);
void DanmakuHW_GetFrameSize(DANMAKU_HW_HANDLE h, unsigned int* height, unsigned int* width);
void DanmakuHW_GetFIFOUsage(DANMAKU_HW_HANDLE h, unsigned int* size);

void DanmakuHW_AllocRenderBuf(DANMAKU_HW_HANDLE h,uintptr_t *uaddr, uintptr_t *paddr, uint32_t length);
void DanmakuHW_DestroyRenderBuf(DANMAKU_HW_HANDLE h);
uintptr_t DanmakuHW_GetFrameBuffer(DANMAKU_HW_HANDLE h, int buf_index);

int DanmakuHW_FrameBufferTxmit(DANMAKU_HW_HANDLE h, int buf_index, int tag, uint32_t length);
int DanmakuHW_ClearResponse(DANMAKU_HW_HANDLE h);
int DanmakuHW_ResponseOfOverlay(DANMAKU_HW_HANDLE h, bool *ok, bool *err, int *tag);

void DanmakuHW_RenderFlush(DANMAKU_HW_HANDLE h);
int DanmakuHW_RenderStartDMA(DANMAKU_HW_HANDLE h,uintptr_t dst, uintptr_t src, uint32_t length);
int DanmakuHW_RenderDMAIdle(DANMAKU_HW_HANDLE h);
uint32_t DanmakuHW_RenderDMAStatus(DANMAKU_HW_HANDLE h);
int DanmakuHW_WaitForRenderDMA(DANMAKU_HW_HANDLE h);

int DanmakuHW_ImageCapture(DANMAKU_HW_HANDLE h, uint32_t addr, uint32_t length);
int DanmakuHW_PendingImgCap(DANMAKU_HW_HANDLE h);

#endif
