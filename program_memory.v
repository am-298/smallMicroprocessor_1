`timescale 1ns / 1ps
module program_memory(
    input [15:0] PC,
    output reg [31:0] instruction
);
reg [31:0] memory [0:15];

initial begin
    $readmemb("program_data.mem", memory);
end

always @(*) begin
    instruction = memory[PC];
end
endmodule
