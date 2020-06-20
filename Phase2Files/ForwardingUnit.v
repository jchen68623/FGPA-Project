`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Team Members: Carlos Perez, Ramos Jiuru Chen
//
////////////////////////////////////////////////////////////////////////////////

/*
	Hazard Conditions:
    1a. EX/MEM.RegisterRd = ID/EX.RegisterRs
    1b. EX/MEM.RegisterRd = ID/EX.RegisterRt
    2a. MEM/WB.RegisterRd = ID/EX.RegisterRs
    2b. MEM/WB.RegisterRd = ID/EX.RegisterRt
*/

module ForwardingUnit(
    // input regs
    Rd_EXMEM, Rd_MEMWB, Rs_IDEX, Rt_IDEX,
    // input control signals
    RegWrite_EXMEM, RegWrite_MEMWB,
    // output mux control
    A_Mux_sel, B_Mux_sel
);
	// Destination Registers
	input [4:0] Rd_EXMEM; 
	input [4:0] Rd_MEMWB;
	// Source Registers
	input [4:0] Rs_IDEX;
	input [4:0] Rt_IDEX;
	
	// Control Signals
	input RegWrite_EXMEM, RegWrite_MEMWB;

    // ALU input mux control (to Ex stage)
	output reg [1:0] A_Mux_sel;
	output reg [1:0] B_Mux_sel;
	
	initial begin
	   A_Mux_sel <= 2'b00;
	   B_Mux_sel <= 2'b00;
	end
	
	always @(*) begin
	   // A mux control
	   if (RegWrite_EXMEM && (Rd_EXMEM != 0) && (Rd_EXMEM == Rs_IDEX)) begin
	           A_Mux_sel <= 2'b10;
	   end
	   else if (RegWrite_MEMWB 
              && (Rd_MEMWB != 0) 
              && ~(RegWrite_EXMEM && (Rd_EXMEM != 0) && (Rd_EXMEM == Rs_IDEX)) 
              && (Rd_MEMWB == Rs_IDEX)) begin
               A_Mux_sel <= 2'b01;
        end
        else begin
               A_Mux_sel <= 2'b00;
        end
	   // B mux control
	   if (RegWrite_EXMEM && (Rd_EXMEM != 0) && (Rd_EXMEM == Rt_IDEX)) begin
		      B_Mux_sel <= 2'b10;
	   end
	   else if (RegWrite_MEMWB 
              && (Rd_MEMWB != 0) 
              && ~(RegWrite_EXMEM && (Rd_EXMEM != 0) && (Rd_EXMEM == Rt_IDEX))
              && (Rd_MEMWB == Rt_IDEX)) begin
               B_Mux_sel <= 2'b01;
       end
       else begin
               B_Mux_sel <= 2'b00;
       end
	end
	
	
/*	always @(*) begin 
	    /// Ex Hazard
		if (RegWrite_EXMEM && (Rd_EXMEM != 0) && (Rd_EXMEM == Rs_IDEX)) begin
	       A_Mux_sel <= 2'b10;
		end
		else if (RegWrite_EXMEM && (Rd_EXMEM != 0) && (Rd_EXMEM == Rt_IDEX)) begin
		   B_Mux_sel <= 2'b10;
		end
		/// Mem Hazard
		else if (RegWrite_MEMWB 
		  && (Rd_MEMWB != 0) 
		  && ~(RegWrite_EXMEM && (Rd_EXMEM != 0) && (Rd_EXMEM == Rs_IDEX)) 
		  && (Rd_MEMWB == Rs_IDEX)) begin
		   A_Mux_sel <= 2'b01;
		end
		else if (RegWrite_MEMWB 
		  && (Rd_MEMWB != 0) 
		  && ~(RegWrite_EXMEM && (Rd_EXMEM != 0) && (Rd_EXMEM == Rt_IDEX))
		  && (Rd_MEMWB == Rt_IDEX)) begin
		   B_Mux_sel <= 2'b01;
		end
		else begin
			A_Mux_sel <= 2'b00;
			B_Mux_sel <= 2'b00;
		end
	end*/
    
endmodule