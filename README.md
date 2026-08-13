# RV32I Subset RISC-V Processor

A 32-bit single-cycle processor implementing a basic subset of the RISC-V RV32I instruction set in Verilog HDL and simulated using QuestaSim.

The processor is built using modular RTL blocks and supports a basic subset of RV32I instructions including arithmetic, immediate, memory, and branch-related control logic.

---

## Tools Used

- Verilog HDL
- QuestaSim
- VS Code
- GitHub

---

## Currently Supported Instructions

| Instruction | Type | Operation |
|------------|------|-----------|
| `nop` | I-Type | No operation |
| `addi` | I-Type | Add immediate |
| `add` | R-Type | Add two registers |
| `sub` | R-Type | Subtract two registers |
| `and` | R-Type | Bitwise AND |
| `or` | R-Type | Bitwise OR |
| `xor` | R-Type | Bitwise XOR |
| `lw` | I-Type | Load word from data memory |
| `sw` | S-Type | Store word to data memory |
| `beq` | B-Type | Branch if equal |

---

## Project Structure

```text
riscv-rv32i-processor/

docs/
    waveform.png
    program_counter_waveform.png
    instruction_memory_waveform.png
    immediate_generator_waveform.png
    data_memory_waveform.png
    control_unit_waveform.png
    Final_CPU.png

src/
    alu.v
    register_file.v
    program_counter.v
    instruction_memory.v
    immediate_generator.v
    control_unit.v
    data_memory.v
    cpu_top.v

tb/
    alu_tb.v
    register_file_tb.v
    program_counter_tb.v
    instruction_memory_tb.v
    immediate_generator_tb.v
    control_unit_tb.v
    data_memory_tb.v
    cpu_top_tb.v
```

---

## Processor Architecture

The processor is implemented as a single-cycle datapath. Each instruction is fetched, decoded, executed, and written back within one clock cycle.

```text
Program Counter
      |
      v
Instruction Memory
      |
      v
Instruction Decode
      |
      +------------------+
      |                  |
      v                  v
Control Unit       Register File
      |                  |
      |                  v
      |          Immediate Generator
      |                  |
      +---------> ALU <---+
                    |
                    v
              Data Memory
                    |
                    v
              Write Back
```

---

## Module Overview

| Module | Description |
|--------|-------------|
| `program_counter.v` | Stores the current instruction address and updates to the next address on every clock cycle. |
| `instruction_memory.v` | Stores the instruction sequence and outputs the instruction based on the current PC value. |
| `control_unit.v` | Decodes opcode, funct3, and funct7 fields to generate control signals. |
| `register_file.v` | Implements 32 registers of 32-bit width with two read ports and one write port. Register `x0` is hardwired to zero. |
| `immediate_generator.v` | Extracts and sign-extends immediate values for I-Type, S-Type, and B-Type instructions. |
| `alu.v` | Performs arithmetic and logical operations such as ADD, SUB, AND, OR, and XOR. |
| `data_memory.v` | Supports load and store operations using `lw` and `sw`. |
| `cpu_top.v` | Connects all modules to form the complete single-cycle processor. |

---

## CPU Interconnections

### 1. Program Counter to Instruction Memory

The Program Counter provides the address of the current instruction.

```verilog
instruction_memory IMEM (
    .PC(PC),
    .Instruction(Instruction)
);
```

The instruction memory uses:

```verilog
Instruction = memory[PC[31:2]];
```

This converts byte addressing into word addressing.

```text
PC = 0   -> memory[0]
PC = 4   -> memory[1]
PC = 8   -> memory[2]
PC = 12  -> memory[3]
```

---

### 2. Instruction Field Extraction

The 32-bit instruction is split into RISC-V instruction fields.

```verilog
opcode = Instruction[6:0];
rd     = Instruction[11:7];
funct3 = Instruction[14:12];
rs1    = Instruction[19:15];
rs2    = Instruction[24:20];
funct7 = Instruction[31:25];
```

These fields are passed to the Control Unit and Register File.

---

### 3. Control Unit

The Control Unit generates control signals based on the instruction type.

