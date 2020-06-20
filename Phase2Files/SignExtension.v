`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// ECE369 - Computer Architecture
// 
// Module - SignExtension.v
// Description - Sign extension module.
////////////////////////////////////////////////////////////////////////////////
module SignExtension(in, out);

    /* A 16-Bit input word */
    input [15:0] in;
    
    /* A 32-Bit output word */
    output reg [31:0] out;
    
    reg [31:0] temp;
    
    always @ (*) begin
		if (in[15] == 1'b0) begin
		  out <= {16'h0000, in};
		end
		else begin
		  out <= {16'hFFFF, in};
		end
	end

endmodule
