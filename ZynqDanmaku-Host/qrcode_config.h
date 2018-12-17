#pragma once

#include <stdio.h>

#ifdef __cplusplus
extern "C"{
#endif

enum{
    QrCodeParseOK = 0,

    QrCodeNotFound = -1000,
    QrCodeContentErr,
    QrCodeInvalidIPv4,
    QrCodeInvalidIPv6,
    QrCodeInvalidURL,
    QrCodeNeither4Nor6
};

int ExtractConfig(void* image, size_t len, int height, int width);
int ApplyConfig();


#ifdef __cplusplus
}
#endif