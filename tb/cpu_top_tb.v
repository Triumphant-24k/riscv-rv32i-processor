`timescale 1ns/1ps

module cpu_top_tb;

reg clk;
reg rst;

// Instantiate CPU
cpu_top uut (
    .clk(clk),
    .rst(rst)
);

// Clock generation
// 10 ns clock period
always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;

    // Hold reset for 10 ns
    #10;
    rst = 0;

    // Run enough cycles to execute instructions
    #100;

    $stop;

end

endmodule