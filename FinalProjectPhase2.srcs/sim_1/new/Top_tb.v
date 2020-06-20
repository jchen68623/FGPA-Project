`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2019 02:37:52 PM
// Design Name: 
// Module Name: Top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_tb();
    reg Reset_Clk, Reset_Datapath, Clk;
    wire [6:0] out7;
    wire [7:0] en_out;
    
    //Top u0(.Reset(Reset), .Clk(Clk), .out7(out7), .en_out(en_out));
    Top u0(.Reset_Clk(Reset_Clk), .Reset_Datapath(Reset_Datapath), .Clk(Clk), .out7(out7), .en_out(en_out));
    
    
    initial begin
        Clk <= 1'b0;
        forever #10 Clk <= ~Clk;
    end
    
    initial begin
    Reset_Datapath <= 1;
    #50
    Reset_Clk <= 1;
    #200
    Reset_Clk <= 0;
    #200
    Reset_Datapath <= 0;
    #5000
    Reset_Clk <= 0;
    
    end
endmodule
