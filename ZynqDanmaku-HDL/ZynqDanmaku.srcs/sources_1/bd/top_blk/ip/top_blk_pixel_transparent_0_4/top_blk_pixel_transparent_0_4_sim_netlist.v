// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
// Date        : Sun Apr 16 10:41:24 2017
// Host        : skyworks running 64-bit Ubuntu 16.04.2 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/skyworks/ZynqDanmaku/ZynqDanmaku-HDL/ZynqDanmaku.srcs/sources_1/bd/top_blk/ip/top_blk_pixel_transparent_0_4/top_blk_pixel_transparent_0_4_sim_netlist.v
// Design      : top_blk_pixel_transparent_0_4
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "top_blk_pixel_transparent_0_4,pixel_transparent_v1_0,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "pixel_transparent_v1_0,Vivado 2016.4" *) 
(* NotValidForBitStream *)
module top_blk_pixel_transparent_0_4
   (m00_axi_awaddr,
    m00_axi_awlen,
    m00_axi_awsize,
    m00_axi_awburst,
    m00_axi_awlock,
    m00_axi_awcache,
    m00_axi_awprot,
    m00_axi_awvalid,
    m00_axi_awready,
    m00_axi_wdata,
    m00_axi_wstrb,
    m00_axi_wlast,
    m00_axi_wvalid,
    m00_axi_wready,
    m00_axi_bresp,
    m00_axi_bvalid,
    m00_axi_bready,
    m00_axi_araddr,
    m00_axi_arlen,
    m00_axi_arsize,
    m00_axi_arburst,
    m00_axi_arlock,
    m00_axi_arcache,
    m00_axi_arprot,
    m00_axi_arvalid,
    m00_axi_arready,
    m00_axi_rdata,
    m00_axi_rresp,
    m00_axi_rlast,
    m00_axi_rvalid,
    m00_axi_rready,
    m00_axi_aclk,
    m00_axi_aresetn,
    s00_axi_awaddr,
    s00_axi_awlen,
    s00_axi_awsize,
    s00_axi_awburst,
    s00_axi_awlock,
    s00_axi_awcache,
    s00_axi_awprot,
    s00_axi_awvalid,
    s00_axi_awready,
    s00_axi_wdata,
    s00_axi_wstrb,
    s00_axi_wlast,
    s00_axi_wvalid,
    s00_axi_wready,
    s00_axi_bresp,
    s00_axi_bvalid,
    s00_axi_bready,
    s00_axi_araddr,
    s00_axi_arlen,
    s00_axi_arsize,
    s00_axi_arburst,
    s00_axi_arlock,
    s00_axi_arcache,
    s00_axi_arprot,
    s00_axi_arvalid,
    s00_axi_arready,
    s00_axi_rdata,
    s00_axi_rresp,
    s00_axi_rlast,
    s00_axi_rvalid,
    s00_axi_rready,
    s00_axi_aclk,
    s00_axi_aresetn);
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWADDR" *) output [31:0]m00_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWLEN" *) output [7:0]m00_axi_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWSIZE" *) output [2:0]m00_axi_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWBURST" *) output [1:0]m00_axi_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWLOCK" *) output m00_axi_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWCACHE" *) output [3:0]m00_axi_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWPROT" *) output [2:0]m00_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWVALID" *) output m00_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI AWREADY" *) input m00_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WDATA" *) output [63:0]m00_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WSTRB" *) output [7:0]m00_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WLAST" *) output m00_axi_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WVALID" *) output m00_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI WREADY" *) input m00_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BRESP" *) input [1:0]m00_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BVALID" *) input m00_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI BREADY" *) output m00_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARADDR" *) output [31:0]m00_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARLEN" *) output [7:0]m00_axi_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARSIZE" *) output [2:0]m00_axi_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARBURST" *) output [1:0]m00_axi_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARLOCK" *) output m00_axi_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARCACHE" *) output [3:0]m00_axi_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARPROT" *) output [2:0]m00_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARVALID" *) output m00_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI ARREADY" *) input m00_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RDATA" *) input [63:0]m00_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RRESP" *) input [1:0]m00_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RLAST" *) input m00_axi_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RVALID" *) input m00_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M00_AXI RREADY" *) output m00_axi_rready;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 M00_AXI_CLK CLK" *) input m00_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 M00_AXI_RST RST" *) input m00_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR" *) input [31:0]s00_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWLEN" *) input [7:0]s00_axi_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWSIZE" *) input [2:0]s00_axi_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWBURST" *) input [1:0]s00_axi_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWLOCK" *) input s00_axi_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWCACHE" *) input [3:0]s00_axi_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT" *) input [2:0]s00_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID" *) input s00_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY" *) output s00_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WDATA" *) input [63:0]s00_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB" *) input [7:0]s00_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WLAST" *) input s00_axi_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WVALID" *) input s00_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WREADY" *) output s00_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BRESP" *) output [1:0]s00_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BVALID" *) output s00_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BREADY" *) input s00_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR" *) input [31:0]s00_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARLEN" *) input [7:0]s00_axi_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARSIZE" *) input [2:0]s00_axi_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARBURST" *) input [1:0]s00_axi_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARLOCK" *) input s00_axi_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARCACHE" *) input [3:0]s00_axi_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT" *) input [2:0]s00_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID" *) input s00_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY" *) output s00_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RDATA" *) output [63:0]s00_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RRESP" *) output [1:0]s00_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RLAST" *) output s00_axi_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RVALID" *) output s00_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RREADY" *) input s00_axi_rready;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK" *) input s00_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S00_AXI_RST RST" *) input s00_axi_aresetn;

  wire m00_axi_arready;
  wire m00_axi_awready;
  wire [1:0]m00_axi_bresp;
  wire m00_axi_bvalid;
  wire [63:0]m00_axi_rdata;
  wire m00_axi_rlast;
  wire [1:0]m00_axi_rresp;
  wire m00_axi_rvalid;
  wire m00_axi_wready;
  wire [7:0]m00_axi_wstrb;
  wire [31:0]s00_axi_araddr;
  wire [1:0]s00_axi_arburst;
  wire [3:0]s00_axi_arcache;
  wire [7:0]s00_axi_arlen;
  wire s00_axi_arlock;
  wire [2:0]s00_axi_arprot;
  wire [2:0]s00_axi_arsize;
  wire s00_axi_arvalid;
  wire [31:0]s00_axi_awaddr;
  wire [1:0]s00_axi_awburst;
  wire [3:0]s00_axi_awcache;
  wire [7:0]s00_axi_awlen;
  wire s00_axi_awlock;
  wire [2:0]s00_axi_awprot;
  wire [2:0]s00_axi_awsize;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_rready;
  wire [63:0]s00_axi_wdata;
  wire s00_axi_wlast;
  wire [7:0]s00_axi_wstrb;
  wire s00_axi_wvalid;

  assign m00_axi_araddr[31:0] = s00_axi_araddr;
  assign m00_axi_arburst[1:0] = s00_axi_arburst;
  assign m00_axi_arcache[3:0] = s00_axi_arcache;
  assign m00_axi_arlen[7:0] = s00_axi_arlen;
  assign m00_axi_arlock = s00_axi_arlock;
  assign m00_axi_arprot[2:0] = s00_axi_arprot;
  assign m00_axi_arsize[2:0] = s00_axi_arsize;
  assign m00_axi_arvalid = s00_axi_arvalid;
  assign m00_axi_awaddr[31:0] = s00_axi_awaddr;
  assign m00_axi_awburst[1:0] = s00_axi_awburst;
  assign m00_axi_awcache[3:0] = s00_axi_awcache;
  assign m00_axi_awlen[7:0] = s00_axi_awlen;
  assign m00_axi_awlock = s00_axi_awlock;
  assign m00_axi_awprot[2:0] = s00_axi_awprot;
  assign m00_axi_awsize[2:0] = s00_axi_awsize;
  assign m00_axi_awvalid = s00_axi_awvalid;
  assign m00_axi_bready = s00_axi_bready;
  assign m00_axi_rready = s00_axi_rready;
  assign m00_axi_wdata[63:0] = s00_axi_wdata;
  assign m00_axi_wlast = s00_axi_wlast;
  assign m00_axi_wvalid = s00_axi_wvalid;
  assign s00_axi_arready = m00_axi_arready;
  assign s00_axi_awready = m00_axi_awready;
  assign s00_axi_bresp[1:0] = m00_axi_bresp;
  assign s00_axi_bvalid = m00_axi_bvalid;
  assign s00_axi_rdata[63:0] = m00_axi_rdata;
  assign s00_axi_rlast = m00_axi_rlast;
  assign s00_axi_rresp[1:0] = m00_axi_rresp;
  assign s00_axi_rvalid = m00_axi_rvalid;
  assign s00_axi_wready = m00_axi_wready;
  top_blk_pixel_transparent_0_4_pixel_transparent_v1_0 inst
       (.m00_axi_wstrb(m00_axi_wstrb),
        .s00_axi_wdata({s00_axi_wdata[60:56],s00_axi_wdata[52:48],s00_axi_wdata[44:40],s00_axi_wdata[36:32],s00_axi_wdata[28:24],s00_axi_wdata[20:16],s00_axi_wdata[12:8],s00_axi_wdata[4:0]}),
        .s00_axi_wstrb(s00_axi_wstrb));
