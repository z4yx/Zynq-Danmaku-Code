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
wire ps_overlay_clk, ps_fabric_50M_clk, ps_fabric_rstn;

wire [15:0] pxl_width;
wire [15:0] pxl_height;
wire [15:0] now_x;
wire [15:0] now_y;

wire hps_fpga_reset_n = 1'b1;

wire sw_debug, sw_test_pattern, sw_pattern_pause;
wire sw_conj;
wire [3:0] gpo_dummy;
wire imgcap_start,
    imgcap_AXIS_tlast,
    imgcap_AXIS_tready,
    imgcap_AXIS_tvalid,
    imgcap_aclk,
    imgcap_aresetn;
wire [63:0] imgcap_AXIS_tdata;

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
    .ps_reset_n(ps_fabric_rstn),
    .UART_0_rxd(mcu_tx),
    .UART_0_txd(mcu_rx),
    .resolution_h(pxl_height),
    .resolution_w(pxl_width),
    .imgcap_AXIS_tdata(imgcap_AXIS_tdata),
    .imgcap_AXIS_tlast(imgcap_AXIS_tlast),
    .imgcap_AXIS_tready(imgcap_AXIS_tready),
    .imgcap_AXIS_tvalid(imgcap_AXIS_tvalid),
    .imgcap_aclk(imgcap_aclk),
    .imgcap_aresetn(imgcap_aresetn),
    .gpio_ctl_tri_io({mcu_boot,mcu_rst_n}),
    .btn_in(switch_in),
    .gpo({imgcap_start,gpo_dummy,sw_debug,sw_test_pattern,sw_pattern_pause})
    );

//`default_nettype none

wire in_clk_pll,in_clk_reset_n,in_clk_locked,clk_out_hdmi;
clk_wiz_0 in_pll(
  .clk_in1(IN_CLK),
  .clk_out1(in_clk_pll),
  .clk_out2(clk_out_hdmi),
  .locked(in_clk_locked)
);
clock_reset_gen in_rst(
  .clk    (in_clk_pll),
  .locked (in_clk_locked),
  .reset_n(in_clk_reset_n)
);

wire ps_overlay_clk_rstn;
clock_reset_gen feeder_rst(
  .clk    (ps_overlay_clk),
  .locked (ps_fabric_rstn),
  .reset_n(ps_overlay_clk_rstn)
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
wire led_flash_clk;

wire de_to_output,hs_to_output,vs_to_output;
wire [7:0] pixel_r_to_output,pixel_g_to_output,pixel_b_to_output;
wire [7:0] pixel_fwd_r_to_output,pixel_fwd_g_to_output,pixel_fwd_b_to_output;
wire pixel_clk_to_output;

wire de_to_hdmi[0:1],hs_to_hdmi[0:1],vs_to_hdmi[0:1];
wire [15:0] ycrcb_to_hdmi[0:1];
wire [23:0] crycb444[0:1];

assign pixel_fifo_data = sw_test_pattern ? pixel_fifo_data_int : pixel_fifo_data_ext;
assign pixel_fifo_empty = sw_test_pattern ? pixel_fifo_empty_int : pixel_fifo_empty_ext;

led_clkdiv led_flash(.clk(odck_to_overlay), .divided(led_flash_clk));

led_pwm_ctl leds(
  .clk_fabric(ps_fabric_50M_clk),
  .enable    ({4'hf, led_flash_clk}),
  .active    ({sw_blank[1],sw_en_overlay[1],sw_blank[0],sw_en_overlay[0],1'b1}),
  .led_o_n   (led_out_n)
);

bistable_switch #(.WIDTH(5)) btn(
  .clk      (ps_fabric_50M_clk),
  .rst_n    (hps_fpga_reset_n),
  .switch_in(switch_in),
  .state_out({sw_blank[1],sw_en_overlay[1],sw_blank[0],sw_en_overlay[0],sw_conj})
);

assign CLKA = clk_out_hdmi;
assign HSA = hs_to_hdmi[0];
assign O1_VS = vs_to_hdmi[0];
assign DEA = de_to_hdmi[0];
assign {O1_D[23:8]} = {ycrcb_to_hdmi[0]};

assign CLKB = clk_out_hdmi;
assign HSB = hs_to_hdmi[1];
assign O2_VS = vs_to_hdmi[1];
assign DEB = de_to_hdmi[1];
assign {O1_D[7:0],O2_D[15:8]} = {ycrcb_to_hdmi[1]};

//assign O1_D = crycb444[0];
    
assign O1_SCLK=IN_SCLK;
assign MCLKA=IN_MCLK;
assign LRCLKA=IN_LR;
assign O1_I2S={1'b0,I2S};
    
assign O2_SCLK=IN_SCLK;
assign MCLKB=IN_MCLK;
assign LRCLKB=IN_LR;
assign O2_I2S={1'b0,I2S};

simpleyuv testpattern(
  .pxlClk(pixel_clk_to_output),
  .rst(in_clk_reset_n),
  .hcnt(now_x),
  .vcnt(now_y),
  .hsize(pxl_width),
  .vsize(pxl_height),
  
//  .data(ycrcb_to_hdmi[0]),
  
  .pause(sw_conj)
);

genvar out_idx;
generate
for(out_idx=0;out_idx<2;out_idx=out_idx+1)begin : gen_hdmi
    hdmi_out hdmi_o(
        .clk(pixel_clk_to_output),
        .rst_n(in_clk_reset_n),
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
        .out_ycrcb(ycrcb_to_hdmi[out_idx]),
        .out_crycb444(crycb444[out_idx]),
    
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
  
   .nowX(now_x),
   .nowY(now_y),
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
  .rst(ps_overlay_clk_rstn),
  .clk_feeder(ps_overlay_clk),
  .fifoData_out(pixel_fifo_data_int),
  .fifoRdclk(pixel_fifo_clk),
  .fifoRdreq(pixel_fifo_req),
  .fifoRdempty(pixel_fifo_empty_int),
  
  .pause(sw_pattern_pause)
);

image_capture imgcap(
  .reset_o_n (imgcap_aresetn),
  .start     (imgcap_start),
  .pixel     (pixel_r_to_overlay),
  .hs        (hsync_to_overlay),
  .de        (de_to_overlay),
  .vs        (vsync_to_overlay),
  .axis_valid(imgcap_AXIS_tvalid),
  .axis_last (imgcap_AXIS_tlast),
  .axis_data (imgcap_AXIS_tdata),
  .clk       (odck_to_overlay),
  .rst_n     (in_clk_reset_n)
);
assign imgcap_aclk = odck_to_overlay;

endmodule
