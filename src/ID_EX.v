`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2022 03:44:38
// Design Name: 
// Module Name: ID_EX
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


module ID_EX#(parameter size = 32)(
    input clk,
    input reset,
    input flush,
    input Predicted_MPC_i,
    input [size-1 : 0] A_i,
    input [size-1 : 0] B_i,
    input [size-1 : 0] RAM_DATA_i,
    input [size-1 : 0] PCplus_i,
    input [25 : 0] Control_Signal_i,
    input [2:0] Branch_sel_i,
    
    output Predicted_MPC_o,          
    output [size-1 : 0] A_o,           
    output [size-1 : 0] B_o,           
    output [size-1 : 0] RAM_DATA_o,  
    output [size-1 : 0] PCplus_o,    
    output [25 : 0] Control_Signal_o,
    output [2:0] Branch_sel_o);
    
    defparam MPC.mem_width = 1;
    defparam A.mem_width = size;
    defparam B.mem_width = size;
    defparam RAM.mem_width = size;
    defparam PC.mem_width = size;
    defparam Control.mem_width = 26;
    defparam Branch.mem_width = 3;
    
    D_FF_async_rst MPC(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(Predicted_MPC_i),
        .we(1'b1),              
        .Rout(Predicted_MPC_o));
        
    D_FF_async_rst A(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(A_i),
        .we(1'b1),              
        .Rout(A_o));
        
    D_FF_async_rst B(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(B_i),
        .we(1'b1),              
        .Rout(B_o));
        
   D_FF_async_rst RAM(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(RAM_DATA_i),
        .we(1'b1),              
        .Rout(RAM_DATA_o));
        
   D_FF_async_rst PC(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(PCplus_i),
        .we(1'b1),             
        .Rout(PCplus_o));
   
   D_FF_async_rst Control(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(Control_Signal_i),
        .we(1'b1),              
        .Rout(Control_Signal_o));
        
    D_FF_async_rst Branch(
        .clk(clk),
        .reset(reset & ~flush),
        .Rin(Branch_sel_i),
        .we(1'b1),              
        .Rout(Branch_sel_o));
endmodule
