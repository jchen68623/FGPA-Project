`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Student(s) Name and Last Name: Carlos Perez, Ramos Jiuru Chen
//
// mthi: hi <- rs
// mtlo: lo <- rs
// mfhi: rd <- hi
// mflo: rd <- lo
////////////////////////////////////////////////////////////////////////////////

module HiLo_reg(Clk, Hi, Lo, mthi, mtlo, WriteEnable, ReadEnable, Hi_out, Lo_out);
    input Clk;
    input [31:0] Hi;
    input [31:0] Lo;
    input mthi;
    input mtlo;
    input WriteEnable;
    input ReadEnable;
    
    output reg [31:0] Hi_out;
    output reg [31:0] Lo_out;
    
    reg [31:0] Hi_tmp;
    reg [31:0] Lo_tmp;
    
	initial begin
		Hi_out <= 32'h0000;
		Lo_out <= 32'h0000;
		Hi_tmp <= 32'h0000;
		Lo_tmp <= 32'h0000;
	end
	
	// todo: figure out mthi/mtlo
	// Write to register file on clock posedge
	always @(posedge Clk) begin
		if (WriteEnable == 1) begin
		    if (mthi == 0 && mtlo == 0) begin
               Hi_tmp <= Hi;
               Lo_tmp <= Lo;
            end
            if (mthi == 1) begin
                Hi_tmp <= Hi;
            end
            if (mtlo == 1) begin
                Lo_tmp <= Lo;
            end  
		end
	end
	
	always @(*) begin
	   if (ReadEnable == 1) begin
	       Hi_out <= Hi_tmp;
	       Lo_out <= Lo_tmp;
	   end
    end

endmodule
