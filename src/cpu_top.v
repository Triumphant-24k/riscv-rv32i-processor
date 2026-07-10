module cpu_top(

input clk,
input rst

);

// ================================
// Internal wires
// ================================

wire [31:0] PC;
wire [31:0] PC_next;
wire [31:0] Instruction;

wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] funct3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [6:0] funct7;

wire RegWrite;
wire ALUSrc;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire Branch;
wire [1:0] ImmSel;
wire [2:0] ALU_Sel;

wire [31:0] ReadData1;
wire [31:0] ReadData2;
wire [31:0] ImmOut;
wire [31:0] ALU_B;
wire [31:0] ALU_Out;
wire Zero;
wire [31:0] MemReadData;
wire [31:0] WriteBackData;

wire [31:0] PC_plus_4;
wire [31:0] Branch_Target;
wire Branch_Taken;

// ================================
// Instruction field extraction
// ================================

assign opcode = Instruction[6:0];
assign rd     = Instruction[11:7];
assign funct3 = Instruction[14:12];
assign rs1    = Instruction[19:15];
assign rs2    = Instruction[24:20];
assign funct7 = Instruction[31:25];

// ================================
// PC Logic
// ================================

assign PC_plus_4 = PC + 32'd4;
assign Branch_Target = PC + ImmOut;
assign Branch_Taken = Branch & Zero;

assign PC_next = (Branch_Taken) ? Branch_Target : PC_plus_4;

// ================================
// Module Instantiations
// ================================

program_counter PC_UNIT (
    .clk(clk),
    .rst(rst),
    .PC_next(PC_next),
    .PC(PC)
);

instruction_memory IMEM (
    .PC(PC),
    .Instruction(Instruction)
);

control_unit CTRL (
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .ImmSel(ImmSel),
    .ALU_Sel(ALU_Sel)
);

register_file REGFILE (
    .clk(clk),
    .rst(rst),
    .RegWrite(RegWrite),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .WriteData(WriteBackData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

immediate_generator IMM_GEN (
    .Instruction(Instruction),
    .ImmSel(ImmSel),
    .ImmOut(ImmOut)
);

assign ALU_B = (ALUSrc) ? ImmOut : ReadData2;

alu ALU_UNIT (
    .A(ReadData1),
    .B(ALU_B),
    .ALU_Sel(ALU_Sel),
    .ALU_Out(ALU_Out),
    .Zero(Zero)
);

data_memory DMEM (
    .clk(clk),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Address(ALU_Out),
    .WriteData(ReadData2),
    .ReadData(MemReadData)
);

assign WriteBackData = (MemtoReg) ? MemReadData : ALU_Out;

endmodule