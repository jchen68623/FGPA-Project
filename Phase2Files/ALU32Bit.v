`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Carlos Perez, Ramos Jiuru Chen
// Module - ALU32Bit.v
// Description - 32-Bit wide arithmetic logic unit (ALU).
//
// INPUTS:-
// ALUControl: N-Bit input control bits to select an ALU operation.
// A: 32-Bit input port A.
// B: 32-Bit input port B.
//
// OUTPUTS:-
// ALUResult: 32-Bit ALU result output.
// ZERO: 1-Bit output flag. 
// Hi_out, Lo_out: 32-bit outputs
//
// FUNCTIONALITY:-
// Design a 32-Bit ALU, so that it supports all arithmetic operations 
// needed by the MIPS instructions given in Labs5-8.docx document. 
//   The 'ALUResult' will output the corresponding result of the operation 
//   based on the 32-Bit inputs, 'A', and 'B'. 
//   The 'Zero' flag is high when 'ALUResult' is '0'. 
//   The 'ALUControl' signal should determine the function of the ALU 
//   You need to determine the bitwidth of the ALUControl signal based on the number of 
//   operations needed to support. 
////////////////////////////////////////////////////////////////////////////////

module ALU32Bit(ALUControl, A, B, ALUResult, Zero, Hi_in, Lo_in, Hi_out, Lo_out);

	input [5:0] ALUControl; // control bits for ALU operation
                                // you need to adjust the bitwidth as needed
	input [31:0] A;
	input [31:0] B;	    // inputs
	input [31:0] Hi_in;
	input [31:0] Lo_in;

	output reg [31:0] ALUResult;	// answer
	output reg Zero;	    // Zero=1 if ALUResult == 0
    output reg [31:0] Hi_out;
    output reg [31:0] Lo_out;
    
    reg [63:0] Result64bit;
    
    reg [31:0] upper;
    reg [31:0] lower;
    
    initial begin
        Zero <= 0;
        ALUResult <= 0;
        Result64bit <= 0;
        Hi_out <= 0;
        Lo_out <= 0;
    end

    /* Please fill in the implementation here... */
    always @(*) begin
        case (ALUControl)
            // Arithmetic
            6'b000000 : begin         // add
                ALUResult <= A + B;
            end
            6'b000001 : begin         // addiu
                ALUResult <= $unsigned(A) + $unsigned(B);
            end
            6'b000010 : begin         // addu
                ALUResult <= $unsigned(A) + $unsigned(B);
            end
            6'b000011 : begin         // addi
                ALUResult <= A + B;                
            end
            6'b000100 : begin         // sub
                ALUResult <= A - B;
            end
            6'b000101 : begin         // mul
                ALUResult <= A * B;
            end
            6'b000110 : begin         // mult
                Result64bit <= A * B;
                Hi_out <= Result64bit[63:32];
                Lo_out <= Result64bit[31:0];
            end
            6'b000111 : begin         // multu
                Result64bit <= $unsigned(A) * $unsigned(B);
                Hi_out <= Result64bit[63:32];
                Lo_out <= Result64bit[31:0];
            end
            6'b001000 : begin         // madd
                Result64bit <= ({Hi_in, Lo_in}) + (A * B);
                Hi_out <= Result64bit[63:32];
                Lo_out <= Result64bit[31:0];
            end
            6'b001001 : begin         // msub
                Result64bit <= ({Hi_in, Lo_in}) - (A * B);
                Hi_out <= Result64bit[63:32];
                Lo_out <= Result64bit[31:0];
            end
            // Logical
            6'b001010 : begin         // and
                ALUResult <= A & B;
            end
            6'b001011 : begin         // andi
                ALUResult <= A & B;
            end
            6'b001100 : begin         // or
                ALUResult <= A | B;
            end
            6'b001101 : begin         // nor
                ALUResult <= ~(A | B);
            end
            6'b001110 : begin         // xor
                ALUResult <= A ^ B;
            end
            6'b001111 : begin         // ori
                //ALUResult <= A | B;
                lower <= {16'h0000, B[15:0]};
                ALUResult <= A | lower;
            end
            6'b010000 : begin         // xori
                ALUResult <= A ^ B;
            end
            6'b010001 : begin         // seh
                if (B[15] == 0) begin
                    ALUResult[31:16] <= 16'h0000;
                    ALUResult[15:0] <= B[15:0]; 
                end
                else if (B[15] == 1) begin
                    ALUResult[31:16] <= 16'hFFFF;
                    ALUResult[15:0] <= B[15:0]; 
                end
            end
            6'b010010 : begin         // sll
                ALUResult <= B << A;
            end
            6'b010011 : begin         // srl
                ALUResult <= B >> A;
            end
            6'b010100 : begin         // sllv
                ALUResult <= B << A;
            end
            6'b010101 : begin         // srlv
                ALUResult <= B >> A;
            end
            6'b010110 : begin         // slt
                if (A < B) begin
                    ALUResult <= 1;
                end
                else begin
                    ALUResult <= 0;
                end
            end
            6'b010111 : begin         // slti
                if (A < B) begin
                    ALUResult <= 1;
                end
                else begin
                    ALUResult <= 0;
                end
            end
            6'b011000 : begin         // movn move A to reg on not zero
                if (B != 0) begin
                    ALUResult <= A;
                end
            end
            6'b011001 : begin         // movz
                if (B == 0) begin
                    ALUResult <= A;
                end
            end
            6'b011010 : begin         // rotrv rotate variable
                ALUResult <= (B << (32 - A)) | (B >> A);
            end
            6'b011011 : begin         // rotr (Shift right with wrap around)
                ALUResult <= (B << (32 - A)) | (B >> A);
                
               // upper <= B << (32 - A);
               // lower <= B >> A;
                //ALUResult <= upper | lower;
            end
            6'b011100 : begin         // sra '>>>' is arithmetic shift operator
                ALUResult <= A >>> B;
            end
            6'b011101 : begin         // srav
                ALUResult <= B >>> A;
            end
            6'b011110 : begin         // seb-sign extend byte
                if (B[7] == 0) begin
                    ALUResult[31:8] <= 24'h000000;
                    ALUResult[7:0] <= B[7:0];
                end
                else if (B[7] == 1) begin
                    ALUResult[31:8] <= 24'hFFFFFF;
                    ALUResult[7:0] <= B[7:0];
                end
            end
            6'b011111 : begin         // sltiu
                if ($unsigned(A) < $unsigned(B)) begin
                    ALUResult <= 1;
                end
                else begin
                    ALUResult <= 0;
                end
            end
            6'b100000 : begin         // sltu
                if ($unsigned(A) < $unsigned(B)) begin
                    ALUResult <= 1;
                end
                else begin
                    ALUResult <= 0;
                end
            end
            6'b100001 : begin         // mthi
               Hi_out <= A;
            end
            6'b100010 : begin         // mtlo
               Lo_out <= A;
            end
            6'b100011 : begin         // mfhi
                ALUResult <= Hi_in;
            end
            6'b100100 : begin         // mflo
                ALUResult <= Lo_in;
            end
            // * * * DATA * * * //
            6'b100101 : begin         // lw/sw/sb/lh/lb/sh
                ALUResult <= A + B;   // base + offset
            end
            6'b100110 : begin         // lui
                ALUResult[31:0] <= {B[15:0], 16'h0000};
            end
            6'b100111 : begin       // bgez
                if ($signed(A) >= 0) begin
                    ALUResult <= 0;
                end
                else begin
                    ALUResult <= 1;
                end
            end
            6'b101000 : begin       // beq
                if (A == B) begin
                    ALUResult <= 0;
                end
                else begin
                    ALUResult <= 1;
                end
            end
            6'b101001 : begin       // bne
                if ($signed(A) != $signed(B)) begin
                    ALUResult <= 0;
                end
                else begin
                    ALUResult <= 1;
                end
            end
            6'b101010 : begin       //bgtz
                if ($signed(A) > 0) begin
                    ALUResult <= 0;
                end
                else begin
                    ALUResult <= 1;
                end
            end
            6'b101011 : begin       //blez
                if ($signed(A) <= 0) begin
                    ALUResult <= 0;
                end
                else begin
                    ALUResult <= 1;
                end
            end
            6'b101100 : begin       //bltz
                if ($signed(A) < 0) begin
                    ALUResult <= 0;
                end
                else begin
                    ALUResult <= 1;
                end
            end
            6'b101101 : begin       //j, jr
                ALUResult <= 0;
            end
            6'b101110 : begin       // jal
                ALUResult <= 0;
            end
            default   : begin
                ALUResult <= 32'h00000000;
            end
        endcase
       if (ALUResult == 0) begin
            Zero <= 1;
       end     
       else if (ALUResult != 0) begin
            Zero <= 0;
       end
    end
    
endmodule

