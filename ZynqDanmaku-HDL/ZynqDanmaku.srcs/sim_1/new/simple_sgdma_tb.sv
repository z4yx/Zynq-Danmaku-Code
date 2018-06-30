`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/21 10:55:54
// Design Name: 
// Module Name: simple_sgdma_tb
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


module simple_sgdma_tb(

    );
    
reg ps_clk  =0;
reg ps_porb =0;
reg ps_srstb=0;
reg axi_gen_start=0;

wire FIXED_IO_ps_clk  =ps_clk;
wire FIXED_IO_ps_porb =ps_porb;
wire FIXED_IO_ps_srstb=ps_srstb;

always #15 ps_clk=~ps_clk;

simple_sgdma_test dut(
	.core_ext_start_0 (axi_gen_start),
	.FIXED_IO_ps_porb (FIXED_IO_ps_porb),
	.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
	.FIXED_IO_ps_clk  (FIXED_IO_ps_clk)
);

initial begin 
	int resp,read_data;

	repeat(10) begin 
		@(posedge  ps_clk);
	end
	ps_porb = 1;
	ps_srstb = 1;
	repeat(10) begin 
		@(posedge  ps_clk);
	end

	for (int i = 0; i < 256; i+=4) begin
		int data;
		data = (i+3)<<24 | (i+2)<<16 | (i+1)<<8 | i;
		dut.processing_system7_0.inst.write_mem(data, 32'h100000|i, 4);
	end

	dut.processing_system7_0.inst.fpga_soft_reset(32'h1);
	dut.processing_system7_0.inst.fpga_soft_reset(32'h0);

	dut.processing_system7_0.inst.set_arqos("S_AXI_HP0", 4'h0);
	dut.processing_system7_0.inst.set_awqos("S_AXI_HP0", 4'h0);
	dut.processing_system7_0.inst.set_slave_profile("S_AXI_HP0", 2'b10); //Worst case
	dut.processing_system7_0.inst.set_debug_level_info(0);

	repeat(50)begin 
		@(posedge dut.processing_system7_0.FCLK_CLK0);
	end

	dut.processing_system7_0.inst.write_data(32'h4050_0000,4, 32'h100000, resp); //mmaddr
	dut.processing_system7_0.inst.write_data(32'h4050_0004,4, 32'd4, resp); //length
	dut.processing_system7_0.inst.write_data(32'h4050_0008,4, 32'b0001_1, resp); //control

	do begin 
		dut.processing_system7_0.inst.read_data(32'h4050_0008,4,read_data,resp);
	end while(read_data&1);

	dut.processing_system7_0.inst.write_data(32'h4050_0000,4, 32'h100003, resp); //mmaddr
	dut.processing_system7_0.inst.write_data(32'h4050_0004,4, 32'd15, resp); //length
	dut.processing_system7_0.inst.write_data(32'h4050_0008,4, 32'b0010_1, resp); //control

	do begin 
		dut.processing_system7_0.inst.read_data(32'h4050_0008,4,read_data,resp);
	end while(read_data&1);

    dut.processing_system7_0.inst.write_data(32'h4050_0010,4, 32'hff, resp); //status
	dut.processing_system7_0.inst.write_data(32'h4050_0000,4, 32'h100002, resp); //mmaddr
	dut.processing_system7_0.inst.write_data(32'h4050_0004,4, 32'ha000, resp); //length
	dut.processing_system7_0.inst.write_data(32'h4050_0008,4, 32'b0011_1, resp); //control

	do begin 
		dut.processing_system7_0.inst.read_data(32'h4050_0008,4,read_data,resp);
	end while(read_data&1);
    dut.processing_system7_0.inst.read_data(32'h4050_0010,4,read_data,resp);
    $display ("%t, committed, status = 32'h%x",$time, read_data);
    #72000;
    dut.processing_system7_0.inst.read_data(32'h4050_0010,4,read_data,resp);
    $display ("%t, completed, status = 32'h%x",$time, read_data);
    dut.processing_system7_0.inst.write_data(32'h4050_0010,4, 32'hff, resp); //status
    dut.processing_system7_0.inst.read_data(32'h4050_0010,4,read_data,resp);
    $display ("%t, cleared, status = 32'h%x",$time, read_data);

	dut.processing_system7_0.inst.write_data(32'h4050_0000,4, 32'h100000, resp); //mmaddr
	dut.processing_system7_0.inst.write_data(32'h4050_0004,4, 32'd30, resp); //length
	dut.processing_system7_0.inst.write_data(32'h4050_0008,4, 32'b0100_1, resp); //control

	do begin 
		dut.processing_system7_0.inst.read_data(32'h4050_0008,4,read_data,resp);
	end while(read_data&1);

	dut.processing_system7_0.inst.write_data(32'h4050_0000,4, 32'h100020, resp); //mmaddr
	dut.processing_system7_0.inst.write_data(32'h4050_0004,4, 32'ha030, resp); //length
	dut.processing_system7_0.inst.write_data(32'h4050_0008,4, 32'b0101_1, resp); //control

	do begin 
		dut.processing_system7_0.inst.read_data(32'h4050_0008,4,read_data,resp);
	end while(read_data&1);

	axi_gen_start = 1;

	for (int start = 0; start < 25; start++) begin

		dut.processing_system7_0.inst.write_data(32'h4050_0000,4, 32'h100000|start, resp); //mmaddr
		dut.processing_system7_0.inst.write_data(32'h4050_0004,4, 32'h80, resp); //length
		dut.processing_system7_0.inst.write_data(32'h4050_0008,4, 32'b0110_1, resp); //control

		do begin 
			dut.processing_system7_0.inst.read_data(32'h4050_0008,4,read_data,resp);
		end while(read_data&1);
	end

    dut.processing_system7_0.inst.write_data(32'h4050_0008,4, 32'hC0000000, resp); //control
    #1900;
    
    dut.processing_system7_0.inst.read_data(32'h4050_000C,4,read_data,resp); //response
    $display ("%t, response = 32'h%x",$time, read_data);
    dut.processing_system7_0.inst.write_data(32'h4050_000C,4, 0, resp); //response
    dut.processing_system7_0.inst.read_data(32'h4050_000C,4,read_data,resp); //response
    $display ("%t, cleared response = 32'h%x",$time, read_data);
    
    dut.processing_system7_0.inst.read_data(32'h4050_0010,4,read_data,resp);
    $display ("%t, halted, status = 32'h%x",$time, read_data);

	// //This drives the LEDs on the GPIO output
	// dut.processing_system7_0.inst.write_data(32'h41200000,4, 32'hFFFFFFFF, resp);
	// $display ("LEDs are toggled, observe the waveform");
	// //Write into the BRAM through GP0 and read back
	// dut.processing_system7_0.inst.write_data(32'h40000000,4, 32'hDEADBEEF, resp);
	// dut.processing_system7_0.inst.read_data(32'h40000000,4,read_data,resp);
	// $display ("%t, running the testbench, data read from BRAM was 32'h%x",$time, read_data);

end
endmodule
