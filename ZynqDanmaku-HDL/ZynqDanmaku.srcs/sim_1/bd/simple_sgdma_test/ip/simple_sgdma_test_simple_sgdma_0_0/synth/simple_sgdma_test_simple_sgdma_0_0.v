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


// IP VLNV: user.org:user:simple_sgdma:1.0
// IP Revision: 3

(* X_CORE_INFO = "simple_sgdma_v1_0,Vivado 2018.1" *)
(* CHECK_LICENSE_TYPE = "simple_sgdma_test_simple_sgdma_0_0,simple_sgdma_v1_0,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module simple_sgdma_test_simple_sgdma_0_0 (
  axi_lite_reg_awaddr,
  axi_lite_reg_awprot,
  axi_lite_reg_awvalid,
  axi_lite_reg_awready,
  axi_lite_reg_wdata,
  axi_lite_reg_wstrb,
  axi_lite_reg_wvalid,
  axi_lite_reg_wready,
  axi_lite_reg_bresp,
  axi_lite_reg_bvalid,
  axi_lite_reg_bready,
  axi_lite_reg_araddr,
  axi_lite_reg_arprot,
  axi_lite_reg_arvalid,
  axi_lite_reg_arready,
  axi_lite_reg_rdata,
  axi_lite_reg_rresp,
  axi_lite_reg_rvalid,
  axi_lite_reg_rready,
  axi_lite_reg_aclk,
  axi_lite_reg_aresetn,
  axis_cmd_tdata,
  axis_cmd_tvalid,
  axis_cmd_tready,
  axis_sts_tdata,
  axis_sts_tkeep,
  axis_sts_tlast,
  axis_sts_tvalid,
  axis_sts_tready
);

(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg AWADDR" *)
input wire [4 : 0] axi_lite_reg_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg AWPROT" *)
input wire [2 : 0] axi_lite_reg_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg AWVALID" *)
input wire axi_lite_reg_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg AWREADY" *)
output wire axi_lite_reg_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg WDATA" *)
input wire [31 : 0] axi_lite_reg_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg WSTRB" *)
input wire [3 : 0] axi_lite_reg_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg WVALID" *)
input wire axi_lite_reg_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg WREADY" *)
output wire axi_lite_reg_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg BRESP" *)
output wire [1 : 0] axi_lite_reg_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg BVALID" *)
output wire axi_lite_reg_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg BREADY" *)
input wire axi_lite_reg_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg ARADDR" *)
input wire [4 : 0] axi_lite_reg_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg ARPROT" *)
input wire [2 : 0] axi_lite_reg_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg ARVALID" *)
input wire axi_lite_reg_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg ARREADY" *)
output wire axi_lite_reg_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg RDATA" *)
output wire [31 : 0] axi_lite_reg_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg RRESP" *)
output wire [1 : 0] axi_lite_reg_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg RVALID" *)
output wire axi_lite_reg_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_lite_reg, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 8, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 50000000, ID_WIDTH 0, ADDR_WIDTH 5, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN simple_sgdma_test_p\
rocessing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 axi_lite_reg RREADY" *)
input wire axi_lite_reg_rready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_lite_reg_CLK, ASSOCIATED_BUSIF axi_lite_reg:axis_sts:axis_cmd, ASSOCIATED_RESET axi_lite_reg_aresetn:axi_lite_reg_RST, FREQ_HZ 50000000, PHASE 0.000, CLK_DOMAIN simple_sgdma_test_processing_system7_0_0_FCLK_CLK0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axi_lite_reg_CLK CLK" *)
input wire axi_lite_reg_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_lite_reg_RST, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 axi_lite_reg_RST RST" *)
input wire axi_lite_reg_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 axis_cmd TDATA" *)
output wire [71 : 0] axis_cmd_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 axis_cmd TVALID" *)
output wire axis_cmd_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axis_cmd, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 9, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 50000000, PHASE 0.000, CLK_DOMAIN simple_sgdma_test_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 axis_cmd TREADY" *)
input wire axis_cmd_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 axis_sts TDATA" *)
input wire [7 : 0] axis_sts_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 axis_sts TKEEP" *)
input wire [0 : 0] axis_sts_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 axis_sts TLAST" *)
input wire axis_sts_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 axis_sts TVALID" *)
input wire axis_sts_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axis_sts, WIZ_DATA_WIDTH 32, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 50000000, PHASE 0.000, CLK_DOMAIN simple_sgdma_test_processing_system7_0_0_FCLK_CLK0, LAYERED_METADATA undef" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 axis_sts TREADY" *)
output wire axis_sts_tready;

  simple_sgdma_v1_0 #(
    .C_axi_lite_reg_DATA_WIDTH(32),  // Width of S_AXI data bus
    .C_axi_lite_reg_ADDR_WIDTH(5),  // Width of S_AXI address bus
    .C_axis_cmd_TDATA_WIDTH(72),  // Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
    .C_axis_cmd_START_COUNT(1),  // Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
    .C_axis_sts_TDATA_WIDTH(8)  // AXI4Stream sink: Data Width
  ) inst (
    .axi_lite_reg_awaddr(axi_lite_reg_awaddr),
    .axi_lite_reg_awprot(axi_lite_reg_awprot),
    .axi_lite_reg_awvalid(axi_lite_reg_awvalid),
    .axi_lite_reg_awready(axi_lite_reg_awready),
    .axi_lite_reg_wdata(axi_lite_reg_wdata),
    .axi_lite_reg_wstrb(axi_lite_reg_wstrb),
    .axi_lite_reg_wvalid(axi_lite_reg_wvalid),
    .axi_lite_reg_wready(axi_lite_reg_wready),
    .axi_lite_reg_bresp(axi_lite_reg_bresp),
    .axi_lite_reg_bvalid(axi_lite_reg_bvalid),
    .axi_lite_reg_bready(axi_lite_reg_bready),
    .axi_lite_reg_araddr(axi_lite_reg_araddr),
    .axi_lite_reg_arprot(axi_lite_reg_arprot),
    .axi_lite_reg_arvalid(axi_lite_reg_arvalid),
    .axi_lite_reg_arready(axi_lite_reg_arready),
    .axi_lite_reg_rdata(axi_lite_reg_rdata),
    .axi_lite_reg_rresp(axi_lite_reg_rresp),
    .axi_lite_reg_rvalid(axi_lite_reg_rvalid),
    .axi_lite_reg_rready(axi_lite_reg_rready),
    .axi_lite_reg_aclk(axi_lite_reg_aclk),
    .axi_lite_reg_aresetn(axi_lite_reg_aresetn),
    .axis_cmd_tdata(axis_cmd_tdata),
    .axis_cmd_tvalid(axis_cmd_tvalid),
    .axis_cmd_tready(axis_cmd_tready),
    .axis_sts_tdata(axis_sts_tdata),
    .axis_sts_tkeep(axis_sts_tkeep),
    .axis_sts_tlast(axis_sts_tlast),
    .axis_sts_tvalid(axis_sts_tvalid),
    .axis_sts_tready(axis_sts_tready)
  );
endmodule
