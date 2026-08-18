// ASIC-facing processor core. Instruction and data memories are external so
// they can be implemented with the memory resources of the selected process.
module cpu_core (
    input         clk,
    input         rst,
    output [31:0] instr_addr,
    input  [31:0] instr_rdata,
    output        data_read,
    output        data_write,
    output [31:0] data_addr,
    output [31:0] data_wdata,
    input  [31:0] data_rdata
);

wire [31:0] PC_next;
wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] funct3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [6:0] funct7;
wire RegWrite, ALUSrc, MemtoReg, Branch;
wire [1:0] ImmSel;
wire [2:0] ALU_Sel;
wire [31:0] ReadData1, ReadData2, ImmOut, ALU_B, ALU_Out;
wire Zero;
wire [31:0] WriteBackData, PC_plus_4, Branch_Target;
wire Branch_Taken;

assign opcode = instr_rdata[6:0];
assign rd     = instr_rdata[11:7];
assign funct3 = instr_rdata[14:12];
assign rs1    = instr_rdata[19:15];
assign rs2    = instr_rdata[24:20];
assign funct7 = instr_rdata[31:25];

assign PC_plus_4 = instr_addr + 32'd4;
assign Branch_Target = instr_addr + ImmOut;
assign Branch_Taken = Branch & Zero;
assign PC_next = Branch_Taken ? Branch_Target : PC_plus_4;

program_counter PC_UNIT (
    .clk(clk), .rst(rst), .PC_next(PC_next), .PC(instr_addr)
);

control_unit CTRL (
    .opcode(opcode), .funct3(funct3), .funct7(funct7),
    .RegWrite(RegWrite), .ALUSrc(ALUSrc), .MemRead(data_read),
    .MemWrite(data_write), .MemtoReg(MemtoReg), .Branch(Branch),
    .ImmSel(ImmSel), .ALU_Sel(ALU_Sel)
);

register_file REGFILE (
    .clk(clk), .rst(rst), .RegWrite(RegWrite), .rs1(rs1), .rs2(rs2),
    .rd(rd), .WriteData(WriteBackData), .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

immediate_generator IMM_GEN (
    .Instruction(instr_rdata), .ImmSel(ImmSel), .ImmOut(ImmOut)
);

assign ALU_B = ALUSrc ? ImmOut : ReadData2;

alu ALU_UNIT (
    .A(ReadData1), .B(ALU_B), .ALU_Sel(ALU_Sel),
    .ALU_Out(ALU_Out), .Zero(Zero)
);

assign data_addr = ALU_Out;
assign data_wdata = ReadData2;
assign WriteBackData = MemtoReg ? data_rdata : ALU_Out;

endmodule
