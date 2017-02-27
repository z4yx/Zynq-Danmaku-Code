
#include "hdmi_dec_enc.h"
#include "common.h"
#include "main.h"
#include <string.h>

extern I2C_HandleTypeDef hi2c1;

#define ADV7611_ALSB_PU 0x0
#define ADV7611_IO_ADDR      (0x98 | ADV7611_ALSB_PU)
#define ADV7611_CP_ADDR   0x44
#define ADV7611_HDMI_ADDR 0x68
#define ADV7611_EDID_ADRR 0x6C
#define ADV7611_KSV_ADDR  0x64
#define ADV7611_DPLL_ADDR 0x4C
#define ADV7611_INF_ADDR  0x7C
#define ADV7611_CEC_ADDR  0x80

#define ADV7513_ADDR(idx) (0x72|((idx)<<3))
#define ADV7513_EDID_ADDR(idx) (0x52|((idx)<<3))

uint8_t i2c_read_8(uint8_t baseAddr, uint8_t subAddress)
{
    HAL_StatusTypeDef ret;
    uint8_t data[1] = {0}; // `data` will store the register data
    ret = HAL_I2C_Mem_Read(&hi2c1, baseAddr, subAddress, I2C_MEMADD_SIZE_8BIT, data, 1, 100);
    if(ret != HAL_OK){
        DBG_MSG(" HAL_I2C_Mem_Read: %d", ret);
    }
    return data[0];
}

void i2c_write_8(uint8_t baseAddr, uint8_t subAddress, uint8_t writeData)
{
    HAL_StatusTypeDef ret;
    ret = HAL_I2C_Mem_Write(&hi2c1, baseAddr, subAddress, I2C_MEMADD_SIZE_8BIT, &writeData, 1, 100);
    if(ret != HAL_OK){
        DBG_MSG(" HAL_I2C_Mem_Write: %d", ret);
    }
}


void i2c_read_multibytes(uint8_t baseAddr, uint8_t subAddress, uint32_t count, uint8_t* buf)
{
    HAL_StatusTypeDef ret;
    ret = HAL_I2C_Mem_Read(&hi2c1, baseAddr, subAddress, I2C_MEMADD_SIZE_8BIT, buf, count, 100);
    if(ret != HAL_OK){
        DBG_MSG(" HAL_I2C_Mem_Read: %d", ret);
    }
}


void i2c_write_multibytes(uint8_t baseAddr, uint8_t subAddress, uint32_t count, uint8_t* buf)
{
    HAL_StatusTypeDef ret;
    ret = HAL_I2C_Mem_Write(&hi2c1, baseAddr, subAddress, I2C_MEMADD_SIZE_8BIT, buf, count, 100);
    if(ret != HAL_OK){
        DBG_MSG(" HAL_I2C_Mem_Write: %d", ret);
    }
}

uint8_t REGS_7513[][3] = {
		{0,0x01,0x00}, // Set N Value(6144)
		{0,0x02,0x18}, // Set N Value(6144)
		{0,0x03,0x00}, // Set N Value(6144)
		{0,0x15,0x00}, // Input 444 (RGB or YCrCb) with Separate Syncs, 44.1kHz fs
		{0,0x16,0x70}, // Output format 444, 24-bit input
		{0,0x18,0x46}, // CSC disabled
		{0,0x40,0x80}, // General Control packet enable
		{0,0x41,0x10}, // Power down control
		{0,0x48,0x08}, // Data right justified
		{0,0x49,0xA8}, // Set Dither_mode - 12-to-10 bit
		{0,0x4C,0x00}, // 8 bit Output
		{0,0x56,0x08}, // Set active format Aspect
		{0,0x96,0x20}, // HPD Interrupt clear
		{0,0x98,0x03}, // ADI Recommended Write
		{0,0x99,0x02}, // ADI Recommended Write
		{0,0x9A,0xE0}, // Must be set to 0b1110000
		{0,0x9C,0x30}, // PLL Filter R1 Value
		{0,0x9D,0x61}, // Set clock divide
		{0,0xA2,0xA4}, // ADI Recommended Write
		{0,0xA3,0xA4}, // ADI Recommended Write
		{0,0xA5,0x04}, // ADI Recommended Write
		{0,0xAB,0x40}, // ADI Recommended Write
		{0,0xAF,0x16}, // Set HDMI Mode
		{0,0xBA,0x60}, // No clock delay
		{0,0xD1,0xFF}, // ADI Recommended Write
		{0,0xDE,0xD8}, // ADI Recommended Write
		{0,0xE0,0xD0}, // Must be set to 0xD0 for proper operation
		{0,0xE4,0x60}, // VCO_Swing_Reference_Voltage
		{0,0xF9,0x00}, // Must be set to 0x00 for proper operation
		{0,0xFA,0x7D}, // Nbr of times to search for good phase
};

