
#define ADV7611_ALSB_PU 0x0

alt_u8 REGS_7513[][3] = {
		{0x72,0x01,0x00}, // Set N Value(6144)
		{0x72,0x02,0x18}, // Set N Value(6144)
		{0x72,0x03,0x00}, // Set N Value(6144)
		{0x72,0x15,0x00}, // Input 444 (RGB or YCrCb) with Separate Syncs, 44.1kHz fs
		{0x72,0x16,0x70}, // Output format 444, 24-bit input
		{0x72,0x18,0x46}, // CSC disabled
		{0x72,0x40,0x80}, // General Control packet enable
		{0x72,0x41,0x10}, // Power down control
		{0x72,0x48,0x08}, // Data right justified
		{0x72,0x49,0xA8}, // Set Dither_mode - 12-to-10 bit
		{0x72,0x4C,0x00}, // 8 bit Output
		{0x72,0x56,0x08}, // Set active format Aspect
		{0x72,0x96,0x20}, // HPD Interrupt clear
		{0x72,0x98,0x03}, // ADI Recommended Write
		{0x72,0x99,0x02}, // ADI Recommended Write
		{0x72,0x9A,0xE0}, // Must be set to 0b1110000
		{0x72,0x9C,0x30}, // PLL Filter R1 Value
		{0x72,0x9D,0x61}, // Set clock divide
		{0x72,0xA2,0xA4}, // ADI Recommended Write
		{0x72,0xA3,0xA4}, // ADI Recommended Write
		{0x72,0xA5,0x04}, // ADI Recommended Write
		{0x72,0xAB,0x40}, // ADI Recommended Write
		{0x72,0xAF,0x16}, // Set HDMI Mode
		{0x72,0xBA,0x60}, // No clock delay
		{0x72,0xD1,0xFF}, // ADI Recommended Write
		{0x72,0xDE,0xD8}, // ADI Recommended Write
		{0x72,0xE0,0xD0}, // Must be set to 0xD0 for proper operation
		{0x72,0xE4,0x60}, // VCO_Swing_Reference_Voltage
		{0x72,0xF9,0x00}, // Must be set to 0x00 for proper operation
		{0x72,0xFA,0x7D}, // Nbr of times to search for good phase
};

alt_u8 REGS_7611[][3] = {
		//{0x98|ADV7611_ALSB_PU,0xFF,0x80}, // I2C reset
		{0x98|ADV7611_ALSB_PU,0xF4,0x80}, // CEC
		{0x98|ADV7611_ALSB_PU,0xF5,0x7C}, // INFOFRAME
		{0x98|ADV7611_ALSB_PU,0xF8,0x4C}, // DPLL
		{0x98|ADV7611_ALSB_PU,0xF9,0x64}, // KSV
		{0x98|ADV7611_ALSB_PU,0xFA,0x6C}, // EDID
		{0x98|ADV7611_ALSB_PU,0xFB,0x68}, // HDMI
		{0x98|ADV7611_ALSB_PU,0xFD,0x44}, // CP
		{0x98|ADV7611_ALSB_PU,0x01,0x06}, // Prim_Mode =110b HDMI-GR
		{0x98|ADV7611_ALSB_PU,0x02,0xF2}, // Auto CSC, RGB out
		{0x98|ADV7611_ALSB_PU,0x03,0x40}, // 24 bit SDR 444 Mode 0
		{0x98|ADV7611_ALSB_PU,0x05,0x28}, // AV Codes Off
		{0x98|ADV7611_ALSB_PU,0x0B,0x44}, // Power up part
		{0x98|ADV7611_ALSB_PU,0x0C,0x42}, // Power up part
		{0x98|ADV7611_ALSB_PU,0x14,0x7F}, // Max Drive Strength
		{0x98|ADV7611_ALSB_PU,0x15,0x80}, // Disable Tristate of Pins
		{0x98|ADV7611_ALSB_PU,0x19,0x88}, // LLC DLL phase
		{0x98|ADV7611_ALSB_PU,0x33,0x40}, // LLC DLL enable
		{0x98|ADV7611_ALSB_PU,0x06,0xA1}, // LLC Invert
		{0x44,0x6C,0x00}, // ADI required setting
		{0x44,0xBA,0x01}, // Set HDMI FreeRun
		//{0x44,0x7B,0x04}, // No DE_WITH_AVCODE

		{0x44,0xBF,0x06}, // FreeRun Manual Color
		{0x44,0xC0,0x55}, // FreeRun Color A
		{0x44,0xC1,0x55}, // FreeRun Color B
		{0x44,0xC2,0x55}, // FreeRun Color C

		{0x64,0x40,0x81}, // Disable HDCP 1.1 features
		{0x68,0x9B,0x03}, // ADI recommended setting
		{0x68,0xC1,0x01}, // ADI recommended setting
		{0x68,0xC2,0x01}, // ADI recommended setting
		{0x68,0xC3,0x01}, // ADI recommended setting
		{0x68,0xC4,0x01}, // ADI recommended setting
		{0x68,0xC5,0x01}, // ADI recommended setting
		{0x68,0xC6,0x01}, // ADI recommended setting
		{0x68,0xC7,0x01}, // ADI recommended setting
		{0x68,0xC8,0x01}, // ADI recommended setting
		{0x68,0xC9,0x01}, // ADI recommended setting
		{0x68,0xCA,0x01}, // ADI recommended setting
		{0x68,0xCB,0x01}, // ADI recommended setting
		{0x68,0xCC,0x01}, // ADI recommended setting
		{0x68,0x00,0x00}, // Set HDMI Input Port A
		{0x68,0x83,0xFE}, // Enable clock terminator for port A
		{0x68,0x6F,0x0C}, // ADI recommended setting
		{0x68,0x85,0x1F}, // ADI recommended setting
		{0x68,0x87,0x70}, // ADI recommended setting
		{0x68,0x8D,0x04}, // LFG
		{0x68,0x8E,0x1E}, // HFG
		{0x68,0x1A,0x8A}, // unmute audio
		{0x68,0x57,0xDA}, // ADI recommended setting
		{0x68,0x58,0x01}, // ADI recommended setting
		{0x68,0x4C,0x44}, // Set NEW_VS_PARAM 0x44[2]=1
		{0x68,0x03,0x98}, // DIS_I2C_ZERO_COMPR
		{0x68,0x75,0x10}, // DDC drive strength
};

