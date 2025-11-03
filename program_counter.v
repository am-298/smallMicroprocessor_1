`timescale 1ns / 1ps
module program_counter(
    input clk, reset, jump_signal,
    input [15:0] jump_addr,
    output reg [15:0] PC
);
always @(posedge clk or posedge reset) begin
    if (reset)
        PC <= 0;
    else if (jump_signal)
        PC <= jump_addr;
    else
        PC <= PC + 1;
end
endmodule
