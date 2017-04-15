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
  inout wire [14:0]DDR_addr,
  inout wire [2:0]DDR_ba,
  inout wire DDR_cas_n,
  inout wire DDR_ck_n,
  inout wire DDR_ck_p,
  inout wire DDR_cke,
  inout wire DDR_cs_n,
  inout wire [3:0]DDR_dm,
  inout wire [31:0]DDR_dq,
  inout wire [3:0]DDR_dqs_n,
  inout wire [3:0]DDR_dqs_p,
  inout wire DDR_odt,
  inout wire DDR_ras_n,
  inout wire DDR_reset_n,
  inout wire DDR_we_n,
  inout wire FIXED_IO_ddr_vrn,
  inout wire FIXED_IO_ddr_vrp,
  inout wire [53:0]FIXED_IO_mio,
  inout wire FIXED_IO_ps_clk,
  inout wire FIXED_IO_ps_porb,
  inout wire FIXED_IO_ps_srstb,
      
    inout wire mcu_rst_n,
    inout wire mcu_boot,
    input wire mcu_tx,    
    output wire mcu_rx,

    input wire [4:0]switch_in,
    output wire [4:0]led_out_n,
  
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
wire ps_overlay_clk, ps_fabric_50M_clk;

wire [15:0] pxl_width;
wire [15:0] pxl_height;

wire hps_fpga_reset_n = 1'b1;

wire sw_debug, sw_test_pattern, sw_pattern_pause;
   
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
    .ps_overlay_clock(ps_overlay_clk),
    .ps_fabric_50M_clk(ps_fabric_50M_clk),
    .UART_0_rxd(mcu_tx),
    .UART_0_txd(mcu_rx),
    .resolution_h(pxl_height),
    .resolution_w(pxl_width),
    .gpio_ctl_tri_io({mcu_boot,mcu_rst_n}),
    .gpo_tri_o({sw_debug,sw_test_pattern,sw_pattern_pause})
    );

//`default_nettype none

wire in_clk_pll,in_clk_reset_n,in_clk_locked;
clk_wiz_0 in_pll(
  .clk_in1(IN_CLK),
  .clk_out1(in_clk_pll),
  .locked(in_clk_locked)
);
clock_reset_gen in_rst(
  .clk    (in_clk_pll),
  .locked (in_clk_locked),
  .reset_n(in_clk_reset_n)
);

wire scdt_to_overlay;
wire odck_to_overlay;
wire vsync_to_overlay;
wire hsync_to_overlay;
wire de_to_overlay;
wire[7:0] pixel_r_to_overlay;
wire[7:0] pixel_g_to_overlay;
wire[7:0] pixel_b_to_overlay;
tfp401a dvi_in_1(
    .rst(in_clk_reset_n),
    .odck_in(in_clk_pll),
    .vsync_in(IN_VS),
    .hsync_in(IN_HS),
    .de_in(IN_DE),
    .pixel_r_in(IN_D[23:16]),
    .pixel_g_in(IN_D[15:8]),
    .pixel_b_in(IN_D[7:0]),
    .scdt_o(scdt_to_overlay),
    .odck_o(odck_to_overlay),
    .vsync_o(vsync_to_overlay),
    .hsync_o(hsync_to_overlay),
    .de_o(de_to_overlay),
    .pixel_r_o(pixel_r_to_overlay),
    .pixel_g_o(pixel_g_to_overlay),
    .pixel_b_o(pixel_b_to_overlay)
);
wire[31:0] pixel_fifo_data;
wire pixel_fifo_req;
wire pixel_fifo_clk;
wire pixel_fifo_empty;
wire[31:0] pixel_fifo_data_ext;
wire[31:0] pixel_fifo_data_int;
wire pixel_fifo_empty_ext;
wire pixel_fifo_empty_int;
wire sw_blank[0:1];
wire sw_en_overlay[0:1];
wire sw_conj;
wire led_flash_clk;

wire de_to_output,hs_to_output,vs_to_output;
wire [7:0] pixel_r_to_output,pixel_g_to_output,pixel_b_to_output;
wire [7:0] pixel_fwd_r_to_output,pixel_fwd_g_to_output,pixel_fwd_b_to_output;
wire pixel_clk_to_output;

wire de_to_hdmi[0:1],hs_to_hdmi[0:1],vs_to_hdmi[0:1];
wire [23:0] rgb_to_hdmi[0:1];

assign pixel_fifo_data = sw_test_pattern ? pixel_fifo_data_int : pixel_fifo_data_ext;
assign pixel_fifo_empty = sw_test_pattern ? pixel_fifo_empty_int : pixel_fifo_empty_ext;

led_clkdiv led_flash(.clk(odck_to_overlay), .divided(led_flash_clk));

led_pwm_ctl leds(
  .clk_fabric(ps_fabric_50M_clk),
  .enable    ({4'hf, sw_conj?led_flash_clk:1'b1}),
  .active    ({sw_blank[1],sw_en_overlay[1],sw_blank[0],sw_en_overlay[0],sw_conj}),
  .led_o_n   (led_out_n)
);

