`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2022 18:32:20
// Design Name: 
// Module Name: FU
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


module FU#(parameter size = 32)(
    input [size-1:0] A, 
    input [size-1:0] B, 
    input [3:0] Sel, 
    output [size-1:0] S,
    output C,
    output V,
    output N,
    output Z);
    
    wire [size-1:0] alu_out; 
    wire [size-1:0] shifter_out; 
    wire ALU_C, ALU_V, ALU_N, ALU_Z;
    
    assign C = ALU_C & ~Sel[3];
    assign V = ALU_V & ~Sel[3];
    assign N = ALU_N & ~Sel[3];
    assign Z = ALU_Z & ~Sel[3];
    
    defparam ALU.size = size;
    defparam shifter.size = size;
    defparam out_mux.mem_width = size;
    defparam out_mux.mem_depth = 2; 
    
    ALU ALU(
        .A(A),
        .B(B),
        .Sel(Sel[2:0]),
        .S(alu_out),
        .C(ALU_C),
        .V(ALU_V),
        .Z(ALU_Z),
        .N(ALU_N));
        
    shifter shifter(
        .Sel(Sel[1:0]),
        .shamt(B[$clog2(size)-1 :0]),
        .Data_in(A),
        .Data_out(shifter_out));
        
    Parametric_mux out_mux(
        .addr(Sel[3]),
        .data_in({shifter_out,alu_out}),
        .data_out(S));
        
endmodule
