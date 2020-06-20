`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory 1
// Module - pc_register.v
// Description - 32-Bit program counter (PC) register.
//
// INPUTS:-
// Address: 32-Bit address input port.
// Reset: 1-Bit input control signal.
// Clk: 1-Bit input clock signal.
//
// OUTPUTS:-
// PCResult: 32-Bit registered output port.
//
// FUNCTIONALITY:-
// Design a program counter register that holds the current address of the 
// instruction memory.  This module should be updated at the positive edge of 
// the clock. The contents of a register default to unknown values or 'X' upon 
// instantiation in your module. Hence, please add a synchronous 'Reset' 
// signal to your PC register to enable global reset of your datapath to point 
// to the first instruction in your instruction memory (i.e., the first address 
// location, 0x00000000H).
////////////////////////////////////////////////////////////////////////////////

module ProgramCounter(Address, PCResult, Reset, Clk, PCWrite);
	input [31:0] Address;
	input Reset, Clk;
	input PCWrite;
	output reg [31:0] PCResult;
	reg [31:0] PCResultSave;

    always @(posedge Clk) begin
        if (Reset == 1) begin
            PCResult <= 32'h00000000;
        end
        else if (PCWrite == 1) begin
            PCResult <= Address;
            PCResultSave <= PCResult;
        end
        else if (PCWrite == 0) begin
            PCResult <= PCResultSave + 4'b0100;
        end
    end
    
/*        always @(posedge Clk) begin
        if (Reset == 1) begin
            PCResult <= 32'h00000000;
            end
        else begin
            PCResult <= Address;
        end
    end
    
    always @(negedge Clk) begin
        if (PCWrite == 0) begin
            PCResult <= Address - 4'b1000;
        end
    end*/

        
endmodule

