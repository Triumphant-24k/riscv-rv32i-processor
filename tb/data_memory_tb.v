`timescale 1ns/1ps

module data_memory_tb;

reg clk;
reg MemRead;
reg MemWrite;

reg [31:0] Address;
reg [31:0] WriteData;

wire [31:0] ReadData;

// Instantiate Data Memory
data_memory uut (
    .clk(clk),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Address(Address),
    .WriteData(WriteData),
    .ReadData(ReadData)
);

// Clock generation
always #5 clk = ~clk;

initial begin

    clk = 0;
    MemRead = 0;
    MemWrite = 0;
    Address = 32'd0;
    WriteData = 32'd0;

    // Test 1: Write 100 to address 0
    Address = 32'd0;
    WriteData = 32'd100;
    MemWrite = 1;
    MemRead = 0;
    #10;

    // Test 2: Read from address 0
    MemWrite = 0;
    MemRead = 1;
    Address = 32'd0;
    #10;

    // Test 3: Write 200 to address 4
    MemRead = 0;
    MemWrite = 1;
    Address = 32'd4;
    WriteData = 32'd200;
    #10;

    // Test 4: Read from address 4
    MemWrite = 0;
    MemRead = 1;
    Address = 32'd4;
    #10;

    // Test 5: Read disabled
    MemRead = 0;
    MemWrite = 0;
    Address = 32'd4;
    #10;

    $stop;

end

endmodule