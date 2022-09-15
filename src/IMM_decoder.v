`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2022 23:47:11
// Design Name: 
// Module Name: IMM_decoder
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


module IMM_decoder#(parameter size = 32)(
    input [size-1 : 0] instruction,
    input [2:0] IMM_sel,
    output [size-1 : 0 ] IMM_out);

    
    wire [size-1: 0] I_imm;
    wire [size-1: 0] S_imm;
    wire [size-1: 0] B_imm;
    wire [size-1: 0] U_imm;
    wire [size-1: 0] J_imm;
    

    
    assign I_imm = {{20{instruction[31]}},instruction[31:20]};
    assign S_imm = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
    assign B_imm = {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8], 1'b0};
    assign U_imm = {instruction[31:12], {12{1'b0}}};
    assign J_imm = {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0};
    
    defparam MUX.mem_width = size;
    defparam MUX.mem_depth = 8;
    
    Parametric_mux MUX(
        .data_in({96'd0,J_imm,U_imm,B_imm,S_imm,I_imm}),
        .addr(IMM_sel),
        .data_out(IMM_out));

endmodule
