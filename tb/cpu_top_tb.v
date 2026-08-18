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

    // Avoid releasing reset on the active clock edge.
    #12;
    rst = 0;

    // Run enough cycles to execute instructions
    #60;

    if (uut.CORE.REGFILE.registers[5] !== 32'd10) $fatal(1, "x5 mismatch");
    if (uut.CORE.REGFILE.registers[6] !== 32'd20) $fatal(1, "x6 mismatch");
    if (uut.CORE.REGFILE.registers[7] !== 32'd30) $fatal(1, "x7 mismatch");
    if (uut.CORE.REGFILE.registers[8] !== 32'd10) $fatal(1, "x8 mismatch");

    $display("PASS: CPU sample program completed correctly");

    $finish;

end

endmodule
