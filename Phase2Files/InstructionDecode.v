`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Carlos Perez, Ramos Jiuru Chen
////////////////////////////////////////////////////////////////////////////////

module InstructionDecode(
// input
Clk, Instruction, WriteData, WriteRegister, RegWrite_WB,
// output
ALUSrc, ALUOp, RegDst, PCSrc, Branch, MemRead, MemWrite, RegWrite, 
MemtoReg, ReadData2, instruction15_0, jumpAddress, jumpSrc, jregSrc, LinkStoreSel, rs_sa, //ALUSrcTop(removed as output) 
mthi, mtlo, WriteEnable, ReadEnable, DataWidth, instruction_25_21, instruction_20_16, x, y, SAD
);
    output [31:0] x;
    output [31:0] y;
    output [31:0] SAD;
    input Clk;
    
    input [31:0] Instruction;
    
    // these come from the writeback stage 
    input [31:0] WriteData;
    input [4:0] WriteRegister;
    input RegWrite_WB;
    
    reg [5:0] instruction_31_26;
    reg [5:0] instruction_5_0;
    output reg [4:0] instruction_25_21; //  Rs (ReadRegister1)
    output reg [4:0] instruction_20_16; //  Rt (ReadRegister2)
    reg [4:0] instruction_10_6;
    reg [25:0] instruction25_0;
    reg instruction21;
    reg instruction6;
    
    
    // control signals
    output ALUSrc, PCSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg;
    output [1:0] RegDst;
    output [5:0] ALUOp;
    wire ALUSrcTop; // (Shift select)
    output mthi, mtlo, WriteEnable, ReadEnable; // Hi/Lo control signals
    output [1:0] DataWidth;
    output reg [31:0] jumpAddress;
    output jumpSrc;
    output jregSrc;
    output LinkStoreSel;
    output [31:0] rs_sa;
    
    // output [31:0] PCAdder_out; deal with this in top module
    wire [31:0] ReadData1;
    output [31:0] ReadData2;
    output [31:0] instruction15_0;
    
    always @ (*) begin
        instruction_31_26 <= Instruction[31:26];
        instruction_5_0 <= Instruction[5:0];
        instruction_25_21 <= Instruction[25:21];
        instruction_20_16 <= Instruction[20:16];
        instruction_10_6 <= Instruction[10:6];
        instruction25_0 <= {6'b000000, Instruction[25:0]};
        instruction21 <= Instruction[21];
        instruction6 <= Instruction[6];
        jumpAddress <= instruction25_0 << 2;
    end
    
    
    Controller controller(.Opcode(instruction_31_26), .func(instruction_5_0), .instruction_20_16(instruction_20_16), .instruction10_6(instruction_10_6), 
        .instruction21(instruction21), .instruction6(instruction6),.ALUSrc(ALUSrc), 
        .RegDst(RegDst), .RegWrite(RegWrite), .ALUOp(ALUOp), .MemRead(MemRead), .DataWidth(DataWidth), 
        .MemWrite(MemWrite), .MemtoReg(MemtoReg), .PCSrc(PCSrc), .Branch(Branch), .ALUSrcTop(ALUSrcTop),
        .mthi(mthi), .mtlo(mtlo), .WriteEnable(WriteEnable), .ReadEnable(ReadEnable), .jumpSrc(jumpSrc), .jregSrc(jregSrc), .LinkStoreSel(LinkStoreSel)
        );
    
    RegisterFile registerfile(.ReadRegister1(instruction_25_21), .ReadRegister2(instruction_20_16), 
        .WriteRegister(WriteRegister), .WriteData(WriteData), .RegWrite(RegWrite_WB), 
        .Clk(Clk), .ReadData1(ReadData1), .ReadData2(ReadData2), .x(x), .y(y), .SAD(SAD));
    
    // Used to select from ReadData2 or sa (for shift type instructions)
    Mux32Bit2To1 rd_sa_sel(.out(rs_sa), .inA(ReadData1), .inB({27'h0000, instruction_10_6}), .sel(ALUSrcTop));
    
    
    SignExtension signExtend(.in(Instruction[15:0]), .out(instruction15_0));
    

endmodule