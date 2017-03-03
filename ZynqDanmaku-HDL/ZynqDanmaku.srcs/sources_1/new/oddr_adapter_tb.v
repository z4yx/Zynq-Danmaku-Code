module oddr_adapter_tb (
        
);
wire O1_VS;
wire HSA;
wire CLKA;
wire DEA;
wire [23:0]O1_D;

wire O2_VS;
wire HSB;
wire CLKB;
wire DEB;
wire [15:8]O2_D;

reg pixel_clk_to_output = 0;
reg de_to_hdmi[0:1],hs_to_hdmi[0:1],vs_to_hdmi[0:1];
reg [23:0] rgb_to_hdmi[0:1];

reg [23:0] adv7513_d1;
reg adv7513_de1;
reg [23:0] adv7513_d2;
reg adv7513_de2;

always #5 pixel_clk_to_output = ~pixel_clk_to_output;

always @(posedge CLKA) begin : proc_adv7513_d1
    adv7513_d1 <= O1_D;
    adv7513_de1 <= DEA;
end
always @(posedge CLKB) begin : proc_adv7513_d2
    adv7513_d2 <= {O1_D[7:0],O2_D[15:8],O1_D[23:16]};
    adv7513_de2 <= DEB;
end

initial begin 
    de_to_hdmi[0] = 0;
    hs_to_hdmi[0] = 0;
    vs_to_hdmi[0] = 0;
    rgb_to_hdmi[0] = 0;
    repeat(50) @(posedge pixel_clk_to_output);
    repeat(5) begin 
        @(posedge pixel_clk_to_output);
        de_to_hdmi[0] = 1;
        rgb_to_hdmi[0] = $random();
    end
    @(posedge pixel_clk_to_output);
    de_to_hdmi[0] = 0;
end

initial begin 
    de_to_hdmi[1] = 0;
    hs_to_hdmi[1] = 0;
    vs_to_hdmi[1] = 0;
    rgb_to_hdmi[1] = 0;
    repeat(50) @(posedge pixel_clk_to_output);
    repeat(5) begin 
        @(posedge pixel_clk_to_output);
        de_to_hdmi[1] = 1;
        rgb_to_hdmi[1] = $random();
    end
    @(posedge pixel_clk_to_output);
    de_to_hdmi[1] = 0;
end


oddr_adapter adapter(
  .pix_clk    (pixel_clk_to_output),
  .de_to_hdmi0 (de_to_hdmi[0]),
  .hs_to_hdmi0 (hs_to_hdmi[0]),
  .vs_to_hdmi0 (vs_to_hdmi[0]),
  .rgb_to_hdmi0(rgb_to_hdmi[0]),

  .de_to_hdmi1 (de_to_hdmi[1]),
  .hs_to_hdmi1 (hs_to_hdmi[1]),
  .vs_to_hdmi1 (vs_to_hdmi[1]),
  .rgb_to_hdmi1(rgb_to_hdmi[1]),

  .O2_VS      (O2_VS),
  .HSB        (HSB),
  .CLKB       (CLKB),
  .DEB        (DEB),
  .O2_D       (O2_D),
  
  .O1_VS      (O1_VS),
  .HSA        (HSA),
  .CLKA       (CLKA),
  .DEA        (DEA),
  .O1_D       (O1_D)
);

wire dut_out;
ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
.INIT(1'b0), // Initial value of Q: 1'b0 or 1'b1
.SRTYPE("ASYNC") // Set/Reset type: "SYNC" or "ASYNC"
) ODDR_dut (
.Q(dut_out), // 1-bit DDR output
.C(pixel_clk_to_output), // 1-bit clock input
.CE(1), // 1-bit clock enable input
.D1(1), // 1-bit data input (positive edge)
.D2(0), // 1-bit data input (negative edge)
.R(0), // 1-bit reset
.S(0) // 1-bit set
);

endmodule