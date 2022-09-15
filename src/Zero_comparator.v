`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2022 02:44:43
// Design Name: 
// Module Name: Zero_comparator
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


module Zero_comparator#(parameter size = 32)(
    input [size-1:0] A,
    output Z);
    
    
    wire [15:0] first_stage; 
    wire [7:0] second_stage;
	wire [3:0] third_stage;
	wire [1:0] fourth_stage;
	genvar i;
	for(i=0;i<16;i = i+1) begin
		assign first_stage[i] = A[2*i] | A[2*i+1];
	end
	
	for(i=0;i<8;i = i+1) begin	
		assign second_stage[i] = first_stage[2*i] | first_stage[2*i+1];
	end

	for(i=0;i<4;i = i+1) begin
		assign third_stage[i] = second_stage[2*i] | second_stage[2*i+1];
	end

	assign fourth_stage[0] = third_stage[1] | third_stage[0];
	assign fourth_stage[1] = third_stage[3] | third_stage[2];
	assign Z = ~(fourth_stage[0] | fourth_stage[1]);
endmodule
