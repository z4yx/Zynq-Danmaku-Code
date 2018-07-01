//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
//Date        : Sun Jul  1 17:43:05 2018
//Host        : cqtestlab running 64-bit Deepin 15.6
//Command     : generate_target top_blk_wrapper.bd
//Design      : top_blk_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module top_blk_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    M_AXIS_tdata,
    M_AXIS_tready,
    M_AXIS_tvalid,
    UART_0_rxd,
    UART_0_txd,
    btn_in,
    gpio_t,
    gpo,
    imgcap_AXIS_tdata,
    imgcap_AXIS_tlast,
    imgcap_AXIS_tready,
    imgcap_AXIS_tvalid,
    imgcap_aclk,
    imgcap_aresetn,
    ps_fabric_50M_clk,
    ps_overlay_clock,
    ps_reset_n,
    resolution_h,
    resolution_w);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  output [63:0]M_AXIS_tdata;
  input M_AXIS_tready;
  output M_AXIS_tvalid;
  input UART_0_rxd;
  output UART_0_txd;
  input [4:0]btn_in;
  output [15:0]gpio_t;
  output [15:0]gpo;
  input [63:0]imgcap_AXIS_tdata;
  input imgcap_AXIS_tlast;
  output imgcap_AXIS_tready;
  input imgcap_AXIS_tvalid;
  input imgcap_aclk;
  input imgcap_aresetn;
  output ps_fabric_50M_clk;
  output ps_overlay_clock;
  output ps_reset_n;
  input [15:0]resolution_h;
  input [15:0]resolution_w;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [63:0]M_AXIS_tdata;
  wire M_AXIS_tready;
  wire M_AXIS_tvalid;
  wire UART_0_rxd;
  wire UART_0_txd;
  wire [4:0]btn_in;
  wire [15:0]gpio_t;
  wire [15:0]gpo;
  wire [63:0]imgcap_AXIS_tdata;
  wire imgcap_AXIS_tlast;
  wire imgcap_AXIS_tready;
  wire imgcap_AXIS_tvalid;
  wire imgcap_aclk;
  wire imgcap_aresetn;
  wire ps_fabric_50M_clk;
  wire ps_overlay_clock;
  wire ps_reset_n;
  wire [15:0]resolution_h;
  wire [15:0]resolution_w;

  top_blk top_blk_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .M_AXIS_tdata(M_AXIS_tdata),
        .M_AXIS_tready(M_AXIS_tready),
        .M_AXIS_tvalid(M_AXIS_tvalid),
        .UART_0_rxd(UART_0_rxd),
        .UART_0_txd(UART_0_txd),
        .btn_in(btn_in),
        .gpio_t(gpio_t),
        .gpo(gpo),
        .imgcap_AXIS_tdata(imgcap_AXIS_tdata),
        .imgcap_AXIS_tlast(imgcap_AXIS_tlast),
        .imgcap_AXIS_tready(imgcap_AXIS_tready),
        .imgcap_AXIS_tvalid(imgcap_AXIS_tvalid),
        .imgcap_aclk(imgcap_aclk),
        .imgcap_aresetn(imgcap_aresetn),
        .ps_fabric_50M_clk(ps_fabric_50M_clk),
        .ps_overlay_clock(ps_overlay_clock),
        .ps_reset_n(ps_reset_n),
        .resolution_h(resolution_h),
        .resolution_w(resolution_w));
endmodule
