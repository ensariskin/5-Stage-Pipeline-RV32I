`timescale 1ns / 1ps

module Datapath#(parameter size = 32)(
    input clk,
    input reset,
    input we,
	input MB_select,
	input MD_select,
	input MR_select,
	input [3:0] Sel, 
    input [$clog2(size)-1 : 0] A_select,
	input [$clog2(size)-1 : 0] B_select,
	input [$clog2(size)-1 : 0] D_addr,
	input [size-1 : 0] PC_in,
	input [size-1 : 0] Data_in,
	input [size-1 : 0] Constant_in,
	output [size-1 : 0] Addr_out,
	output [size-1 : 0] Data_out,
	output C,
    output V,
    output N,
    output Z);
   

	wire [size-1:0] A_final;
	wire [size-1:0] B_data;
	wire [size-1:0] B_final;
	wire [size-1:0] FU_out;
	wire [size-1:0] D_bus;
	wire [size-1:0] Reg_in;
	
	assign Addr_out = FU_out;
	assign Data_out = B_data;

	defparam RegFile.mem_width = size;
	defparam RegFile.mem_depth = size;
	
	defparam Mux_B.mem_width = size;
	defparam Mux_B.mem_depth = 2;
	
	defparam Func_Unit.size = size;
	
	defparam Mux_D.mem_width = size;
	defparam Mux_D.mem_depth = 2;
        
    defparam Mux_Reg.mem_width = size;
	defparam Mux_Reg.mem_depth = 2;
	   
    RegisterFile RegFile(
		.clk(clk),
		.reset(reset),
		.we(we),
		.Rin(Reg_in),
		.A_select(A_select),
		.B_select(B_select),
		.D_addr(D_addr),
		.A_out(A_final),
		.B_out(B_data));
	

	Parametric_mux Mux_B(
		.addr(MB_select),
        .data_in({Constant_in,B_data}),
        .data_out(B_final));
	
	FU Func_Unit(
		.A(A_final), 
		.B(B_final), 
		.Sel(Sel), 
		.S(FU_out),
		.C(C),
		.V(V),
		.N(N),
		.Z(Z));

	Parametric_mux Mux_D(
		.addr(MD_select),
		.data_in({Data_in,FU_out}),
		.data_out(D_bus));
    
    Parametric_mux Mux_Reg(
		.addr(MR_select),
		.data_in({PC_in,D_bus}),
		.data_out(Reg_in));




endmodule

