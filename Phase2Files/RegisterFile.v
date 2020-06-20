`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
//
//
// Student(s) Name and Last Name: Carlos Perez, Ramos Jiuru Chen
//
//
// Module - register_file.v
// Description - Implements a register file with 32 32-Bit wide registers.
//
// 
// INPUTS:-
// ReadRegister1: 5-Bit address to select a register to be read through 32-Bit 
//                output port 'ReadRegister1'.
// ReadRegister2: 5-Bit address to select a register to be read through 32-Bit 
//                output port 'ReadRegister2'.
// WriteRegister: 5-Bit address to select a register to be written through 32-Bit
//                input port 'WriteRegister'.
// WriteData: 32-Bit write input port.
// RegWrite: 1-Bit control input signal.
//
// OUTPUTS:-
// ReadData1: 32-Bit registered output. 
// ReadData2: 32-Bit registered output. 
//
// FUNCTIONALITY:-
// 'ReadRegister1' and 'ReadRegister2' are two 5-bit addresses to read two 
// registers simultaneously. The two 32-bit data sets are available on ports 
// 'ReadData1' and 'ReadData2', respectively. 'ReadData1' and 'ReadData2' are 
// registered outputs (output of register file is written into these registers 
// at the falling edge of the clock). You can view it as if outputs of registers
// specified by ReadRegister1 and ReadRegister2 are written into output 
// registers ReadData1 and ReadData2 at the falling edge of the clock. 
//
// 'RegWrite' signal is high during the rising edge of the clock if the input 
// data is to be written into the register file. The contents of the register 
// specified by address 'WriteRegister' in the register file are modified at the 
// rising edge of the clock if 'RegWrite' signal is high. The D-flip flops in 
// the register file are positive-edge (rising-edge) triggered. (You have to use 
// this information to generate the write-clock properly.) 
//
// NOTE:-
// We will design the register file such that the contents of registers do not 
// change for a pre-specified time before the falling edge of the clock arrives 
// to allow for data multiplexing and setup time.
////////////////////////////////////////////////////////////////////////////////

module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, Clk, ReadData1, ReadData2, x, y, SAD);
    (* mark_debug = "true" *) output reg [31:0] x;
    (* mark_debug = "true" *) output reg [31:0] y;
    (* mark_debug = "true" *) output reg [31:0] SAD;
    
    input Clk;
    input [4:0] ReadRegister1;
    input [4:0] ReadRegister2;
    input [4:0] WriteRegister;
    input [31:0] WriteData;
    input RegWrite;
    
    output reg [31:0] ReadData1;
    output reg [31:0] ReadData2;
    
    reg [31:0] registerFile [0:31];
	
	integer i;
	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			registerFile[i] = 32'h00000000;
		end
		registerFile[29] = 5000; // initialize stack pointer
	end
	
	// Write to register file on clock posedge
	always @(posedge Clk) begin
	   if (RegWrite == 1) begin
	       registerFile[WriteRegister] <= WriteData;
	   end
	   if (WriteRegister != 5'b00000) begin
	       registerFile[0] <= 32'h00000000; // reset $zero on next posedge after being written
	   end
	end
	// Write the output of the register file into into ReadData's at falling clock edge
	always @(negedge Clk) begin
	   if (ReadRegister1 == 0 && ReadRegister2 != 0) begin
	       ReadData1 <= 0;
	       ReadData2 <= registerFile[ReadRegister2];
	   end
	   else if (ReadRegister1 != 0 && ReadRegister2 == 0) begin
	      ReadData1 <= registerFile[ReadRegister1];
	      ReadData2 <= 0; 
	   end
	   else if (ReadRegister1 == 0 && ReadRegister2 == 0) begin
	      ReadData1 <= 0;
	      ReadData2 <= 0; 
	   end
	   else begin
		  ReadData1 <= registerFile[ReadRegister1];
		  ReadData2 <= registerFile[ReadRegister2];
	   end
       x <= registerFile[2];
	   y <= registerFile[3];
	   SAD <= registerFile[20];
	end

endmodule
