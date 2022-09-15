`timescale 1ns / 1ps

module shifter#(parameter size = 32)(
    input [1:0] Sel,
    input [$clog2(size)-1 : 0] shamt,
    input [size-1:0] Data_in,
    output [size-1:0] Data_out);
    
    wire [size-1:0] shifter_in;
    wire [size-1:0] shifter_out;
    wire arithmetic_shifter_in;
	wire left;
    genvar i;
    genvar j;
    
    assign arithmetic_shifter_in = Data_in[size-1]  & Sel[0];
	assign left = ~(Sel[1] | Sel[0]);
    for(j = 0; j <size; j= j+1)
    begin    
        assign shifter_in[j] = (left & Data_in[size-1-j]) | (~left & Data_in[j]);
        assign Data_out[j] = (left & shifter_out[size-1-j]) | (~left & shifter_out[j]);
    end
    
   
    generate 
        for(i = 0; i < size; i = i+1) begin
            defparam mux.mem_width = 1;
            defparam mux.mem_depth = size;
            Parametric_mux mux(
                .addr(shamt),
                .data_in({{i{arithmetic_shifter_in}},{shifter_in[(size-1):i]}}),
                .data_out(shifter_out[i]));
        end
    endgenerate
endmodule
