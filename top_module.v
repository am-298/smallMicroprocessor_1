`timescale 1ns / 1ps
module microprocessor_top(
    input clk, reset,
    input [15:0] input_data,
    output [15:0] output_data
);
wire [15:0] PC;
wire [31:0] instruction;
wire [4:0] opcode, dest, src1, src2;
wire [15:0] imm;
wire imm_flag;
wire [15:0] reg_data1, reg_data2, alu_result, special_reg;
wire carry, zero, overflow, sign;

// Program Counter
wire jump_signal = 0;
wire [15:0] jump_addr = imm;
program_counter PCU(clk, reset, jump_signal, jump_addr, PC);

// Program Memory
program_memory PM(PC, instruction);

// Instruction Decoder
instruction_decoder DEC(instruction, opcode, dest, src1, src2, imm, imm_flag);

// Register File
wire reg_we = 1'b1;
register_file RF(clk, reg_we, dest, src1, src2, alu_result, reg_data1, reg_data2);

// ALU
alu ALU(opcode, reg_data1, reg_data2, imm, imm_flag, alu_result, special_reg, carry, zero, overflow, sign);

// Data Memory (optional for load/store)
wire [15:0] mem_read;
data_memory DM(clk, 1'b0, imm, reg_data1, mem_read);

// Output connection
assign output_data = alu_result;

endmodule
