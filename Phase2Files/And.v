`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Carlos Perez, Ramos Jiuru Chen
// 
//////////////////////////////////////////////////////////////////////////////////

module And(A, B, result);
	input A, B;
	output reg result;

	initial begin
		result <= 0;
	end
	
	always @(*) begin
		if (A == 1 && B == 1) begin
			result <= 1;
		end
		else begin
			result <= 0;
		end
	end
	
endmodule