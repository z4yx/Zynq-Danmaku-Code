`timescale 1ns/1ps
module image_capture_tb (

    
);

reg clk = 0;
reg rst_n = 0;
wire vga_hsync,vga_vsync,vga_de;
wire [7:0] pixel;
reg start = 0;

always #10 clk = ~clk;

initial begin 
    repeat(10)
        @(posedge clk);
    rst_n = 1;
    wait(vga_de==1);
    @(negedge clk);
    start = 1;
    @(negedge clk);
    start = 0;

    wait(vga_vsync==0);
    wait(vga_vsync==1);
    
    wait(vga_vsync==0);
    repeat(10)
        @(posedge clk);
    @(negedge clk);
    start = 1;
    @(negedge clk);
    start = 0;
end

image_capture dut(
    .rst_n     (rst_n),
    .reset_o_n (),
    .start     (start),
    .pixel     (pixel),
    .hs        (vga_hsync),
    .de        (vga_de),
    .vs        (vga_vsync),
    .axis_valid(),
    .axis_last (),
    .axis_data (),
    .clk       (clk)
);

wire [11:0] hdata, vdata;
assign pixel = 800*vdata+hdata;
vga #(12, 800, 856, 976, 1040, 4, 5, 8, 10, 0, 0) vga800x600at75 (
    .clk(clk), 
    .hdata(hdata),
    .vdata(vdata),
    .hsync(vga_hsync),
    .vsync(vga_vsync),
    .data_enable(vga_de)
);


endmodule

module vga
#(parameter WIDTH = 0, HSIZE = 0, HFP = 0, HSP = 0, HMAX = 0, VSIZE = 0, VFP = 0, VSP = 0, VMAX = 0, HSPP = 0, VSPP = 0)
(
    input clk,
    output wire hsync,
    output wire vsync,
    output reg [WIDTH - 1:0] hdata,
    output reg [WIDTH - 1:0] vdata,
    output wire data_enable
);

// init
initial begin
    hdata <= 0;
    vdata <= 0;
end

// hdata
always @ (posedge clk)
begin
    if (hdata == (HMAX - 1))
        hdata <= 0;
    else
        hdata <= hdata + 1;
end

// vdata
always @ (posedge clk)
begin
    if (hdata == (HMAX - 1)) 
    begin
        if (vdata == (VMAX - 1))
            vdata <= 0;
        else
            vdata <= vdata + 1;
    end
end

// hsync & vsync & blank
assign hsync = ((hdata >= HFP) && (hdata < HSP)) ? HSPP : !HSPP;
assign vsync = ((vdata >= VFP) && (vdata < VSP)) ? VSPP : !VSPP;
assign data_enable = ((hdata < HSIZE) & (vdata < VSIZE));

endmodule