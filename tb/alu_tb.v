`timescale 1ns/1ps

module alu_tb;

reg [31:0] A;
reg [31:0] B;
reg [2:0] ALU_Sel;

wire [31:0] ALU_Out;
wire Zero;

// Instantiate the ALU module
alu uut (
    .A(A),
    .B(B),
    .ALU_Sel(ALU_Sel),
    .ALU_Out(ALU_Out),
    .Zero(Zero)
);

initial begin

    // Test 1: ADD
    A = 32'd10;
    B = 32'd5;
    ALU_Sel = 3'b000;
    #10;

    // Test 2: SUB
    A = 32'd10;
    B = 32'd5;
    ALU_Sel = 3'b001;
    #10;

    // Test 3: SUB giving zero
    A = 32'd10;
    B = 32'd10;
    ALU_Sel = 3'b001;
    #10;

    // Test 4: AND
    A = 32'b1010;
    B = 32'b1100;
    ALU_Sel = 3'b010;
    #10;

    // Test 5: OR
    A = 32'b1010;
    B = 32'b1100;
    ALU_Sel = 3'b011;
    #10;

    // Test 6: XOR
    A = 32'b1010;
    B = 32'b1100;
    ALU_Sel = 3'b100;
    #10;

    // End simulation
    $stop;

end

endmodule