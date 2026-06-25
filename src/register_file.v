module register_file(

input clk,
input rst,

input RegWrite,

input [4:0] rs1,
input [4:0] rs2,
input [4:0] rd,

input [31:0] WriteData,

output [31:0] ReadData1,
output [31:0] ReadData2

);

reg [31:0] registers [31:0];

integer i;

// Write logic
always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'b0;
    end
    else
    begin
        if (RegWrite && rd != 5'b00000)
            registers[rd] <= WriteData;
    end
end

// Read logic
assign ReadData1 = registers[rs1];
assign ReadData2 = registers[rs2];

endmodule   