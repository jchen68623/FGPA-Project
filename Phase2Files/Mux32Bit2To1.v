`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Carlos Perez, Ramos Jiuru Chen
// Module - Mux32Bit2To1.v
// Description - Performs signal multiplexing between 2 32-Bit words.
////////////////////////////////////////////////////////////////////////////////

module Mux32Bit2To1(out, inA, inB, sel);
    input [31:0] inA;
    input [31:0] inB;
    output reg [31:0] out;
    input sel;

    initial begin 
        out <= 0;
    end

    always @(*) begin
        if (sel == 0) begin
            out <= inA;
        end
        else if (sel == 1) begin
            out <= inB;
        end
    end
	
endmodule
