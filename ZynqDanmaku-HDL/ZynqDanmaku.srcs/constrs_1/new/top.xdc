
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports mcu_rst_n]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports mcu_boot]
set_property PACKAGE_PIN M19 [get_ports mcu_tx]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_tx]
set_property PULLUP true [get_ports mcu_tx]
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports mcu_rx]

set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {switch_in[0]}]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {switch_in[1]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {switch_in[2]}]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports {switch_in[3]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {switch_in[4]}]

set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports {led_out_n[0]}]
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports {led_out_n[1]}]
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports {led_out_n[2]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {led_out_n[3]}]
set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports {led_out_n[4]}]

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets IN_CLK_IBUF]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets IN_CLK_IBUF_BUFG]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets in_pll/inst/clk_in1_clk_wiz_0]

set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports IN_VS]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports IN_HS]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports IN_DE]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports IN_CLK]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports O1_VS]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports O2_VS]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports HSA]
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33} [get_ports HSB]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports DEA]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports DEB]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports CLKA]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports CLKB]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports O1_SCLK]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports O2_SCLK]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports MCLKA]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD LVCMOS33} [get_ports MCLKB]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports LRCLKA]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports LRCLKB]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports IN_SCLK]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports IN_MCLK]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports IN_LR]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports I2S]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {IN_D[0]}]
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports {IN_D[1]}]
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {IN_D[2]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {IN_D[3]}]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {IN_D[4]}]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {IN_D[5]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33} [get_ports {IN_D[6]}]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {IN_D[7]}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {IN_D[8]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports {IN_D[9]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports {IN_D[10]}]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports {IN_D[11]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {IN_D[12]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {IN_D[13]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {IN_D[14]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {IN_D[15]}]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {IN_D[16]}]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {IN_D[17]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {IN_D[18]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {IN_D[19]}]
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports {IN_D[20]}]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {IN_D[21]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {IN_D[22]}]
set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports {IN_D[23]}]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports {O1_D[8]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {O1_D[9]}]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {O1_D[10]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports {O1_D[11]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {O1_D[12]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {O1_D[13]}]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {O1_D[14]}]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {O1_D[15]}]
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33} [get_ports {O1_D[16]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {O1_D[17]}]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {O1_D[18]}]
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports {O1_D[19]}]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {O1_D[20]}]
set_property -dict {PACKAGE_PIN T12 IOSTANDARD LVCMOS33} [get_ports {O1_D[21]}]
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports {O1_D[22]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {O1_D[23]}]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports {O2_D[8]}]
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports {O2_D[9]}]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {O2_D[10]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {O2_D[11]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {O2_D[12]}]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {O2_D[13]}]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {O2_D[14]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {O2_D[15]}]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports {O1_D[0]}]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports {O1_D[1]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {O1_D[2]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {O1_D[3]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports {O1_D[4]}]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {O1_D[5]}]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports {O1_D[6]}]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports {O1_D[7]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports {O1_I2S[0]}]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports {O1_I2S[1]}]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33} [get_ports {O2_I2S[0]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports {O2_I2S[1]}]

create_clock -period 6.667 -name IN_CLK -waveform {0.000 3.334} [get_ports IN_CLK]

#create_generated_clock -name in_clk_pll -source [get_pins in_pll/clk_in1] -multiply_by 1 [get_pins in_pll/clk_out1]
#create_generated_clock -name hdmi_clk_a -source [get_pins adapter/pll/clk_out2] -multiply_by 1 [get_ports CLKA]
#create_generated_clock -name hdmi_clk_b -source [get_pins adapter/pll/clk_in1] -multiply_by 1 [get_pins adapter/pll/clk_out3]
create_generated_clock -name hdmi_clk_a -source [get_pins in_pll/inst/clk_out2] -multiply_by 1 [get_ports CLKA]
create_generated_clock -name hdmi_clk_b -source [get_pins in_pll/inst/clk_out2] -multiply_by 1 [get_ports CLKB]

set_input_delay -clock clk_out1_clk_wiz_0 -min -add_delay 1.100 [get_ports {IN_D[*]}]
set_input_delay -clock clk_out1_clk_wiz_0 -max -add_delay 3.600 [get_ports {IN_D[*]}]
set_input_delay -clock clk_out1_clk_wiz_0 -min -add_delay 1.100 [get_ports IN_DE]
set_input_delay -clock clk_out1_clk_wiz_0 -max -add_delay 3.600 [get_ports IN_DE]
set_input_delay -clock clk_out1_clk_wiz_0 -min -add_delay 1.100 [get_ports IN_HS]
set_input_delay -clock clk_out1_clk_wiz_0 -max -add_delay 3.600 [get_ports IN_HS]
set_input_delay -clock clk_out1_clk_wiz_0 -min -add_delay 1.100 [get_ports IN_VS]
set_input_delay -clock clk_out1_clk_wiz_0 -max -add_delay 3.600 [get_ports IN_VS]
set_output_delay -clock hdmi_clk_a -min -add_delay -1.400 [get_ports {O1_D[*]}]
set_output_delay -clock hdmi_clk_a -max -add_delay 1.900 [get_ports {O1_D[*]}]
set_output_delay -clock hdmi_clk_a -min -add_delay -1.400 [get_ports DEA]
set_output_delay -clock hdmi_clk_a -max -add_delay 1.900 [get_ports DEA]
set_output_delay -clock hdmi_clk_a -min -add_delay -1.400 [get_ports HSA]
set_output_delay -clock hdmi_clk_a -max -add_delay 1.900 [get_ports HSA]
set_output_delay -clock hdmi_clk_a -min -add_delay -1.400 [get_ports O1_VS]
set_output_delay -clock hdmi_clk_a -max -add_delay 1.900 [get_ports O1_VS]

set_output_delay -clock hdmi_clk_b -min -add_delay -1.300 [get_ports {O2_D[*]}]
set_output_delay -clock hdmi_clk_b -max -add_delay 1.950 [get_ports {O2_D[*]}]
set_output_delay -clock hdmi_clk_b -min -add_delay -1.300 [get_ports DEB]
set_output_delay -clock hdmi_clk_b -max -add_delay 1.950 [get_ports DEB]
set_output_delay -clock hdmi_clk_b -min -add_delay -1.300 [get_ports HSB]
set_output_delay -clock hdmi_clk_b -max -add_delay 1.950 [get_ports HSB]
set_output_delay -clock hdmi_clk_b -min -add_delay -1.300 [get_ports O2_VS]
set_output_delay -clock hdmi_clk_b -max -add_delay 1.950 [get_ports O2_VS]

set_property ASYNC_REG true [get_cells {top_blk_i/top_blk_i/system_ctl_reg_0/inst/system_ctl_reg_v1_0_S00_AXI_inst/resolution_sync_reg[0][*]}]
set_property ASYNC_REG true [get_cells {gen_hdmi[*].hdmi_o/en_overlay_sync_reg[0]}]
set_property ASYNC_REG true [get_cells {gen_hdmi[*].hdmi_o/en_blank_sync_reg[0]}]

set_false_path -from [get_pins {btn/state_switch[*].state_out_reg[*]/C}] -to [get_pins {gen_hdmi[*].hdmi_o/en_overlay_sync_reg[0]/D}]
set_false_path -from [get_pins {btn/state_switch[*].state_out_reg[*]/C}] -to [get_pins {gen_hdmi[*].hdmi_o/en_blank_sync_reg[0]/D}]
set_false_path -from [get_pins {overlay_logic_1/pxlCounter_inst/screenX_reg[*]/C}] -to [get_pins {top_blk_i/top_blk_i/system_ctl_reg_0/inst/system_ctl_reg_v1_0_S00_AXI_inst/resolution_sync_reg[0][*]/D}]
set_false_path -from [get_pins {top_blk_i/top_blk_i/axis_data_fifo_0/inst/gen_fifo_generator.fifo_generator_inst/inst_fifo_gen/gaxis_fifo.gaxisf.axisf/grf.rf/gntv_or_sync_fifo.gl0.rd/gr1.gdcf.dc/dc/count_reg[*]/C}] -to [get_pins {top_blk_i/top_blk_i/system_ctl_reg_0/inst/system_ctl_reg_v1_0_S00_AXI_inst/overlay_fifo_cnt_sync_reg[0][*]/D}]
set_false_path -from [get_pins {top_blk_i/top_blk_i/axigpio_ctl/U0/gpio_core_1/Dual.gpio2_Data_Out_reg[*]/C}]
#set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks clk_out1_clk_wiz_0]


