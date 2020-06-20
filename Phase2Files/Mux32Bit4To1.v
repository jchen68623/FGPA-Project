`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// Carlos Perez, Ramos Jiuru Chen
// Module - Mux32Bit4To1.v
// Description - Performs signal multiplexing between 4 32-Bit words.
////////////////////////////////////////////////////////////////////////////////

module Mux32Bit4To1(out, inA, inB, inC, inD, sel);
    
    input [31:0] inA;
    input [31:0] inB;
    input [31:0] inC;
    input [31:0] inD;
    
    output reg [31:0] out;
    input [1:0] sel;

    initial begin 
        out <= 0;
    end

    always @(*) begin
        case (sel)
            2'b00 : begin
                out <= inA;
            end
            2'b01 : begin
                out <= inB;
            end
            2'b10 : begin
                out <= inC;
            end
            2'b11 : begin
                out <= inD;
            end
        endcase
    end
	
endmodule
