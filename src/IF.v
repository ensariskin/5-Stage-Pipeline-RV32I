`timescale 1ns / 1ps

module IF#(parameter size = 32)(
    input clk,
    input reset,
    input buble,
    input [size-1 : 0] instruction_i,
    input isValid,
	input [size-1 : 0] Correct_PC,
    output [size-1 : 0] instruction_o,
    output [size-1 : 0] ins_address,
    output [size-1 : 0] IMM,
    output [size-1 : 0] PCplus,
    output Predicted_MPC);
    
    wire w_Predicted_MPC;
    wire [size-1 : 0] w_IMM;
	wire JALR;
    
    Branch_predictor branch_predictor(
        .instruction(instruction_i),
        .IMM(w_IMM),
        .isValid(isValid),
        .Predicted_MPC(w_Predicted_MPC),
		.JALR(JALR));
        
    ES_IMM_Decoder  ES_IMM(
        .instruction(instruction_i),
        .IMM_out(w_IMM));
    
    PC_new PC(
        .clk(clk),
        .reset(reset),
        .buble(buble),
        .MPC(w_Predicted_MPC),
		.JALR(JALR),
		.Correct_PC(Correct_PC),
		.isValid(isValid),
        .IMM(w_IMM),
        .PC_Addr(ins_address),
        .PC_save(PCplus));
    
    assign instruction_o = instruction_i;
    assign IMM = w_IMM;
    assign Predicted_MPC = w_Predicted_MPC;
    
endmodule
