`timescale 1ns/1ps
module flag_sync(/*autoport*/
//output
           FlagOut_clkB,
//input
           clkA,
           FlagIn_clkA,
           clkB);

input wire clkA;
input wire FlagIn_clkA;
input wire clkB;
output wire FlagOut_clkB;

// this changes level when the FlagIn_clkA is seen in clkA
reg FlagToggle_clkA;
always @(posedge clkA)
begin
    FlagToggle_clkA <= FlagToggle_clkA ^ FlagIn_clkA;
end

// which can then be sync-ed to clkB
reg [2:0] SyncA_clkB;
always @(posedge clkB)
begin
    SyncA_clkB <= {SyncA_clkB[1:0], FlagToggle_clkA};
end

// and recreate the flag in clkB
assign FlagOut_clkB = (SyncA_clkB[2] ^ SyncA_clkB[1]);

initial begin
    FlagToggle_clkA = 0;
end

/*

always #20 clkA = ~clkA;
always #3 clkB = ~clkB;
initial begin
    clkB=0;
    clkA=0;
    FlagToggle_clkA=0;
    SyncA_clkB=0;    
    FlagIn_clkA=0;
    @(negedge clkA);
    FlagIn_clkA=1;
    @(negedge clkA);
    FlagIn_clkA=0;

    repeat(5)
        @(negedge clkA);
    FlagIn_clkA=1;
    @(negedge clkA);
    FlagIn_clkA=0;
end

*/

endmodule
