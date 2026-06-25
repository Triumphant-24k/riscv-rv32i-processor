`timescale 1ns/1ps

module program_counter_tb;

reg clk;
reg rst;
reg [31:0] PC_next;

wire [31:0] PC;

// Instantiate Program Counter
program_counter uut (
    .clk(clk),
    .rst(rst),
    .PC_next(PC_next),
    .PC(PC)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    PC_next = 32'b0;

    // Reset PC
    #10;
    rst = 0;

    // PC = 4
    PC_next = 32'd4;
    #10;

    // PC = 8
    PC_next = 32'd8;
    #10;

    // PC = 12
    PC_next = 32'd12;
    #10;

    // PC = 16
    PC_next = 32'd16;
    #10;

    // Reset again
    rst = 1;
    #10;

    rst = 0;
    PC_next = 32'd20;
    #10;

    $stop;
end

endmodule