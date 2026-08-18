module instruction_memory(

input [31:0] PC,

output [31:0] Instruction

);

reg [31:0] memory [0:255];

integer i;

initial begin
    // Give every location a deterministic, harmless value in simulation.
    // For an ASIC implementation, replace this inferred ROM with the ROM/SRAM
    // macro supplied by the target technology.
    for (i = 0; i < 256; i = i + 1)
        memory[i] = 32'h00000013; // NOP: addi x0, x0, 0

    // Sample instructions stored manually
    memory[0] = 32'h00000013; // NOP: addi x0, x0, 0
    memory[1] = 32'h00A00293; // addi x5, x0, 10
    memory[2] = 32'h01400313; // addi x6, x0, 20
    memory[3] = 32'h006283B3; // add x7, x5, x6
    memory[4] = 32'h40638433; // sub x8, x7, x6
end

// 256 words require an 8-bit word index. Low two bits are the byte offset.
assign Instruction = memory[PC[9:2]];

endmodule
