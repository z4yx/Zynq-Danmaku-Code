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

assign rgb_shared = {
    rgb_to_hdmi1[7:0],
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
.Q(HSA), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(0), // 1-bit data input (positive edge)
.D2(hs_to_hdmi0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_vsa (
.Q(O1_VS), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(0), // 1-bit data input (positive edge)
.D2(vs_to_hdmi0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_dea (
.Q(DEA), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(0), // 1-bit data input (positive edge)
.D2(de_to_hdmi0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);

// =====To HDMI B=====
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_hsb (
.Q(HSB), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(hs_to_hdmi1), // 1-bit data input (positive edge)
.D2(0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_vsb (
.Q(O2_VS), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(vs_to_hdmi1), // 1-bit data input (positive edge)
.D2(0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_deb (
.Q(DEB), // 1-bit DDR output
.C(pix_clk), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(de_to_hdmi1), // 1-bit data input (positive edge)
.D2(0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
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
    .Q(O1_D[i]), // 1-bit DDR output
    .C(pix_clk), // 1-bit clock input
    .CE(1), // 1-bit clock enable input
    .D1(rgb_shared[i]), // 1-bit data input (positive edge)
    .D2(rgb_to_hdmi0[i]), // 1-bit data input (negative edge)
    .R(0), // 1-bit reset
    .S(0) // 1-bit set
    );
end
for(j=8;j<16;j=j+1)
begin : gen_db
    ODDR #(
    .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
    ) ODDR_db (
    .Q(O2_D[j]), // 1-bit DDR output
    .C(pix_clk), // 1-bit clock input
    .CE(1), // 1-bit clock enable input
    .D1(rgb_to_hdmi1[j]), // 1-bit data input (positive edge)
    .D2(1'b0), // 1-bit data input (negative edge)
    .R(0), // 1-bit reset
    .S(0) // 1-bit set
    );
end
endgenerate

endmodule
