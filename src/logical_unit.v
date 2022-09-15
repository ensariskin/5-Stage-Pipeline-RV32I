`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2022 22:56:50
// Design Name: 
// Module Name: logical_unit
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


module logical_unit#(parameter size = 32)(
    input [size-1:0] A,
    input [size-1:0] B,
    input [1:0] Sel,
    output [size-1:0] S);
    
    
    wire [size-1:0] xor_w;
    wire [size-1:0] or_w;
    wire [size-1:0] and_w;
    
    
    assign xor_w = A ^ B;
    assign or_w  = A | B;
    assign and_w = A & B;
    
    defparam out_mux.mem_width = size;
    defparam out_mux.mem_depth = 4;
    Parametric_mux out_mux(
        .addr(Sel),
        .data_in({{size{1'b0}},and_w,or_w,xor_w}),
        .data_out(S));
    
endmodule
