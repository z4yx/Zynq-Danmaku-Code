module bistable_switch (
    clk,    // Clock
    rst_n,  // Asynchronous reset active low
    
    switch_in,
    state_out    
);

parameter WIDTH = 32;

input wire clk;
input wire rst_n;
input wire [WIDTH-1:0]switch_in;

output reg [WIDTH-1:0]state_out;

reg [WIDTH-1:0] debounce_in_sync[0:1];
wire [WIDTH-1:0] debounce_out;
reg  [WIDTH-1:0] debounce_out_dly;

always @(posedge clk or negedge rst_n) begin : proc_sync
    if(~rst_n) begin
        debounce_in_sync[0] <= 0;
        debounce_in_sync[1] <= debounce_in_sync[0];
    end else begin
        debounce_in_sync[0] <= switch_in;
        debounce_in_sync[1] <= debounce_in_sync[0];
    end
end // proc_sync

debounce #(
    .WIDTH(WIDTH),
    .POLARITY("HIGH")    // set to be "HIGH" for active high debounce or "LOW" for active low debounce
) sw_debounce(
    .clk     (clk),
    .reset_n (rst_n),
    .data_in (debounce_in_sync[1]),
    .data_out(debounce_out)
);

genvar i;
generate
    for (i = 0; i < WIDTH; i=i+1) begin : state_switch
        always @(posedge clk or negedge rst_n) begin
            if(~rst_n) begin
                debounce_out_dly[i] <= 0;
                state_out[i] <= 0;
            end else begin
                debounce_out_dly[i] <= debounce_out[i];
                if(!debounce_out_dly[i] && debounce_out[i])
                    state_out[i] = ~state_out[i];
            end
        end
    end
endgenerate

endmodule