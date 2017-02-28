`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CST-SAST
// Engineer: Zhang Yuxiang
// 
// Create Date: 2017/02/28 13:42:47
// Design Name: 
// Module Name: danmaku9_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module danmaku9_top(
  inout [14:0]DDR_addr,
  inout [2:0]DDR_ba,
  inout DDR_cas_n,
  inout DDR_ck_n,
  inout DDR_ck_p,
  inout DDR_cke,
  inout DDR_cs_n,
  inout [3:0]DDR_dm,
  inout [31:0]DDR_dq,
  inout [3:0]DDR_dqs_n,
  inout [3:0]DDR_dqs_p,
  inout DDR_odt,
  inout DDR_ras_n,
  inout DDR_reset_n,
  inout DDR_we_n,
  inout FIXED_IO_ddr_vrn,
  inout FIXED_IO_ddr_vrp,
  inout [53:0]FIXED_IO_mio,
  inout FIXED_IO_ps_clk,
  inout FIXED_IO_ps_porb,
  inout FIXED_IO_ps_srstb,
  
    input wire IN_VS,
    input wire IN_HS,
    input wire IN_CLK,
    input wire IN_DE,
    input wire [23:0]IN_D,
    
    input wire IN_SCLK,
    input wire IN_MCLK,
    input wire IN_LR,
    input wire I2S,
    
    output wire O1_VS,
    output wire HSA,
    output wire CLKA,
    output wire DEA,
    output wire [23:0]O1_D,
    
    output wire O1_SCLK,
    output wire MCLKA,
    output wire LRCLKA,
    output wire [1:0]O1_I2S,
    
    output wire O2_VS,
    output wire HSB,
    output wire CLKB,
    output wire DEB,
    output wire [15:8]O2_D,
    
    output wire O2_SCLK,
    output wire MCLKB,
    output wire LRCLKB,
    output wire [1:0]O2_I2S
    );
    
wire [63:0]M_AXIS_tdata;
wire M_AXIS_tready;
wire M_AXIS_tvalid;
wire overlay_clock;

top_blk_wrapper top_blk_i
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
    .overlay_clock(overlay_clock));
endmodule
