// Simulation/demo wrapper. Use cpu_core, not this module, as the OpenROAD top.
module cpu_top (
    input clk,
    input rst
);

wire [31:0] PC;
wire [31:0] Instruction;
wire MemRead;
wire MemWrite;
wire [31:0] ALU_Out;
wire [31:0] WriteData;
wire [31:0] MemReadData;

cpu_core CORE (
    .clk(clk),
    .rst(rst),
    .instr_addr(PC),
    .instr_rdata(Instruction),
    .data_read(MemRead),
    .data_write(MemWrite),
    .data_addr(ALU_Out),
    .data_wdata(WriteData),
    .data_rdata(MemReadData)
);

instruction_memory IMEM (
    .PC(PC),
    .Instruction(Instruction)
);

data_memory DMEM (
    .clk(clk),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Address(ALU_Out),
    .WriteData(WriteData),
    .ReadData(MemReadData)
);

endmodule