uint8_t REGS_7611[][3] = {
		//{ADV7611_IO_ADDR,0xFF,0x80}, // I2C reset
		{ADV7611_IO_ADDR,0xF4,ADV7611_CEC_ADDR}, // CEC
		{ADV7611_IO_ADDR,0xF5,ADV7611_INF_ADDR}, // INFOFRAME
		{ADV7611_IO_ADDR,0xF8,ADV7611_DPLL_ADDR}, // DPLL
		{ADV7611_IO_ADDR,0xF9,ADV7611_KSV_ADDR}, // KSV
		{ADV7611_IO_ADDR,0xFA,ADV7611_EDID_ADRR}, // EDID
		{ADV7611_IO_ADDR,0xFB,ADV7611_HDMI_ADDR}, // HDMI
		{ADV7611_IO_ADDR,0xFD,ADV7611_CP_ADDR}, // CP
		{ADV7611_IO_ADDR,0x01,0x06}, // Prim_Mode =110b HDMI-GR
		{ADV7611_IO_ADDR,0x02,0xF2}, // Auto CSC, RGB out
		{ADV7611_IO_ADDR,0x03,0x40}, // 24 bit SDR 444 Mode 0
		{ADV7611_IO_ADDR,0x05,0x28}, // AV Codes Off
		{ADV7611_IO_ADDR,0x0B,0x44}, // Power up part
		{ADV7611_IO_ADDR,0x0C,0x42}, // Power up part
		{ADV7611_IO_ADDR,0x14,0x7F}, // Max Drive Strength
		{ADV7611_IO_ADDR,0x15,0x80}, // Disable Tristate of Pins
		{ADV7611_IO_ADDR,0x19,0x88}, // LLC DLL phase
		{ADV7611_IO_ADDR,0x33,0x40}, // LLC DLL enable
		{ADV7611_IO_ADDR,0x06,0xA1}, // LLC Invert

		{ADV7611_CP_ADDR,0x6C,0x00}, // ADI required setting
		{ADV7611_CP_ADDR,0xBA,0x01}, // Set HDMI FreeRun
		//{ADV7611_CP_ADDR,0x7B,0x04}, // No DE_WITH_AVCODE

		{ADV7611_CP_ADDR,0xBF,0x06}, // FreeRun Manual Color
		{ADV7611_CP_ADDR,0xC0,0x55}, // FreeRun Color A
		{ADV7611_CP_ADDR,0xC1,0x55}, // FreeRun Color B
		{ADV7611_CP_ADDR,0xC2,0x55}, // FreeRun Color C

		{ADV7611_KSV_ADDR,0x40,0x81}, // Disable HDCP 1.1 features

		{ADV7611_HDMI_ADDR,0x9B,0x03}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xC1,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xC2,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xC3,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xC4,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xC5,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xC6,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xC7,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xC8,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xC9,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xCA,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xCB,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0xCC,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0x00,0x00}, // Set HDMI Input Port A
		{ADV7611_HDMI_ADDR,0x83,0xFE}, // Enable clock terminator for port A
		{ADV7611_HDMI_ADDR,0x6F,0x0C}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0x85,0x1F}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0x87,0x70}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0x8D,0x04}, // LFG
		{ADV7611_HDMI_ADDR,0x8E,0x1E}, // HFG
		{ADV7611_HDMI_ADDR,0x1A,0x8A}, // unmute audio
		{ADV7611_HDMI_ADDR,0x57,0xDA}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0x58,0x01}, // ADI recommended setting
		{ADV7611_HDMI_ADDR,0x4C,0x44}, // Set NEW_VS_PARAM 0x44[2]=1
		{ADV7611_HDMI_ADDR,0x03,0x98}, // DIS_I2C_ZERO_COMPR
		{ADV7611_HDMI_ADDR,0x75,0x10}, // DDC drive strength
};

