`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Carlos Perez, Carlos Perez, Ramos Jiuru Chen
//
//		CONTROL SIGNALS
//		WB: RegWrite, MemtoReg
//      M: Branch, MemRead, MemWrite
//      EX: ALUSrc, ALUOp, RegDst
//      others: PCSrc (comes from branch gate), Zero (comes from ALU), PCAdder, ALUSrcTop(shift select)
////////////////////////////////////////////////////////////////////////////////



module EX_MEM_reg (
// inputs
Hi, Lo, EX_MEM_Write, 
Clock, BranchAddress, Branch, MemRead, MemWrite, Zero, RegWrite, MemtoReg, ALUResult, ReadData2, destinationReg, DataWidth,
WriteEnable, ReadEnable,
// outputs
BranchAddress_out, Branch_out, MemRead_out, MemWrite_out, Zero_out, RegWrite_out, MemtoReg_out, ALUResult_out, ReadData2_out, destinationReg_out, DataWidth_out,
Hi_out, Lo_out,
WriteEnable_out, ReadEnable_out
);
	//::INPUTS::
	input Clock;
	
	// branch target address (output of adder), 
	input [31:0] BranchAddress;
	
	// Control signals
	input Branch, MemRead, MemWrite, RegWrite, MemtoReg;
	input [1:0] DataWidth;
	// ALUSrcTop;
	
	// ALU output
	input [31:0] ALUResult;
	input  Zero;
	
	// from register file
	input [31:0] ReadData2;
	
	// destination register (output of 2:1 mux controlled by RegDst)
	input [4:0] destinationReg;
	
	// hazard detection
    input EX_MEM_Write;
	
	
	//::OUTPUTS::
	output reg [31:0] BranchAddress_out;
	
	output reg Branch_out, MemRead_out, MemWrite_out, Zero_out, RegWrite_out, MemtoReg_out;
	output reg [1:0] DataWidth_out;
	 //ALUSrcTop_out;
	
	output reg [31:0] ALUResult_out;
	
	output reg [31:0] ReadData2_out;
	
	output reg [4:0] destinationReg_out;
	
	input [31:0] Hi;
	input [31:0] Lo;
	output reg [31:0] Hi_out;
	output reg [31:0] Lo_out;
	input WriteEnable, ReadEnable;
	output reg WriteEnable_out, ReadEnable_out;
	
	
	initial begin
	    BranchAddress_out <= 0;
		Branch_out <= 0;
		MemRead_out <= 0;
		MemWrite_out <= 0; 
		Zero_out <= 0;
		RegWrite_out <= 0; 
		MemtoReg_out <= 0; 
		DataWidth_out <= 0;
		//ALUSrcTop_out <= 0;
		ALUResult_out <= 0;
		ReadData2_out <= 0;
		destinationReg_out <= 0;
		Hi_out <= 0;
		Lo_out <= 0;
		WriteEnable_out <= 0; 
		ReadEnable_out <= 0;
	end

	always @(posedge Clock) begin
	   if (EX_MEM_Write == 0) begin
	       BranchAddress_out <= 0;
           Branch_out <= 0;
           MemRead_out <= 0;
           MemWrite_out <= 0;
           Zero_out <= 0;
           RegWrite_out <= 0;
           MemtoReg_out <= 0;
           DataWidth_out <= 0;
           //ALUSrcTop_out <= ALUSrcTop;
           ALUResult_out <= 0;
           ReadData2_out <= 0;
           destinationReg_out <= 0;
           Hi_out <= 0;
           Lo_out <= 0;
           WriteEnable_out <= 0; 
		   ReadEnable_out <= 0;
	   end
	   else if (EX_MEM_Write == 1) begin
            BranchAddress_out <= BranchAddress;
            Branch_out <= Branch;
            MemRead_out <= MemRead;
            MemWrite_out <= MemWrite;
            Zero_out <= Zero;
            RegWrite_out <= RegWrite;
            MemtoReg_out <= MemtoReg;
            DataWidth_out <= DataWidth;
            //ALUSrcTop_out <= ALUSrcTop;
            ALUResult_out <= ALUResult;
            ReadData2_out <= ReadData2;
            destinationReg_out <= destinationReg;
            Hi_out <= Hi;
            Lo_out <= Lo;
            WriteEnable_out <= WriteEnable; 
		    ReadEnable_out <= ReadEnable;
       end
	end
	
	
endmodule