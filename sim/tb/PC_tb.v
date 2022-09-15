`timescale 1ns / 1ps
`include "../liberty/D_CELLS_3V/verilog/D_CELLS_3V.v"
`include "../liberty/D_CELLS_3V/verilog/VLG_PRIMITIVES.v"

module PC_tb();
	parameter sdfFile = "../synth/PC/results/PC.sdf"; 
    parameter size = 32;



	reg clk;
	reg reset = 1'b0;
	reg MPC = 1'b0;
	reg JALR = 1'b0;
	reg [size-1 : 0] IMM = 32'd12;
	reg [size-1 : 0] IMM_rs = 32'd100;
	wire [size-1 : 0] PC_Addr;
	wire [size-1 : 0] PC_save;
	
	PC UUT(
	   	.clk(clk),
        .reset(reset),
        .MPC(MPC),
		.JALR(JALR),
        .IMM(IMM),
		.IMM_rs(IMM_rs),
        .PC_Addr(PC_Addr),
        .PC_save(PC_save));

	initial $sdf_annotate(sdfFile,UUT,,,"TYPICAL");
        
    parameter PERIOD = 20;
    
    always begin
        clk = 1'b1;
        #(PERIOD/2) clk = 1'b0;
        #(PERIOD/2);
    end
   
    initial begin
        #(4.5*PERIOD);
        reset = 1'b1;
        #(5*PERIOD);
        MPC = 1'b1;
        #(5*PERIOD);
		JALR = 1'B1;
		#(5*PERIOD);
        $finish();
   
   
    end
		
endmodule
