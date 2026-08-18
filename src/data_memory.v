module data_memory(

input clk,
input MemRead,
input MemWrite,

input [31:0] Address,
input [31:0] WriteData,

output [31:0] ReadData

);

reg [31:0] memory [0:255];

// Write operation
always @(posedge clk)
begin
    if (MemWrite)
        memory[Address[9:2]] <= WriteData;
end

// Read operation
assign ReadData = (MemRead) ? memory[Address[9:2]] : 32'b0;

endmodule
