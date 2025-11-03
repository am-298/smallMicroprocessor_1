`timescale 1ns / 1ps

// Import opcodes
`define mov_to_reg   5'b00000
`define move         5'b00001
`define add_op       5'b00010
`define sub_op       5'b00011
`define mul_op       5'b00100
`define rotate_right 5'b00101
`define and_op       5'b00110
`define xor_op       5'b00111
`define xnor_op      5'b01000
`define nand_op      5'b01001
`define nor_op       5'b01010
`define not_op       5'b01011

module alu(
    input [4:0] opcode,
    input [15:0] src1, src2, imm_value,
    input immediate_flag,
    output reg [15:0] result,
    output reg [15:0] special_reg,
    output reg carry_flag, zero_flag, overflow_flag, sign_flag
);
reg [31:0] mul_result;
reg [16:0] temp_sum;

always @(*) begin
    // Default flags
    carry_flag = 0; zero_flag = 0; overflow_flag = 0; sign_flag = 0;
    result = 0; special_reg = 0;

    case (opcode)
        `move: begin
            result = immediate_flag ? imm_value : src1;
        end

        `add_op: begin
            temp_sum = immediate_flag ? (src1 + imm_value) : (src1 + src2);
            result = temp_sum[15:0];
            carry_flag = temp_sum[16];
        end

        `sub_op: begin
            result = immediate_flag ? (src1 - imm_value) : (src1 - src2);
        end

        `mul_op: begin
            mul_result = immediate_flag ? (src1 * imm_value) : (src1 * src2);
            result = mul_result[15:0];
            special_reg = mul_result[31:16];
        end

        `and_op: result = immediate_flag ? (src1 & imm_value) : (src1 & src2);
        `xor_op: result = immediate_flag ? (src1 ^ imm_value) : (src1 ^ src2);
        `xnor_op: result = immediate_flag ? (src1 ~^ imm_value) : (src1 ~^ src2);
        `nand_op: result = immediate_flag ? ~(src1 & imm_value) : ~(src1 & src2);
        `nor_op: result = immediate_flag ? ~(src1 | imm_value) : ~(src1 | src2);
        `not_op: result = immediate_flag ? ~imm_value : ~src1;

        default: result = 0;
    endcase

    // Flags
    sign_flag = result[15];
    zero_flag = (result == 0);
    overflow_flag = 0; // can be improved with signed overflow logic
end
endmodule
