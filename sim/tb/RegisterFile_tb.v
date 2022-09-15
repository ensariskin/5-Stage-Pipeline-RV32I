`timescale 1ns / 1ps
`include "../liberty/D_CELLS_3V/verilog/D_CELLS_3V.v"
`include "../liberty/D_CELLS_3V/verilog/VLG_PRIMITIVES.v"


module RegisterFile_tb();   

	parameter sdfFile = "../synth/RegisterFile/result/RegisterFile.sdf"; 
    
    parameter mem_width = 32;
    parameter mem_depth = 32;
    parameter PERIOD = 10;
    reg clk;
    reg reset = 1'b0;
    reg we = 1'b0;
    reg [mem_width-1 : 0] Rin = 0;
    reg [$clog2(mem_depth)-1 : 0] D_addr = 0;
	reg [$clog2(mem_depth)-1 : 0] A_select = 0;
	reg [$clog2(mem_depth)-1 : 0] B_select = 0;
    wire [mem_width-1 : 0] A_out;
	wire [mem_width-1 : 0] B_out;

    RegisterFile UUT(
        .clk(clk),
        .reset(reset),
        .we(we),
        .Rin(Rin),
		.A_select(A_select),
		.B_select(B_select),
        .D_addr(D_addr), 
        .A_out(A_out),
		.B_out(B_out));
        
    
	initial $sdf_annotate(sdfFile,UUT,,,"TYPICAL");

    always begin
        clk = 1'b0;
        #(PERIOD/2) clk = 1'b1;
        #(PERIOD/2);
    end
    
    initial begin
        #(3.25*PERIOD);
		reset = 1'b1;
		we = 1'b1;
		Rin = 31'd1;
       	for(D_addr = 5'd0; D_addr < mem_depth-1; D_addr = D_addr +1) begin
			#(PERIOD);
			Rin = Rin + 1;
		end
		#PERIOD;
		we = 1'b0;
		D_addr = 5'd0;
		#(2*PERIOD);
		B_select = 5'd31;
		for(A_select = 5'd0; A_select < mem_depth-1; A_select = A_select +1) begin
			#PERIOD;
			B_select = B_select - 1;
		end
		#(2*PERIOD);
		$finish();
    end
endmodule
