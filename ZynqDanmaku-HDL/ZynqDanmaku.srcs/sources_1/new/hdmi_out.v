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
    input wire rst_n,
    input wire orig_vs,
    input wire orig_hs,
    input wire orig_de,
    input wire [23:0]orig_rgb,
    
    input wire overlay_vs,
    input wire overlay_hs,
    input wire overlay_de,
    input wire [23:0]overlay_rgb,
    
    output wire out_vs,
    output wire out_hs,
    output wire out_de,
    output wire [15:0]out_ycrcb,
    output wire [23:0]out_crycb444,
    
    input wire en_overlay,
    input wire en_blank
);
reg [23+3:0] buf_orig, buf_overlay;
reg inner_vs,inner_hs,inner_de;
reg [23:0]inner_rgb;
reg [1:0] en_overlay_sync, en_blank_sync;
reg hs_to_csc,vs_to_csc,de_to_csc;
reg [23:0] rgb_to_csc;

always @(posedge clk) begin : proc_sw
    en_overlay_sync <= {en_overlay_sync[0], en_overlay};
    en_blank_sync   <= {en_blank_sync[0], en_blank};
end

always@(posedge clk)
begin
    buf_orig <= {orig_vs,orig_hs,orig_de,orig_rgb};
    buf_overlay <= {overlay_vs,overlay_hs,overlay_de,overlay_rgb};
    {inner_vs,inner_hs,inner_de,inner_rgb} <= en_overlay_sync[1] ? buf_overlay : buf_orig;
    {vs_to_csc,hs_to_csc,de_to_csc,rgb_to_csc} <= {inner_vs,inner_hs,inner_de,en_blank_sync[1] ? 24'b0 : inner_rgb};
end

rgb444toycrcb422 csc(
    .clk    (clk),
    .rst_n  (rst_n),
    .de_i   (de_to_csc),
    .hs_i   (hs_to_csc),
    .vs_i   (vs_to_csc),
    .rgb_i  (rgb_to_csc),
    .de_o   (out_de),
    .hs_o   (out_hs),
    .vs_o   (out_vs),
    .out_crycb444(out_crycb444),
    .ycrcb_o(out_ycrcb)
);

endmodule
