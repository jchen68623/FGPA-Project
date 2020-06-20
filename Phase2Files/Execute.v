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
/*
ID/EX outputs:
PCadder_out, ALUSrc_out, RegDst_out, RegWrite_out, MemRead_out, MemWrite_out, 
MemtoReg_out, PCSrc_out, Zero_out, Branch_out, ALUSrcTop_out, ALUop_out, readData1_out,
 readData2_out, signExtend_out, instruction15_0_out, instruction20_16_out, 
 instruction15_11_out, Hi_out, Lo_out
*/

module Execute(
// inputs
Hi, Lo,
Clk,
PCAdder, Instruction15_0, ReadData1, ReadData2, instruction20_16, instruction15_11,
ALUSrc, RegDst, ALUOp, mthi, mtlo, WriteEnable, ReadEnable, jumpAddress, jumpSrc, jregSrc, LinkStoreSel,
A_Mux_sel, B_Mux_sel,
WriteData_WB, ALUResult_MEM,
// outputs
Zero, ALUResult, destinationReg, JumpBranchAddress,
Hi_out, Lo_out, B_to_Signextend
);  
    input Clk;
    input [31:0] PCAdder;
    input [31:0] Instruction15_0;
    input [31:0] ReadData1;
    input [31:0] ReadData2;
    input [4:0] instruction20_16;
    input [4:0]  instruction15_11;
    input [31:0] jumpAddress;
    
    // control signals
    input ALUSrc;
    input [1:0] RegDst;
    input [5:0] ALUOp;
    input mthi, mtlo, WriteEnable, ReadEnable;
    input jumpSrc;
    input LinkStoreSel;
    
    output Zero;
    wire [31:0] BranchAddress;
    output [31:0] JumpBranchAddress;
    output [31:0] ALUResult;
    //output [31:0] ReadData2_out; moved to ID/EX register - Made into B out
    output [4:0] destinationReg;
    
    wire [31:0] ShiftResult;
    output wire [31:0] B_to_Signextend;
    
    wire [31:0] Hi_result;
    wire [31:0] Lo_result;
    
    input [31:0] Hi;
    input [31:0] Lo;
    output [31:0] Hi_out;
    output [31:0] Lo_out;
    
    input jregSrc;
    wire [31:0] JSrcAddress;
    wire [31:0] A;
    wire [31:0] B;
    
    ShiftLeft2 shiftleft2(Instruction15_0, ShiftResult);
    Add add(.A(PCAdder), .B(ShiftResult), .AddResult(BranchAddress));
    
    // select jump address from Address[25:0] (j & jal) or from register(ReadData1)
    Mux32Bit2To1 jregmux(.out(JSrcAddress), .inA(jumpAddress), .inB(ReadData1), .sel(jregSrc));
    // Branch or jump select
    Mux32Bit2To1 muxBranchJump(.out(JumpBranchAddress), .inA(BranchAddress), .inB(JSrcAddress), .sel(jumpSrc));
        
    
    
    /* Forwarding muxes */
    // wire [31:0] A, B;
    input [1:0] A_Mux_sel, B_Mux_sel;
    input [31:0] WriteData_WB, ALUResult_MEM;
    Mux32Bit4To1 A_Mux(.out(A), .inA(ReadData1), .inB(WriteData_WB), .inC(ALUResult_MEM), .inD(0), .sel(A_Mux_sel));
    Mux32Bit4To1 B_Mux(.out(B_to_Signextend), .inA(ReadData2), .inB(WriteData_WB), .inC(ALUResult_MEM), .inD(0), .sel(B_Mux_sel));
    
    Mux32Bit2To1 SignExtendmux(.out(B), .inA(B_to_Signextend), .inB(Instruction15_0), .sel(ALUSrc));
    /* * * * * * * * * */
    
    wire [31:0] ALUResult_mux;
    ALU32Bit ALU(.ALUControl(ALUOp), .A(A), .B(B), .ALUResult(ALUResult_mux), .Zero(Zero), .Hi_in(Hi_out), .Lo_in(Lo_out), .Hi_out(Hi_result), .Lo_out(Lo_result));
    //ALU32Bit ALU(.ALUControl(ALUOp), .A(ReadData1), .B(mux32Result), .ALUResult(ALUResult_mux), .Zero(Zero), .Hi_in(Hi_out), .Lo_in(Lo_out), .Hi_out(Hi_result), .Lo_out(Lo_result));
    
    wire [31:0] PCResultplus4;
    Add addtoPCResult(.A(PCAdder), .B(32'h00000000), .AddResult(PCResultplus4));
    Mux32Bit2To1 ALUresultmux(.out(ALUResult), .inA(ALUResult_mux), .inB(PCResultplus4), .sel(LinkStoreSel));
    
    HiLo_reg hi_lo_reg(.Clk(Clk), .Hi(Hi_result), .Lo(Lo_result), .mthi(mthi), .mtlo(mtlo), .WriteEnable(WriteEnable), .ReadEnable(ReadEnable), .Hi_out(Hi_out), .Lo_out(Lo_out));
    
    //Mux5Bit2To1 mux5bit(.inA(instruction20_16), .inB(instruction15_11), .sel(RegDst), .out(destinationReg));
    Mux5Bit4To1 muxSrcReg(.out(destinationReg), .inA(instruction20_16), .inB(instruction15_11), .inC(5'b11111), .inD(5'b00000), .sel(RegDst));
    
endmodule

