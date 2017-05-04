module oddr_adapter (
    input wire pix_clk,    // Clock

    input wire de_to_hdmi0,
    input wire hs_to_hdmi0,
    input wire vs_to_hdmi0,
    input wire [23:0] rgb_to_hdmi0,

    input wire de_to_hdmi1,
    input wire hs_to_hdmi1,
    input wire vs_to_hdmi1,
    input wire [23:0] rgb_to_hdmi1,
    
    output wire O2_VS,
    output wire HSB,
    output wire CLKB,
    output wire DEB,
    output wire [15:8]O2_D,

    output wire O1_VS,
    output wire HSA,
    output wire CLKA,
    output wire DEA,
    output wire [23:0]O1_D
);

wire [23:0] rgb_shared;

wire O2_VS_int;
wire HSB_int;
wire CLKB_int;
wire DEB_int;
wire [15:8]O2_D_int;
wire O1_VS_int;
wire HSA_int;
wire CLKA_int;
wire DEA_int;
wire [23:0]O1_D_int;

assign rgb_shared = {
    rgb_to_hdmi1[0],rgb_to_hdmi1[1],rgb_to_hdmi1[2],rgb_to_hdmi1[3],rgb_to_hdmi1[4],rgb_to_hdmi1[5],rgb_to_hdmi1[6],rgb_to_hdmi1[7],
    8'b0,
    rgb_to_hdmi1[23:16]
};

clk_video pll(
    .clk_in1(pix_clk),
    .clk_out1(),
    .clk_out2(CLKA),
    .clk_out3(CLKB),
    .locked()
);

// =====To HDMI A=====
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_hsa (
.Q(HSA_int), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(hs_to_hdmi0), // 1-bit data input (positive edge)
.D2(hs_to_hdmi0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_vsa (
.Q(O1_VS_int), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(vs_to_hdmi0), // 1-bit data input (positive edge)
.D2(vs_to_hdmi0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_dea (
.Q(DEA_int), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(de_to_hdmi0), // 1-bit data input (positive edge)
.D2(de_to_hdmi0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
OBUF #(
.DRIVE(16), // Specify the output drive strength
.SLEW("FAST") // Specify the output slew rate
) OBUF_hsa (
.O(HSA), // Buffer output (connect directly to top-level port)
.I(HSA_int) // Buffer input
);
OBUF #(
.DRIVE(16), // Specify the output drive strength
.SLEW("FAST") // Specify the output slew rate
) OBUF_vsa (
.O(O1_VS), // Buffer output (connect directly to top-level port)
.I(O1_VS_int) // Buffer input
);
OBUF #(
.DRIVE(16), // Specify the output drive strength
.SLEW("FAST") // Specify the output slew rate
) OBUF_dea (
.O(DEA), // Buffer output (connect directly to top-level port)
.I(DEA_int) // Buffer input
);

// =====To HDMI B=====

ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_hsb (
.Q(HSB_int), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(hs_to_hdmi1), // 1-bit data input (positive edge)
.D2(hs_to_hdmi1), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_vsb (
.Q(O2_VS_int), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(vs_to_hdmi1), // 1-bit data input (positive edge)
.D2(vs_to_hdmi1), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_deb (
.Q(DEB_int), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(de_to_hdmi1), // 1-bit data input (positive edge)
.D2(de_to_hdmi1), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
OBUF #(
.DRIVE(16), // Specify the output drive strength
.SLEW("FAST") // Specify the output slew rate
) OBUF_hsb (
.O(HSB), // Buffer output (connect directly to top-level port)
.I(HSB_int) // Buffer input
);
OBUF #(
.DRIVE(16), // Specify the output drive strength
.SLEW("FAST") // Specify the output slew rate
) OBUF_vsb (
.O(O2_VS), // Buffer output (connect directly to top-level port)
.I(O2_VS_int) // Buffer input
);
OBUF #(
.DRIVE(16), // Specify the output drive strength
.SLEW("FAST") // Specify the output slew rate
) OBUF_deb (
.O(DEB), // Buffer output (connect directly to top-level port)
.I(DEB_int) // Buffer input
);

genvar i,j;
generate
for(i=0;i<24;i=i+1)
begin : gen_da
    ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
    ) ODDR_da (
    .Q(O1_D_int[i]), // 1-bit DDR output
    .C(pix_clk), // 1-bit clock input
    .CE(1), // 1-bit clock enable input
    .D1(rgb_to_hdmi0[i]), // 1-bit data input (positive edge)
    .D2(rgb_shared[i]), // 1-bit data input (negative edge)
    .R(0), // 1-bit reset
    .S(0) // 1-bit set
    );
    OBUF #(
    .DRIVE(24), // Specify the output drive strength
    .IOSTANDARD("LVTTL"),
    .SLEW("FAST") // Specify the output slew rate
    ) OBUF_da (
    .O(O1_D[i]), // Buffer output (connect directly to top-level port)
    .I(O1_D_int[i]) // Buffer input
    );
end
for(j=8;j<16;j=j+1)
begin : gen_db
    ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
    ) ODDR_db (
    .Q(O2_D_int[j]), // 1-bit DDR output
    .C(pix_clk), // 1-bit clock input
    .CE(1), // 1-bit clock enable input
    .D1(rgb_to_hdmi1[j]), // 1-bit data input (positive edge)
    .D2(rgb_to_hdmi1[j]), // 1-bit data input (negative edge)
    .R(0), // 1-bit reset
    .S(0) // 1-bit set
    );
    OBUF #(
    .DRIVE(24), // Specify the output drive strength
    .IOSTANDARD("LVTTL"),
    .SLEW("FAST") // Specify the output slew rate
    ) OBUF_db (
    .O(O2_D[j]), // Buffer output (connect directly to top-level port)
    .I(O2_D_int[j]) // Buffer input
    );
end
endgenerate

endmodule
