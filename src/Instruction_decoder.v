`timescale 1ns / 1ps

module Instruction_decoder#(parameter size = 32)(
    input [size-1 : 0] instruction,
    output [2:0] IMM_sel,
	output [2:0] Branch_sel,
	output [2:0] Mem_type_sel,
	output [$clog2(size)-1 : 0] A_select,
	output [$clog2(size)-1 : 0] B_select,
	output [$clog2(size)-1 : 0] D_addr,
	output we,
	output MR,
	output MD,
	output MB,
	output [3:0] FS);
    
  
    wire R;
    wire S;
    wire B;
    wire U;
    wire J;
	wire Load;
	wire I_normal;
	wire JALR;

    wire [2:0] func3;
    wire fs0_1;
    wire fs0_2;
    wire fs0_3;
    
    assign func3 = instruction[14:12];
    
    
	
    assign Load = ~(instruction[6]| instruction[5]| instruction[4]| instruction[3]|instruction[2]);
	assign JALR = (instruction[6] & instruction[5] & ~instruction[4] & ~instruction[3] & instruction[2]);
	assign I_normal = (~instruction[6] & ~instruction[5] & instruction[4] & ~instruction[3] & ~instruction[2]);

    assign R = ~instruction[6] & instruction[5] & instruction[4] & ~instruction[3] & ~instruction[2]; 
    assign S = ~instruction[6] & instruction[5] &  ~instruction[4] & ~instruction[3] & ~instruction[2];
    assign B = instruction[6] & instruction[5] & ~instruction[4] & ~instruction[3] & ~instruction[2];
    assign U = ~instruction[6] & instruction[4] & ~instruction[3] & instruction[2];
    assign J = instruction[6] & instruction[5] & ~instruction[4] & instruction[3] & instruction[2];
	
	
    assign fs0_1 = B;
    assign fs0_2 = (R | I_normal) & ((func3[2] & func3[1] & ~func3[0]) | (~func3[2] & func3[1] & func3[0]));
	assign fs0_3 = ((R | I_normal) & instruction[30] & ((func3[2] & ~func3[1] & func3[0]) | (~func3[2] & ~func3[1] & ~func3[0])));
    
	assign FS[3] = (R | I_normal) & (~func3[1] & func3[0]);
	assign FS[2] = (R | I_normal) & (func3[2] & (func3[1] | ~func3[0]));
	assign FS[1] = (B & func3[2] & func3[1]) | ((R | I_normal) & ((func3[2] & func3[0]) | (~func3[2] & func3[1])));
	assign FS[0] = fs0_1 | fs0_2 | fs0_3;
    
    assign we = ~(B|S);
	assign MR = J | JALR | (U & ~instruction[5]);
	assign MD = Load;
	assign MB = ~(B | R);

    assign A_select = {$clog2(size){(~(U|J))}} & instruction[19:15];
    assign B_select = instruction[24:20];
    assign D_addr = instruction[11:7];
    
    assign Mem_type_sel = func3;
    
    assign IMM_sel[2] = J;
    assign IMM_sel[1] = U | B;
    assign IMM_sel[0] = U | S;

	assign Branch_sel[0] = (B & func3[0]) | JALR;
    assign Branch_sel[1] = (B & ~func3[2]) | J | JALR;
    assign Branch_sel[2] = (B & func3[2]) | J | JALR;
    
    
    
endmodule
