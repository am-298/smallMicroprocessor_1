`timescale 1ns / 1ps
module instruction_decoder(
    input [31:0] instruction,
    output [4:0] opcode,
    output [4:0] dest_reg,
    output [4:0] src1_reg,
    output [4:0] src2_reg,
    output [15:0] imm_value,
    output immediate_flag
);
assign opcode         = instruction[31:27];
assign dest_reg       = instruction[26:22];
assign src1_reg       = instruction[21:17];
assign immediate_flag = instruction[16];
assign src2_reg       = instruction[15:11];
assign imm_value      = instruction[15:0];
endmodule
