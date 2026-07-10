`timescale 1ns/1ps

module immediate_generator_tb;

reg [31:0] Instruction;
reg [1:0] ImmSel;

wire [31:0] ImmOut;

// Instantiate Immediate Generator
immediate_generator uut (
    .Instruction(Instruction),
    .ImmSel(ImmSel),
    .ImmOut(ImmOut)
);

initial begin

    // Test 1: I-Type
    // addi x5, x0, 10
    // Expected Immediate = 10
    Instruction = 32'h00A00293;
    ImmSel = 2'b00;
    #10;

    // Test 2: I-Type
    // addi x5, x0, -1
    // Expected Immediate = -1 = FFFFFFFF
    Instruction = 32'hFFF00293;
    ImmSel = 2'b00;
    #10;

    // Test 3: S-Type
    // sw x5, 8(x1)
    // Expected Immediate = 8
    Instruction = 32'h0050A423;
    ImmSel = 2'b01;
    #10;

    // Test 4: B-Type
    // beq x5, x6, 8
    // Expected Immediate = 8
    Instruction = 32'h00628463;
    ImmSel = 2'b10;
    #10;

    $stop;

end

endmodule