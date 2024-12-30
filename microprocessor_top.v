`timescale 1ns / 1ps

/////////// Instruction Register (IR) Fields
`define opcode     IR[31:27]
`define dest_reg   IR[26:22]
`define src1_reg   IR[21:17]
`define immediate  IR[16]
`define src2_reg   IR[15:11]
`define imm_value  IR[15:0]

///////////////////////// Arithmetic Operations
`define mov_to_reg   5'b00000
`define move          5'b00001
`define add_op        5'b00010
`define sub_op        5'b00011
`define mul_op        5'b00100

///////////////////////// Logical Operations (AND, OR, XOR, XNOR, NAND, NOR, NOT)
`define rotate_right  5'b00101
`define and_op        5'b00110
`define xor_op        5'b00111
`define xnor_op       5'b01000
`define nand_op       5'b01001
`define nor_op        5'b01010
`define not_op        5'b01011

///////////////////////// Memory Operations (Load & Store)
`define store_reg     5'b01101   // Store register content to memory
`define store_input   5'b01110   // Store input data to memory
`define send_to_output 5'b01111  // Send data from memory to output
`define load_to_reg   5'b10001   // Load data from memory to register

///////////////////////// Control Flow Instructions (Jump & Branch)
`define jump_addr     5'b10010  // Jump to address
`define jump_if_carry 5'b10011  // Jump if carry flag set
`define jump_if_no_carry 5'b10100
`define jump_if_sign  5'b10101  // Jump if sign flag set
`define jump_if_no_sign 5'b10110
`define jump_if_zero  5'b10111  // Jump if zero flag set
`define jump_if_no_zero 5'b11000
`define jump_if_overflow 5'b11001 // Jump if overflow flag set
`define jump_if_no_overflow 5'b11010

