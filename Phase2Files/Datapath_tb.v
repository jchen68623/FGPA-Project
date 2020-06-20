`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members:    Carlos Perez, Ramos Jiuru Chen
// Percent Effort:  50%			  50%
// ECE369A - Computer Architecture
//// Module - Datapath_tb.v
// Description - Test 'Datapath.v' 
////////////////////////////////////////////////////////////////////////////////

module Datapath_tb();
	reg Reset, Clk;
    wire [31:0] PCResult;
    wire [31:0] WriteData;
    wire [31:0] Hi;
    wire [31:0] Lo;
    wire [31:0] x;
    wire [31:0] y;
    wire [31:0] SAD;
    
	Datapath u0 (
        .Reset(Reset), 
        .Clk(Clk), 
        .PCResult(PCResult), 
        .WriteData(WriteData), 
        .Hi_reg(Hi), 
        .Lo_reg(Lo),
        .x(x), .y(y), .SAD(SAD)
	);

	initial begin
		Clk <= 1'b0;
		forever #10 Clk <= ~Clk;
	end
    
    initial begin
    #10
    Reset <= 1;
    #40
    Reset <= 0;
    #5000
    Reset <= 0;
    
    end

endmodule
