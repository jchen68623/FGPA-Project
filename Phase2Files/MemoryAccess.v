`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Carlos Perez, Ramos Jiuru Chen
//
// Control Signals:
//		EX: ALUSrc, ALUOp, RegDst
//		M: Branch, MemRead, MemWrite, Zero
//		PCSrc
//		WB: RegWrite, MemtoReg
//		 ALUSrcTop(shift select)
//
////////////////////////////////////////////////////////////////////////////////


module MemoryAccess(
Clk,
// inputs
MemRead, MemWrite, ALUResult, ReadData2, DataWidth,
//outputs
DataMem_out
);
    input Clk;
    // control signals
    input MemRead, MemWrite;
    input [31:0] ALUResult;
    input [31:0] ReadData2;
    input [1:0] DataWidth;
    
    output [31:0] DataMem_out;
    
    DataMemory datamemory(.Address(ALUResult), .WriteData(ReadData2), .Clk(Clk), 
        .MemWrite(MemWrite), .MemRead(MemRead), .ReadData(DataMem_out),
        .DataWidth(DataWidth)); 

endmodule

