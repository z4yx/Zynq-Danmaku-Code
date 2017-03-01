module pixel_data_adapter (
    input wire rst_n,  // Asynchronous reset active low

    input wire clk_src,
    input wire [63:0] data_src,
    input wire valid_src,
    output wire ready_src,

    input wire clk_sink,
    output reg [31:0] pixel_sink,
    output wire empty_sink,
    input wire req_sink
    
);

wire [63:0] rev_order;
wire wrfull;
wire [7:0] short;
wire [31:0] mapped_pixel;
assign ready_src = ~wrfull;
assign rev_order = {data_src[7:0],data_src[15:8],data_src[23:16],data_src[31:24],
                    data_src[39:32],data_src[47:40],data_src[55:48],data_src[63:56]};

adapter_fifo fifo( //fifo in showahead mode
    .wr_clk(clk_src),
    .wr_en(valid_src),
    .full(wrfull),
    .din(rev_order),
    .rd_clk(clk_sink),
    .rd_en(req_sink),
    .empty(empty_sink),
    .dout(short)
    );

color_mapper mapper(
  .short(short[3:0]),
  .long (mapped_pixel)
);

always @(posedge clk_sink) begin : proc_pixel_sink
  if(req_sink) begin
    pixel_sink <= mapped_pixel;
  end
end

endmodule

module color_mapper(
  input wire [3:0] short, 
  output wire [32:0] long
);

assign long = (short[3] == 1'b0) ? ({
  short[0]?8'hff:8'h00,
  short[1]?8'hff:8'h00,
  short[2]?8'hff:8'h00,
  8'hff
}):(
  (short ==  4'hf) ? 32'h00_00_00_02 : (
    (short == 4'he) ? 32'h00_00_00_01 : 32'h00_00_00_00
  )
);
endmodule

