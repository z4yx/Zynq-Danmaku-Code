/*******************************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________

--Module Name:
--Project Name:
--Chinese Description:
	
--English Description:
	
--Version:VERA.1.0.0
--Data modified:
--author:Young-����
--E-mail: wmy367@Gmail.com
--Data created:2015/6/18 
________________________________________________________
********************************************************/
`timescale 1ns/1ps
module rgb_yuv_tb;

bit		clock;

always #10 clock = ~clock;

logic[15:0]		rdata,gdata,bdata;
logic	unsigned[15:0]		ydata;
logic	signed[15:0]		udata;
logic	signed[15:0]		vdata;

rgb_yuv rgb_yuv_inst(
/*	input			*/	.clock			(clock			),	
/*	input[15:0]		*/	.rdata			(rdata       	),
/*	input[15:0]		*/	.gdata			(gdata     		),
/*	input[15:0]		*/	.bdata			(bdata     		),
/*	output[15:0]	*/	.ydata			(ydata          ),
/*	output[15:0]	*/	.udata			(udata          ),
/*	output[15:0]	*/	.vdata			(vdata          )
);
real Y_cal;
int unsigned Y_m;
real U_cal;
int U_m;
real V_cal;
int V_m;

always@(posedge clock)begin
	rdata		= $urandom_range(0,8'hFF);
    gdata		= $urandom_range(0,8'hFF);
    bdata		= $urandom_range(0,8'hFF);
end

logic[15:0]		R,G,B;
cross_clk_sync #(                     
	.DSIZE    	(16*3),                 
	.LAT		(8)                   
)latency_data(                              
	clock,                              
	1'b1,                            
	{rdata,gdata,bdata},
	{R,G,B}
);       

always@(R,G,B)begin
	Y_cal		= R*0.299+G*0.587+0.114*B;
	U_cal		= 0.492*(B-Y_cal);
	V_cal		= 0.877*(R-Y_cal);
end

always@(ydata,udata,vdata)begin
	Y_m		= ydata*1	;
    U_m     = udata*1	;
	V_m     = vdata*1	;
end

always@(negedge clock)begin:COUNT
int		II;
	$display("-------------->> %5d  <<---------",II);
	$display("Y: Model--> %16d ; cal--> %10.6f ",Y_m,Y_cal);
	$display("U: Model--> %16d ; cal--> %10.6f ",U_m,U_cal);
	$display("V: Model--> %16d ; cal--> %10.6f ",V_m,V_cal);
	$display("==========================================");
	II += 1;
end

endmodule

