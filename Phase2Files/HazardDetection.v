`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2019 02:08:36 PM
// Design Name: 
// Module Name: HazardDetection
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


module HazardDetection(
//inputs
ID_EX_MemRead, IF_ID_Insturction, ID_EX_Rt, branchPCSrc,
MEMWB_RegWrite, MEMWB_Rd,
//outputs
PCWrite, IF_ID_Write, ControlWrite, EX_MEM_Write, IF_ID_Write_Flush
    );
    
    input ID_EX_MemRead;
    input [31:0] IF_ID_Insturction;
    input [4:0] ID_EX_Rt;
    input branchPCSrc;
    input MEMWB_RegWrite; 
    input [4:0] MEMWB_Rd;
    
    
    reg [4:0] IF_ID_Rs;
    reg [4:0] IF_ID_Rt;
    
    output reg PCWrite;
    output reg IF_ID_Write;
    output reg ControlWrite;
    output reg EX_MEM_Write;
    output reg IF_ID_Write_Flush;
    
    initial begin
        PCWrite <= 1;
        IF_ID_Write <= 1;
        ControlWrite <= 1; 
        EX_MEM_Write <= 1;
        IF_ID_Write_Flush <= 1;
    end
    
    always @(*) begin
        IF_ID_Rs <= IF_ID_Insturction[25:21];
        IF_ID_Rt <= IF_ID_Insturction[20:16];
        if(ID_EX_MemRead == 1) begin
            if(ID_EX_Rt == IF_ID_Rs || ID_EX_Rt == IF_ID_Rt) begin
                //stall the pipeline
                //make all signals zero for one cycle
                ControlWrite <= 0;
                IF_ID_Write <= 0;
                PCWrite <= 0;
                
                EX_MEM_Write <= 1;
                IF_ID_Write_Flush <= 1;
                // 0 means not writing, which is stalling and flushing 
            end
            else begin
                PCWrite <= 1;
                IF_ID_Write <= 1;
                ControlWrite <= 1; 
                EX_MEM_Write <= 1;   
                IF_ID_Write_Flush <= 1;        
            end
        end
        else if (branchPCSrc == 1) begin
            PCWrite <= 1;
            IF_ID_Write <= 1;
            //branch is on
            //flush three pipelines
            ControlWrite <= 0; 
            EX_MEM_Write <= 0;
            IF_ID_Write_Flush <= 0;
        end
        else if((MEMWB_RegWrite == 1) && (MEMWB_Rd != 0)) begin
            if((IF_ID_Rs == MEMWB_Rd) || (IF_ID_Rt == MEMWB_Rd)) begin
                ControlWrite <= 0;
                IF_ID_Write <= 0;
                PCWrite <= 0;
                
                EX_MEM_Write <= 1;
                IF_ID_Write_Flush <= 1;
            end
            else begin
                PCWrite <= 1;
                IF_ID_Write <= 1;
                ControlWrite <= 1; 
                EX_MEM_Write <= 1;
                IF_ID_Write_Flush <= 1;                
            end
        end
        else begin
            PCWrite <= 1;
            IF_ID_Write <= 1;
            ControlWrite <= 1; 
            EX_MEM_Write <= 1;
            IF_ID_Write_Flush <= 1;
        end
    end
    
endmodule


//        else if((MEMWB_RegWrite == 1) && (MEMWB_Rd != 0)) begin
//            if((IF_ID_Rs == MEMWB_Rd) || (IF_ID_Rt == MEMWB_Rd)) begin
//                ControlWrite <= 0;
//                PCWrite <= 0;
//            end
//            else begin
//                PCWrite <= 1;
//                IF_ID_Write <= 1;
//                ControlWrite <= 1; 
//                EX_MEM_Write <= 1;                
//            end
//        end