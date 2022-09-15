`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2022 01:50:25
// Design Name: 
// Module Name: PC_new
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


module PC_new#(parameter size = 32)(
	input clk,
	input reset,
	input buble,
	input MPC,
	input JALR,
	input [size-1 : 0] IMM,
	input [size-1 : 0] Correct_PC,
	input isValid,
	output [size-1 : 0] PC_Addr,
	output [size-1 : 0] PC_save);
    
    wire [size-1 : 0] PC_current_val;
    wire [size-1 : 0] PC_new_val;
	wire [size-1 : 0] PC_plus_four;
   	wire [size-1 : 0] PC_plus_imm;
	wire [size-1 : 0] PC_plus;



	defparam PC_reg.mem_width = size;
	defparam Adder1.size = size;
	defparam inner_mux.mem_width = size;
	defparam inner_mux.mem_depth = 2;
	defparam out_mux.mem_width = size;
	defparam out_mux.mem_depth = 2;
	defparam correction_mux.mem_width = size;
	defparam correction_mux.mem_depth = 2;

	D_FF_async_rst PC_reg(
		.clk(clk),
        .reset(reset),
        .Rin(PC_new_val),
        .we(~buble),
        .Rout(PC_current_val));

	RCA Adder1(
		.x(PC_current_val),
		.y(32'd1),
		.ci(1'b0),
		.cout(),
		.s(PC_plus_four));

	RCA Adder2(
		.x(PC_current_val),
		.y(IMM),
		.ci(1'b0),
		.cout(),
		.s(PC_plus_imm));

	Parametric_mux inner_mux(
		.addr(MPC),
		.data_in({PC_plus_imm, PC_plus_four}),
		.data_out(PC_plus));

	Parametric_mux out_mux(
		.addr(MPC|JALR),
		.data_in({PC_plus_four, PC_plus_imm}),
		.data_out(PC_save));

	Parametric_mux correction_mux(
		.addr(isValid),
		.data_in({PC_plus,Correct_PC}),
		.data_out(PC_new_val));

	assign PC_Addr = PC_current_val;

endmodule
