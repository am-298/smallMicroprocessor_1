# Microprocessor Design in Verilog

This project implements a simple microprocessor using Verilog, featuring basic arithmetic, logical, and memory operations. The microprocessor performs a series of operations like addition, subtraction, multiplication, bitwise operations (AND, OR, XOR, etc.), data memory access, and branch/jump instructions. It is designed to be extensible, allowing you to add more complex features.

## Features

- **Arithmetic Operations**: Addition, subtraction, multiplication with support for immediate values.
- **Logical Operations**: AND, OR, XOR, XNOR, NAND, NOR, NOT, and rotate operations.
- **Memory Operations**: Load and store data between registers and memory.
- **Conditional Branching**: Jump instructions based on carry, sign, zero, or overflow flags.
- **Halt Condition**: Support for halting the processor's execution.
- **Registers**: 32 general-purpose registers and special registers (for example, the SGPR register used in multiplication).
- **Condition Flags**: Sign, carry, overflow, and zero flags for branching and decision-making.

## Design Overview

The processor is designed around a **4-stage pipeline**:
1. **Instruction Fetch**: Fetches the next instruction from program memory.
2. **Instruction Decode & Execution**: Decodes the instruction and performs the corresponding operation (arithmetic, logical, load/store, etc.).
3. **Condition Flag Update**: Updates the condition flags (carry, overflow, sign, zero) based on the executed instruction.
4. **Next Instruction Fetch**: Determines the next instruction based on jump conditions and program counter (PC).

### Example Instruction Set

The processor supports the following operations:
- **Arithmetic**: `MOV`, `ADD`, `SUB`, `MUL`
- **Logical**: `AND`, `OR`, `XOR`, `NOT`, `NAND`, `NOR`, `XNOR`
- **Load/Store**: `LOAD`, `STORE`, `SENDREG`, `SENDBYTE`
- **Control Flow**: `JUMP`, `JZERO`, `JNEG`, `JPOS`

You can modify the testbench to load different instructions into the memory to observe how the processor executes them.

## Testing

A testbench file  is provided to simulate the processor. The testbench applies a variety of instructions and checks the output . Modify the testbench to test different aspects of the processor.

## Acknowledgments

- Verilog HDL documentation
- Xilinx and EDA Playground for simulation tools
- Open-source projects that inspired this design
