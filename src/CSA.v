`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2022 23:00:31
// Design Name: 
// Module Name: CSA
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


module CSA#(parameter size = 32)(
    input [size-1:0] A,
    input [size-1:0] B,
    input [size-1:0] C,
    output [size-1:0] S,
    output cout,
    output v);
    
    wire [size-1:0] S1;
    wire [size-1:0] C1;
    wire [size-1:0] RCA_out;
    

    
    assign S[0] = S1[0];
    assign S[size-1:1] = RCA_out[size-2:0];
    assign cout = RCA_out[size-1];
    
    
    assign v = (S[size-1]^A[size-1]) & ~(A[size-1]^B[size-1]);
    
    
   
    genvar i;
    generate 
        for(i = 0; i < size; i = i+1)
        begin 
            FA first_stage(
                .x(A[i]),
                .y(B[i]),
                .ci(C[i]),
                .cout(C1[i]),
                .s(S1[i]));
        end
    endgenerate
    
    defparam final_stage.size = size;
    RCA final_stage(
        .x({1'b0,S1[size-1:1]}),
        .y(C1),
        .ci(1'b0),
        .cout(),
        .s(RCA_out));

endmodule
