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


module Branch_Controller(
    input [2:0] Branch_sel, 
	input Z,
	input N,
    output MPC,
	output JALR);
    
    

	assign JALR = Branch_sel[2] & Branch_sel[1] & Branch_sel[0];

	
    defparam MUX.mem_width = 1;
    defparam MUX.mem_depth = 8;
    
    Parametric_mux MUX(
        .data_in({1'b1, 1'b1, ~N, N, ~Z, Z,1'b0, 1'b0}),
        .addr(Branch_sel),
        .data_out(MPC));
    
    

    
endmodule