bistable_switch #(.WIDTH(5)) btn(
  .clk      (ps_fabric_50M_clk),
  .rst_n    (hps_fpga_reset_n),
  .switch_in(switch_in),
  .state_out({sw_blank[1],sw_en_overlay[1],sw_blank[0],sw_en_overlay[0],sw_conj})
);

oddr_adapter adapter(
  .pix_clk    (pixel_clk_to_output),
  .de_to_hdmi0 (de_to_hdmi[0]),
  .hs_to_hdmi0 (hs_to_hdmi[0]),
  .vs_to_hdmi0 (vs_to_hdmi[0]),
  .rgb_to_hdmi0(rgb_to_hdmi[0]),

  .de_to_hdmi1 (de_to_hdmi[1]),
  .hs_to_hdmi1 (hs_to_hdmi[1]),
  .vs_to_hdmi1 (vs_to_hdmi[1]),
  .rgb_to_hdmi1(rgb_to_hdmi[1]),

  .O2_VS      (O2_VS),
  .HSB        (HSB),
  .CLKB       (CLKB),
  .DEB        (DEB),
  .O2_D       (O2_D),
  
  .O1_VS      (O1_VS),
  .HSA        (HSA),
  .CLKA       (CLKA),
  .DEA        (DEA),
  .O1_D       (O1_D)
);

genvar out_idx;
generate
for(out_idx=0;out_idx<2;out_idx=out_idx+1)begin : gen_hdmi
    hdmi_out hdmi_o(
        .clk(pixel_clk_to_output),
        .orig_vs(vs_to_output),
        .orig_hs(hs_to_output),
        .orig_de(de_to_output),
        .orig_rgb({pixel_fwd_r_to_output,pixel_fwd_g_to_output,pixel_fwd_b_to_output}),
        
        .overlay_vs(vs_to_output),
        .overlay_hs(hs_to_output),
        .overlay_de(de_to_output),
        .overlay_rgb({pixel_r_to_output,pixel_g_to_output,pixel_b_to_output}),
        
        .out_vs(vs_to_hdmi[out_idx]),
        .out_hs(hs_to_hdmi[out_idx]),
        .out_de(de_to_hdmi[out_idx]),
        .out_rgb(rgb_to_hdmi[out_idx]),
    
        .en_overlay(sw_en_overlay[out_idx]),
        .en_blank(sw_blank[out_idx])
        );
end
endgenerate

danmaku_overlay overlay_logic_1(
   .rst(in_clk_reset_n),
   .scdt_in(scdt_to_overlay),
   .odck_in(odck_to_overlay),
   .vsync_in(vsync_to_overlay),
   .hsync_in(hsync_to_overlay),
   .de_in(de_to_overlay),
   .pixel_r_in(pixel_r_to_overlay),
   .pixel_g_in(pixel_g_to_overlay),
   .pixel_b_in(pixel_b_to_overlay),
   .fifoData_in(pixel_fifo_data),
   .fifoRdEmpty(pixel_fifo_empty),
   .noDebug(~sw_debug), 
   
   .pixel_clk_o(pixel_clk_to_output),
   .vsync_o(vs_to_output),
   .hsync_o(hs_to_output),
   .de_o(de_to_output),
   .pixel_r_o(pixel_r_to_output),
   .pixel_g_o(pixel_g_to_output),
   .pixel_b_o(pixel_b_to_output),
   .pixel_fwd_r_o(pixel_fwd_r_to_output),
   .pixel_fwd_g_o(pixel_fwd_g_to_output),
   .pixel_fwd_b_o(pixel_fwd_b_to_output),

   .fifoRdclk(pixel_fifo_clk),
   .fifoRdreq(pixel_fifo_req),
   .screenX(pxl_width[15:0]),
   .screenY(pxl_height[15:0]),
   .screenPxl(),
  
   .nowX(),
   .nowY(),
   .nowPxl(),
  
   .ovf(),
   .syncWaitV(),
   
   .overlay_en(1'b1)
);


pixel_data_adapter dma2overlay(
  .rst_n     (in_clk_reset_n),
  .clk_src   (ps_overlay_clk),
  .data_src  (M_AXIS_tdata),
  .valid_src (M_AXIS_tvalid),
  .ready_src (M_AXIS_tready),
  .clk_sink  (pixel_fifo_clk),
  .pixel_sink(pixel_fifo_data_ext),
  .empty_sink(pixel_fifo_empty_ext),
  .req_sink  (pixel_fifo_req)
);

test_img_feeder feeder1(
  .rst(in_clk_reset_n),
  .clk_feeder(ps_overlay_clk),
  .fifoData_out(pixel_fifo_data_int),
  .fifoRdclk(pixel_fifo_clk),
  .fifoRdreq(pixel_fifo_req),
  .fifoRdempty(pixel_fifo_empty_int),
  
  .pause(sw_pattern_pause)
);

endmodule
