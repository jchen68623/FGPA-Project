`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Carlos Perez, Ramos Jiuru Chen
// 
// Control Signals: 
// ALUSrc- for immediates
// PCSrc- branch select
// RegWrite- write to register file
// memWrite/MemRead - DataMemory r/w (not register file)
// MemtoReg- Select ALUResult or DataMemory- loads/stores?
// RegDst- Select instruction[20:16] or instruction[15-11] (register destination)
// Branch-
// ALUSrcTop- ?
//
// Hi/Lo Operations: madd, msub, mthi, mtlo, mfhi, mflo
// Hi/Lo control signals: mthi, mtlo, WriteEnable, ReadEnable
//    
//////////////////////////////////////////////////////////////////////////////////


module Controller(
    Opcode, func, instruction_20_16, instruction10_6, ALUSrc, RegDst, RegWrite, ALUOp, MemRead, MemWrite, MemtoReg, PCSrc, Branch, ALUSrcTop, DataWidth, LinkStoreSel,
    instruction21, instruction6,
    // Hi/Lo control signals
    mthi, mtlo, WriteEnable, ReadEnable, jumpSrc, jregSrc
);


    input [5:0] Opcode, func;
    input [4:0] instruction_20_16;
    input [4:0] instruction10_6;
    input instruction21;
    input instruction6;
    output reg ALUSrc;
    output reg RegWrite;
    output reg MemRead;
    output reg MemWrite;
    output reg MemtoReg;
    output reg PCSrc;
    output reg Branch;
    output reg ALUSrcTop;
    output reg [1:0] RegDst;
    output reg mthi;
    output reg mtlo;
    output reg WriteEnable;
    output reg ReadEnable; // hi/lo control signals
    output reg [1:0] DataWidth; 
    output reg [5:0] ALUOp;
    output reg jumpSrc; // select branch(0) or jump(1)
    output reg jregSrc; // select address from instruction(0) or register (1)
    output reg LinkStoreSel;
    
    initial begin
        ALUOp <= 6'b000000;
        ALUSrc <= 0;
        PCSrc <= 0;
        RegWrite <= 0;
        MemWrite <= 0;
        MemRead <= 0;
        MemtoReg <= 0;
        RegDst <= 0;
        Branch <= 0;
        ALUSrcTop <= 0;
        mthi <= 0;
        mtlo <= 0;
        WriteEnable <= 0;
        ReadEnable <= 0;
        DataWidth <= 2'b00;
        jumpSrc <= 0;
        jregSrc <= 0;
        LinkStoreSel <= 0;
    end
    
    always @(*) begin
        if (Opcode == 6'b000000 && func == 6'b000000) begin //nop
            ALUOp <= 6'b000000;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            DataWidth <= 2'b00;
            LinkStoreSel <= 0;
        end
        // Arithmetic
       if(Opcode == 6'b000000 && func == 6'b100000) begin //add
            ALUOp <= 6'b000000;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
       end
	   else if (Opcode == 6'b001001) begin //addiu
			ALUOp <= 6'b000001;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
	   end
	   else if (Opcode == 6'b000000 && func == 6'b100001) begin // addu
	   		ALUOp <= 6'b000010;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
	   end
       else if (Opcode == 6'b001000) begin //addi 
            ALUOp <= 6'b000011;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0; 
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
       end
       else if (Opcode == 6'b000000 && func == 6'b100010) begin //sub
            ALUOp <= 6'b000100;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b011100 && func == 6'b000010) begin //mul 
            ALUOp <= 6'b000101;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
       end
	   /* Hi/Lo */
       else if (Opcode == 6'b000000 && func == 6'b011000) begin //mult 
            ALUOp <= 6'b000110;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 1;
            mtlo <= 1;
            WriteEnable <= 1;
            ReadEnable <= 1;
            LinkStoreSel <= 0;
		end
		else if (Opcode == 6'b000000 && func == 6'b011001) begin //multu
            ALUOp <= 6'b000111;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 1;
            mtlo <= 1;
            WriteEnable <= 1;
            ReadEnable <= 1;
            LinkStoreSel <= 0;
		end
		else if (Opcode == 6'b011100 && func == 6'b000000) begin //madd
            ALUOp <= 6'b001000;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 1;
            mtlo <= 1;
            WriteEnable <= 1;
            ReadEnable <= 1;
            LinkStoreSel <= 0;
		end
		else if (Opcode == 6'b011100 && func == 6'b000100) begin //msub
            ALUOp <= 6'b001001;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 1;
            mtlo <= 1;
            WriteEnable <= 1;
            ReadEnable <= 1;
            LinkStoreSel <= 0;
		end

		// -----------------------------------------------------
       // Logical
        else if (Opcode == 6'b000000 && func == 6'b100100) begin // and
            ALUOp <= 6'b001010;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b001100) begin // andi
            ALUOp <= 6'b001011;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b100101) begin // or
            ALUOp <= 6'b001100;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
		else if (Opcode == 6'b000000 && func == 6'b100111) begin // nor
            ALUOp <= 6'b001101;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
		else if (Opcode == 6'b000000 && func == 6'b100110) begin // xor
            ALUOp <= 6'b001110;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
		else if (Opcode == 6'b001101) begin	//ori
            ALUOp <= 6'b001111;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0;  
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
		end
		else if (Opcode == 6'b001110) begin	//xori
            ALUOp <= 6'b010000;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
		end
		else if (Opcode == 6'b011111 && func == 6'b100000) begin	//seh & seb merged here
            if (instruction10_6 == 5'b11000) begin // seh
            ALUOp <= 6'b010001;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
            end
            if (instruction10_6 == 5'b10000) begin  // seb
            ALUOp <= 6'b011110;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
            end
		end
		else if (Opcode == 6'b000000 && func == 6'b000000) begin //sll
            ALUOp <= 6'b010010; //<=====
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 1; // shift select
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
		else if (Opcode == 6'b000000 && func == 6'b000010 && instruction21 == 0) begin //srl 
            ALUOp <= 6'b010011;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 1;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
	    else if (Opcode == 6'b000000 && func == 6'b000100) begin //sllv 
            ALUOp <= 6'b010100;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
		else if (Opcode == 6'b000000 && func == 6'b000110 && instruction6 == 1'b0) begin //srlv
            ALUOp <= 6'b010101;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b101010) begin // slt
            ALUOp <= 6'b010110;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
		else if (Opcode == 6'b001010) begin // slti
            ALUOp <= 6'b010111;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b001011) begin // movn
            ALUOp <= 6'b011000;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b001010) begin // movz
            ALUOp <= 6'b011001; 
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b000110 && instruction6 == 1'b1) begin // rotrv
            ALUOp <= 6'b011010; 
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b000010 && instruction21 == 1) begin // rotr
            ALUOp <= 6'b011011; 
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 1;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b000011) begin // sra
            ALUOp <= 6'b011100; 
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 1;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b000111) begin // srav
            ALUOp <= 6'b011101; 
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
		else if (Opcode == 6'b001011) begin // sltiu
            ALUOp <= 6'b011111;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
		else if (Opcode == 6'b000000 && func == 6'b101011) begin // sltu
            ALUOp <= 6'b100000;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            LinkStoreSel <= 0;
        end
		// logical hi/lo instructions
		else if (Opcode == 6'b000000 && func == 6'b010001) begin // mthi
            ALUOp <= 6'b100001;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 1;
            mtlo <= 0;
            WriteEnable <= 1;
            ReadEnable <= 1;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b010011) begin // mtlo
            ALUOp <= 6'b100010;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 1;
            WriteEnable <= 1;
            ReadEnable <= 1;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b010000) begin // mfhi
            ALUOp <= 6'b100011;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 1;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b000000 && func == 6'b010010) begin // mflo
            ALUOp <= 6'b100100;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 1;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 1;
            LinkStoreSel <= 0;
        end
        //data 
        else if (Opcode == 6'b100011) begin //lw
            ALUOp <= 6'b100101; 
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 1;
            MemtoReg <= 0;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            DataWidth <= 2'b00;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b101011) begin //sw
            ALUOp <= 6'b100101; 
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 0;
            MemWrite <= 1;
            MemRead <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            DataWidth <= 2'b00;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b101000) begin //sb
            ALUOp <= 6'b100101;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 0;
            MemWrite <= 1;
            MemRead <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            DataWidth <= 2'b10;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b100001) begin //lh
            ALUOp <= 6'b100101;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 1;
            MemtoReg <= 0;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            DataWidth <= 2'b01;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b100000) begin //lb
            ALUOp <= 6'b100101;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 1;
            MemtoReg <= 0;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            DataWidth <= 2'b10;
            LinkStoreSel <= 0;
        end
        else if (Opcode == 6'b101001) begin //sh
            ALUOp <= 6'b100101; 
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 0;
            MemWrite <= 1;
            MemRead <= 0;
            //MemtoReg <= xxxxx; leave it as 0 or 1
			//in ALU it's adding base and offset as the address of the memory. ALUResult is the memory this case
            //RegDst <= xxxxx;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            DataWidth <= 2'b01;
            LinkStoreSel <= 0;
        end
        else if(Opcode == 6'b001111) begin //lui
            ALUOp <= 6'b100110;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <=0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            //DataWidth <= 2'b00;
            LinkStoreSel <= 0;
        end
       //branch
       else if (Opcode == 6'b000001 && instruction_20_16 == 5'b00001) begin //bgez
            ALUOp <= 6'b100111;
            ALUSrc <= 0;
            PCSrc <= 1;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 1;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            jumpSrc <= 0;
            LinkStoreSel <= 0;
       end
       else if (Opcode == 6'b000100) begin //beq
            ALUOp <= 6'b101000;
            ALUSrc <= 0;
            PCSrc <= 1;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 1;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            jumpSrc <= 0;
            LinkStoreSel <= 0;LinkStoreSel <= 0;
       end
       else if (Opcode == 6'b000101) begin //bne
            ALUOp <= 6'b101001; 
            ALUSrc <= 0;
            PCSrc <= 1;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 1;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            jumpSrc <= 0;
            LinkStoreSel <= 0;
       end
       else if (Opcode == 6'b000111) begin //bgtz
            ALUOp <= 6'b101010;
            ALUSrc <= 0;
            PCSrc <= 1;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 1;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            jumpSrc <= 0;
            LinkStoreSel <= 0;
       end
       else if (Opcode == 6'b000110) begin //blez
            ALUOp <= 6'b101011;
            ALUSrc <= 0;
            PCSrc <= 1;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 1;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            jumpSrc <= 0;
            LinkStoreSel <= 0;
       end
       else if (Opcode == 6'b000001 && instruction_20_16 == 5'b00000) begin //bltz
            ALUOp <= 6'b101100;
            ALUSrc <= 0;
            PCSrc <= 1;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 0;
            Branch <= 1;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            jumpSrc <= 0;
            LinkStoreSel <= 0;
       end
       // jumps
       else if (Opcode == 6'b000010) begin //j
            ALUOp <= 6'b101101;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            Branch <= 1;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            jumpSrc <= 1;
            jregSrc <= 0;
            LinkStoreSel <= 0;
       end
       else if (Opcode == 6'b000000 && func == 6'b001000) begin // jr
            ALUOp <= 6'b101101;
            ALUSrc <= 1;
            PCSrc <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            Branch <= 1;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            jumpSrc <= 1;
            jregSrc <= 1;
            LinkStoreSel <= 0;
       end
       else if (Opcode == 6'b000011) begin // jal
            ALUOp <= 6'b101110;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 1;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 1;
            RegDst <= 2;
            Branch <= 1;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            jumpSrc <= 1;
            jregSrc <= 0;
            LinkStoreSel <= 1;
       end
        else begin
            ALUOp <= 6'b000000;
            ALUSrc <= 0;
            PCSrc <= 0;
            RegWrite <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            Branch <= 0;
            ALUSrcTop <= 0;
            mthi <= 0;
            mtlo <= 0;
            WriteEnable <= 0;
            ReadEnable <= 0;
            DataWidth <= 2'b00;
            jumpSrc <= 0;
            jregSrc <= 0;
            LinkStoreSel <= 0;
        end
    end
endmodule
