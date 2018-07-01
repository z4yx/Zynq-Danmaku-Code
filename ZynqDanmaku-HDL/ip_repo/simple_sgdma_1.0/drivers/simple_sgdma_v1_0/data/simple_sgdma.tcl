

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "simple_sgdma" "NUM_INSTANCES" "DEVICE_ID"  "C_axi_lite_reg_BASEADDR" "C_axi_lite_reg_HIGHADDR"
}
