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




module MEM_WB_reg (
// inputs
Hi, Lo,
Clock, RegWrite, MemtoReg, DataMemory, ALUResult, destinationReg,
WriteEnable, ReadEnable,
// outputs
RegWrite_out, MemtoReg_out, DataMemory_out, ALUResult_out, destinationReg_out,
Hi_out, Lo_out,
WriteEnable_out, ReadEnable_out
);
	//::INPUTS::
	input Clock;
	
	// Control signals
	input RegWrite, MemtoReg;
	
	input [31:0] DataMemory; 
	input [31:0] ALUResult;
	
	// destination register (output of 2:1 mux controlled by RegDst)
	input [4:0] destinationReg;
	
	//::OUTPUTS::
	output reg RegWrite_out, MemtoReg_out;
	output reg [31:0] DataMemory_out; 
	output reg [31:0] ALUResult_out;
	output reg [4:0] destinationReg_out;
	
	input [31:0] Hi;
	input [31:0] Lo;
	output reg [31:0] Hi_out;
	output reg [31:0] Lo_out;
	input WriteEnable;
	input ReadEnable;
	output reg WriteEnable_out;
	output reg ReadEnable_out;
	
	initial begin
		RegWrite_out <= 0;
		MemtoReg_out <= 0;
		DataMemory_out <= 0;
		ALUResult_out <= 0;
		destinationReg_out <= 0;
	    Hi_out <= 0;
	    Lo_out <= 0;
	    WriteEnable_out <= 0;
	    ReadEnable_out <= 0;
	end

	always @(posedge Clock) begin
		RegWrite_out <= RegWrite;
		MemtoReg_out <= MemtoReg;
		DataMemory_out <= DataMemory;
		ALUResult_out <= ALUResult;
		destinationReg_out <= destinationReg;
		Hi_out <= Hi;
	    Lo_out <= Lo;
	    WriteEnable_out <= WriteEnable;
	    ReadEnable_out <= ReadEnable;
	end
	
	
endmodule