module led_pwm_ctl (
    input wire clk_fabric,    // Clock

    input wire [4:0] enable,
    input wire [4:0] active,
    
    output wire [4:0] led_o_n
);

parameter integer WEAK_LIGHT_PULSE = 16384*10/100;

reg [24:0] counter;
wire weak_on = (counter[15:0] < WEAK_LIGHT_PULSE);
wire flash = counter[24];
wire [4:0] led_out;

always @(posedge clk_fabric) begin : proc_counter
    counter <= counter + 1;
end

assign led_out = enable & (active & {flash,1'b1,flash,1'b1,1'b1} | (weak_on ? 5'b11111 : 5'b0));

assign led_o_n = ~led_out;

endmodule