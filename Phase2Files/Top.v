`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Team Members: Carlos Perez, Ramos Jiuru Chen
// Overall percent effort of each team member: 
// Carlos 50%, Ramos 50%
// ECE369A - Computer Architecture
// Project Phase 2
// Module - Top.v
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(Reset_Clk, Reset_Datapath, Clk, out7, en_out);
    input Reset_Clk ,Reset_Datapath, Clk;
    wire [31:0] Instruction;
    wire Clkout;
    output [6:0] out7;
    output [7:0] en_out;
    wire [31:0] x;
    wire [31:0] y;
    wire [31:0] SAD;
    wire [31:0] PCResult;
    Datapath TopDataPath(.Reset(Reset_Datapath), .Clk(Clkout), .PCResult(PCResult), .x(x), .y(y), .SAD(SAD));
    // Two4DigitDisplay(Clk, NumberA, NumberB, out7, en_out); // A= least significant, B= most significant
    Two4DigitDisplay TopDisplay(.Clk(Clkout), .NumberA(x), .NumberB(y), .out7(out7), .en_out(en_out)); 
    // ClkDiv(Clk, Rst, ClkOut);
    ClkDiv TopClk(.Clk(Clk), .Rst(Reset_Clk), .ClkOut(Clkout));
    
endmodule
