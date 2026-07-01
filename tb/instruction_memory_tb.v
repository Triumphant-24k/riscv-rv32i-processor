`timescale 1ns/1ps

module instruction_memory_tb;

reg [31:0] PC;
wire [31:0] Instruction;

// Instantiate Instruction Memory
instruction_memory uut (
    .PC(PC),
    .Instruction(Instruction)
);

initial begin

    // Fetch instruction at address 0
    PC = 32'd0;
    #10;

    // Fetch instruction at address 4
    PC = 32'd4;
    #10;

    // Fetch instruction at address 8
    PC = 32'd8;
    #10;

    // Fetch instruction at address 12
    PC = 32'd12;
    #10;

    // Fetch instruction at address 16
    PC = 32'd16;
    #10;

    $stop;

end

endmodule