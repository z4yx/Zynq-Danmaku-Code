// (c) Copyright 1995-2018 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:ip:axi_traffic_gen:3.0
// IP Revision: 2

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module simple_sgdma_test_axi_traffic_gen_0_0 (
  s_axi_aclk,
  s_axi_aresetn,
  core_ext_start,
  m_axi_arid,
  m_axi_araddr,
  m_axi_arlen,
  m_axi_arsize,
  m_axi_arburst,
  m_axi_arlock,
  m_axi_arcache,
  m_axi_arprot,
  m_axi_arqos,
  m_axi_aruser,
  m_axi_arvalid,
  m_axi_arready,
  m_axi_rid,
  m_axi_rlast,
  m_axi_rdata,
  m_axi_rresp,
  m_axi_rvalid,
  m_axi_rready,
  irq_out
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clock, ASSOCIATED_BUSIF S_AXI:M_AXI:M_AXIS_MASTER:S_AXIS_MASTER:M_AXIS_SLAVE:S_AXIS_SLAVE:M_AXI_LITE_CH1:M_AXI_LITE_CH2:M_AXI_LITE_CH3:M_AXI_LITE_CH4:M_AXI_LITE_CH5, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 150000000, PHASE 0.000, CLK_DOMAIN simple_sgdma_test_processing_system7_0_0_FCLK_CLK1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clock CLK" *)
input wire s_axi_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset RST" *)
input wire s_axi_aresetn;
input wire core_ext_start;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARID" *)
output wire [0 : 0] m_axi_arid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARADDR" *)
output wire [31 : 0] m_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARLEN" *)
output wire [7 : 0] m_axi_arlen;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARSIZE" *)
output wire [2 : 0] m_axi_arsize;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARBURST" *)
output wire [1 : 0] m_axi_arburst;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARLOCK" *)
output wire [0 : 0] m_axi_arlock;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARCACHE" *)
output wire [3 : 0] m_axi_arcache;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARPROT" *)
output wire [2 : 0] m_axi_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARQOS" *)
output wire [3 : 0] m_axi_arqos;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARUSER" *)
output wire [7 : 0] m_axi_aruser;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARVALID" *)
output wire m_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARREADY" *)
input wire m_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RID" *)
input wire [0 : 0] m_axi_rid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RLAST" *)
input wire m_axi_rlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RDATA" *)
input wire [63 : 0] m_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RRESP" *)
input wire [1 : 0] m_axi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RVALID" *)
input wire m_axi_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI, NUM_READ_OUTSTANDING 7, NUM_WRITE_OUTSTANDING 7, DATA_WIDTH 64, PROTOCOL AXI4, FREQ_HZ 150000000, ID_WIDTH 1, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 8, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_ONLY, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 0, HAS_BRESP 0, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, MAX_BURST_LENGTH 256, PHASE 0.000, CLK_DOMAIN simple_sgdma_test_processing_system7_0_0_FCLK_CLK1, NUM_READ_\
THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RREADY" *)
output wire m_axi_rready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME interrupt, SENSITIVITY LEVEL_HIGH, PortWidth 1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT" *)
output wire irq_out;

  axi_traffic_gen_v3_0_2_top #(
    .C_FAMILY("zynq"),
    .C_BASEADDR('H00000000),
    .C_HIGHADDR('H0000FFFF),
    .C_ZERO_INVALID(1),
    .C_NO_EXCL(0),
    .C_S_AXI_DATA_WIDTH(32),
    .C_S_AXI_AWUSER_WIDTH(8),
    .C_S_AXI_ARUSER_WIDTH(8),
    .C_S_AXI_ID_WIDTH(1),
    .C_M_AXI_THREAD_ID_WIDTH(1),
    .C_M_AXI_DATA_WIDTH(64),
    .C_M_AXI_ADDR_WIDTH(32),
    .C_M_AXI_AWUSER_WIDTH(8),
    .C_M_AXI_ARUSER_WIDTH(8),
    .C_AXIS1_HAS_TKEEP(1),
    .C_AXIS1_HAS_TSTRB(1),
    .C_AXIS2_HAS_TKEEP(0),
    .C_AXIS2_HAS_TSTRB(0),
    .C_AXIS_TDATA_WIDTH(32),
    .C_AXIS_TUSER_WIDTH(8),
    .C_AXIS_TID_WIDTH(8),
    .C_AXIS_TDEST_WIDTH(8),
    .C_ATG_BASIC_AXI4(0),
    .C_ATG_REPEAT_TYPE(0),
    .C_ATG_HLTP_MODE(1),
    .C_ATG_STATIC(0),
    .C_ATG_SYSTEM_INIT(0),
    .C_ATG_SYSTEM_TEST(0),
    .C_ATG_STREAMING(0),
    .C_ATG_STREAMING_MST_ONLY(1),
    .C_ATG_STREAMING_MST_LPBK(0),
    .C_ATG_STREAMING_SLV_LPBK(0),
    .C_ATG_STREAMING_MAX_LEN_BITS(16),
    .C_ATG_STREAMING_MEM_FILE("no_mem_file_loaded"),
    .C_ATG_AXIS_DATA_GEN_TYPE(0),
    .C_AXIS_SPARSE_EN(1),
    .C_ATG_SLAVE_ONLY(0),
    .C_ATG_STATIC_WR_ADDRESS('H0000000000000000),
    .C_ATG_STATIC_RD_ADDRESS('H0000000000000000),
    .C_ATG_STATIC_WR_HIGH_ADDRESS('H0000000000000FFF),
    .C_ATG_STATIC_RD_HIGH_ADDRESS('H0000000000000FFF),
    .C_ATG_STATIC_INCR(0),
    .C_ATG_STATIC_EN_READ(1),
    .C_ATG_STATIC_EN_WRITE(1),
    .C_ATG_STATIC_FREE_RUN(1),
    .C_ATG_STATIC_RD_PIPELINE(1),
    .C_ATG_STATIC_WR_PIPELINE(1),
    .C_ATG_STATIC_TRANGAP(19198),
    .C_ATG_STATIC_LENGTH(16),
    .C_ATG_SYSTEM_INIT_DATA_MIF("simple_sgdma_test_axi_traffic_gen_0_0_data.mem"),
    .C_ATG_SYSTEM_INIT_ADDR_MIF("simple_sgdma_test_axi_traffic_gen_0_0_addr.mem"),
    .C_ATG_SYSTEM_INIT_CTRL_MIF("simple_sgdma_test_axi_traffic_gen_0_0_ctrl.mem"),
    .C_ATG_SYSTEM_INIT_MASK_MIF("simple_sgdma_test_axi_traffic_gen_0_0_mask.mem"),
    .C_ATG_MIF_DATA_DEPTH(16),
    .C_ATG_MIF_ADDR_BITS(4),
    .C_ATG_SYSTEM_CMD_MAX_RETRY(256),
    .C_ATG_SYSTEM_TEST_MAX_CLKS(5000),
    .C_ATG_SYSTEM_MAX_CHANNELS('B00000000000000000000000000000001),
    .C_ATG_SYSTEM_CH1_LOW('H00000000),
    .C_ATG_SYSTEM_CH1_HIGH('HFFFFFFFF),
    .C_ATG_SYSTEM_CH2_LOW('H00000100),
    .C_ATG_SYSTEM_CH2_HIGH('H000001FF),
    .C_ATG_SYSTEM_CH3_LOW('H00000200),
    .C_ATG_SYSTEM_CH3_HIGH('H000002FF),
    .C_ATG_SYSTEM_CH4_LOW('H00000300),
    .C_ATG_SYSTEM_CH4_HIGH('H000003FF),
    .C_ATG_SYSTEM_CH5_LOW('H00000400),
    .C_ATG_SYSTEM_CH5_HIGH('H000004FF),
    .C_RAMINIT_CMDRAM0_F("simple_sgdma_test_axi_traffic_gen_0_0_data_cmdram.mem"),
    .C_RAMINIT_CMDRAM1_F("NONE"),
    .C_RAMINIT_CMDRAM2_F("NONE"),
    .C_RAMINIT_CMDRAM3_F("NONE"),
    .C_RAMINIT_SRAM0_F("simple_sgdma_test_axi_traffic_gen_0_0_data_sram.mem"),
    .C_RAMINIT_PARAMRAM0_F("simple_sgdma_test_axi_traffic_gen_0_0_data_paramram.mem"),
    .C_RAMINIT_ADDRRAM0_F("simple_sgdma_test_axi_traffic_gen_0_0_data_addrram.mem"),
    .C_REPEAT_COUNT(254),
    .C_STRM_DATA_SEED('HABCD),
    .C_AXI_WR_ADDR_SEED('H7C9B),
    .C_AXI_RD_ADDR_SEED('H5A5A),
    .C_READ_ONLY(1),
    .C_WRITE_ONLY(2)
  ) inst (
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    .core_ext_start(core_ext_start),
    .core_ext_stop(1'B0),
    .s_axi_awid(1'B0),
    .s_axi_awaddr(32'B0),
    .s_axi_awlen(8'B0),
    .s_axi_awsize(3'B0),
    .s_axi_awburst(2'B0),
    .s_axi_awlock(1'B0),
    .s_axi_awcache(4'B0),
    .s_axi_awprot(3'B0),
    .s_axi_awqos(4'B0),
    .s_axi_awuser(8'B0),
    .s_axi_awvalid(1'B0),
    .s_axi_awready(),
    .s_axi_wlast(1'B0),
    .s_axi_wdata(32'B0),
    .s_axi_wstrb(4'B0),
    .s_axi_wvalid(1'B0),
    .s_axi_wready(),
    .s_axi_bid(),
    .s_axi_bresp(),
    .s_axi_bvalid(),
    .s_axi_bready(1'B0),
    .s_axi_arid(1'B0),
    .s_axi_araddr(32'B0),
    .s_axi_arlen(8'B0),
    .s_axi_arsize(3'B0),
    .s_axi_arburst(2'B0),
    .s_axi_arlock(1'B0),
    .s_axi_arcache(4'B0),
    .s_axi_arprot(3'B0),
    .s_axi_arqos(4'B0),
    .s_axi_aruser(8'B0),
    .s_axi_arvalid(1'B0),
    .s_axi_arready(),
    .s_axi_rid(),
    .s_axi_rlast(),
    .s_axi_rdata(),
    .s_axi_rresp(),
    .s_axi_rvalid(),
    .s_axi_rready(1'B0),
    .m_axi_awid(),
    .m_axi_awaddr(),
    .m_axi_awlen(),
    .m_axi_awsize(),
    .m_axi_awburst(),
    .m_axi_awlock(),
    .m_axi_awcache(),
    .m_axi_awprot(),
    .m_axi_awqos(),
    .m_axi_awuser(),
    .m_axi_awvalid(),
    .m_axi_awready(1'B0),
    .m_axi_wlast(),
    .m_axi_wdata(),
    .m_axi_wstrb(),
    .m_axi_wvalid(),
    .m_axi_wready(1'B0),
    .m_axi_bid(1'B0),
    .m_axi_bresp(2'B0),
    .m_axi_bvalid(1'B0),
    .m_axi_bready(),
    .m_axi_arid(m_axi_arid),
    .m_axi_araddr(m_axi_araddr),
    .m_axi_arlen(m_axi_arlen),
    .m_axi_arsize(m_axi_arsize),
    .m_axi_arburst(m_axi_arburst),
    .m_axi_arlock(m_axi_arlock),
    .m_axi_arcache(m_axi_arcache),
    .m_axi_arprot(m_axi_arprot),
    .m_axi_arqos(m_axi_arqos),
    .m_axi_aruser(m_axi_aruser),
    .m_axi_arvalid(m_axi_arvalid),
    .m_axi_arready(m_axi_arready),
    .m_axi_rid(m_axi_rid),
    .m_axi_rlast(m_axi_rlast),
    .m_axi_rdata(m_axi_rdata),
    .m_axi_rresp(m_axi_rresp),
    .m_axi_rvalid(m_axi_rvalid),
    .m_axi_rready(m_axi_rready),
    .m_axis_1_tready(1'B1),
    .m_axis_1_tvalid(),
    .m_axis_1_tlast(),
    .m_axis_1_tdata(),
    .m_axis_1_tstrb(),
    .m_axis_1_tkeep(),
    .m_axis_1_tuser(),
    .m_axis_1_tid(),
    .m_axis_1_tdest(),
    .s_axis_1_tready(),
    .s_axis_1_tvalid(1'B0),
    .s_axis_1_tlast(1'B0),
    .s_axis_1_tdata(32'B0),
    .s_axis_1_tstrb(4'HF),
    .s_axis_1_tkeep(4'HF),
    .s_axis_1_tuser(8'B0),
    .s_axis_1_tid(8'B0),
    .s_axis_1_tdest(8'B0),
    .axis_err_count(),
    .s_axis_2_tready(),
    .s_axis_2_tvalid(1'B0),
    .s_axis_2_tlast(1'B0),
    .s_axis_2_tdata(32'B0),
    .s_axis_2_tstrb(4'HF),
    .s_axis_2_tkeep(4'HF),
    .s_axis_2_tuser(8'B0),
    .s_axis_2_tid(8'B0),
    .s_axis_2_tdest(8'B0),
    .m_axis_2_tready(1'B1),
    .m_axis_2_tvalid(),
    .m_axis_2_tlast(),
    .m_axis_2_tdata(),
    .m_axis_2_tstrb(),
    .m_axis_2_tkeep(),
    .m_axis_2_tuser(),
    .m_axis_2_tid(),
    .m_axis_2_tdest(),
    .irq_out(irq_out),
    .err_out(),
    .m_axi_lite_ch1_awaddr(),
    .m_axi_lite_ch1_awprot(),
    .m_axi_lite_ch1_awvalid(),
    .m_axi_lite_ch1_awready(1'B0),
    .m_axi_lite_ch1_wdata(),
    .m_axi_lite_ch1_wstrb(),
    .m_axi_lite_ch1_wvalid(),
    .m_axi_lite_ch1_wready(1'B0),
    .m_axi_lite_ch1_bresp(2'B0),
    .m_axi_lite_ch1_bvalid(1'B0),
    .m_axi_lite_ch1_bready(),
    .m_axi_lite_ch1_araddr(),
    .m_axi_lite_ch1_arvalid(),
    .m_axi_lite_ch1_arready(1'B0),
    .m_axi_lite_ch1_rdata(64'B0),
    .m_axi_lite_ch1_rvalid(1'B0),
    .m_axi_lite_ch1_rresp(2'B0),
    .m_axi_lite_ch1_rready(),
    .m_axi_lite_ch2_awaddr(),
    .m_axi_lite_ch2_awprot(),
    .m_axi_lite_ch2_awvalid(),
    .m_axi_lite_ch2_awready(1'B0),
    .m_axi_lite_ch2_wdata(),
    .m_axi_lite_ch2_wstrb(),
    .m_axi_lite_ch2_wvalid(),
    .m_axi_lite_ch2_wready(1'B0),
    .m_axi_lite_ch2_bresp(2'B0),
    .m_axi_lite_ch2_bvalid(1'B0),
    .m_axi_lite_ch2_bready(),
    .m_axi_lite_ch2_araddr(),
    .m_axi_lite_ch2_arvalid(),
    .m_axi_lite_ch2_arready(1'B0),
    .m_axi_lite_ch2_rdata(64'B0),
    .m_axi_lite_ch2_rvalid(1'B0),
    .m_axi_lite_ch2_rresp(2'B0),
    .m_axi_lite_ch2_rready(),
    .m_axi_lite_ch3_awaddr(),
    .m_axi_lite_ch3_awprot(),
    .m_axi_lite_ch3_awvalid(),
    .m_axi_lite_ch3_awready(1'B0),
    .m_axi_lite_ch3_wdata(),
    .m_axi_lite_ch3_wstrb(),
    .m_axi_lite_ch3_wvalid(),
    .m_axi_lite_ch3_wready(1'B0),
    .m_axi_lite_ch3_bresp(2'B0),
    .m_axi_lite_ch3_bvalid(1'B0),
    .m_axi_lite_ch3_bready(),
    .m_axi_lite_ch3_araddr(),
    .m_axi_lite_ch3_arvalid(),
    .m_axi_lite_ch3_arready(1'B0),
    .m_axi_lite_ch3_rdata(64'B0),
    .m_axi_lite_ch3_rvalid(1'B0),
    .m_axi_lite_ch3_rresp(2'B0),
    .m_axi_lite_ch3_rready(),
    .m_axi_lite_ch4_awaddr(),
    .m_axi_lite_ch4_awprot(),
    .m_axi_lite_ch4_awvalid(),
    .m_axi_lite_ch4_awready(1'B0),
    .m_axi_lite_ch4_wdata(),
    .m_axi_lite_ch4_wstrb(),
    .m_axi_lite_ch4_wvalid(),
    .m_axi_lite_ch4_wready(1'B0),
    .m_axi_lite_ch4_bresp(2'B0),
    .m_axi_lite_ch4_bvalid(1'B0),
    .m_axi_lite_ch4_bready(),
    .m_axi_lite_ch4_araddr(),
    .m_axi_lite_ch4_arvalid(),
    .m_axi_lite_ch4_arready(1'B0),
    .m_axi_lite_ch4_rdata(64'B0),
    .m_axi_lite_ch4_rvalid(1'B0),
    .m_axi_lite_ch4_rresp(2'B0),
    .m_axi_lite_ch4_rready(),
    .m_axi_lite_ch5_awaddr(),
    .m_axi_lite_ch5_awprot(),
    .m_axi_lite_ch5_awvalid(),
    .m_axi_lite_ch5_awready(1'B0),
    .m_axi_lite_ch5_wdata(),
    .m_axi_lite_ch5_wstrb(),
    .m_axi_lite_ch5_wvalid(),
    .m_axi_lite_ch5_wready(1'B0),
    .m_axi_lite_ch5_bresp(2'B0),
    .m_axi_lite_ch5_bvalid(1'B0),
    .m_axi_lite_ch5_bready(),
    .m_axi_lite_ch5_araddr(),
    .m_axi_lite_ch5_arvalid(),
    .m_axi_lite_ch5_arready(1'B0),
    .m_axi_lite_ch5_rdata(64'B0),
    .m_axi_lite_ch5_rvalid(1'B0),
    .m_axi_lite_ch5_rresp(2'B0),
    .m_axi_lite_ch5_rready(),
    .done(),
    .status()
  );
endmodule