uint8_t EDID[256];


int HDMI_Init(void)
{ 
	int i;

	HAL_GPIO_WritePin(VIN_RST_GPIO_Port, VIN_RST_Pin, GPIO_PIN_SET); //Release ADV7611 reset

    HAL_Delay(200); //waiting for I2C address detection

    i2c_write_8((ADV7611_IO_ADDR),0xFF,0x80); //Main Reset

    HAL_Delay(50);

	for(i=0; i<sizeof(REGS_7611)/sizeof(REGS_7611[0]); i++){
		i2c_write_8(REGS_7611[i][0],REGS_7611[i][1],REGS_7611[i][2]);
	}

	DBG_MSG("ADV7611 init done");

    for(i=0; i<sizeof(REGS_7513)/sizeof(REGS_7513[0]); i++){
        i2c_write_8(ADV7513_ADDR(0),REGS_7513[i][1],REGS_7513[i][2]);
    }

    for(i=0; i<sizeof(REGS_7513)/sizeof(REGS_7513[0]); i++){
        i2c_write_8(ADV7513_ADDR(1),REGS_7513[i][1],REGS_7513[i][2]);
    }

    i2c_write_8(ADV7513_ADDR(0),0x43,ADV7513_EDID_ADDR(0));
    i2c_write_8(ADV7513_ADDR(1),0x43,ADV7513_EDID_ADDR(1));

	DBG_MSG("ADV7513 init done");

	/* Event loop never exits. */
	uint8_t hpd_last = 0, hpd;

	while (1) {
		uint8_t tmp[4];
		uint8_t status = i2c_read_8(ADV7513_ADDR(0),0x42);
		hpd = (status & ((1<<6)/*|(1<<5)*/));
		if(hpd ^ hpd_last){
			DBG_MSG("monitor status 0x%x",hpd);
			hpd_last = hpd;
			if(hpd == ((1<<6)/*|(1<<5)*/)){
				DBG_MSG("EDID reading...");
				while((i2c_read_8(ADV7513_ADDR(0),0x96) & (1<<2)) == 0);
				DBG_MSG("EDID read");
				i2c_read_multibytes(ADV7513_EDID_ADDR(0),0,256,EDID);
				EDID[126] = 0;//Extension block
				memset(EDID+128,0,128);
				i2c_write_multibytes(ADV7611_EDID_ADRR,0,256,EDID);
				i2c_write_8(ADV7611_KSV_ADDR,0x74,1); //Enable EDID
			}
		}
		HAL_Delay(500);
		i2c_read_multibytes(ADV7611_HDMI_ADDR,0x07,4,tmp);
		DBG_MSG("width=%d", (int)(tmp[0]&0x1f)<<8 | tmp[1]);
		DBG_MSG("height=%d", (int)(tmp[2]&0x1f)<<8 | tmp[3]);
		DBG_MSG("7611HDMI[0x05]=0x%x", i2c_read_8(ADV7611_HDMI_ADDR,0x05));
	}

	return 0;
}