endmodule

(* ORIG_REF_NAME = "pixel_transparent_v1_0" *) 
module top_blk_pixel_transparent_0_4_pixel_transparent_v1_0
   (m00_axi_wstrb,
    s00_axi_wstrb,
    s00_axi_wdata);
  output [7:0]m00_axi_wstrb;
  input [7:0]s00_axi_wstrb;
  input [39:0]s00_axi_wdata;

  wire [7:0]m00_axi_wstrb;
  wire [39:0]s00_axi_wdata;
  wire [7:0]s00_axi_wstrb;

  LUT6 #(
    .INIT(64'hAAAAAAAAAAAA2AAA)) 
    \m00_axi_wstrb[0]_INST_0 
       (.I0(s00_axi_wstrb[0]),
        .I1(s00_axi_wdata[0]),
        .I2(s00_axi_wdata[3]),
        .I3(s00_axi_wdata[2]),
        .I4(s00_axi_wdata[4]),
        .I5(s00_axi_wdata[1]),
        .O(m00_axi_wstrb[0]));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAA2AAA)) 
    \m00_axi_wstrb[1]_INST_0 
       (.I0(s00_axi_wstrb[1]),
        .I1(s00_axi_wdata[5]),
        .I2(s00_axi_wdata[8]),
        .I3(s00_axi_wdata[7]),
        .I4(s00_axi_wdata[9]),
        .I5(s00_axi_wdata[6]),
        .O(m00_axi_wstrb[1]));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAA2AAA)) 
    \m00_axi_wstrb[2]_INST_0 
       (.I0(s00_axi_wstrb[2]),
        .I1(s00_axi_wdata[10]),
        .I2(s00_axi_wdata[13]),
        .I3(s00_axi_wdata[12]),
        .I4(s00_axi_wdata[14]),
        .I5(s00_axi_wdata[11]),
        .O(m00_axi_wstrb[2]));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAA2AAA)) 
    \m00_axi_wstrb[3]_INST_0 
       (.I0(s00_axi_wstrb[3]),
        .I1(s00_axi_wdata[15]),
        .I2(s00_axi_wdata[18]),
        .I3(s00_axi_wdata[17]),
        .I4(s00_axi_wdata[19]),
        .I5(s00_axi_wdata[16]),
        .O(m00_axi_wstrb[3]));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAA2AAA)) 
    \m00_axi_wstrb[4]_INST_0 
       (.I0(s00_axi_wstrb[4]),
        .I1(s00_axi_wdata[20]),
        .I2(s00_axi_wdata[23]),
        .I3(s00_axi_wdata[22]),
        .I4(s00_axi_wdata[24]),
        .I5(s00_axi_wdata[21]),
        .O(m00_axi_wstrb[4]));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAA2AAA)) 
    \m00_axi_wstrb[5]_INST_0 
       (.I0(s00_axi_wstrb[5]),
        .I1(s00_axi_wdata[25]),
        .I2(s00_axi_wdata[28]),
        .I3(s00_axi_wdata[27]),
        .I4(s00_axi_wdata[29]),
        .I5(s00_axi_wdata[26]),
        .O(m00_axi_wstrb[5]));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAA2AAA)) 
    \m00_axi_wstrb[6]_INST_0 
       (.I0(s00_axi_wstrb[6]),
        .I1(s00_axi_wdata[30]),
        .I2(s00_axi_wdata[33]),
        .I3(s00_axi_wdata[32]),
        .I4(s00_axi_wdata[34]),
        .I5(s00_axi_wdata[31]),
        .O(m00_axi_wstrb[6]));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAA2AAA)) 
    \m00_axi_wstrb[7]_INST_0 
       (.I0(s00_axi_wstrb[7]),
        .I1(s00_axi_wdata[35]),
        .I2(s00_axi_wdata[38]),
        .I3(s00_axi_wdata[37]),
        .I4(s00_axi_wdata[39]),
        .I5(s00_axi_wdata[36]),
        .O(m00_axi_wstrb[7]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
