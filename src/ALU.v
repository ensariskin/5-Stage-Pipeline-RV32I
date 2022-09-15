`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2022 22:54:32
// Design Name: 
// Module Name: ALU
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


module ALU#(parameter size = 32)(
    input [size-1:0] A,
    input [size-1:0] B,
    input [2:0] Sel,
    output [size-1:0] S,
    output C,
    output V,
    output Z,
    output N);
    
    wire [size-1:0] arithmetic_out;
    wire [size-1:0] logical_out;
    
    defparam arithmetic.size = size;
    defparam logical.size = size;
    defparam out_mux.mem_width = size;
    defparam out_mux.mem_depth = 2;

    arithmetic_unit arithmetic(
        .A(A),
        .B(B),
        .Sel(Sel[1:0]),
        .S(arithmetic_out),
        .C(C),
        .V(V),
        .Z(Z),
        .N(N));
    
    logical_unit logical(
        .A(A),
        .B(B),
        .Sel(Sel[1:0]),
        .S(logical_out));
        
    Parametric_mux out_mux(
        .addr(Sel[2]),
        .data_in({logical_out, arithmetic_out}),
        .data_out(S));
    

endmodule
