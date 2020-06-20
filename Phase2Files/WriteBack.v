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


module WriteBack(
// input
MemtoReg, DataMemory, ALUResult,
// output
WriteData
);
    // Control signal
    input MemtoReg;
    
    input [31:0] DataMemory;
    input [31:0] ALUResult; 
    
    output [31:0] WriteData;

    Mux32Bit2To1 mux32bit2(.out(WriteData), .inA(DataMemory), .inB(ALUResult), .sel(MemtoReg));

endmodule

