/*
--创建日期   : 2015-05-18
--目标芯片   : EP4CE22F17C8
--时钟选择   : odck<=165MHz
--演示说明   : rst全局复位低有效，odck_in为像素时钟输入，v/hsync_in为同步信号输入，
              de_in为数据有效信号输入，pixel_*为像素颜色值，fifo*与弹幕像素FIFO相连，
              pixel_clk_o为像素时钟输出，v/hsync_o为同步信号输出，de_o为数据有效信号输出，
              noDebug为禁止调试用颜色输入，now*为当前像素位置输出，screen*为屏幕分辨率输出，
              ovf为计数器溢出指示，syncWaitV为场同步等待指示
*/
module danmaku_overlay(
  input wire rst,

  input wire scdt_in,
  input wire odck_in,
  input wire vsync_in,
  input wire hsync_in,
  input wire de_in,
  input wire[7:0] pixel_r_in,
  input wire[7:0] pixel_g_in,
  input wire[7:0] pixel_b_in,
  input wire[31:0] fifoData_in,
  input wire fifoRdEmpty,
  input wire noDebug,

  output wire pixel_clk_o,
  output reg vsync_o,
  output reg hsync_o,
  output reg de_o,
  output wire[7:0] pixel_r_o,
  output wire[7:0] pixel_g_o,
  output wire[7:0] pixel_b_o,
  output wire[7:0] pixel_fwd_r_o,
  output wire[7:0] pixel_fwd_g_o,
  output wire[7:0] pixel_fwd_b_o,
  output wire fifoRdclk,
  output reg fifoRdreq,

  output wire [15:0] screenX,
  output wire [15:0] screenY,
  output wire [31:0] screenPxl,

  output wire [15:0] nowX,
  output wire [15:0] nowY,
  output wire [31:0] nowPxl,

  output wire ovf,
  output wire syncWaitV,

  input wire overlay_en

);

wire syncWait;
wire syncWaitH;
//wire syncWaitV;

reg[7:0] pixel_r_orig;
reg[7:0] pixel_g_orig;
reg[7:0] pixel_b_orig;

/*
wire [15:0] nowX;
wire [15:0] nowY;
wire [31:0] nowPxl;

wire ovf;
*/
assign pixel_clk_o=odck_in;
assign fifoRdclk = odck_in;
assign syncWait = syncWaitH || syncWaitV;
assign {pixel_fwd_r_o, pixel_fwd_g_o, pixel_fwd_b_o} =
    {
      (fifoRdEmpty && !noDebug)? ~pixel_r_orig : pixel_r_orig,
      pixel_g_orig,
      (syncWait && !noDebug) ? ~pixel_b_orig :  pixel_b_orig
    };
assign {pixel_r_o, pixel_g_o, pixel_b_o} =
  (fifoData_in[7]==1'b0 || syncWait || !overlay_en)?
    {
      (fifoRdEmpty && !noDebug)? ~pixel_r_orig : pixel_r_orig,
      pixel_g_orig,
      (syncWait && !noDebug) ? ~pixel_b_orig :  pixel_b_orig
    }:
    fifoData_in[31:8];

assign syncWaitH = fifoData_in[1:0] == 2'h01;
assign syncWaitV = fifoData_in[1:0] == 2'h02;


pxlCounter pxlCounter_inst(
    .odck(odck_in),
    .scdt(scdt_in),
    .vsyncIn(vsync_in),
    .hsyncIn(hsync_in),
    .deIn(de_in),
    .rst(rst),

    .nowX(nowX),
    .nowY(nowY),
    .nowPxl(nowPxl),

    .screenX(screenX),
    .screenY(screenY),
    .screenPxl(screenPxl),

    .ovf(ovf)
);

reg vsync_t, hsync_t, de_t;
reg[7:0] pixel_r_orig_t;
reg[7:0] pixel_g_orig_t;
reg[7:0] pixel_b_orig_t;

always @(posedge odck_in or negedge rst) begin

  if (rst==0) begin
    {pixel_r_orig, pixel_g_orig, pixel_b_orig} <= 32'h00_00_00_00;
    {vsync_o, hsync_o, de_o} <= 3'b000;
    {pixel_r_orig_t, pixel_g_orig_t, pixel_b_orig_t} <= 32'h00_00_00_00;
    {vsync_t, hsync_t, de_t} <= 3'b000;
    fifoRdreq <= 0;
  end else begin
    {pixel_r_orig, pixel_g_orig, pixel_b_orig} <= {pixel_r_orig_t, pixel_g_orig_t, pixel_b_orig_t};
    {pixel_r_orig_t, pixel_g_orig_t, pixel_b_orig_t} <= {pixel_r_in, pixel_g_in, pixel_b_in};
    {vsync_o, hsync_o, de_o} <= {vsync_t, hsync_t, de_t};
    {vsync_t, hsync_t, de_t} <= {vsync_in, hsync_in, de_in};
    fifoRdreq <= (! syncWaitH || (de_in && (nowX == 16'h00_02 || nowX == 16'h00_01))) && (! syncWaitV || (de_in && (nowPxl == 32'h00_00_00_02 || nowPxl == 32'h00_00_00_01)));
  end

end

endmodule
