`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2022 22:10:52
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB#(parameter size = 32)(
    input clk,
    input reset,
    
    input [size-1 : 0] FU_i,
    input [size-1 : 0] MEM_result_i,
    input [size-1 : 0] PCplus_i,
    input [7 : 0] Control_Signal_i,
    
    output [size-1 : 0] FU_o,
    output [size-1 : 0] MEM_result_o,
    output [size-1 : 0] PCplus_o,
    output [7 : 0] Control_Signal_o);
    
    defparam FU.mem_width = size;
    defparam MEM.mem_width = size;
    defparam PC.mem_width = size;
    defparam Control.mem_width = 8;
    
    D_FF_async_rst FU(
        .clk(clk),
        .reset(reset),
        .Rin(FU_i),
        .we(1'b1),              
        .Rout(FU_o));
        
    D_FF_async_rst MEM(
        .clk(clk),
        .reset(reset),
        .Rin(MEM_result_i),
        .we(1'b1),              
        .Rout(MEM_result_o));
        
    D_FF_async_rst PC(
        .clk(clk),
        .reset(reset),
        .Rin(PCplus_i),
        .we(1'b1),              
        .Rout(PCplus_o));
        
   D_FF_async_rst Control(
        .clk(clk),
        .reset(reset),
        .Rin(Control_Signal_i),
        .we(1'b1),              
        .Rout(Control_Signal_o));

endmodule
