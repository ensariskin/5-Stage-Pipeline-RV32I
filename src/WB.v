`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2022 22:15:17
// Design Name: 
// Module Name: WB
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


module WB#(parameter size = 32)(
    input [size-1 : 0] FU_i,
    input [size-1 : 0] MEM_result_i,
    input [size-1 : 0] PCplus_i,
    input [7 : 0] Control_Signal_i,
    
    output [4:0] RD_WB,
    output WE_WB,
    
    output [size-1 : 0] Final_Result,
    output [5 : 0] Control_Signal_o);
    
    defparam Final_mux.mem_width = size;
    defparam Final_mux.mem_depth = 4;
    
    Parametric_mux Final_mux(
        .addr(Control_Signal_i[1:0]),
        .data_in({{size{1'b0}},PCplus_i,MEM_result_i,FU_i}),
        .data_out(Final_Result));
    
    
    assign Control_Signal_o = Control_Signal_i[7:2];
    
    assign RD_WB = Control_Signal_i[7:3];
    assign WE_WB = Control_Signal_i[2];
endmodule
