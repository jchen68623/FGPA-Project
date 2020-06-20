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


module IF_ID_reg (IF_ID_Write_Flush, IF_ID_Write, Hi, Lo, Clock, PCadder, Instruction, PCadder_out, Instruction_out, Hi_out, Lo_out);
	input Clock;
	input [31:0] PCadder, Instruction;
	output reg [31:0] PCadder_out, Instruction_out;
	
	input [31:0] Hi;
	input [31:0] Lo;
	output reg [31:0] Hi_out, Lo_out;
	
	input IF_ID_Write, IF_ID_Write_Flush;
	reg [31:0] PCResultSave;
	reg [31:0] InstructionResultSave;
	reg [31:0] HiResultSave;
	reg [31:0] LoResultSave;
	
	initial begin
		PCadder_out <= 32'h00000000;
		Instruction_out <= 32'h00000000;
		Hi_out <= 32'h00000000;
		Lo_out <= 32'h00000000;
	end
	
	always @(posedge Clock) begin
	   if (IF_ID_Write_Flush == 0) begin //flush = 0 means flushing
           PCadder_out <= 32'h00000000;
           Instruction_out <= 32'h00000000;
           Hi_out <= 32'h00000000;
           Lo_out <= 32'h00000000;
	   end
	   else if (IF_ID_Write_Flush == 1) begin
           if (IF_ID_Write == 0) begin
               PCadder_out <= PCResultSave;
               Instruction_out <= InstructionResultSave;
               Hi_out <= HiResultSave;
               Lo_out <= LoResultSave;       
           end
           else if (IF_ID_Write == 1) begin
               PCadder_out <= PCadder;
               Instruction_out <= Instruction;
               Hi_out <= Hi;
               Lo_out <= Lo;
               PCResultSave <= PCadder;
               InstructionResultSave <= Instruction;
               HiResultSave <= Hi;
               LoResultSave <= Lo;
           end
	   end
	end

endmodule


//module IF_ID_reg (IF_ID_Write, Hi, Lo, Clock, PCadder, Instruction, PCadder_out, Instruction_out, Hi_out, Lo_out);
//	input Clock;
//	input [31:0] PCadder, Instruction;
//	output reg [31:0] PCadder_out, Instruction_out;
	
//	input [31:0] Hi;
//	input [31:0] Lo;
//	output reg [31:0] Hi_out, Lo_out;
	
//	input IF_ID_Write;
	
//	initial begin
//		PCadder_out <= 32'h00000000;
//		Instruction_out <= 32'h00000000;
//		Hi_out <= 32'h00000000;
//		Lo_out <= 32'h00000000;
//	end
	
//	always @(posedge Clock) begin
//	   if (IF_ID_Write == 0) begin
//	       PCadder_out <= 32'h00000000;
//           Instruction_out <= 32'h00000000;
//           Hi_out <= 32'h00000000;
//           Lo_out <= 32'h00000000;	   
//	   end
//	   else if (IF_ID_Write == 1) begin
//	       PCadder_out <= PCadder;
//		   Instruction_out <= Instruction;
//		   Hi_out <= Hi;
//		   Lo_out <= Lo;
//		end
//	end

//endmodule