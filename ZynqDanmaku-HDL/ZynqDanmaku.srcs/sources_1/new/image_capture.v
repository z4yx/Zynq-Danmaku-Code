module image_capture (
    input wire clk,    // Clock
    input wire rst_n,  // Asynchronous reset active low
    
    output reg reset_o_n,

    input wire start,

    input wire [7:0] pixel,
    input wire hs,
    input wire de,
    input wire vs,

    output wire axis_valid,
    output wire axis_last,
    output wire [63:0] axis_data
);

reg [2:0] state;
reg start_sync, start_sync0;

always @(posedge clk or negedge rst_n) begin : proc_start
    if(~rst_n) begin
        start_sync0 <= 0;
        start_sync <= 0;
    end else begin
        start_sync <= start_sync0;
        start_sync0 <= start;
    end
end

always @(posedge clk or negedge rst_n) begin : proc_state
    if(~rst_n) begin
        state <= 0;
    end else begin
        case (state)
            3'h0: if(start_sync) state <= 3'h1;
            3'h1: if(!start_sync) state <= 3'h2;
            3'h2: if(vs) state <= 3'h3;
            3'h3: if(!vs) state <= 3'h4;
            3'h4: state <= 3'h5;
            3'h5: if(vs) state <= 3'h6;
            3'h6: state <= 3'h0;
            default : state <= 3'h0;
        endcase
    end
end
wire end_of_frame;
assign end_of_frame = (state == 3'h6);

always @(posedge clk or negedge rst_n) begin : proc_reset_o_n
    if(~rst_n) begin
        reset_o_n <= 0;
    end else if(state==3'h3) begin
        reset_o_n <= 0;
    end else begin 
        reset_o_n <= 1;
    end
end

reg valid_in_data;
reg[63:0] data_shift;
reg[7:0] buffer_input;
always @(posedge clk or negedge rst_n) begin : proc_in_buffer
    if(~rst_n) begin
        valid_in_data <= 0;
    end else begin
        buffer_input <= pixel;
        valid_in_data <= (state == 3'h5 && de);
    end
end

reg[2:0] shift_cnt;
reg shift_full;
always @(posedge clk) begin : proc_data_shift
    if(state == 3'h4 || !rst_n) begin
        shift_cnt <= 0;
        shift_full <= 0;
    end else begin
        if(valid_in_data)begin
            data_shift <= {buffer_input,data_shift[63:8]};
            shift_cnt <= shift_cnt+3'b1;
        end
        shift_full <= (shift_cnt==3'h7 && valid_in_data);
    end
end

reg [63:0] inner_buf;
reg inner_buf_valid;
always @(posedge clk) begin : proc_inner_buf
    if(state == 3'h4 || !rst_n) begin
        inner_buf_valid <= 0;
    end else if(shift_full) begin
        inner_buf <= data_shift;
        inner_buf_valid <= 1;
    end
end

reg [63:0] output_buf;
reg output_buf_valid, output_buf_last;

always @(posedge clk or negedge rst_n) begin : proc_output_buf
    if(~rst_n) begin
        output_buf_valid <= 0;
        output_buf_last <= 0;
    end else if(shift_full) begin
        output_buf <= inner_buf;
        output_buf_valid <= inner_buf_valid;
        output_buf_last <= 0;
    end else if(end_of_frame) begin 
        output_buf <= inner_buf;
        output_buf_valid <= inner_buf_valid;
        output_buf_last <= 1;
    end else begin
        output_buf_valid <= 0;
        output_buf_last <= 0;
    end
end

assign axis_last = output_buf_last;
assign axis_data = output_buf;
assign axis_valid = output_buf_valid;

endmodule