`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2022 02:07:03
// Design Name: 
// Module Name: Branch_predictor
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


module Branch_predictor#(parameter size = 32)(
    input [size-1 : 0] instruction,
    input [size-1 : 0] IMM,
    input isValid,
    output Predicted_MPC,
	output JALR);

	wire J;
	wire B;

	assign J = instruction[6] & instruction[5] & ~instruction[4] & instruction[3] & instruction[2];
	assign B = instruction[6] & instruction[5] & ~instruction[4] & ~instruction[3] & ~instruction[2];
    




    assign Predicted_MPC = J | (B & 1'b1);
	assign JALR = (instruction[6] & instruction[5] & ~instruction[4] & ~instruction[3] & instruction[2]);






endmodule
