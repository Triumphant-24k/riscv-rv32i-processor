module immediate_generator(

input [31:0] Instruction,
input [1:0] ImmSel,

output reg [31:0] ImmOut

);

always @(*)
begin
    case (ImmSel)

        // I-Type immediate: addi, lw
        2'b00: ImmOut = {{20{Instruction[31]}}, Instruction[31:20]};

        // S-Type immediate: sw
        2'b01: ImmOut = {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]};

        // B-Type immediate: beq
        2'b10: ImmOut = {{19{Instruction[31]}}, Instruction[31], Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};

        default: ImmOut = 32'b0;

    endcase
end

endmodule