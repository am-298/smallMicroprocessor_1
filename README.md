# 🧠 Custom RISC-Style Microprocessor (Verilog)

This repository implements a **modular RISC-style 16-bit microprocessor** built using **Verilog HDL**.  
The design follows a simple instruction cycle — **Fetch, Decode, Execute, and Write Back** — and demonstrates the structure of a basic CPU architecture with separate functional modules.

---

## 🏗️ Project Overview

The processor supports **arithmetic, logical, memory, and control flow** operations, designed around a custom instruction set architecture (ISA).  
Each module represents a distinct hardware block, allowing clear separation of functionality and easier simulation or debugging.

---

## 📂 Repository Structure

| File | Description |
|------|--------------|
| `program_counter.v` | 16-bit Program Counter — handles sequential and jump-based instruction flow |
| `program_memory.v` | Instruction memory initialized from `program_data.mem` |
| `instruction_decoder.v` | Decodes 32-bit instruction into opcode, registers, and immediate values |
| `register_file.v` | 32 general-purpose registers with read/write capability |
| `alu.v` | Arithmetic Logic Unit — supports add, sub, mul, logic, and bitwise ops |
| `data_memory.v` | Simple 16x16 memory for load/store operations |
| `control_unit.v` | FSM to control processor state transitions (IDLE, FETCH, DECODE, EXECUTE, HALT) |
| `microprocessor_top.v` | Integrates all submodules into a single top-level CPU design |
| `tb_microprocessor.v` | Testbench for simulation and functional verification |
| `program_data.mem` | Memory file containing the instruction program for execution |

---
<img src="images/Screenshot 2025-12-05 181219.png" width="800">
## ⚙️ Key Features

- **Custom 32-bit instruction format**
- **Modular design** for clarity and reuse
- **16-bit data path**, **32 registers**
- **ALU** supporting arithmetic & logical operations
- **Program & Data memory** separation (Harvard-style architecture)
- **Basic control flow** (jump and halt instructions)
- **Testbench included** for end-to-end simulation

---

## 🧩 Processor Pipeline

1. **Fetch** — Program Counter retrieves instruction from memory  
2. **Decode** — Instruction Decoder extracts opcode, registers, and operands  
3. **Execute** — ALU performs the operation  
4. **Memory Access / Writeback** — Data is written to registers or memory  
5. **Next Instruction** — PC increments or jumps based on control signal  
<img src="images/Screenshot 2025-12-05 181804.png" width="800">
---

## 🧠 Supported Instruction Categories

| Type | Example Instructions |
|------|----------------------|
| **Arithmetic** | ADD, SUB, MUL |
| **Logical** | AND, OR, XOR, NOT |
| **Bitwise** | NAND, NOR, XNOR, Rotate |
| **Memory** | LOAD, STORE, SEND, INPUT |
| **Control** | JUMP, HALT, Conditional Jumps |

---

## ▶️ How to Simulate

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/microprocessor_project.git
   cd microprocessor_project
