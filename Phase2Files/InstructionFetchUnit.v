`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Carlos Perez, Ramos Jiuru Chen
// ECE369A - Computer Architecture
// Laboratory 3 (PostLab)
// Module - InstructionFetchUnit.v
// Description - Fetches the instruction from the instruction memory based on 
//               the program counter (PC) value.
// INPUTS:-
// Reset: 1-Bit input signal. 
// Clk: Input clock signal.
//
// OUTPUTS:-
// Instruction: 32-Bit output instruction from the instruction memory. 
//              Decimal value diplayed on the LCD usng the wrapper given in Lab 2
//
// FUNCTIONALITY:-
// Please connect up the following implemented modules to create this
// 'InstructionFetchUnit':-
//   (a) ProgramCounter.v
//   (b) PCAdder.v
//   (c) InstructionMemory.v
// Connect the modules together in a testbench so that the instruction memory
// outputs the contents of the next instruction indicated by the memory location
// in the PC at every clock cycle. Please initialize the instruction memory with
// some preliminary values for debugging purposes.
//
// @@ The 'Reset' input control signal is connected to the program counter (PC) 
// register which initializes the unit to output the first instruction in 
// instruction memory.
// @@ The 'Instruction' output port holds the output value from the instruction
// memory module.
// @@ The 'Clk' input signal is connected to the program counter (PC) register 
// which generates a continuous clock pulse into the module.
////////////////////////////////////////////////////////////////////////////////

module InstructionFetchUnit(Reset, Clk, BranchAddress, PCSrc, Instruction, PCWrite, PCAddResult, ProgramCounter);
    input Reset, Clk;
    
    // datapath inputs
    input PCSrc; // to mux (branch select)
    input [31:0] BranchAddress; // from EX/MEM
    input PCWrite; //hazard
    
    output [31:0] PCAddResult;
    output [31:0] Instruction;
    
    (* mark_debug = "true" *) output [31:0] ProgramCounter;
    
    wire [31:0] muxResult;
    wire [31:0] PCResult;
    
    //Mux32Bit2To1 Mux32bit_IFU(.out(muxResult), .inA(PCAddResult), .inB(BranchAddress), .sel(PCSrc));
    //ProgramCounter counter(PCAddResult, PCResult, Reset, Clk);
    //PCAdder adder(PCResult, PCAddResult);
    //InstructionMemory memory(PCResult, Instruction);
    
    Mux32Bit2To1 Mux32bit_IFU(.out(muxResult), .inA(PCAddResult), .inB(BranchAddress), .sel(PCSrc));
    ProgramCounter counter(.Address(muxResult), .PCResult(PCResult), .Reset(Reset), .Clk(Clk), .PCWrite(PCWrite));
    PCAdder adder(PCResult, PCAddResult);
    InstructionMemory memory(PCResult, Instruction);
    
    assign ProgramCounter = PCResult;
    
endmodule