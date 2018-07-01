`timescale 1ns / 1ps

module simple_sgdma_tb(    );


// Ports of Axi Slave Bus Interface axi_lite_reg
wire  axi_lite_reg_aclk;
wire  axi_lite_reg_aresetn;
wire [C_axi_lite_reg_ADDR_WIDTH-1 : 0] axi_lite_reg_awaddr;
wire [2 : 0] axi_lite_reg_awprot;
wire  axi_lite_reg_awvalid;
wire  axi_lite_reg_awready;
wire [C_axi_lite_reg_DATA_WIDTH-1 : 0] axi_lite_reg_wdata;
wire [(C_axi_lite_reg_DATA_WIDTH/8)-1 : 0] axi_lite_reg_wstrb;
wire  axi_lite_reg_wvalid;
wire  axi_lite_reg_wready;
wire [1 : 0] axi_lite_reg_bresp;
wire  axi_lite_reg_bvalid;
wire  axi_lite_reg_bready;
wire [C_axi_lite_reg_ADDR_WIDTH-1 : 0] axi_lite_reg_araddr;
wire [2 : 0] axi_lite_reg_arprot;
wire  axi_lite_reg_arvalid;
wire  axi_lite_reg_arready;
wire [C_axi_lite_reg_DATA_WIDTH-1 : 0] axi_lite_reg_rdata;
wire [1 : 0] axi_lite_reg_rresp;
wire  axi_lite_reg_rvalid;
wire  axi_lite_reg_rready;

// Ports of Axi Master Bus Interface axis_cmd
wire  axis_cmd_tvalid;
wire [C_axis_cmd_TDATA_WIDTH-1 : 0] axis_cmd_tdata;
wire  axis_cmd_tready;

// Ports of Axi Slave Bus Interface axis_sts
wire  axis_sts_tready;
wire [C_axis_sts_TDATA_WIDTH-1 : 0] axis_sts_tdata;
wire [(C_axis_sts_TDATA_WIDTH/8)-1 : 0] axis_sts_tkeep;
wire  axis_sts_tlast;
wire  axis_sts_tvalid;

simple_sgdma_v1_0 dut(
    .axi_lite_reg_awaddr (axi_lite_reg_awaddr),
    .axi_lite_reg_awprot (axi_lite_reg_awprot),
    .axi_lite_reg_awvalid(axi_lite_reg_awvalid),
    .axi_lite_reg_awready(axi_lite_reg_awready),
    .axi_lite_reg_wdata  (axi_lite_reg_wdata),
    .axi_lite_reg_wstrb  (axi_lite_reg_wstrb),
    .axi_lite_reg_wvalid (axi_lite_reg_wvalid),
    .axi_lite_reg_wready (axi_lite_reg_wready),
    .axi_lite_reg_bresp  (axi_lite_reg_bresp),
    .axi_lite_reg_bvalid (axi_lite_reg_bvalid),
    .axi_lite_reg_bready (axi_lite_reg_bready),
    .axi_lite_reg_araddr (axi_lite_reg_araddr),
    .axi_lite_reg_arprot (axi_lite_reg_arprot),
    .axi_lite_reg_arvalid(axi_lite_reg_arvalid),
    .axi_lite_reg_arready(axi_lite_reg_arready),
    .axi_lite_reg_rdata  (axi_lite_reg_rdata),
    .axi_lite_reg_rresp  (axi_lite_reg_rresp),
    .axi_lite_reg_rvalid (axi_lite_reg_rvalid),
    .axi_lite_reg_rready (axi_lite_reg_rready),
    .axis_cmd_tvalid     (axis_cmd_tvalid),
    .axis_cmd_tdata      (axis_cmd_tdata),
    .axis_cmd_tready     (axis_cmd_tready),
    .axis_sts_tready     (axis_sts_tready),
    .axis_sts_tdata      (axis_sts_tdata),
    .axis_sts_tkeep      (axis_sts_tkeep),
    .axis_sts_tlast      (axis_sts_tlast),
    .axis_sts_tvalid     (axis_sts_tvalid),
    .axi_lite_reg_aresetn(axi_lite_reg_aresetn),
    .axi_lite_reg_aclk   (axi_lite_reg_aclk)

);

datamover datamover_for_test (
  .m_axi_mm2s_aclk(m_axi_mm2s_aclk),                        // input wire m_axi_mm2s_aclk
  .m_axi_mm2s_aresetn(m_axi_mm2s_aresetn),                  // input wire m_axi_mm2s_aresetn
  .mm2s_err(),                                      // output wire mm2s_err
  .m_axis_mm2s_cmdsts_aclk(axi_lite_reg_aclk),        // input wire m_axis_mm2s_cmdsts_aclk
  .m_axis_mm2s_cmdsts_aresetn(axi_lite_reg_aresetn),  // input wire m_axis_mm2s_cmdsts_aresetn
  .s_axis_mm2s_cmd_tvalid(axis_cmd_tvalid),          // input wire s_axis_mm2s_cmd_tvalid
  .s_axis_mm2s_cmd_tready(axis_cmd_tready),          // output wire s_axis_mm2s_cmd_tready
  .s_axis_mm2s_cmd_tdata(axis_cmd_tdata),            // input wire [71 : 0] s_axis_mm2s_cmd_tdata
  .m_axis_mm2s_sts_tvalid(axis_sts_tvalid),          // output wire m_axis_mm2s_sts_tvalid
  .m_axis_mm2s_sts_tready(axis_sts_tready),          // input wire m_axis_mm2s_sts_tready
  .m_axis_mm2s_sts_tdata(axis_sts_tdata),            // output wire [7 : 0] m_axis_mm2s_sts_tdata
  .m_axis_mm2s_sts_tkeep(axis_sts_tkeep),            // output wire [0 : 0] m_axis_mm2s_sts_tkeep
  .m_axis_mm2s_sts_tlast(axis_sts_tlast),            // output wire m_axis_mm2s_sts_tlast
  .m_axi_mm2s_arid(m_axi_mm2s_arid),                        // output wire [3 : 0] m_axi_mm2s_arid
  .m_axi_mm2s_araddr(m_axi_mm2s_araddr),                    // output wire [31 : 0] m_axi_mm2s_araddr
  .m_axi_mm2s_arlen(m_axi_mm2s_arlen),                      // output wire [7 : 0] m_axi_mm2s_arlen
  .m_axi_mm2s_arsize(m_axi_mm2s_arsize),                    // output wire [2 : 0] m_axi_mm2s_arsize
  .m_axi_mm2s_arburst(m_axi_mm2s_arburst),                  // output wire [1 : 0] m_axi_mm2s_arburst
  .m_axi_mm2s_arprot(m_axi_mm2s_arprot),                    // output wire [2 : 0] m_axi_mm2s_arprot
  .m_axi_mm2s_arcache(m_axi_mm2s_arcache),                  // output wire [3 : 0] m_axi_mm2s_arcache
  .m_axi_mm2s_aruser(m_axi_mm2s_aruser),                    // output wire [3 : 0] m_axi_mm2s_aruser
  .m_axi_mm2s_arvalid(m_axi_mm2s_arvalid),                  // output wire m_axi_mm2s_arvalid
  .m_axi_mm2s_arready(m_axi_mm2s_arready),                  // input wire m_axi_mm2s_arready
  .m_axi_mm2s_rdata(m_axi_mm2s_rdata),                      // input wire [63 : 0] m_axi_mm2s_rdata
  .m_axi_mm2s_rresp(m_axi_mm2s_rresp),                      // input wire [1 : 0] m_axi_mm2s_rresp
  .m_axi_mm2s_rlast(m_axi_mm2s_rlast),                      // input wire m_axi_mm2s_rlast
  .m_axi_mm2s_rvalid(m_axi_mm2s_rvalid),                    // input wire m_axi_mm2s_rvalid
  .m_axi_mm2s_rready(m_axi_mm2s_rready),                    // output wire m_axi_mm2s_rready
  .m_axis_mm2s_tdata(m_axis_mm2s_tdata),                    // output wire [63 : 0] m_axis_mm2s_tdata
  .m_axis_mm2s_tkeep(m_axis_mm2s_tkeep),                    // output wire [7 : 0] m_axis_mm2s_tkeep
  .m_axis_mm2s_tlast(m_axis_mm2s_tlast),                    // output wire m_axis_mm2s_tlast
  .m_axis_mm2s_tvalid(m_axis_mm2s_tvalid),                  // output wire m_axis_mm2s_tvalid
  .m_axis_mm2s_tready(m_axis_mm2s_tready)                  // input wire m_axis_mm2s_tready
);



endmodule
