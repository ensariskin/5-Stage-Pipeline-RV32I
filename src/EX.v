`timescale 1ns / 1ps


module EX#(parameter size = 32)(
    input clk,
    input reset,
    
    input Predicted_MPC_i,
    input [size-1 : 0] A_i,
    input [size-1 : 0] B_i,
    input [size-1 : 0] RAM_DATA_i,
    input [size-1 : 0] PCplus_i,
    input [25 : 0] Control_Signal_i,
    input [size-1 : 0] Data_MEM,
    input [size-1 : 0] Data_WB,
    input [1 : 0] A_sel,
    input [1 : 0] B_sel,
    input [2:0] Branch_sel,
    
    output [size-1 : 0] FU_o,
    output [size-1 : 0] RAM_DATA_o,
    output [size-1 : 0] PCplus_o,
    output [11 : 0] Control_Signal_o,
    output [4:0] RA,
    output [4:0] RB,
    output isValid,
	output [size-1 : 0] Correct_PC);
    
    
    wire [size-1:0] A;
    wire [size-1:0] B;
    wire N,Z;
    wire Real_MPC;
	wire isJALR;
    
    defparam A_mux.mem_width = size;
	defparam A_mux.mem_depth = 4;
	
	defparam B_mux.mem_width = size;
	defparam B_mux.mem_depth = 4;
	
	defparam correction_mux.mem_width = size;
	defparam correction_mux.mem_depth = 2;

	defparam Func_Unit.size = size;
    Parametric_mux A_mux(
        .addr(A_sel),
        .data_in({Data_MEM,Data_WB,Data_MEM,A_i}),
        .data_out(A));
        
   Parametric_mux B_mux(
        .addr(B_sel),
        .data_in({Data_MEM,Data_WB,Data_MEM,B_i}),
        .data_out(B)); 
        
        
   FU Func_Unit(
		.A(A), 
		.B(B), 
		.Sel(Control_Signal_i[10:7]), 
		.S(FU_o),
		.C(),
		.V(),
		.N(N),
		.Z(Z));
		
    Branch_Controller branch_controller(
        .Branch_sel(Branch_sel), 
        .Z(Z),
        .N(N),
        .MPC(Real_MPC),
        .JALR(isJALR));
    

	Parametric_mux correction_mux(
		.addr(isJALR),
		.data_in({FU_o, PCplus_i}),
		.data_out(Correct_PC));


    assign RAM_DATA_o = RAM_DATA_i;
    assign PCplus_o = PCplus_i;
    assign Control_Signal_o = {Control_Signal_i[25:21],Control_Signal_i[6:0]};
    assign RA = Control_Signal_i[15:11]; 
    assign RB = Control_Signal_i[20:16];
    assign isValid =  ~(Real_MPC ^  Predicted_MPC_i);
endmodule
