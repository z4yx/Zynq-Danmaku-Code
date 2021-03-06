
`timescale 1 ns / 1 ps

	module pixel_transparent_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_ID_WIDTH	= 0,
		parameter integer C_S00_AXI_DATA_WIDTH	= 64,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_S00_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_BUSER_WIDTH	= 0,

		// Parameters of Axi Master Bus Interface M00_AXI
		parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_M00_AXI_BURST_LEN	= 16,
		parameter integer C_M00_AXI_ID_WIDTH	= 0,
		parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M00_AXI_DATA_WIDTH	= 64,
		parameter integer C_M00_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_BUSER_WIDTH	= 0
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [7 : 0] s00_axi_awlen,
		input wire [2 : 0] s00_axi_awsize,
		input wire [1 : 0] s00_axi_awburst,
		input wire  s00_axi_awlock,
		input wire [3 : 0] s00_axi_awcache,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wlast,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [7 : 0] s00_axi_arlen,
		input wire [2 : 0] s00_axi_arsize,
		input wire [1 : 0] s00_axi_arburst,
		input wire  s00_axi_arlock,
		input wire [3 : 0] s00_axi_arcache,
		input wire [2 : 0] s00_axi_arprot,
		input wire [C_S00_AXI_ARUSER_WIDTH-1 : 0] s00_axi_aruser,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rlast,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,

		// Ports of Axi Master Bus Interface M00_AXI
		input wire  m00_axi_aclk,
		input wire  m00_axi_aresetn,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
		output wire [7 : 0] m00_axi_awlen,
		output wire [2 : 0] m00_axi_awsize,
		output wire [1 : 0] m00_axi_awburst,
		output wire  m00_axi_awlock,
		output wire [3 : 0] m00_axi_awcache,
		output wire [2 : 0] m00_axi_awprot,
		output wire  m00_axi_awvalid,
		input wire  m00_axi_awready,
		output wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
		output wire [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
		output wire  m00_axi_wlast,
		output wire  m00_axi_wvalid,
		input wire  m00_axi_wready,
		input wire [1 : 0] m00_axi_bresp,
		input wire  m00_axi_bvalid,
		output wire  m00_axi_bready,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
		output wire [7 : 0] m00_axi_arlen,
		output wire [2 : 0] m00_axi_arsize,
		output wire [1 : 0] m00_axi_arburst,
		output wire  m00_axi_arlock,
		output wire [3 : 0] m00_axi_arcache,
		output wire [2 : 0] m00_axi_arprot,
		output wire  m00_axi_arvalid,
		input wire  m00_axi_arready,
		input wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
		input wire [1 : 0] m00_axi_rresp,
		input wire  m00_axi_rlast,
		input wire  m00_axi_rvalid,
		output wire  m00_axi_rready
	);
	// Add user logic here
	
	
wire[C_M00_AXI_DATA_WIDTH/8-1:0] mask;

generate
genvar i;
for(i=0;i<C_M00_AXI_DATA_WIDTH/8;i=i+1)begin : proc_mask
    assign mask[i] = (s00_axi_wdata[(i+1)*8-4:i*8] != 5'hd);
end
endgenerate
	
assign m00_axi_awaddr=s00_axi_awaddr;
assign m00_axi_awlen=s00_axi_awlen;
assign m00_axi_awsize=s00_axi_awsize;
assign m00_axi_awburst=s00_axi_awburst;
assign m00_axi_awlock=s00_axi_awlock;
assign m00_axi_awcache=s00_axi_awcache;
assign m00_axi_awprot=s00_axi_awprot;
assign m00_axi_awvalid=s00_axi_awvalid;
assign s00_axi_awready=m00_axi_awready;

assign m00_axi_wdata=s00_axi_wdata;
assign m00_axi_wstrb=s00_axi_wstrb & mask;
assign m00_axi_wlast=s00_axi_wlast;
assign m00_axi_wvalid=s00_axi_wvalid;
assign s00_axi_wready=m00_axi_wready;

assign s00_axi_bresp=m00_axi_bresp;
assign s00_axi_bvalid=m00_axi_bvalid;
assign m00_axi_bready=s00_axi_bready;

assign m00_axi_araddr=s00_axi_araddr;
assign m00_axi_arlen=s00_axi_arlen;
assign m00_axi_arsize=s00_axi_arsize;
assign m00_axi_arburst=s00_axi_arburst;
assign m00_axi_arlock=s00_axi_arlock;
assign m00_axi_arcache=s00_axi_arcache;
assign m00_axi_arprot=s00_axi_arprot;
assign m00_axi_arvalid=s00_axi_arvalid;
assign s00_axi_arready=m00_axi_arready;

assign s00_axi_rdata=m00_axi_rdata;
assign s00_axi_rresp=m00_axi_rresp;
assign s00_axi_rlast=m00_axi_rlast;
assign s00_axi_rvalid=m00_axi_rvalid;
assign m00_axi_rready=s00_axi_rready;
	// User logic ends

	endmodule