| Signal | Purpose |
|--------|---------|
| `RegWrite` | Enables writing into the register file |
| `ALUSrc` | Selects ALU second input from register or immediate |
| `MemRead` | Enables data memory read |
| `MemWrite` | Enables data memory write |
| `MemtoReg` | Selects write-back data from memory or ALU |
| `Branch` | Enables branch decision logic |
| `ImmSel` | Selects immediate format |
| `ALU_Sel` | Selects ALU operation |

---

### 4. Register File to ALU

The Register File provides two source operands.

```verilog
ReadData1 = registers[rs1];
ReadData2 = registers[rs2];
```

For R-Type instructions:

```text
ALU input A = ReadData1
ALU input B = ReadData2
```

For I-Type, Load, and Store instructions:

```text
ALU input B = Immediate value
```

This selection is done using:

```verilog
assign ALU_B = (ALUSrc) ? ImmOut : ReadData2;
```

---

### 5. Immediate Generator

The Immediate Generator extracts constants from instructions.

Examples:

| Instruction | Immediate |
|------------|-----------|
| `addi x5, x0, 10` | `10` |
| `sw x5, 8(x1)` | `8` |
| `beq x5, x6, 8` | `8` |

The module supports:

```text
I-Type immediate
S-Type immediate
B-Type immediate
```

---

### 6. ALU to Data Memory

The ALU performs arithmetic or address calculation.

For arithmetic instructions:

```text
ALU_Out = calculation result
```

For memory instructions:

```text
ALU_Out = memory address
```

Example:

```assembly
lw x5, 0(x1)
sw x5, 0(x1)
```

The ALU calculates:

```text
Address = x1 + immediate
```

---

### 7. Write Back Path

The result written back to the register file is selected using `MemtoReg`.

```verilog
assign WriteBackData = (MemtoReg) ? MemReadData : ALU_Out;
```

For arithmetic instructions:

```text
WriteBackData = ALU_Out
```

For load instructions:

```text
WriteBackData = MemReadData
```

---

### 8. PC Update Logic

The processor normally moves to the next instruction using:

```verilog
PC_plus_4 = PC + 4;
```

For branch instructions:

```verilog
Branch_Target = PC + ImmOut;
Branch_Taken  = Branch & Zero;
```

Final PC selection:

```verilog
PC_next = (Branch_Taken) ? Branch_Target : PC_plus_4;
```

---

## Test Program Used in CPU Top

The instruction memory was initialized with the following test program:

```assembly
nop
addi x5, x0, 10
addi x6, x0, 20
add  x7, x5, x6
sub  x8, x7, x6
```

Machine code stored in instruction memory:

| Address | Instruction | Assembly |
|---------|-------------|----------|
| `0` | `00000013` | `nop` |
| `4` | `00A00293` | `addi x5, x0, 10` |
| `8` | `01400313` | `addi x6, x0, 20` |
| `12` | `006283B3` | `add x7, x5, x6` |
| `16` | `40638433` | `sub x8, x7, x6` |

Expected register results:

| Register | Expected Value | Hex |
|----------|----------------|-----|
| `x5` | `10` | `0000000A` |
| `x6` | `20` | `00000014` |
| `x7` | `30` | `0000001E` |
| `x8` | `10` | `0000000A` |

---

## Simulation Results



### Final CPU Integration Waveform

<img src="docs/Final_CPU.png" width="900"/>

---

## Simulation Summary

| Module | Testbench | Status |
|--------|-----------|--------|
| ALU | `alu_tb.v` | Simulated |
| Register File | `register_file_tb.v` | Simulated |
| Program Counter | `program_counter_tb.v` | Simulated |
| Instruction Memory | `instruction_memory_tb.v` | Simulated |
| Immediate Generator | `immediate_generator_tb.v` | Simulated |
| Control Unit | `control_unit_tb.v` | Simulated |
| Data Memory | `data_memory_tb.v` | Simulated |
| CPU Top | `cpu_top_tb.v` | Simulated |

---

## Current Status

A working educational single-cycle processor implementing a limited RV32I subset has been completed and simulated using module-level and CPU-level testbenches.

The current testbenches generate simulation stimulus for waveform inspection. They do not yet contain automated assertions, full instruction-level regression tests, or official RISC-V ISA compliance testing.