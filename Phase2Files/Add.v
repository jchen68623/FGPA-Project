`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Carlos Perez, Ramos Jiuru Chen
////////////////////////////////////////////////////////////////////////////////

module Add(A, B, AddResult);

    input [31:0] A, B;

    output reg [31:0] AddResult;
    
    initial begin
        AddResult <= 0;
    end

    always @(*) begin
        AddResult <= A + B;
    end

endmodule