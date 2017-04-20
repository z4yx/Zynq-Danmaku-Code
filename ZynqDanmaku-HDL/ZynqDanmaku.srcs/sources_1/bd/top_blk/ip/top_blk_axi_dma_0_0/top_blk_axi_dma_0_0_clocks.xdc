# file: top_blk_axi_dma_0_0.xdc
# (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
# 
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
# 
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
# 
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
# 
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
# Design is in Asynchronous. Following constraints needed in this mode.


## INFO: Level CDC Crossing in AXI DMA


## Following constraints are needed for various ASYNC FIFOs



## MM2S

set mm2s_sts_wr_clock [get_clocks -of_objects [get_ports m_axi_mm2s_aclk]]
set mm2s_sts_rd_clock [get_clocks -of_objects [get_ports s_axi_lite_aclk]]
  set mm2s_sts_wr_clk_period     [get_property PERIOD $mm2s_sts_wr_clock]
  set mm2s_sts_rd_clk_period     [get_property PERIOD $mm2s_sts_rd_clock]
  set mm2s_sts_skew_value [expr {(($mm2s_sts_wr_clk_period < $mm2s_sts_rd_clk_period) ? $mm2s_sts_wr_clk_period : $mm2s_sts_rd_clk_period)} ]
  set_max_delay -from [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/GEN_INCLUDE_STATUS_FIFO.I_STS_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]] -to [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/GEN_INCLUDE_STATUS_FIFO.I_STS_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].wr_stg_inst/Q_reg_reg[*]] -datapath_only [get_property  -min PERIOD $mm2s_sts_rd_clock]
  set_max_delay -from [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/GEN_INCLUDE_STATUS_FIFO.I_STS_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]] -to [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/GEN_INCLUDE_STATUS_FIFO.I_STS_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].rd_stg_inst/Q_reg_reg[*]] -datapath_only [get_property  -min PERIOD $mm2s_sts_wr_clock]

  set_bus_skew -from [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/GEN_INCLUDE_STATUS_FIFO.I_STS_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]] -to [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/GEN_INCLUDE_STATUS_FIFO.I_STS_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].wr_stg_inst/Q_reg_reg[*]] $mm2s_sts_skew_value
  set_bus_skew -from [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/GEN_INCLUDE_STATUS_FIFO.I_STS_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]] -to [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/GEN_INCLUDE_STATUS_FIFO.I_STS_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].rd_stg_inst/Q_reg_reg[*]] $mm2s_sts_skew_value
  set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gsckt_wrst.gic_rst.sckt_wrst_i_reg}] -to [get_cells -hierarchical -filter {NAME =~ *gsckt_wrst.gic_rst.garst_sync_ic[1].rd_rst_inst/Q_reg_reg[0]}]
  set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gsckt_wrst.gic_rst.garst_sync_ic[3].rd_rst_inst/Q_reg_reg[0]}] -to [get_cells -hierarchical -filter {NAME =~ *gsckt_wrst.gic_rst.garst_sync_ic[1].rd_rst_wr_inst/Q_reg_reg[0]}]
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *gsckt_wrst.garst_sync[1].arst_sync_inst/Q_reg_reg[0]/D}] 


set mm2s_cmd_wr_clock [get_clocks -of_objects [get_ports s_axi_lite_aclk]]
set mm2s_cmd_rd_clock [get_clocks -of_objects [get_ports m_axi_mm2s_aclk]]
  set mm2s_cmd_wr_clk_period     [get_property PERIOD $mm2s_cmd_wr_clock]
  set mm2s_cmd_rd_clk_period     [get_property PERIOD $mm2s_cmd_rd_clock]
  set mm2s_cmd_skew_value [expr {(($mm2s_cmd_wr_clk_period < $mm2s_cmd_rd_clk_period) ? $mm2s_cmd_wr_clk_period : $mm2s_cmd_rd_clk_period)} ]

  set_max_delay -from [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/I_CMD_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]] -to [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/I_CMD_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].wr_stg_inst/Q_reg_reg[*]] -datapath_only [get_property  -min PERIOD $mm2s_cmd_rd_clock]
  set_max_delay -from [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/I_CMD_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]] -to [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/I_CMD_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].rd_stg_inst/Q_reg_reg[*]] -datapath_only [get_property  -min PERIOD $mm2s_cmd_wr_clock]

  set_bus_skew -from [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/I_CMD_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]] -to [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/I_CMD_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].wr_stg_inst/Q_reg_reg[*]] $mm2s_cmd_skew_value
  set_bus_skew -from [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/I_CMD_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]] -to [get_cells I_PRMRY_DATAMOVER/GEN_MM2S_FULL.I_MM2S_FULL_WRAPPER/I_CMD_STATUS/I_CMD_FIFO/USE_ASYNC_FIFO.I_ASYNC_FIFO/I_ASYNC_FIFOGEN_FIFO/USE_2N_DEPTH.V6_S6_AND_LATER.I_ASYNC_FIFO_BRAM/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].rd_stg_inst/Q_reg_reg[*]] $mm2s_cmd_skew_value
  set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gsckt_wrst.gic_rst.sckt_wrst_i_reg}] -to [get_cells -hierarchical -filter {NAME =~ *gsckt_wrst.gic_rst.garst_sync_ic[1].rd_rst_inst/Q_reg_reg[0]}]
  set_false_path -from [get_cells -hierarchical -filter {NAME =~ *gsckt_wrst.gic_rst.garst_sync_ic[3].rd_rst_inst/Q_reg_reg[0]}] -to [get_cells -hierarchical -filter {NAME =~ *gsckt_wrst.gic_rst.garst_sync_ic[1].rd_rst_wr_inst/Q_reg_reg[0]}]

set_false_path -to [get_pins -hierarchical -filter {NAME =~ *gsckt_wrst.garst_sync[1].arst_sync_inst/Q_reg_reg[0]/D}] 




