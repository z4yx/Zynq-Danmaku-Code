`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/08 21:00:19
// Design Name: 
// Module Name: rgb444toycrcb422
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


module rgb444toycrcb422(
    input wire clk,
    input wire rst_n,
    input wire de_i,
    input wire hs_i,
    input wire vs_i,
    input wire [23:0] rgb_i,
    output reg de_o,
    output reg hs_o,
    output reg vs_o,
    output reg [15:0] ycrcb_o
    );

reg[6:0] de_delay,hs_delay,vs_delay;
reg de_internal, hs_internal, vs_internal;
wire de_from_conv, hs_from_conv, vs_from_conv;
reg even;
wire[7:0] ydata,udata,vdata;
reg[7:0] ydata_last,udata_last,vdata_last;
reg[15:0] ycrcb_next;

RGB_YCbCr RGB2YCbCr(
    .clock(clk),
	.invsync(vs_i),
	.inhsync(hs_i),
	.inde(de_i),
    .inR({8'b0,rgb_i[23:16]}),
    .inG({8'b0,rgb_i[15:8]}),
    .inB({8'b0,rgb_i[7:0]}),
    .outvsync(vs_from_conv),
    .outhsync(hs_from_conv),
    .outde(de_from_conv),
    .outY(ydata),
    .outCb(udata),
    .outCr(vdata)
);

always @(posedge clk) begin 
    ydata_last <= ydata;
    udata_last <= udata;
    vdata_last <= vdata;
    if(!de_internal && de_from_conv) begin 
        even <= 1'b1;
    end else begin 
        even <= ~even;
    end
end

always @(posedge clk or negedge rst_n) begin : proc_output
    if(~rst_n) begin
        de_o <= 0;
        ycrcb_o <= 0;
        ycrcb_next <= 0;
    end else begin
        de_internal <= de_from_conv;
        hs_internal <= hs_from_conv;
        vs_internal <= vs_from_conv;
        de_o <= de_internal;   
        hs_o <= hs_internal;
        vs_o <= vs_internal;
        if(even)begin 
            ycrcb_o <= {(9'b0+udata+udata_last)>>1, ydata_last};
            ycrcb_next <= {(9'b0+vdata+vdata_last)>>1, ydata};
        end else begin 
            ycrcb_o <= ycrcb_next;
        end
    end
end






endmodule