alt_u8 EDID[256];


int main()
{ 
	int i;
	alt_putstr("Hello from Nios II!\n");
    I2C_init(I2C_MASTER_DECA_BASE,50000000,100000);
    I2C_init(I2C_MASTER_BBB_BASE,50000000,100000);

    i2c_write_8(I2C_MASTER_BBB_BASE,(0x98|ADV7611_ALSB_PU)>>1,0xFF,0x80); //Main Reset

    usleep(50000);

	for(i=0; i<sizeof(REGS_7611)/sizeof(REGS_7611[0]); i++){
		i2c_write_8(I2C_MASTER_BBB_BASE,REGS_7611[i][0]>>1,REGS_7611[i][1],REGS_7611[i][2]);
	}

	alt_putstr("ADV7611 init done\n");

	for(i=0; i<sizeof(REGS_7513)/sizeof(REGS_7513[0]); i++){
		i2c_write_8(I2C_MASTER_DECA_BASE,REGS_7513[i][0]>>1,REGS_7513[i][1],REGS_7513[i][2]);
	}

	alt_putstr("ADV7513 init done\n");

	/* Event loop never exits. */
	alt_u8 hpd_last = 0, hpd;

	while (1) {
		alt_u8 tmp[4];
		alt_u8 status = i2c_read_8(I2C_MASTER_DECA_BASE,0x72>>1,0x42);
		hpd = (status & ((1<<6)/*|(1<<5)*/));
		if(hpd ^ hpd_last){
			printf("monitor status %d\n",hpd);
			hpd_last = hpd;
			if(hpd == ((1<<6)/*|(1<<5)*/)){
				printf("EDID reading...\n");
				while((i2c_read_8(I2C_MASTER_DECA_BASE,0x72>>1,0x96) & (1<<2)) == 0);
				printf("EDID read\n");
				i2c_read_multibyes(I2C_MASTER_DECA_BASE,0x7E>>1,0,256,EDID);
				EDID[126] = 0;//Extension block
				memset(EDID+128,0,128);
				i2c_write_multibyes(I2C_MASTER_BBB_BASE,0x6C>>1,0,256,EDID);
				i2c_write_8(I2C_MASTER_BBB_BASE,0x64>>1,0x74,1); //Enable EDID
			}
		}
		usleep(500000);
		i2c_read_multibyes(I2C_MASTER_BBB_BASE,0x68>>1,0x07,4,tmp);
		printf("width=%d\n", (int)(tmp[0]&0x1f)<<8 | tmp[1]);
		printf("height=%d\n", (int)(tmp[2]&0x1f)<<8 | tmp[3]);
		printf("7611HDMI-0x05=0x%x\n", i2c_read_8(I2C_MASTER_BBB_BASE,0x68>>1,0x05));
	}

	return 0;
}
