`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2022 01:35:44
// Design Name: 
// Module Name: ES_IMM_Decoder
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


module ES_IMM_Decoder#(parameter size = 32)(
    input [size-1 : 0] instruction,
    output [size-1 : 0 ] IMM_out);

    
    wire [size-1: 0] I_imm;
    wire [size-1: 0] S_imm;
    wire [size-1: 0] B_imm;
    wire [size-1: 0] U_imm;
    wire [size-1: 0] J_imm;
    wire [2:0] IMM_sel;
    wire S;
    wire B;
    wire U;
    wire J;
    
    
    assign S = ~instruction[6] & instruction[5] &  ~instruction[4] & ~instruction[3] & ~instruction[2];
    assign B = instruction[6] & instruction[5] & ~instruction[4] & ~instruction[3] & ~instruction[2];
    assign U = ~instruction[6] & instruction[4] & ~instruction[3] & instruction[2];
    assign J = instruction[6] & instruction[5] & ~instruction[4] & instruction[3] & instruction[2];
    
    assign IMM_sel[2] = J;
    assign IMM_sel[1] = U | B;
    assign IMM_sel[0] = U | S;

    
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
