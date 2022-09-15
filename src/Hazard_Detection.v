`timescale 1ns / 1ps


module Hazard_Detection#(parameter size = 32)(
    input clk,
    input [4:0] RD_EX,
    input isLoad_EX,
    input [4:0] RA_ID, 
    input [4:0] RB_ID,
    output reg buble = 1'b0);
    
    
    wire [4:0] RD_RA;
    wire [4:0] RD_RB;
    wire isRA;
    wire isRB;
    
    assign RD_RA = RD_EX ^ RA_ID;
    assign RD_RB = RD_EX ^ RB_ID;
    assign isRA = ~(RD_RA[4] | RD_RA[3] | RD_RA[2] | RD_RA[1] | RD_RA[0]);
    assign isRB = ~(RD_RB[4] | RD_RB[3] | RD_RB[2] | RD_RB[1] | RD_RB[0]);
   
    always@(negedge clk) begin
        buble = isLoad_EX & (isRA | isRB);
    end
endmodule
