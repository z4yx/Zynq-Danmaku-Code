
`timescale 1 ns / 1 ps

	module simple_sgdma_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface axi_lite_reg
		parameter integer C_axi_lite_reg_DATA_WIDTH	= 32,
		parameter integer C_axi_lite_reg_ADDR_WIDTH	= 5,

		// Parameters of Axi Master Bus Interface axis_cmd
		parameter integer C_axis_cmd_TDATA_WIDTH	= 72,
		parameter integer C_axis_cmd_START_COUNT	= 1,

		// Parameters of Axi Slave Bus Interface axis_sts
		parameter integer C_axis_sts_TDATA_WIDTH	= 8
	)
	(
		// Users to add ports here
		
		output reg halt,
		output reg allow_req,
		
		input wire halt_cmplt,
		input wire req_posted,
		input wire xfer_cmplt,
		
        input wire datamover_axi_clk,

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface axi_lite_reg
		input wire  axi_lite_reg_aclk,
		input wire  axi_lite_reg_aresetn,
		input wire [C_axi_lite_reg_ADDR_WIDTH-1 : 0] axi_lite_reg_awaddr,
		input wire [2 : 0] axi_lite_reg_awprot,
		input wire  axi_lite_reg_awvalid,
		output wire  axi_lite_reg_awready,
		input wire [C_axi_lite_reg_DATA_WIDTH-1 : 0] axi_lite_reg_wdata,
		input wire [(C_axi_lite_reg_DATA_WIDTH/8)-1 : 0] axi_lite_reg_wstrb,
		input wire  axi_lite_reg_wvalid,
		output wire  axi_lite_reg_wready,
		output wire [1 : 0] axi_lite_reg_bresp,
		output wire  axi_lite_reg_bvalid,
		input wire  axi_lite_reg_bready,
		input wire [C_axi_lite_reg_ADDR_WIDTH-1 : 0] axi_lite_reg_araddr,
		input wire [2 : 0] axi_lite_reg_arprot,
		input wire  axi_lite_reg_arvalid,
		output wire  axi_lite_reg_arready,
		output wire [C_axi_lite_reg_DATA_WIDTH-1 : 0] axi_lite_reg_rdata,
		output wire [1 : 0] axi_lite_reg_rresp,
		output wire  axi_lite_reg_rvalid,
		input wire  axi_lite_reg_rready,

		// Ports of Axi Master Bus Interface axis_cmd
		output reg  axis_cmd_tvalid,
		output reg [C_axis_cmd_TDATA_WIDTH-1 : 0] axis_cmd_tdata,
		input wire  axis_cmd_tready,

		// Ports of Axi Slave Bus Interface axis_sts
		output wire  axis_sts_tready,
		input wire [C_axis_sts_TDATA_WIDTH-1 : 0] axis_sts_tdata,
		input wire [(C_axis_sts_TDATA_WIDTH/8)-1 : 0] axis_sts_tkeep,
		input wire  axis_sts_tlast,
		input wire  axis_sts_tvalid
	);

	wire [C_axi_lite_reg_DATA_WIDTH-1:0]	slv_reg_mmaddr;
	wire [C_axi_lite_reg_DATA_WIDTH-1:0]	slv_reg_length;
	wire slv_reg_control_commit;
	wire [3:0] slv_reg_control_tag;
	wire disable_req, slv_reg_control_halt;
	wire clear_response;
	reg halt_sync, allow_req_sync;
	reg commit_ack;
	reg [3:0] slv_reg_response_tag;
	reg [3:0] slv_reg_response_ok_slverr_decerr_interr;
	
    reg[1:0] halt_cmplt_sync;
    wire req_posted_clkB;
    wire xfer_cmplt_clkB;
    
    flag_sync sync_req_posted(
        .clkA(datamover_axi_clk),.FlagIn_clkA(req_posted),
        .clkB(axi_lite_reg_aclk),.FlagOut_clkB(req_posted_clkB)
        );
    flag_sync sync_xfer_cmplt(
        .clkA(datamover_axi_clk),.FlagIn_clkA(xfer_cmplt),
        .clkB(axi_lite_reg_aclk),.FlagOut_clkB(xfer_cmplt_clkB)
        );

// Instantiation of Axi Bus Interface axi_lite_reg
	simple_sgdma_v1_0_axi_lite_reg # ( 
		.C_S_AXI_DATA_WIDTH(C_axi_lite_reg_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_axi_lite_reg_ADDR_WIDTH)
	) simple_sgdma_v1_0_axi_lite_reg_inst (
		.slv_reg_mmaddr(slv_reg_mmaddr),
		.slv_reg_length(slv_reg_length),
		.slv_reg_control_commit(slv_reg_control_commit),
		.slv_reg_control_tag(slv_reg_control_tag),
        .slv_reg_control_halt(slv_reg_control_halt),
        .slv_reg_control_disable_req(disable_req),
		.commit_ack(commit_ack),
		.slv_reg_response_tag(slv_reg_response_tag),
		.slv_reg_response_ok_slverr_decerr_interr(slv_reg_response_ok_slverr_decerr_interr),
		.clear_response(clear_response),
        .halt_cmplt(halt_cmplt_sync[1]),
        .req_posted(req_posted_clkB),
        .xfer_cmplt(xfer_cmplt_clkB),
		.S_AXI_ACLK(axi_lite_reg_aclk),
		.S_AXI_ARESETN(axi_lite_reg_aresetn),
		.S_AXI_AWADDR(axi_lite_reg_awaddr),
		.S_AXI_AWPROT(axi_lite_reg_awprot),
		.S_AXI_AWVALID(axi_lite_reg_awvalid),
		.S_AXI_AWREADY(axi_lite_reg_awready),
		.S_AXI_WDATA(axi_lite_reg_wdata),
		.S_AXI_WSTRB(axi_lite_reg_wstrb),
		.S_AXI_WVALID(axi_lite_reg_wvalid),
		.S_AXI_WREADY(axi_lite_reg_wready),
		.S_AXI_BRESP(axi_lite_reg_bresp),
		.S_AXI_BVALID(axi_lite_reg_bvalid),
		.S_AXI_BREADY(axi_lite_reg_bready),
		.S_AXI_ARADDR(axi_lite_reg_araddr),
		.S_AXI_ARPROT(axi_lite_reg_arprot),
		.S_AXI_ARVALID(axi_lite_reg_arvalid),
		.S_AXI_ARREADY(axi_lite_reg_arready),
		.S_AXI_RDATA(axi_lite_reg_rdata),
		.S_AXI_RRESP(axi_lite_reg_rresp),
		.S_AXI_RVALID(axi_lite_reg_rvalid),
		.S_AXI_RREADY(axi_lite_reg_rready)
	);


	// Add user logic here
	always @(posedge axi_lite_reg_aclk)begin
	   halt_cmplt_sync <= {halt_cmplt_sync[0],halt_cmplt};
	end
	always @(posedge datamover_axi_clk)begin
	   {allow_req, allow_req_sync} <= {allow_req_sync, ~disable_req};
	   {halt, halt_sync} <= {halt_sync, slv_reg_control_halt};
	end

	wire axis_cmd_handshake;
	wire commit_posedge;
	reg slv_reg_control_commit_last;
	assign axis_cmd_handshake = axis_cmd_tready & axis_cmd_tvalid;
	assign commit_posedge = ~slv_reg_control_commit_last & slv_reg_control_commit;

	always @(posedge axi_lite_reg_aclk) begin
		if(~axi_lite_reg_aresetn)begin
			slv_reg_control_commit_last <= 0;
			commit_ack <= 0;
		end else begin
			slv_reg_control_commit_last <= slv_reg_control_commit;
			commit_ack <= axis_cmd_handshake;
		end
	end
	always @(posedge axi_lite_reg_aclk) begin
		if(~axi_lite_reg_aresetn)begin
			axis_cmd_tvalid <= 1'b0;
		end else begin		
			if(commit_posedge)
				axis_cmd_tvalid <= 1'b1;
			else if(axis_cmd_handshake)
				axis_cmd_tvalid <= 1'b0;
		end
	end
	
	always @(posedge axi_lite_reg_aclk) begin
		axis_cmd_tdata <= {slv_reg_control_tag, slv_reg_mmaddr, 1'b0, 1'b1, 6'h0, 1'b1, slv_reg_length[22:0]};
	end

	assign axis_sts_tready = 1'b1;
	always @(posedge axi_lite_reg_aclk) begin
        if(~axi_lite_reg_aresetn | clear_response)
            {slv_reg_response_ok_slverr_decerr_interr, slv_reg_response_tag} <= 0;
		else if(axis_sts_tvalid)
			{slv_reg_response_ok_slverr_decerr_interr, slv_reg_response_tag} <= axis_sts_tdata;
	end

	// User logic ends

	endmodule
