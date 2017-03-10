module rgb444toycrcb422_tb (
);

reg clk = 0;
reg rst_n = 0;
reg de_i =0 , hs_i=0, vs_i=0;
reg[23:0] rgb_i;

rgb444toycrcb422 dut(
    .clk    (clk),
    .rst_n  (rst_n),
    .de_i   (de_i),
    .hs_i   (hs_i),
    .vs_i   (vs_i),
    .rgb_i  (rgb_i),
    .de_o   (),
    .hs_o   (),
    .vs_o   (),
    .ycrcb_o()
);

always #5 clk = ~clk;

initial begin 
    @(negedge clk);
    rst_n = 1;
    repeat(5) 
        @(negedge clk);
    de_i = 1;
    repeat(6) begin
        rgb_i = 0;//$random();
        @(negedge clk);
    end
    de_i = 0;
end

endmodule
