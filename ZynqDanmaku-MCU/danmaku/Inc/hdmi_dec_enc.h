/*
 * hdmi_dec_enc.h
 *
 *  Created on: 2017年2月24日
 *      Author: zhang
 */

#ifndef HDMI_DEC_ENC_H_
#define HDMI_DEC_ENC_H_

int HDMI_Init(void);
void HDMI_Task(void);
uint8_t* HDMIDec_GetEDID(int index);
void HDMIEnc_SetEDID(uint8_t* edid);
void HDMIEnc_EnableEDID(void);
void HDMIEnc_DisableEDID(void);
void HDMIEnc_OutFmtSwitch(int idx, int isHDMI, int isYCbCr);

struct register_flag_t{
    uint8_t bit;
    const char* name;
};

#endif /* HDMI_DEC_ENC_H_ */
