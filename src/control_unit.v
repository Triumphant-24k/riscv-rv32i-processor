module control_unit(

input [6:0] opcode,
input [2:0] funct3,
input [6:0] funct7,

output reg RegWrite,
output reg ALUSrc,
output reg MemRead,
output reg MemWrite,
output reg MemtoReg,
output reg Branch,
output reg [1:0] ImmSel,
output reg [2:0] ALU_Sel

);

always @(*)
begin
    // Default values
    RegWrite = 0;
    ALUSrc   = 0;
    MemRead  = 0;
    MemWrite = 0;
    MemtoReg = 0;
    Branch   = 0;
    ImmSel   = 2'b00;
    ALU_Sel  = 3'b000;

    case (opcode)

        // R-Type: add, sub, and, or, xor
        7'b0110011:
        begin
            RegWrite = 1;
            ALUSrc   = 0;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 0;

            case ({funct7, funct3})
                {7'b0000000, 3'b000}: ALU_Sel = 3'b000; // ADD
                {7'b0100000, 3'b000}: ALU_Sel = 3'b001; // SUB
                {7'b0000000, 3'b111}: ALU_Sel = 3'b010; // AND
                {7'b0000000, 3'b110}: ALU_Sel = 3'b011; // OR
                {7'b0000000, 3'b100}: ALU_Sel = 3'b100; // XOR
                default: ALU_Sel = 3'b000;
            endcase
        end

        // I-Type: addi
        7'b0010011:
        begin
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 0;
            ImmSel   = 2'b00;
            ALU_Sel  = 3'b000; // ADD for ADDI
        end

        // Load: lw
        7'b0000011:
        begin
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 1;
            MemWrite = 0;
            MemtoReg = 1;
            Branch   = 0;
            ImmSel   = 2'b00;
            ALU_Sel  = 3'b000; // ADD address
        end

        // Store: sw
        7'b0100011:
        begin
            RegWrite = 0;
            ALUSrc   = 1;
            MemRead  = 0;
            MemWrite = 1;
            MemtoReg = 0;
            Branch   = 0;
            ImmSel   = 2'b01;
            ALU_Sel  = 3'b000; // ADD address
        end

        // Branch: beq
        7'b1100011:
        begin
            RegWrite = 0;
            ALUSrc   = 0;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 1;
            ImmSel   = 2'b10;
            ALU_Sel  = 3'b001; // SUB for comparison
        end

        default:
        begin
            RegWrite = 0;
            ALUSrc   = 0;
            MemRead  = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch   = 0;
            ImmSel   = 2'b00;
            ALU_Sel  = 3'b000;
        end

    endcase
end

endmodule