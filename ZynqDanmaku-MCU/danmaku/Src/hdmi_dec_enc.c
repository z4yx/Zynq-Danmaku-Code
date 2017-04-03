
#include "common.h"
#include "hdmi_dec_enc.h"
#include "system_manage.h"
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

const static struct register_flag_t adv7513_reg42[] = {
    {.bit = 1<<7, .name="PowerDownPolHigh"},
    {.bit = 1<<6, .name="HPD_High"},
    {.bit = 1<<5, .name="ClkTermDet"},
    {.bit = 1<<3, .name="I2S_64b"},
};

const static struct register_flag_t adv7611_io_reg6a[] = {
    {.bit = 1<<6, .name="TMDSLockRaw"},
    {.bit = 1<<4, .name="TMDSDet"},
    {.bit = 1<<2, .name="Video3DRaw"},
    {.bit = 1<<1, .name="VSLockRaw"},
    {.bit = 1<<0, .name="DELockRaw"},
};

const static struct register_flag_t adv7611_hdmi_reg04[] = {
    {.bit = 1<<6, .name="AVMute"},
    {.bit = 1<<5, .name="HDCPRead"},
    {.bit = 1<<4, .name="HDCPErr"},
    {.bit = 1<<3, .name="HDCPExpire"},
    {.bit = 1<<1, .name="TMDSLock"},
    {.bit = 1<<0, .name="AudioLock"},
};

static void print_reg_state(const struct register_flag_t* def, int len, uint8_t val)
{
    int i;
    for (i = 0; i < len; ++i)
    {
        if((def[i].bit & val) == def[i].bit){
            printf(" %s", def[i].name);
        }
    }
    printf("\r\n");
}

uint8_t i2c_read_8(uint8_t baseAddr, uint8_t subAddress)
{
    HAL_StatusTypeDef ret;
    uint8_t data[1] = {0}; // `data` will store the register data
    ret = HAL_I2C_Mem_Read(&hi2c1, baseAddr, subAddress, I2C_MEMADD_SIZE_8BIT, data, 1, 100);
    if(ret != HAL_OK){
        ERR_MSG(" HAL_I2C_Mem_Read: %d", ret);
    }
    return data[0];
}

void i2c_write_8(uint8_t baseAddr, uint8_t subAddress, uint8_t writeData)
{
    HAL_StatusTypeDef ret;
    ret = HAL_I2C_Mem_Write(&hi2c1, baseAddr, subAddress, I2C_MEMADD_SIZE_8BIT, &writeData, 1, 100);
    if(ret != HAL_OK){
        ERR_MSG(" HAL_I2C_Mem_Write[%x,%x]: %d",baseAddr,subAddress, ret);
    }
}


void i2c_read_multibytes(uint8_t baseAddr, uint8_t subAddress, uint32_t count, uint8_t* buf)
{
    HAL_StatusTypeDef ret;
    ret = HAL_I2C_Mem_Read(&hi2c1, baseAddr, subAddress, I2C_MEMADD_SIZE_8BIT, buf, count, 100);
    if(ret != HAL_OK){
        ERR_MSG(" HAL_I2C_Mem_Read[%x,%x]: %d",baseAddr,subAddress, ret);
    }
}


void i2c_write_multibytes(uint8_t baseAddr, uint8_t subAddress, uint32_t count, uint8_t* buf)
{
    HAL_StatusTypeDef ret;
    ret = HAL_I2C_Mem_Write(&hi2c1, baseAddr, subAddress, I2C_MEMADD_SIZE_8BIT, buf, count, 100);
    if(ret != HAL_OK){
        ERR_MSG(" HAL_I2C_Mem_Write: %d", ret);
    }
}

//the registers can be written when HPD is low
const uint8_t REGS_7513_Init[][3] = {
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
    {0,0xD1,0xFF}, // ADI Recommended Write
    {0,0xDE,0xD8}, // ADI Recommended Write
    {0,0xE0,0xD0}, // Must be set to 0xD0 for proper operation
    {0,0xE4,0x60}, // VCO_Swing_Reference_Voltage
    {0,0xF9,0x00}, // Must be set to 0x00 for proper operation
    {0,0xFA,0x7D}, // Nbr of times to search for good phase
};

