`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// ECE369A - Computer Architecture
// Laboratory  1
// Module - InstructionMemory.v
// Description - 32-Bit wide instruction memory.
//
// INPUT:-
// Address: 32-Bit address input port.
//
// OUTPUT:-
// Instruction: 32-Bit output port.
//
// FUNCTIONALITY:-
// Similar to the DataMemory, this module should also be byte-addressed
// (i.e., ignore bits 0 and 1 of 'Address'). All of the instructions will be 
// hard-coded into the instruction memory, so there is no need to write to the 
// InstructionMemory.  The contents of the InstructionMemory is the machine 
// language program to be run on your MIPS processor.
//
//
//we will store the machine code for a code written in C later. for now initialize 
//each entry to be its index * 3 (memory[i] = i * 3;)
//all you need to do is give an address as input and read the contents of the 
//address on your output port. 
// 
//Using a 32bit address you will index into the memory, output the contents of that specific 
//address. for data memory we are using 1K word of storage space. for the instruction memory 
//you may assume smaller size for practical purpose. you can use 128 words as the size and 
//hardcode the values.  in this case you need 7 bits to index into the memory. 
//
//be careful with the least two significant bits of the 32bit address. those help us index 
//into one of the 4 bytes in a word. therefore you will need to use bit [8-2] of the input address. 

// 011111  00000  01000  01011  10000  100000
////////////////////////////////////////////////////////////////////////////////

module InstructionMemory(Address, Instruction); 
    input [31:0] Address;        // Input Address 
    output reg [31:0] Instruction;    // Instruction at memory location Address
    
    reg [31:0] memory [0:150];
    
    // Initialize memory
    initial begin
memory[0] <= 32'h34040000;	//	main:		ori	$a0, $zero, 0
memory[1] <= 32'h34050010;	//			ori	$a1, $zero, 16
memory[2] <= 32'h34064010;	//			ori	$a2, $zero, 16400
memory[3] <= 32'h08000004;	//			j	vbsme
memory[4] <= 32'h34020000;	//	vbsme:		ori	$v0, $zero, 0
memory[5] <= 32'h34030000;	//			ori	$v1, $zero, 0
memory[6] <= 32'h8c900000;	//			lw	$s0, 0($a0)
memory[7] <= 32'h8c910004;	//			lw	$s1, 4($a0)
memory[8] <= 32'h8c920008;	//			lw	$s2, 8($a0)
memory[9] <= 32'h8c93000c;	//			lw	$s3, 12($a0)
memory[10] <= 32'h34140fff;	//			ori	$s4, $zero, 4095
memory[11] <= 32'h34150000;	//			ori	$s5, $zero, 0
memory[12] <= 32'h34160000;	//			ori	$s6, $zero, 0
memory[13] <= 32'h0212c022;	//			sub	$t8, $s0, $s2
memory[14] <= 32'h0233c822;	//			sub	$t9, $s1, $s3
memory[15] <= 32'h34170000;	//			ori	$s7, $zero, 0
memory[16] <= 32'h0c00004c;	//			jal	calculateSAD
memory[17] <= 32'h16b80002;	//	ZigZag:		bne	$s5, $t8, continue
memory[18] <= 32'h16d90001;	//			bne	$s6, $t9, continue
memory[19] <= 32'h08000073;	//			j	return
memory[20] <= 32'h20070000;	//	continue:	addi	$a3, $0, 0
memory[21] <= 32'h12e70004;	//			beq	$s7, $a3, PrevMove_d
memory[22] <= 32'h20070001;	//			addi	$a3, $0, 1
memory[23] <= 32'h12e70025;	//			beq	$s7, $a3, PrevMove_v
memory[24] <= 32'h20070002;	//			addi	$a3, $0, 2
memory[25] <= 32'h12e70014;	//			beq	$s7, $a3, PrevMove_h
memory[26] <= 32'h16d90004;	//	PrevMove_d:	bne	$s6, $t9, L1
memory[27] <= 32'h22b50001;	//			addi	$s5, $s5, 1
memory[28] <= 32'h20170001;	//			addi	$s7, $0, 1
memory[29] <= 32'h0c00004c;	//			jal	calculateSAD
memory[30] <= 32'h08000011;	//			j	ZigZag
memory[31] <= 32'h16c0000a;	//	L1:		bne	$s6, $0, L4
memory[32] <= 32'h12a00001;	//	L2:		beq	$s5, $0, L2_1
memory[33] <= 32'h16b80004;	//			bne	$s5, $t8, L3
memory[34] <= 32'h22d60001;	//	L2_1:		addi	$s6, $s6, 1
memory[35] <= 32'h20170002;	//			addi	$s7, $0, 2
memory[36] <= 32'h0c00004c;	//			jal	calculateSAD
memory[37] <= 32'h08000011;	//			j	ZigZag
memory[38] <= 32'h22b50001;	//	L3:		addi	$s5, $s5, 1
memory[39] <= 32'h20170001;	//			addi	$s7, $0, 1
memory[40] <= 32'h0c00004c;	//			jal	calculateSAD
memory[41] <= 32'h08000011;	//			j	ZigZag
memory[42] <= 32'h22d60001;	//	L4:		addi	$s6, $s6, 1
memory[43] <= 32'h20170002;	//			addi	$s7, $0, 2
memory[44] <= 32'h0c00004c;	//			jal	calculateSAD
memory[45] <= 32'h08000011;	//			j	ZigZag
memory[46] <= 32'h20170000;	//	PrevMove_h:	addi	$s7, $0, 0
memory[47] <= 32'h12a00001;	//			beq	$s5, $0, L6
memory[48] <= 32'h16d90006;	//			bne	$s6, $t9, L7
memory[49] <= 32'h12b8ffdf;	//	L6:		beq	$s5, $t8, ZigZag
memory[50] <= 32'h12c0ffde;	//			beq	$s6, $0, ZigZag
memory[51] <= 32'h22b50001;	//			addi	$s5, $s5, 1
memory[52] <= 32'h22d6ffff;	//			addi	$s6, $s6, -1
memory[53] <= 32'h0c00004c;	//			jal	calculateSAD
memory[54] <= 32'h08000031;	//			j	L6
memory[55] <= 32'h12a0ffd9;	//	L7:		beq	$s5, $0, ZigZag
memory[56] <= 32'h12d9ffd8;	//			beq	$s6, $t9, ZigZag
memory[57] <= 32'h22b5ffff;	//			addi	$s5, $s5, -1
memory[58] <= 32'h22d60001;	//			addi	$s6, $s6, 1
memory[59] <= 32'h0c00004c;	//			jal	calculateSAD
memory[60] <= 32'h08000037;	//			j	L7
memory[61] <= 32'h20170000;	//	PrevMove_v:	addi	$s7, $0, 0
memory[62] <= 32'h12a00001;	//			beq	$s5, $0, L8
memory[63] <= 32'h16d90006;	//			bne	$s6, $t9, L9
memory[64] <= 32'h12b8ffd0;	//	L8:		beq	$s5, $t8, ZigZag
memory[65] <= 32'h12c0ffcf;	//			beq	$s6, $0, ZigZag
memory[66] <= 32'h22b50001;	//			addi	$s5, $s5, 1
memory[67] <= 32'h22d6ffff;	//			addi	$s6, $s6, -1
memory[68] <= 32'h0c00004c;	//			jal	calculateSAD
memory[69] <= 32'h08000040;	//			j	L8
memory[70] <= 32'h12a0ffca;	//	L9:		beq	$s5, $0, ZigZag
memory[71] <= 32'h12d9ffc9;	//			beq	$s6, $t9, ZigZag
memory[72] <= 32'h22b5ffff;	//			addi	$s5, $s5, -1
memory[73] <= 32'h22d60001;	//			addi	$s6, $s6, 1
memory[74] <= 32'h0c00004c;	//			jal	calculateSAD
memory[75] <= 32'h08000046;	//			j	L9
memory[76] <= 32'h340f0000;	//	calculateSAD:	ori	$t7, $zero, 0
memory[77] <= 32'h34080000;	//			ori	$t0, $zero, 0
memory[78] <= 32'h0112382a;	//	outerLoop:	slt	$a3, $t0, $s2
memory[79] <= 32'h10e0001c;	//			beq	$a3, $zero, outerDone
memory[80] <= 32'h34090000;	//			ori	$t1, $zero, 0
memory[81] <= 32'h0133382a;	//	innerLoop:	slt	$a3, $t1, $s3
memory[82] <= 32'h10e00017;	//			beq	$a3, $zero, innerDone
memory[83] <= 32'h71135002;	//			mul	$t2, $t0, $s3
memory[84] <= 32'h01495020;	//			add	$t2, $t2, $t1
memory[85] <= 32'h20070004;	//			addi	$a3, $0, 4
memory[86] <= 32'h71475002;	//			mul	$t2, $t2, $a3
memory[87] <= 32'h00c05820;	//			add	$t3, $a2, $zero
memory[88] <= 32'h014b5020;	//			add	$t2, $t2, $t3
memory[89] <= 32'h8d4a0000;	//			lw	$t2, 0($t2)
memory[90] <= 32'h02a85820;	//			add	$t3, $s5, $t0
memory[91] <= 32'h71715802;	//			mul	$t3, $t3, $s1
memory[92] <= 32'h01765820;	//			add	$t3, $t3, $s6
memory[93] <= 32'h01695820;	//			add	$t3, $t3, $t1
memory[94] <= 32'h20070004;	//			addi	$a3, $0, 4
memory[95] <= 32'h71675802;	//			mul	$t3, $t3, $a3
memory[96] <= 32'h00a06020;	//			add	$t4, $a1, $zero
memory[97] <= 32'h016c5820;	//			add	$t3, $t3, $t4
memory[98] <= 32'h8d6b0000;	//			lw	$t3, 0($t3)
memory[99] <= 32'h014b5022;	//			sub	$t2, $t2, $t3
memory[100] <= 32'h000a3fc3;	//			sra	$a3, $t2, 31
memory[101] <= 32'h01475026;	//			xor	$t2, $t2, $a3
memory[102] <= 32'h01475022;	//			sub	$t2, $t2, $a3
memory[103] <= 32'h01ea7820;	//			add	$t7, $t7, $t2
memory[104] <= 32'h21290001;	//			addi	$t1, $t1, 1
memory[105] <= 32'h08000051;	//			j	innerLoop
memory[106] <= 32'h21080001;	//	innerDone:	addi	$t0, $t0, 1
memory[107] <= 32'h0800004e;	//			j	outerLoop
memory[108] <= 32'h028f382a;	//	outerDone:	slt	$a3, $s4, $t7
memory[109] <= 32'h10e00001;	//			beq	$a3, $zero, updateSAD
memory[110] <= 32'h08000072;	//			j	skip
memory[111] <= 32'h01e0a020;	//	updateSAD:	add	$s4, $t7, $0
memory[112] <= 32'h02a01020;	//			add	$v0, $s5, $zero
memory[113] <= 32'h02c01820;	//			add	$v1, $s6, $zero
memory[114] <= 32'h03e00008;	//	skip:		jr	$ra
memory[115] <= 32'h08000074;	//	return:		j	end
memory[116] <= 32'h08000074;	//	end:		j	end
    end
    
    // Fetch and output memory
    always @(*) begin
        Instruction <= memory[Address[31:2]];
    end
    

endmodule
