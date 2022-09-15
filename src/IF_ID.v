`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2022 02:30:09
// Design Name: 
// Module Name: IF_ID
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


module IF_ID#(parameter size = 32)(
    input clk,
    input reset,
    input buble,
    input flush,
    input [size-1 : 0] instruction_i,
    input [size-1 : 0] IMM_i,
    input [size-1 : 0] PCplus_i,
    input Predicted_MPC_i,
    
    output [size-1 : 0] instruction_o,
    output [size-1 : 0] IMM_o,
    output [size-1 : 0] PCplus_o,
    output Predicted_MPC_o);
    
    defparam INS.mem_width = size;
    defparam IMM.mem_width = size;
    defparam PC.mem_width = size;
    defparam MPC.mem_width = 1;
    
    D_FF_async_rst INS(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(instruction_i),
        .we(~buble),              
        .Rout(instruction_o));
        
    D_FF_async_rst IMM(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(IMM_i),
        .we(~buble),             
        .Rout(IMM_o));
    
    D_FF_async_rst PC(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(PCplus_i),
        .we(~buble),             
        .Rout(PCplus_o));
        
    D_FF_async_rst MPC(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(Predicted_MPC_i),
        .we(~buble),              
        .Rout(Predicted_MPC_o));
    
endmodule
