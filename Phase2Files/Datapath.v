`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members:    Carlos Perez, Ramos Jiuru Chen
// Effort:          50%           50%
// Control Signals:
//		
//		
//		CONTROL SIGNALS
//		WB: RegWrite, MemtoReg
//      M: Branch, MemRead, MemWrite
//      EX: ALUSrc, ALUOp, RegDst
//      others: PCSrc (comes from branch gate), Zero (comes from ALU), PCAdder, ALUSrcTop(shift select)
//      Hi/Lo operations: mthi, mtlo, WriteEnable, ReadEnable
////////////////////////////////////////////////////////////////////////////////


module Datapath(Reset, Clk, PCResult, WriteData, Hi_reg, Lo_reg, x, y, SAD);
    input Reset, Clk;
    (* mark_debug = "true" *) output [31:0] PCResult; 
    (* mark_debug = "true" *) output [31:0] WriteData;
    (* mark_debug = "true" *) output [31:0] Hi_reg;
    (* mark_debug = "true" *) output [31:0] Lo_reg;
    (* mark_debug = "true" *) output [31:0] SAD;
    (* mark_debug = "true" *) output [31:0] x;
    (* mark_debug = "true" *) output [31:0] y;
    
    wire [31:0] Instruction;
    
    //::CONTROL SIGNAL WIRES::
    // IF/ID
    // none
    
    // ID/EX 
    // control signals
    wire [31:0] PCAdd_EX;
    wire RegWrite_EX, MemtoReg_EX; // WB
    wire Branch_EX, MemRead_EX, MemWrite_EX; // M
    wire ALUSrc_EX;
    wire [1:0] RegDst_EX;    // EX
    wire [5:0] ALUOp_EX;
    wire mthi_IDEX, mtlo_IDEX, WriteEnable_IDEX, ReadEnable_IDEX;
    
    // EX/MEM
    wire RegWrite_MEM, MemtoReg_MEM; // WB
    wire Branch_MEM, MemRead_MEM, MemWrite_MEM; // M
    
    // MEM/WB
    wire RegWrite_WB, MemtoReg_WB; // WB
    
    wire [1:0] DataWidth_ID;
    wire [1:0] DataWidth_EX;
    wire [1:0] DataWidth_MEM;
    
    wire [31:0] jumpAddress_ID;
    wire [31:0] jumpAddress_EX;
    wire jumpSrc_ID;
    wire jumpSrc_ex;
    wire jregSrc_ID;
    wire jregSrc_ex;
    wire LinkStoreSel_ID;
    wire LinkStoreSel_ex;
    
    //::REGISTER FILE OUTPUTS (not control signals)::
    // IF/ID
    wire [31:0] PCAdd_IFID;
    wire [31:0] Instruction_IFID;
    wire [31:0] Hi_IFID;
    wire [31:0] Lo_IFID;
    
    // ID/EX
    wire [31:0] PCAdd_IDEX;
    wire [31:0] ReadData1_IDEX;
    wire [31:0] ReadData2_IDEX;
    wire [31:0] Instruction15_0_IDEX;
    wire [4:0] Instruction20_16_IDEX;
    wire [4:0] Instruction15_11_IDEX;
    wire [31:0] Hi_IDEX;
    wire [31:0] Lo_IDEX;
    
    // EX/MEM
    wire [31:0] BranchAddress_EXMEM;
    wire [31:0] ALUResult_EXMEM;
    wire [31:0] ReadData2_EXMEM;
    wire Zero_EXMEM;
    wire [4:0] DestinationReg_EXMEM;
    wire [31:0] Hi_EXMEM;
    wire [31:0] Lo_EXMEM;
    
    // MEM/WB
    wire [31:0] DataMemory_MEMWB;
    wire [31:0] ALUResult_MEMWB;
    wire [4:0] DestinationReg_MEMWB;
    wire [31:0] Hi_MEMWB;
    wire [31:0] Lo_MEMWB;
    
    //::MODULE OUTPUTS::
    // INSTRUCTION FETCH
    wire [31:0] PCAdd_IF;
    wire [31:0] Instruction_IF;
    wire [31:0] ProgramCounter_IF;
    // INSTRUCTION DECODE
    wire ALUSrc_ID, PCSrc_ID, Branch_ID, MemRead_ID, MemWrite_ID, Zero_ID, RegWrite_ID, 
            MemtoReg_ID, mthi_ID, mtlo_ID, WriteEnable_ID, ReadEnable_ID;
    wire [1:0] RegDst_ID;
    wire [31:0] ReadData1_ID;
    wire [31:0] ReadData2_ID;        
    wire [31:0] instruction15_0_ID;
    wire [5:0] ALUOp_ID;
    // EXECUTE
    wire Zero_EX;
    wire [31:0] BranchAddress_EX;
    wire [31:0] ALUResult_EX;
    wire [4:0] destinationReg_EX;
    wire [31:0] Hi_EX;
    wire [31:0] Lo_EX;
    // MEMORY ACCESS
    wire [31:0] DataMem_MA;
    // WRITE BACK
    wire [31:0] WriteData_WB;
    wire ReadEnable_MEMWB;
    wire WriteEnable_MEMWB;
    
    ////////////////////////////////////////////////////////////////////////////////
    
    wire PCSrc;
    //Hazard Detection
    wire PCWrite, IF_ID_Write, ControlWrite, EX_MEM_Write, IF_ID_Write_Flush;
    
    InstructionFetchUnit IFU(
        // Inputs
        .Reset(Reset), .Clk(Clk),
        .BranchAddress(BranchAddress_EXMEM), .PCSrc(PCSrc), .PCWrite(PCWrite),
        // Outputs
        .Instruction(Instruction_IF), .PCAddResult(PCAdd_IF),
        .ProgramCounter(ProgramCounter_IF)
        );   
    
    assign PCResult = ProgramCounter_IF;
    
    // IF/ID register 
    IF_ID_reg IFID(
    // input
    .Hi(Hi_MEMWB), .Lo(Lo_MEMWB),
    .Clock(Clk), .PCadder(PCAdd_IF), .Instruction(Instruction_IF), .IF_ID_Write(IF_ID_Write), .IF_ID_Write_Flush(IF_ID_Write_Flush),
    // output
    .PCadder_out(PCAdd_IFID), .Instruction_out(Instruction_IFID),
    .Hi_out(Hi_IFID), .Lo_out(Lo_IFID)
    );
     
    wire [4:0] Rs_IFID, Rt_IFID;
    
    InstructionDecode ID(
    // input
    .Clk(Clk), .Instruction(Instruction_IFID), .WriteData(WriteData_WB), .WriteRegister(DestinationReg_MEMWB), .RegWrite_WB(RegWrite_WB),
    // output
    .ALUSrc(ALUSrc_ID), .ALUOp(ALUOp_ID), .RegDst(RegDst_ID), .PCSrc(PCSrc_ID), .Branch(Branch_ID), .MemRead(MemRead_ID), .MemWrite(MemWrite_ID), .RegWrite(RegWrite_ID), 
    .MemtoReg(MemtoReg_ID), .rs_sa(ReadData1_ID), .ReadData2(ReadData2_ID), .instruction15_0(instruction15_0_ID), .jumpAddress(jumpAddress_ID),
    .mthi(mthi_ID), .mtlo(mtlo_ID), .WriteEnable(WriteEnable_ID), .ReadEnable(ReadEnable_ID), .DataWidth(DataWidth_ID), .jumpSrc(jumpSrc_ID), .jregSrc(jregSrc_ID), .LinkStoreSel(LinkStoreSel_ID),
    .instruction_25_21(Rs_IFID), .instruction_20_16(Rt_IFID), .x(x), .y(y), .SAD(SAD)
    );
    
    wire [4:0] Rs_IDEX, Rt_IDEX;
    
    // ID/EX register
    ID_EX_reg IDEXMEM(
    // inputs
    .Reset(Reset),
    .Hi(Hi_IFID), .Lo(Lo_IFID),
    .Clock(Clk), .PCadder(PCAdd_IFID), .ALUSrc(ALUSrc_ID), .RegDst(RegDst_ID), .RegWrite(RegWrite_ID), .MemRead(MemRead_ID), .MemWrite(MemWrite_ID), .MemtoReg(MemtoReg_ID), 
    .Branch(Branch_ID), .ALUop(ALUOp_ID), .ReadData1(ReadData1_ID), .ReadData2(ReadData2_ID), 
    .instruction15_0(instruction15_0_ID), .instruction20_16(Instruction_IFID[20:16]), .instruction15_11(Instruction_IFID[15:11]),
    .mthi(mthi_ID), .mtlo(mtlo_ID), .WriteEnable(WriteEnable_ID), .ReadEnable(ReadEnable_ID), .DataWidth(DataWidth_ID), .jumpAddress(jumpAddress_ID), .jumpSrc(jumpSrc_ID), .jregSrc(jregSrc_ID),
    .LinkStoreSel(LinkStoreSel_ID), .Rs(Rs_IFID), .Rt(Rt_IFID), .ControlWrite(ControlWrite),
    // outputs
    .PCadder_out(PCAdd_IDEX), .ALUSrc_out(ALUSrc_EX), .RegDst_out(RegDst_EX), .RegWrite_out(RegWrite_EX), .MemRead_out(MemRead_EX), .MemWrite_out(MemWrite_EX), 
    .MemtoReg_out(MemtoReg_EX), .Branch_out(Branch_EX), .ALUop_out(ALUOp_EX), 
    .ReadData1_out(ReadData1_IDEX), .ReadData2_out(ReadData2_IDEX), .instruction15_0_out(Instruction15_0_IDEX), .instruction20_16_out(Instruction20_16_IDEX), 
    .instruction15_11_out(Instruction15_11_IDEX), .mthi_out(mthi_IDEX), .mtlo_out(mtlo_IDEX), .WriteEnable_out(WriteEnable_IDEX), .ReadEnable_out(ReadEnable_IDEX),
    .Hi_out(Hi_IDEX), .Lo_out(Lo_IDEX), .DataWidth_out(DataWidth_EX), .jumpAddress_out(jumpAddress_EX), .jumpSrc_out(jumpSrc_ex), .jregSrc_out(jregSrc_ex), .LinkStoreSel_out(LinkStoreSel_ex),
    .Rs_out(Rs_IDEX), .Rt_out(Rt_IDEX)
    );
    
    //Hazard Detection Unit
    HazardDetection HDU(
    //inputs
    .ID_EX_MemRead(MemRead_EX), .IF_ID_Insturction(Instruction_IFID), .ID_EX_Rt(Instruction20_16_IDEX),
    .branchPCSrc(PCSrc), .MEMWB_RegWrite(RegWrite_WB), .MEMWB_Rd(DestinationReg_MEMWB),
    //outputs
    .PCWrite(PCWrite), .IF_ID_Write(IF_ID_Write), .ControlWrite(ControlWrite), .EX_MEM_Write(EX_MEM_Write), .IF_ID_Write_Flush(IF_ID_Write_Flush)
    );

    wire [1:0] A_Mux_sel;
    wire [1:0] B_Mux_sel;
    ForwardingUnit FU(
    // input reg file values 
    .Rd_EXMEM(DestinationReg_EXMEM), .Rd_MEMWB(DestinationReg_MEMWB), .Rs_IDEX(Rs_IDEX), .Rt_IDEX(Rt_IDEX),
    // input control signals
    .RegWrite_EXMEM(RegWrite_MEM), .RegWrite_MEMWB(RegWrite_WB),
    // output mux control
    .A_Mux_sel(A_Mux_sel), .B_Mux_sel(B_Mux_sel) // goes to EX stage
    );

    wire [31:0] B_EX;
    Execute ex(
    // inputs
    .Hi(Hi_IDEX), .Lo(Lo_IDEX),
    .Clk(Clk),
    .PCAdder(PCAdd_IDEX), .Instruction15_0(Instruction15_0_IDEX), .ReadData1(ReadData1_IDEX), .ReadData2(ReadData2_IDEX), .instruction20_16(Instruction20_16_IDEX), .instruction15_11(Instruction15_11_IDEX),
    .ALUSrc(ALUSrc_EX), .RegDst(RegDst_EX), .ALUOp(ALUOp_EX), .mthi(mthi_IDEX), .mtlo(mtlo_IDEX), 
    .WriteEnable(WriteEnable_MEMWB), .ReadEnable(ReadEnable_MEMWB), 
    .jumpAddress(jumpAddress_EX), .jumpSrc(jumpSrc_ex), .jregSrc(jregSrc_ex), .LinkStoreSel(LinkStoreSel_ex),
    .A_Mux_sel(A_Mux_sel), .B_Mux_sel(B_Mux_sel),
    .WriteData_WB(WriteData_WB), .ALUResult_MEM(ALUResult_EXMEM),
    // outputs
    .Zero(Zero_EX), .JumpBranchAddress(BranchAddress_EX), .ALUResult(ALUResult_EX), .destinationReg(destinationReg_EX),
    .Hi_out(Hi_EX), .Lo_out(Lo_EX), .B_to_Signextend(B_EX)
    );
    
    // 32 bit outputs of Hi/Lo registers
    assign Hi_reg = Hi_EX;
    assign Lo_reg = Lo_EX;
    wire ReadEnable_EXMEM, WriteEnable_EXMEM;
    // EX/MEM register
    EX_MEM_reg EXMEM(
    // inputs
    .Hi(Hi_EX), .Lo(Lo_EX), .EX_MEM_Write(EX_MEM_Write),
    .Clock(Clk), .BranchAddress(BranchAddress_EX), .Branch(Branch_EX), .MemRead(MemRead_EX), .MemWrite(MemWrite_EX), .Zero(Zero_EX), .RegWrite(RegWrite_EX), .MemtoReg(MemtoReg_EX), 
    .ALUResult(ALUResult_EX), .ReadData2(B_EX), .destinationReg(destinationReg_EX), .DataWidth(DataWidth_EX), .WriteEnable(WriteEnable_IDEX), .ReadEnable(ReadEnable_IDEX),
    // outputs
    .BranchAddress_out(BranchAddress_EXMEM), .Branch_out(Branch_MEM), .MemRead_out(MemRead_MEM), .MemWrite_out(MemWrite_MEM), .Zero_out(Zero_EXMEM), .RegWrite_out(RegWrite_MEM), .MemtoReg_out(MemtoReg_MEM), 
    .ALUResult_out(ALUResult_EXMEM), .ReadData2_out(ReadData2_EXMEM), .destinationReg_out(DestinationReg_EXMEM),
    .Hi_out(Hi_EXMEM), .Lo_out(Lo_EXMEM), .DataWidth_out(DataWidth_MEM), .ReadEnable_out(ReadEnable_EXMEM), .WriteEnable_out(WriteEnable_EXMEM)
    );
    
    // And gate for branching
    And brachAnd(.A(Branch_MEM), .B(Zero_EXMEM), .result(PCSrc));
    
    MemoryAccess macc(
    .Clk(Clk),
    // inputs
    .MemRead(MemRead_MEM), .MemWrite(MemWrite_MEM), .ALUResult(ALUResult_EXMEM), .ReadData2(ReadData2_EXMEM), .DataWidth(DataWidth_MEM),
    //outputs
    .DataMem_out(DataMem_MA)
    );
    
    
    // MEM/WB register
    MEM_WB_reg MEMWB(
    // inputs
    .Hi(Hi_EXMEM), .Lo(Lo_EXMEM),
    .Clock(Clk), .RegWrite(RegWrite_MEM), .MemtoReg(MemtoReg_MEM), .DataMemory(DataMem_MA), .ALUResult(ALUResult_EXMEM), .destinationReg(DestinationReg_EXMEM),
    .ReadEnable(ReadEnable_EXMEM), .WriteEnable(WriteEnable_EXMEM),
    // outputs
    .RegWrite_out(RegWrite_WB), .MemtoReg_out(MemtoReg_WB), .DataMemory_out(DataMemory_MEMWB), .ALUResult_out(ALUResult_MEMWB), .destinationReg_out(DestinationReg_MEMWB),
    .Hi_out(Hi_MEMWB), .Lo_out(Lo_MEMWB), .ReadEnable_out(ReadEnable_MEMWB), .WriteEnable_out(WriteEnable_MEMWB)
    );

    WriteBack wb(
    // input
    .MemtoReg(MemtoReg_WB), .DataMemory(DataMemory_MEMWB), .ALUResult(ALUResult_MEMWB),
    // output
    .WriteData(WriteData_WB)
    );
    
    // Write data to Register File    
    assign WriteData = WriteData_WB;
    ////////////////////////////////////////////////////////////////////////////////
    
endmodule

