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
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
--Data created:2015/6/18 
________________________________________________________
********************************************************/                   
`timescale 1ns/1ps  
module rgb_yuv (    
	input				clock		,
	input[15:0]			rdata		,
	input[15:0]			gdata		,
	input[15:0]			bdata		,
                    
	output[15:0]		ydata		,
	output[16:0]		udata		,
	output[16:0]		vdata
);
/*
Y''= 0.299*R'' + 0.587*G'' + 0.114*B''

U''= -0.147*R'' - 0.289*G'' + 0.436*B'' = 0.492*(B''- Y'')

V''= 0.615*R'' - 0.515*G'' - 0.100*B'' = 0.877*(R''- Y'')

[0.299 0.587 0.114].* 2^15  = [9798   19235    3736]

010_0110_0100_0110 = 9798
100_1011_0010_0011 = 19235
000_1110_1001_1000 = 3736

A1	+R<<13 +R<<10 +R<<9 +R<<6 +R<<2 +R<<1
A2  +G<<14 +G<<11 +G<<9 +G<<8 +G<<5 +G<<1 +G<<0
A3  +B<<12 -B<< 9 +B<<7 +B<<4 +B<<3

0.492*2^15 = 16122
0.877*2^15 = 28738

011_1110_1111_1001 = 16122
111_0000_0100_0001 = 28738

B1 +BY<<14 -BY<< 8 -BY<<3 +BY<<0
B2 +RY<<15 -RY<<12 +RY<<6 +RY<<0


*/
reg [17:0]	R13G14;
reg [19:0]	B12B9;
reg [17:0]	R10G11;
reg	[16:0]	R9G9;
reg [17:0]	B7G8;
reg [17:0]	R6G5;
reg [17:0]	B4B3;
reg [17:0]	R2R1;
reg [17:0]	G1G0;
always@(posedge clock)begin
	R13G14	<= rdata + {gdata,1'b0};
	B12B9	<= {bdata,3'b000} - bdata;
	R10G11	<= rdata + {gdata,1'b0};
	R9G9	<= rdata + gdata;
	B7G8	<= bdata + {gdata,1'b0};
	R6G5	<= gdata + {rdata,1'b0};
	B4B3	<= bdata + {bdata,1'b0};
	R2R1	<= rdata + {rdata,1'b0};
	G1G0	<= gdata + {gdata,1'b0};
end

reg [21:0]	R13G14_R10G11;
reg [20:0]	B12B9_R9G9;
reg [20:0]	B7G8_R6G5;
reg [17:0]	B4B3_d1;
reg [19:0]	R2R1_G1G0;

always@(posedge clock)begin
	R13G14_R10G11	<= {R13G14,3'b000} + R10G11;
	B12B9_R9G9		<= B12B9 + R9G9; 
	B7G8_R6G5		<= R6G5  +{B7G8,2'b00};
	B4B3_d1			<= B4B3;
	R2R1_G1G0		<= G1G0  + {R2R1,1'b0};
end

reg [23:0]	R13G14_R10G11__B12B9_R9G9;
reg [23:0]	B7G8_R6G5__B4B3;
reg [19:0]	R2R1_G1G0_d2;
always@(posedge clock)begin
	R13G14_R10G11__B12B9_R9G9	<= B12B9_R9G9 	+ {R13G14_R10G11,1'b0};
	B7G8_R6G5__B4B3				<= B4B3_d1		+ {B7G8_R6G5,2'b00};
	R2R1_G1G0_d2				<= R2R1_G1G0;
end

reg [30:0]	R13G14_R10G11__B12B9_R9G9___B7G8_R6G5__B4B3;
reg [19:0]	R2R1_G1G0_d3;

always@(posedge clock)begin
	R13G14_R10G11__B12B9_R9G9___B7G8_R6G5__B4B3	<= B7G8_R6G5__B4B3 + {R13G14_R10G11__B12B9_R9G9,6'b000_000};
	R2R1_G1G0_d3	<= R2R1_G1G0_d2;
end

reg [34:0]	R_G_B;
always@(posedge clock)begin
	R_G_B	<= R2R1_G1G0_d3 + {R13G14_R10G11__B12B9_R9G9___B7G8_R6G5__B4B3,3'b000};
end

wire[15:0]	Yd;
assign	Yd	= R_G_B[15+:16];

wire[15:0]	lat_rdata,lat_bdata;

cross_clk_sync #(                     
	.DSIZE    	(32),                 
	.LAT		(5)                   
)latency_bdata_rdata(                              
	clock,                              
	1'b1,                            
	{bdata,rdata},           
	{lat_bdata,lat_rdata} 
);                                    


reg [16:0]	BY,RY; //signed

always@(posedge clock)begin
	BY	<= lat_bdata - Yd;
	RY	<= lat_rdata - Yd;
end

/*
0.492*2^15 = 16122
0.877*2^15 = 28738

011_1110_1111_1001 = 16122
111_0000_0100_0001 = 28738

B1 +BY<<14 -BY<< 8 -BY<<3 +BY<<0
B2 +RY<<15 -RY<<12 +RY<<6 +RY<<0
*/

reg [25:0]	BY14BY8;
reg [20:0]	RY15RY12;
reg [20:0]	BY3BY0;
reg [23:0]	RY6RY0;


always@(posedge clock)begin
	BY14BY8		<= {BY,6'b000_000} - {{6{BY[16]}},BY};
	RY15RY12	<= {RY,3'b000} - {{3{RY[16]}},RY};
	BY3BY0		<= {{3{BY[16]}},BY} - {BY,3'b000};	//
	RY6RY0		<= {{6{RY[16]}},RY} + {RY,6'b000_000};
end

reg [33:0]	BY_ALL;
reg [33:0]	RY_ALL;


always@(posedge clock)begin
	BY_ALL	<= {BY14BY8,8'b0000_0000} + {{13{BY3BY0[20]}},BY3BY0};
	RY_ALL	<= {RY15RY12,12'd0} + {{9{RY6RY0[23]}},RY6RY0};
end

cross_clk_sync #(                     
	.DSIZE    	(16),                 
	.LAT		(3)                   
)latency_ydata(                              
	clock,                              
	1'b1,                            
	Yd,           
	ydata
);          

assign	udata	= BY_ALL[15+:17];
assign	vdata	= RY_ALL[15+:17];

endmodule

module cross_clk_sync #(
	parameter	LAT		= 2,
	parameter	DSIZE	= 1
)(
	input					clk,
	input					rst_n,
	input [DSIZE-1:0]		d,
	output[DSIZE-1:0]		q
);

reg	[DSIZE-1:0]		ltc		[LAT-1:0];

always@(posedge clk/*,negedge rst_n*/)begin:GEN_LAT
integer II;
	if(~rst_n)begin
		for(II=0;II<LAT;II=II+1)
			ltc[II]		<= {DSIZE{1'b0}};
	end else begin
		ltc[0]	<= d;
		for(II=1;II<LAT;II=II+1)
			ltc[II]		<= ltc[II-1];
end end

assign	q	= ltc[LAT-1];

endmodule


	




