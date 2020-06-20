`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Carlos Perez, Ramos Jiuru Chen
////////////////////////////////////////////////////////////////////////////////

module ShiftLeft2(signExtended, ShiftResult);

    input [31:0] signExtended;
	output reg [31:0] ShiftResult;
	
    always @(*) begin
        ShiftResult <= signExtended << 2;
    end

endmodule