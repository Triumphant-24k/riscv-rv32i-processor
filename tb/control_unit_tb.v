`timescale 1ns/1ps

module control_unit_tb;

reg [6:0] opcode;
reg [2:0] funct3;
reg [6:0] funct7;

wire RegWrite;
wire ALUSrc;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire Branch;
wire [1:0] ImmSel;
wire [2:0] ALU_Sel;

// Instantiate Control Unit
control_unit uut (
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

initial begin

    // Test 1: R-Type ADD
    // opcode = 0110011, funct3 = 000, funct7 = 0000000
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // Test 2: R-Type SUB
    // opcode = 0110011, funct3 = 000, funct7 = 0100000
    opcode = 7'b0110011;
    funct3 = 3'b000;
    funct7 = 7'b0100000;
    #10;

    // Test 3: I-Type ADDI
    // opcode = 0010011
    opcode = 7'b0010011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // Test 4: Load Word LW
    // opcode = 0000011
    opcode = 7'b0000011;
    funct3 = 3'b010;
    funct7 = 7'b0000000;
    #10;

    // Test 5: Store Word SW
    // opcode = 0100011
    opcode = 7'b0100011;
    funct3 = 3'b010;
    funct7 = 7'b0000000;
    #10;

    // Test 6: Branch Equal BEQ
    // opcode = 1100011
    opcode = 7'b1100011;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // Test 7: R-Type AND
    opcode = 7'b0110011;
    funct3 = 3'b111;
    funct7 = 7'b0000000;
    #10;

    // Test 8: R-Type OR
    opcode = 7'b0110011;
    funct3 = 3'b110;
    funct7 = 7'b0000000;
    #10;

    // Test 9: R-Type XOR
    opcode = 7'b0110011;
    funct3 = 3'b100;
    funct7 = 7'b0000000;
    #10;

    $stop;

end

endmodule