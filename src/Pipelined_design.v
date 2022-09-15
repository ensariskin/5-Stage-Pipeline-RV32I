`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2022 22:50:43
// Design Name: 
// Module Name: Pipelined_design
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


module Pipelined_design#(parameter size = 32)(
    input clk,
    input reset,
    input [size-1 : 0] instruction_i,
    input [size-1 : 0] MEM_result_i,
    output [size-1 : 0] ins_address,
    output [size-1 : 0] RAM_DATA_o,
    output [size-1 : 0] RAM_Addr_o,
    output [2:0] RAM_DATA_control,
    output RAM_rw);
    
    // main pipeline wires
    
    wire [size-1:0] instruction_IF_o;
    wire [size-1:0] IMM_IF_o;
    wire [size-1:0] PCPlus_IF_o;
    wire Predicted_MPC_IF_o;
    
    wire [size-1:0] instruction_ID_i;
    wire [size-1:0] IMM_ID_i;
    wire [size-1:0] PCPlus_ID_i;
    wire Predicted_MPC_ID_i;
    
    wire Predicted_MPC_ID_o;
    wire [size-1 : 0] A_ID_o;
    wire [size-1 : 0] B_ID_o;
    wire [size-1 : 0] RAM_DATA_ID_o;
    wire [size-1 : 0] PCplus_ID_o;
    wire [25 : 0] Control_Signal_ID_o;
    wire [2:0] Branch_sel_ID_o;
    
    wire Predicted_MPC_EX_i;
    wire [size-1 : 0] A_EX_i;
    wire [size-1 : 0] B_EX_i;
    wire [size-1 : 0] RAM_DATA_EX_i;
    wire [size-1 : 0] PCplus_EX_i;
    wire [25 : 0] Control_Signal_EX_i;
    wire [2:0] Branch_sel_EX_i;
    
    
    wire [size-1 : 0] FU_EX_o;
    wire [size-1 : 0] RAM_DATA_EX_o;
    wire [size-1 : 0] PCplus_EX_o;
    wire [11 : 0] Control_Signal_EX_o;
    
    wire [size-1 : 0] FU_MEM_i;
    wire [size-1 : 0] RAM_DATA_MEM_i;
    wire [size-1 : 0] PCplus_MEM_i;
    wire [11 : 0] Control_Signal_MEM_i;
    
    
    wire [size-1 : 0] FU_MEM_o;
    wire [size-1 : 0] MEM_result_MEM_o;
    wire [size-1 : 0] PCplus_MEM_o;
    wire [7 : 0] Control_Signal_MEM_o;
    
    wire [size-1 : 0] FU_WB_i;
    wire [size-1 : 0] MEM_result_WB_i;
    wire [size-1 : 0] PCplus_WB_i;
    wire [7 : 0] Control_Signal_WB_i;
    
    wire [size-1 : 0] Final_Result_WB_o;
    wire [5 : 0] Control_Signal_WB_o;
    
    // 
    wire isValid;
    wire buble;
    wire [4:0] RA_DF, RB_DF, RD_MEM, RD_WB;
    wire WE_MEM, WE_WB, isLoadMem;
    
    wire [1:0] A_sel_DF;
    wire [1:0] B_sel_DF;

	wire [size-1 : 0] PC_EX_o;
    
    
    IF Ins_Fetch(
        .clk(clk),
        .reset(reset),
        .buble(buble),
        .instruction_i(instruction_i),
        .isValid(isValid),
		.Correct_PC(PC_EX_o),
        .instruction_o(instruction_IF_o),
        .ins_address(ins_address),
        .IMM(IMM_IF_o),
        .PCplus(PCPlus_IF_o),
        .Predicted_MPC(Predicted_MPC_IF_o));

    IF_ID IF_ID(
        .clk(clk),
        .reset(reset),
        .buble(buble),
		.flush(~isValid),
        .instruction_i(instruction_IF_o),
        .IMM_i(IMM_IF_o),
        .PCplus_i(PCPlus_IF_o),
        .Predicted_MPC_i(Predicted_MPC_IF_o),
        .instruction_o(instruction_ID_i),
        .IMM_o(IMM_ID_i),
        .PCplus_o(PCPlus_ID_i),
        .Predicted_MPC_o(Predicted_MPC_ID_i));
        
        
    ID ID(
        .clk(clk),
        .reset(reset),
        .buble(buble),
        .instruction_i(instruction_ID_i),
        .IMM_i(IMM_ID_i),
        .PCplus_i(PCPlus_ID_i),
        .Predicted_MPC_i(Predicted_MPC_ID_i),
        .Control_Signal_WB(Control_Signal_WB_o),
        .DATA_in_WB(Final_Result_WB_o),
        .Predicted_MPC_o(Predicted_MPC_ID_o),
        .A(A_ID_o),
        .B(B_ID_o),
        .RAM_DATA(RAM_DATA_ID_o),
        .PCplus_o(PCplus_ID_o),
        .Control_Signal(Control_Signal_ID_o),
        .Branch_sel(Branch_sel_ID_o));
    
    ID_EX ID_EX(
        .clk(clk),
        .reset(reset),
		.flush(~isValid),
        .Predicted_MPC_i(Predicted_MPC_ID_o),
        .A_i(A_ID_o),
        .B_i(B_ID_o),
        .RAM_DATA_i(RAM_DATA_ID_o),
        .PCplus_i(PCplus_ID_o),
        .Control_Signal_i(Control_Signal_ID_o),
        .Branch_sel_i(Branch_sel_ID_o),
        .Predicted_MPC_o(Predicted_MPC_EX_i),          
        .A_o(A_EX_i),
        .B_o(B_EX_i),
        .RAM_DATA_o(RAM_DATA_EX_i),
        .PCplus_o(PCplus_EX_i),
        .Control_Signal_o(Control_Signal_EX_i),
        .Branch_sel_o(Branch_sel_EX_i));    

    EX EX(
        .clk(clk),
        .reset(reset),
    
        .Predicted_MPC_i(Predicted_MPC_EX_i),
        .A_i(A_EX_i),
        .B_i(B_EX_i),
        .RAM_DATA_i(RAM_DATA_EX_i),
        .PCplus_i(PCplus_EX_i),
        .Control_Signal_i(Control_Signal_EX_i),
        .Branch_sel(Branch_sel_EX_i),
        .Data_MEM(FU_MEM_i),    
        .Data_WB(Final_Result_WB_o),     
        .A_sel(A_sel_DF),       
        .B_sel(B_sel_DF),       
        
        .FU_o(FU_EX_o),
        .RAM_DATA_o(RAM_DATA_EX_o),
        .PCplus_o(PCplus_EX_o),
        .Control_Signal_o(Control_Signal_EX_o),
        .RA(RA_DF),          
        .RB(RB_DF),          
        .isValid(isValid),
		.Correct_PC(PC_EX_o));         
        
    EX_MEM EX_MEM(
        .clk(clk),
        .reset(reset),
        .FU_i(FU_EX_o),
        .RAM_DATA_i(RAM_DATA_EX_o),
        .PCplus_i(PCplus_EX_o),
        .Control_Signal_i(Control_Signal_EX_o),
        
        .FU_o(FU_MEM_i),
        .RAM_DATA_o(RAM_DATA_MEM_i),
        .PCplus_o(PCplus_MEM_i),
        .Control_Signal_o(Control_Signal_MEM_i));
        
    MEM MEM(
        .FU_i(FU_MEM_i),
        .RAM_DATA_i(RAM_DATA_MEM_i),
        .PCplus_i(PCplus_MEM_i),
        .MEM_result_i(MEM_result_i),
        .Control_Signal_i(Control_Signal_MEM_i),
        
        .RAM_DATA_o(RAM_DATA_o),
        .RAM_DATA_control(RAM_DATA_control),
        .RAM_rw(RAM_rw),
        
        .RD_MEM(RD_MEM),
        .WE_MEM(WE_MEM),
        
        .FU_o(FU_MEM_o),
        .MEM_result_o(MEM_result_MEM_o),
        .PCplus_o(PCplus_MEM_o),
        .Control_Signal_o(Control_Signal_MEM_o));
    
    MEM_WB MEM_WB(
        .clk(clk),
        .reset(reset),
        
        .FU_i(FU_MEM_o),
        .MEM_result_i(MEM_result_MEM_o),
        .PCplus_i(PCplus_MEM_o),
        .Control_Signal_i(Control_Signal_MEM_o),
        
        .FU_o(FU_WB_i),
        .MEM_result_o(MEM_result_WB_i),
        .PCplus_o(PCplus_WB_i),
        .Control_Signal_o(Control_Signal_WB_i));
        
        
    WB WB(
        .FU_i(FU_WB_i),
        .MEM_result_i(MEM_result_WB_i),
        .PCplus_i(PCplus_WB_i),
        .Control_Signal_i(Control_Signal_WB_i),
        
        
        .RD_WB(RD_WB),
        .WE_WB(WE_WB),
        .Final_Result(Final_Result_WB_o),
        .Control_Signal_o(Control_Signal_WB_o));
        
    
    Data_Forward DF(
        .RA(RA_DF),
        .RB(RB_DF),
		.MB(Control_Signal_EX_i[3]),
        .RD_MEM(RD_MEM),
        .RD_WB(RD_WB),
        .WE_MEM(WE_MEM),
        .WE_WB(WE_WB),
        .A_sel(A_sel_DF),
        .B_sel(B_sel_DF));   
    
    Hazard_Detection HD(
        .clk(clk),
        .RD_EX(Control_Signal_EX_o[11:7]),
        .isLoad_EX(Control_Signal_EX_o[4]),
        .RA_ID(Control_Signal_ID_o[15:11]),
        .RB_ID(Control_Signal_ID_o[20:16]),
        .buble(buble));
        
    assign RAM_Addr_o = FU_MEM_o;
endmodule

