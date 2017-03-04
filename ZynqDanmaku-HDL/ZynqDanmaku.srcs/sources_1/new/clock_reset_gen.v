module clock_reset_gen (
    input wire clk,    // Clock
    input wire locked,
    output reg reset_n
);

reg internel_reset_n;
always @(posedge clk or negedge locked) begin : proc_reset_n
    if(~locked) begin
        reset_n <= 0;
        internel_reset_n <= 0;
    end else begin
        internel_reset_n <= 1;
        reset_n <= internel_reset_n;
    end
end

endmodule