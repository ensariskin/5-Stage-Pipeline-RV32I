`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2022 21:33:39
// Design Name: 
// Module Name: data_organizator
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


module Data_organizer#(parameter size = 32)(
    input [size-1 : 0 ] data_in,
    input [2:0] Type_sel,
    output [size-1 : 0] data_out);
    
    
    wire [size-1 : 0] mask1;
    wire [size-1 : 0] mask2;
    wire [1 : 0] size_sel;
    wire sign;
    
    assign size_sel = Type_sel[1:0];
    assign sign = ~Type_sel[2];
    
    defparam MUX_mask1.mem_depth = 4;
    defparam MUX_mask1.mem_width = size;
    defparam MUX_mask2.mem_depth = 4;
    defparam MUX_mask2.mem_width = size; 
    
    
    Parametric_mux MUX_mask1(
        .addr(size_sel),
        .data_in({{size{1'b1}},{size{1'b1}}, {(size/2){1'b0}},{(size/2){1'b1}}, {(size*3/4){1'b0}}, {(size/4){1'b1}}}),
        .data_out(mask1));
    
    Parametric_mux MUX_mask2(
        .addr(size_sel),
        .data_in({{size{1'b0}},{size{1'b0}}, {(size/2){(sign&data_in[15])}},{(size/2){1'b0}}, {(size*3/4){(sign&data_in[7])}}, {(size/4){1'b0}}}),
        .data_out(mask2));
        
    assign data_out = (mask1 & data_in) | mask2; 
    
endmodule
