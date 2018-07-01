# Runtime Tcl commands to interact with - simple_sgdma_v1_0

# Sourcing design address info tcl
set bd_path [get_property DIRECTORY [current_project]]/[current_project].srcs/[current_fileset]/bd
source ${bd_path}/simple_sgdma_v1_0_include.tcl

# jtag axi master interface hardware name, change as per your design.
set jtag_axi_master hw_axi_1
set ec 0

# hw test script
# Delete all previous axis transactions
if { [llength [get_hw_axi_txns -quiet]] } {
	delete_hw_axi_txn [get_hw_axi_txns -quiet]
}


# Test all lite slaves.
set wdata_1 abcd1234

# Test: axi_lite_reg
# Create a write transaction at axi_lite_reg_addr address
create_hw_axi_txn w_axi_lite_reg_addr [get_hw_axis $jtag_axi_master] -type write -address $axi_lite_reg_addr -data $wdata_1
# Create a read transaction at axi_lite_reg_addr address
create_hw_axi_txn r_axi_lite_reg_addr [get_hw_axis $jtag_axi_master] -type read -address $axi_lite_reg_addr
# Initiate transactions
run_hw_axi r_axi_lite_reg_addr
run_hw_axi w_axi_lite_reg_addr
run_hw_axi r_axi_lite_reg_addr
set rdata_tmp [get_property DATA [get_hw_axi_txn r_axi_lite_reg_addr]]
# Compare read data
if { $rdata_tmp == $wdata_1 } {
	puts "Data comparison test pass for - axi_lite_reg"
} else {
	puts "Data comparison test fail for - axi_lite_reg, expected-$wdata_1 actual-$rdata_tmp"
	inc ec
}

# Check error flag
if { $ec == 0 } {
	 puts "PTGEN_TEST: PASSED!" 
} else {
	 puts "PTGEN_TEST: FAILED!" 
}

