`timescale 1ns/1ps

module register_file_tb;

reg clk;
reg rst;
reg RegWrite;

reg [4:0] rs1;
reg [4:0] rs2;
reg [4:0] rd;

reg [31:0] WriteData;

wire [31:0] ReadData1;
wire [31:0] ReadData2;

// Instantiate register file
register_file uut (
    .clk(clk),
    .rst(rst),
    .RegWrite(RegWrite),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .WriteData(WriteData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    RegWrite = 0;
    rs1 = 0;
    rs2 = 0;
    rd = 0;
    WriteData = 0;

    #10;
    rst = 0;

    // Write 10 to x5
    rd = 5'd5;
    WriteData = 32'd10;
    RegWrite = 1;
    #10;

    // Write 20 to x6
    rd = 5'd6;
    WriteData = 32'd20;
    RegWrite = 1;
    #10;

    // Read x5 and x6
    RegWrite = 0;
    rs1 = 5'd5;
    rs2 = 5'd6;
    #10;

    // Try writing 100 to x0
    rd = 5'd0;
    WriteData = 32'd100;
    RegWrite = 1;
    #10;

    // Read x0 and x5
    RegWrite = 0;
    rs1 = 5'd0;
    rs2 = 5'd5;
    #10;

    $stop;
end

endmodule