`timescale 1ns / 1ps

module ID#(parameter size = 32)(
    input clk,
    input reset,
    input buble,
    input [size-1 : 0] instruction_i,
    input [size-1 : 0] IMM_i,
    input [size-1 : 0] PCplus_i,
    input Predicted_MPC_i,
    input [5:0] Control_Signal_WB,
    input [size-1:0] DATA_in_WB,
    
    output Predicted_MPC_o,
    output [size-1 : 0] A,
    output [size-1 : 0] B,
    output [size-1 : 0] RAM_DATA,
    output [size-1 : 0] PCplus_o,
    output [25 : 0] Control_Signal,
    output [2:0] Branch_sel);
    
    
    
    wire [size-1 : 0] B_data;
    wire [4:0] RD, RB, RA;
    wire [3:0] FS;
    wire [2:0] Mem_Type_Sel;
    wire WE;
    wire MR;
    wire MD;
    wire MB;
    
    
    defparam ins_decoder.size = size;
    
    defparam RegFile.mem_width = size;
	defparam RegFile.mem_depth = size;
    
    defparam Mux_B.mem_width = size;
	defparam Mux_B.mem_depth = 2;
	
	defparam Hazard.mem_width = 26;
	defparam Hazard.mem_depth = 2;
	
     Instruction_decoder ins_decoder(
        .instruction(instruction_i),
        .IMM_sel(),
        .Branch_sel(Branch_sel),
		.Mem_type_sel(Mem_Type_Sel),
        .A_select(RA),
        .B_select(RB),
        .D_addr(RD),
        .we(WE),
        .MR(MR),
        .MD(MD),
        .MB(MB),
        .FS(FS));
        
    RegisterFile RegFile(
        .clk(clk),
        .reset(reset),
        .we(Control_Signal_WB[0]),
        .Rin(DATA_in_WB),
        .A_select(RA),
        .B_select(RB),
        .D_addr(Control_Signal_WB[5:1]),
        .A_out(A),
        .B_out(B_data));
        
 	Parametric_mux Mux_B(
		.addr(MB),
        .data_in({IMM_i,B_data}),
        .data_out(B));
        
	Parametric_mux Hazard(
	   .addr(buble),
	   .data_in({26'd0,{{RD,RB,RA,FS,WE,MR,MD,MB,Mem_Type_Sel} & {26{instruction_i[0]}}}}),
	   .data_out(Control_Signal));
	   
	   
    assign Predicted_MPC_o = Predicted_MPC_i;
    assign RAM_DATA = B_data;
    assign PCplus_o = PCplus_i;
endmodule
