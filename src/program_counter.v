module program_counter(

input clk,
input rst,

input [31:0] PC_next,

output reg [31:0] PC

);

always @(posedge clk or posedge rst)
begin
    if (rst)
        PC <= 32'b0;
    else
        PC <= PC_next;
end

endmodule