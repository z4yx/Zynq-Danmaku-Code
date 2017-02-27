#ifndef __COMMON__H__
#define __COMMON__H__

#include "stm32f0xx_hal.h"
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

#define DEBUG

#define ARRAY_SIZE(_Array) (sizeof(_Array) / sizeof(_Array[0]))

#define STATIC_ASSERT(COND,MSG) typedef char static_assertion_##MSG[(!!(COND))*2-1]


#ifdef DEBUG
#define DBG_MSG(format, ...) printf("[Debug]%s: " format "\r\n", __func__, ##__VA_ARGS__)
#else
#define DBG_MSG(format, ...) do{}while(0)
#endif
#define INFO_MSG(format, ...) printf("[Info]%s: " format "\r\n", __func__, ##__VA_ARGS__)
#define ERR_MSG(format, ...) printf("[Error]%s: " format "\r\n", __func__, ##__VA_ARGS__)
 
#endif /* __COMMON__H__ */
