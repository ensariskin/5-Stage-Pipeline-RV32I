`timescale 1ns / 1ps

module RegisterFile#(parameter mem_width = 32, parameter mem_depth = 32)(
    input clk,
    input reset,
    input we,
    input [mem_width-1 : 0] Rin,
    input [$clog2(mem_depth)-1 : 0] A_select,
	input [$clog2(mem_depth)-1 : 0] B_select,
	input [$clog2(mem_depth)-1 : 0] D_addr,
    output [mem_width-1 : 0] A_out,
	output [mem_width-1 : 0] B_out);
   
    wire [mem_depth-1:0] S;
    wire [mem_width*mem_depth-1:0] FF_out;
    
    defparam decoder_in.mem_depth = mem_depth;
    defparam registers.mem_depth = mem_depth;
    defparam A_mux_out.mem_depth = mem_depth;
	defparam B_mux_out.mem_depth = mem_depth;
    
    defparam registers.mem_width = mem_width;
    defparam A_mux_out.mem_width = mem_width;
	defparam B_mux_out.mem_width = mem_width;
    
    Parametric_decoder decoder_in(
        .addr(D_addr),
        .dec_out(S));
    
 /*   D_FF_block registers(
        .clk(clk),
        .reset(reset),
        .Rin(Rin),
        .we(we),
        .S(S),
        .Rout(FF_out));
*/
    new_DFF_block registers(
        .clk(clk),
        .reset(reset),
        .Rin(Rin),
        .we(we),
        .S(S),
        .Rout(FF_out));
    Parametric_mux A_mux_out(
        .addr(A_select),
        .data_in(FF_out),
        .data_out(A_out));
	
    Parametric_mux B_mux_out(
        .addr(B_select),
        .data_in(FF_out),
        .data_out(B_out));
		
endmodule