//the registers to be written after HPD assert
const uint8_t REGS_7513_Startup[][3] = {
        {0,0x41,0x10}, // Power down control
		{0,0x01,0x00}, // Set N Value(6144)
		{0,0x02,0x18}, // Set N Value(6144)
		{0,0x03,0x00}, // Set N Value(6144)
		// {0,0x15,0x00}, // Input 444 (RGB or YCrCb) with Separate Syncs, 44.1kHz fs
        {0,0x15,0x01}, //16, 20, 24 bit YCbCr 4:2:2 (separate syncs)
        // {0,0x16,0x70}, // Output format 444, 24-bit input
		{0,0x16,0x2c}, // Output format 444, 16-bit input
        // {0,0x18,0x46}, // CSC disabled
        {0,0x18,0xE6},
        {0,0x19,0x69},
        {0,0x1a,0x04},
        {0,0x1b,0xac},
        {0,0x1c,0x00},
        {0,0x1d,0x00},
        {0,0x1e,0x1c},
        {0,0x1f,0x81},
        {0,0x20,0x1c},
        {0,0x21,0xbc},
        {0,0x22,0x04},
        {0,0x23,0xad},
        {0,0x24,0x1e},
        {0,0x25,0x6e},
        {0,0x26,0x02},
        {0,0x27,0x20},
        {0,0x28,0x1f},
        {0,0x29,0xfe},
        {0,0x2a,0x04},
        {0,0x2b,0xad},
        {0,0x2c,0x08},
        {0,0x2d,0x1a},
        {0,0x2e,0x1b},
        {0,0x2f,0xa9},
		{0,0x40,0x80}, // General Control packet enable
		{0,0x48,0x08}, // Data right justified
		{0,0x49,0xA8}, // Set Dither_mode - 12-to-10 bit
		{0,0x4C,0x00}, // 8 bit Output
		{0,0x56,0x08}, // Set active format Aspect
		{0,0xAF,0x04}, // Set DVI Mode
		{0,0xBA,0x60}, // No clock delay
};

const uint8_t REGS_7611[][3] = {
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

static uint8_t EDID[2][256];
static uint8_t MonitorState[2],ADV7513_0x42[2];


static void HDMIEnc_ReadEDID(int idx)
{
    DBG_MSG("EDID reading...");
    i2c_read_multibytes(ADV7513_EDID_ADDR(idx),0,256,EDID[idx]);
}

static void HDMIEnc_DetectMonitor(int idx)
{
    int i;
    uint8_t status = i2c_read_8(ADV7513_ADDR(idx),0x42);
    uint8_t edid_ready;
    if(status != ADV7513_0x42[idx]){
        DBG_MSG("enc[%d] 0x42 changed to 0x%x",
            idx, status);
        print_reg_state(adv7513_reg42, ARRAY_SIZE(adv7513_reg42), status);
        ADV7513_0x42[idx] = status;
    }
    bool hpd = !!(status & ((1<<6)/*|(1<<5)*/));
    static uint32_t last_reread;
    switch(MonitorState[idx]){
        case 0:
            SystemManage_SetSinkPresence(idx, false);
            if(hpd){
                INFO_MSG("enc[%d] HPD changed to %d",
                    idx, (int)hpd);

                DBG_MSG("Writing registers...");
                HAL_Delay(10);
                for(i=0; i<sizeof(REGS_7513_Startup)/sizeof(REGS_7513_Startup[0]); i++){
                    i2c_write_8(ADV7513_ADDR(idx),REGS_7513_Startup[i][1],REGS_7513_Startup[i][2]);
                }
                i2c_write_8(ADV7513_ADDR(idx),0x43,ADV7513_EDID_ADDR(idx));

                last_reread = HAL_GetTick();
                MonitorState[idx] = 1;
            }
            break;
        case 1:
            if(!hpd){
                MonitorState[idx] = 0;
                break;
            }
            edid_ready = i2c_read_8(ADV7513_ADDR(idx),0x96) & (1<<2);
            if(edid_ready){
                HDMIEnc_ReadEDID(idx);
                INFO_MSG("enc[%d] EDID read", idx);
                MonitorState[idx] = 2;
            }else if(HAL_GetTick()-last_reread>1000){
                DBG_MSG("enc[%d] Try to re-read EDID...", idx);
                uint8_t k, c9 = i2c_read_8(ADV7513_ADDR(idx),0xc9);
                c9 &= 0xe0;
                c9 |= 0x13; //Reread=1, Tries=3
                /* Quote from the Programming Guide:
                If the EDID data is read in and the host determines that the data 
                needs to be reread, this bit can be set from 0 to 1 for 10 times 
                consecutively, and the current segment will be reread each time. 
                This register should be toggled from 0 to 1 for 10 times consecutively 
                to ensure a successful capture of the register value. This could 
                be useful if the EDID checksum is calculated and determined not to match.
                */
                for (k = 0; k < 10; ++k)
                {
                    i2c_write_8(ADV7513_ADDR(idx),0xc9,c9);
                }
                last_reread = HAL_GetTick();
            }
            break;
        case 2:
            if(!hpd){
                MonitorState[idx] = 0;
                break;
            }
            SystemManage_SetSinkPresence(idx, true);
            break;
        default:
            MonitorState[idx] = 0;
            break;
    }
}

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

    INFO_MSG("ADV7611 rev [0x%02x%02x]",
        i2c_read_8(ADV7611_IO_ADDR,0xea),
        i2c_read_8(ADV7611_IO_ADDR,0xeb));

	DBG_MSG("ADV7611 init done");

    for(i=0; i<sizeof(REGS_7513_Init)/sizeof(REGS_7513_Init[0]); i++){
        i2c_write_8(ADV7513_ADDR(0),REGS_7513_Init[i][1],REGS_7513_Init[i][2]);
    }

    for(i=0; i<sizeof(REGS_7513_Init)/sizeof(REGS_7513_Init[0]); i++){
        i2c_write_8(ADV7513_ADDR(1),REGS_7513_Init[i][1],REGS_7513_Init[i][2]);
    }

    INFO_MSG("ADV7513 rev [0x%x, 0x%x]",
        i2c_read_8(ADV7513_ADDR(0),0x00),
        i2c_read_8(ADV7513_ADDR(1),0x00));

	DBG_MSG("ADV7513 init done");

    return 0;
}

