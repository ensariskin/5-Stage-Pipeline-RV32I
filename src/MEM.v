`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2022 18:13:38
// Design Name: 
// Module Name: MEM
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


module MEM#(parameter size = 32)(
    input [size-1 : 0] FU_i,
    input [size-1 : 0] RAM_DATA_i,
    input [size-1 : 0] PCplus_i,
    input [size-1 : 0] MEM_result_i,
    input [11 : 0] Control_Signal_i,
    
    output [size-1 : 0] RAM_DATA_o,
    output [2:0] RAM_DATA_control,
    output RAM_rw,
    
    output [4:0] RD_MEM,
    output WE_MEM,
    
    output [size-1 : 0] FU_o,
    output [size-1 : 0] MEM_result_o,
    output [size-1 : 0] PCplus_o,
    output [7 : 0] Control_Signal_o);
    
    
    
    assign RAM_DATA_o = RAM_DATA_i;
    assign RAM_DATA_control = Control_Signal_i[2:0];
    assign RAM_rw = Control_Signal_i[3] & ~Control_Signal_i[6];
    assign FU_o = FU_i;
    assign MEM_result_o = MEM_result_i;
    assign PCplus_o = PCplus_i;
    assign Control_Signal_o = Control_Signal_i[11:4];
    
    
    assign RD_MEM = Control_Signal_i[11:7];
    assign WE_MEM = Control_Signal_i[6];
    
   
endmodule
