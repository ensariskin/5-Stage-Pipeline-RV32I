`timescale 1ns / 1ps


module single_cycle_processor#(parameter size = 32)(
    input clk,
    input reset,
    input [size-1 : 0] instruction,
    input [size-1 : 0] Data_in,
    output [size-1 : 0] Data_out,
    output [size-1 : 0] Addr_out,
    output [size-1 : 0] PC_Addr,
	output [2:0] Mem_type_sel,
	output Mem_write);
   
    wire we, MB, MD, MR, C, V, N, Z;
    wire [3:0]  FS;
    wire [$clog2(size)-1 : 0] A_select;
    wire [$clog2(size)-1 : 0] B_select;
    wire [$clog2(size)-1 : 0] D_addr;
    wire [size-1 : 0] PC;
    wire [size-1 : 0] IMM;
    wire [size-1 : 0] Addr;
    
    assign Addr_out = Addr;
    assign Mem_write = ~we & MB;
    defparam Datapath.size = size;
    defparam Controller.size = size;
    
    
    Datapath Datapath(
        .clk(clk),
        .reset(reset),
        .we(we),
        .MB_select(MB),
        .MD_select(MD),
        .MR_select(MR),
        .Sel(FS), 
        .A_select(A_select),
        .B_select(B_select),
        .D_addr(D_addr),
        .PC_in(PC),
        .Data_in(Data_in),
        .Constant_in(IMM),
        .Addr_out(Addr),
        .Data_out(Data_out),
        .C(C),
        .V(V),
        .N(N),
        .Z(Z));
    
    
    Controller Controller(
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .IMM_rs(Addr),
        .Z(Z),
        .N(N),
        .PC_Addr(PC_Addr),
        .PC_Save(PC),
        .IMM_out(IMM),
		.Mem_type_sel(Mem_type_sel),
        .A_select(A_select),
        .B_select(B_select),
        .D_addr(D_addr),
        .we(we),
        .MR(MR),
        .MD(MD),
        .MB(MB),
        .FS(FS));
    


endmodule