void HDMIDec_CheckInput(void)
{
    static uint8_t IOx6A=0,HDMIx04=0;
    uint8_t reg;
    reg = i2c_read_8(ADV7611_IO_ADDR,0x6A);
    if(reg != IOx6A){
        DBG_MSG("IO[0x6A] changed to 0x%x", reg);
        print_reg_state(adv7611_io_reg6a,ARRAY_SIZE(adv7611_io_reg6a),reg);
        IOx6A = reg;
    }
    reg = i2c_read_8(ADV7611_HDMI_ADDR,0x04);
    if(reg != HDMIx04){
        DBG_MSG("HDMI[0x04] changed to 0x%x", reg);
        print_reg_state(adv7611_hdmi_reg04,ARRAY_SIZE(adv7611_hdmi_reg04),reg);
        HDMIx04 = reg;
    }
    static uint32_t last = 0;
    uint32_t now = HAL_GetTick();
    if(now - last > 4000){
        uint8_t tmp[4];
        // i2c_read_multibytes(ADV7611_HDMI_ADDR,0x07,4,tmp);
        // DBG_MSG("width=%d", (int)(tmp[0]&0x1f)<<8 | tmp[1]);
        // DBG_MSG("height=%d", (int)(tmp[2]&0x1f)<<8 | tmp[3]);
        // DBG_MSG("IO[0x6A]=0x%x", IOx6A);
        // DBG_MSG("HDMI[0x05]=0x%x", i2c_read_8(ADV7611_HDMI_ADDR,0x05));
        last = now;
    }
}

uint8_t* HDMIDec_GetEDID(int index)
{
    return EDID[index];
}

void HDMIEnc_SetEDID(uint8_t* edid)
{
    i2c_write_multibytes(ADV7611_EDID_ADRR,0,256,edid);
}

void HDMIEnc_EnableEDID()
{
    i2c_write_8(ADV7611_KSV_ADDR,0x74,1); //Enable EDID
    DBG_MSG("done");
}

void HDMIEnc_DisableEDID()
{
    i2c_write_8(ADV7611_KSV_ADDR,0x74,0); //Disable EDID
    DBG_MSG("done");
}

void HDMI_Task(void){
	HDMIEnc_DetectMonitor(0);
    HDMIEnc_DetectMonitor(1);
    HDMIDec_CheckInput();

}
