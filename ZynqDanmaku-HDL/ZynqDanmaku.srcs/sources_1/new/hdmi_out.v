`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/02 00:36:11
// Design Name: 
// Module Name: hdmi_out
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


module hdmi_out(
    input wire clk,
    input wire orig_vs,
    input wire orig_hs,
    input wire orig_de,
    input wire [23:0]orig_rgb,
    
    input wire overlay_vs,
    input wire overlay_hs,
    input wire overlay_de,
    input wire [23:0]overlay_rgb,
    
    output reg out_vs,
    output reg out_hs,
    output reg out_de,
    output reg [23:0]out_rgb,
    
    input wire en_overlay,
    input wire en_blank
);
reg [23+3:0] buf_orig, buf_overlay;
reg inner_vs,inner_hs,inner_de;
reg [23:0]inner_rgb;

always@(posedge clk)
begin
    buf_orig <= {orig_vs,orig_hs,orig_de,orig_rgb};
    buf_overlay <= {overlay_vs,overlay_hs,overlay_de,overlay_rgb};
    {inner_vs,inner_hs,inner_de,inner_rgb} <= en_overlay ? buf_overlay : buf_orig;
    {out_vs,out_hs,out_de,out_rgb} <= {inner_vs,inner_hs,inner_de,en_blank ? 24'b0 : inner_rgb};
end


endmodule
