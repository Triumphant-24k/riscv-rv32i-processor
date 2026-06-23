module alu(

input [31:0] A,
input [31:0] B,

input [2:0] ALU_Sel,

output reg [31:0] ALU_Out,

output Zero

);

always @(*)

begin

case(ALU_Sel)

3'b000: ALU_Out = A + B;

3'b001: ALU_Out = A - B;

3'b010: ALU_Out = A & B;

3'b011: ALU_Out = A | B;

3'b100: ALU_Out = A ^ B;

default: ALU_Out = 32'b0;

endcase

end

assign Zero = (ALU_Out == 0);

endmodule