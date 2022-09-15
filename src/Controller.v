`timescale 1ns / 1ps

module Controller#(parameter size = 32)(
    input clk,
    input reset,
    input [31 : 0] instruction,
    input [size-1 : 0] IMM_rs,
    input Z,
    input N,
    output [size-1 : 0] PC_Addr,
    output [size-1 : 0] PC_Save,
    output [size-1 : 0] IMM_out,
	output [2:0] Mem_type_sel,
    output [$clog2(size)-1 : 0] A_select,
	output [$clog2(size)-1 : 0] B_select,
	output [$clog2(size)-1 : 0] D_addr,
    output we,
	output MR,
	output MD,
	output MB,
	output [3:0] FS);
    
    
    wire [2:0] IMM_sel;
    wire [2:0] Branch_sel;
    wire MPC;
    wire JALR;
    wire [size-1:0] IMM;
    
    assign IMM_out = IMM;
    
    defparam ins_decoder.size = size;
    defparam imm_decoder.size = size;
    defparam program_counter.size = size;
    
    Instruction_decoder ins_decoder(
        .instruction(instruction),
        .IMM_sel(IMM_sel),
        .Branch_sel(Branch_sel),
		.Mem_type_sel(Mem_type_sel),
        .A_select(A_select),
        .B_select(B_select),
        .D_addr(D_addr),
        .we(we),
        .MR(MR),
        .MD(MD),
        .MB(MB),
        .FS(FS));
        
    Branch_Controller branch_controller(
        .Branch_sel(Branch_sel), 
        .Z(Z),
        .N(N),
        .MPC(MPC),
        .JALR(JALR));
    
    IMM_decoder imm_decoder(
        .instruction(instruction),
        .IMM_sel(IMM_sel),
        .IMM_out(IMM));
        
    PC program_counter(
        .clk(clk),
        .reset(reset),
        .MPC(MPC),
        .JALR(JALR),
        .IMM(IMM),
        .IMM_rs(IMM_rs),
        .PC_Addr(PC_Addr),
        .PC_save(PC_Save));
endmodule