///////////////////////// Halt Instruction
`define halt_exec     5'b11011

module microprocessor_top(
input clk, reset,
input [15:0] input_data,
output reg [15:0] output_data
);

///////////////////////// Program and Data Memory Modules
reg [31:0] program_memory [15:0];  // Program memory storage
reg [15:0] data_memory [15:0];     // Data memory storage

///////////////////////// Instruction Register (IR)
reg [31:0] instruction_reg;        // Instruction register

///////////////////////// General Purpose Registers (GPR)
reg [15:0] general_purpose_regs [31:0]; // GPR storage

///////////////////////// Special Purpose Register (SGPR)
reg [15:0] special_purpose_reg;    // Used for multiplication MSB

///////////////////////// Condition Flags
reg sign_flag = 0, zero_flag = 0, overflow_flag = 0, carry_flag = 0; 
reg [16:0] temp_sum;
reg jump_signal = 0;
reg stop_signal = 0;

// Decode the instruction
task decode_instruction();
 begin
  jump_signal = 1'b0;
  stop_signal = 1'b0;
  
  case(`opcode)
  /////////////////////////////
  `mov_to_reg: begin
    general_purpose_regs[`dest_reg] = special_purpose_reg;
  end

  /////////////////////////////
  `move : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = `imm_value;
    else
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg];
  end

  /////////////////////////////
  `add_op : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] + `imm_value;
    else
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] + general_purpose_regs[`src2_reg];
  end

  /////////////////////////////
  `sub_op : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] - `imm_value;
    else
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] - general_purpose_regs[`src2_reg];
  end

  /////////////////////////////
  `mul_op : begin
    if(`immediate)
      mul_result   = general_purpose_regs[`src1_reg] * `imm_value;
    else
      mul_result   = general_purpose_regs[`src1_reg] * general_purpose_regs[`src2_reg];
      
    general_purpose_regs[`dest_reg]   =  mul_result[15:0];
    special_purpose_reg               =  mul_result[31:16];
  end

  ///////////////////////////// Bitwise Operations
  `rotate_right : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] | `imm_value;
    else
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] | general_purpose_regs[`src2_reg];
  end

  `and_op : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] & `imm_value;
    else
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] & general_purpose_regs[`src2_reg];
  end

  `xor_op : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] ^ `imm_value;
    else
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] ^ general_purpose_regs[`src2_reg];
  end

  `xnor_op : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] ~^ `imm_value;
    else
      general_purpose_regs[`dest_reg]  = general_purpose_regs[`src1_reg] ~^ general_purpose_regs[`src2_reg];
  end

  `nand_op : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = ~(general_purpose_regs[`src1_reg] & `imm_value);
    else
      general_purpose_regs[`dest_reg]  = ~(general_purpose_regs[`src1_reg] & general_purpose_regs[`src2_reg]);
  end

  `nor_op : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = ~(general_purpose_regs[`src1_reg] | `imm_value);
    else
      general_purpose_regs[`dest_reg]  = ~(general_purpose_regs[`src1_reg] | general_purpose_regs[`src2_reg]);
  end

  `not_op : begin
    if(`immediate)
      general_purpose_regs[`dest_reg]  = ~(`imm_value);
    else
      general_purpose_regs[`dest_reg]  = ~(general_purpose_regs[`src1_reg]);
  end

  ///////////////////////////// Memory Operations
  `store_input: begin
    data_memory[`imm_value] = input_data;
  end

  `store_reg: begin
    data_memory[`imm_value] = general_purpose_regs[`src1_reg];
  end

  `send_to_output: begin
    output_data = data_memory[`imm_value];
  end

  `load_to_reg: begin
    general_purpose_regs[`dest_reg] = data_memory[`imm_value];
  end

  ///////////////////////////// Control Flow Instructions
  `jump_addr: begin
    jump_signal = 1'b1;
  end

  `jump_if_carry: begin
    if(carry_flag == 1'b1)
      jump_signal = 1'b1;
    else
      jump_signal = 1'b0;
  end

  `jump_if_sign: begin
    if(sign_flag == 1'b1)
      jump_signal = 1'b1;
    else
      jump_signal = 1'b0;
  end

  `jump_if_zero: begin
    if(zero_flag == 1'b1)
      jump_signal = 1'b1;
    else
      jump_signal = 1'b0;
  end

  `jump_if_overflow: begin
    if(overflow_flag == 1'b1)
      jump_signal = 1'b1;
    else
      jump_signal = 1'b0;
  end

  `halt_exec: begin
    stop_signal = 1'b1;
  end
  endcase
end
endtask

/////////////////////////// Condition Flag Logic
task update_condition_flags();
begin
  // Update sign flag based on operation type
  if(`opcode == `mul_op)
    sign_flag = special_purpose_reg[15];
  else
    sign_flag = general_purpose_regs[`dest_reg][15];

  // Update carry flag based on addition
  if(`opcode == `add_op) begin
    if(`immediate) begin
      temp_sum = general_purpose_regs[`src1_reg] + `imm_value;
      carry_flag = temp_sum[16]; 
    end else begin
      temp_sum = general_purpose_regs[`src1_reg] + general_purpose_regs[`src2_reg];
      carry_flag = temp_sum[16];
    end
  end else begin
    carry_flag = 1'b0;
  end

  // Update zero flag based on result
  zero_flag = (~(|general_purpose_regs[`dest_reg]) | ~(|special_purpose_reg[15:0]));

  // Update overflow flag based on addition or subtraction
  if(`opcode == `add_op) begin
    if(`immediate)
      overflow_flag = (~general_purpose_regs[`src1_reg][15] & ~IR[15] & general_purpose_regs[`dest_reg][15]) | (general_purpose_regs[`src1_reg][15] & IR[15] & ~general_purpose_regs[`dest_reg][15]);
    else
      overflow_flag = (~general_purpose_regs[`src1_reg][15] & ~general_purpose_regs[`src2_reg][15] & general_purpose_regs[`dest_reg][15]) | (general_purpose_regs[`src1_reg][15] & general_purpose_regs[`src2_reg][15] & ~general_purpose_regs[`dest_reg][15]);
  end else if(`opcode == `sub_op) begin
    if(`immediate)
      overflow_flag = (~general_purpose_regs[`src1_reg][15] & IR[15] & general_purpose_regs[`dest_reg][15]) | (general_purpose_regs[`src1_reg][15] & ~IR[15] & ~general_purpose_regs[`dest_reg][15]);
    else
      overflow_flag = (~general_purpose_regs[`src1_reg][15] & general_purpose_regs[`src2_reg][15] & general_purpose_regs[`dest_reg][15]) | (general_purpose_regs[`src1_reg][15] & ~general_purpose_regs[`src2_reg][15] & ~general_purpose_regs[`dest_reg][15]);
  end else begin
    overflow_flag = 1'b0;
  end
end
endtask

/////////////////////////// Program Initialization
initial begin
  $readmemb("program_data.mem", program_memory);
end

/////////////////////////// FSM States
parameter state_idle = 0, state_fetch = 1, state_decode_execute = 2, state_next_inst = 3, state_check_halt = 4, state_delay_inst = 5;

reg [2:0] current_state = state_idle, next_state = state_idle;

always @(posedge clk) begin
  if (reset)
    current_state <= state_idle;
  else
    current_state <= next_state;
end

always @(*) begin
  case (current_state)
    state_idle: begin
      instruction_reg = 32'h0;
      next_state = state_fetch;
    end
    
    state_fetch: begin
      instruction_reg = program_memory[PC];
      next_state = state_decode_execute;
    end
    
    state_decode_execute: begin
      decode_instruction();
      update_condition_flags();
      next_state = state_delay_inst;
    end
    
    state_delay_inst: begin
      if(count < 4)
        next_state = state_delay_inst;
      else
        next_state = state_next_inst;
    end
    
    state_next_inst: begin
      next_state = state_check_halt;
      if (jump_signal)
        PC = `imm_value;
      else
        PC = PC + 1;
    end
    
    state_check_halt: begin
      if (stop_signal == 1'b0)
        next_state = state_fetch;
      else if (reset == 1'b1)
        next_state = state_idle;
      else
        next_state = state_check_halt;
    end
    
    default: next_state = state_idle;
  endcase
end

/////////////////////////// Count Update Logic
always @(posedge clk) begin
  case(current_state)
    state_idle: begin
      count <= 0;
    end
    
    state_fetch: begin
      count <= 0;
    end
    
    state_decode_execute: begin
      count <= 0;
    end
    
    state_delay_inst: begin
      count <= count + 1;
    end
    
    state_next_inst: begin
      count <= 0;
    end
    
    state_check_halt: begin
      count <= 0;
    end
    
    default: count <= 0;
  endcase
end

endmodule
