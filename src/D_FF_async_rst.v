`timescale 1ns / 1ps

module D_FF_async_rst#(parameter mem_width = 8)(
    input clk,
    input reset,
    input [mem_width-1 : 0] Rin,
    input we,
    output reg [mem_width-1 : 0] Rout = {mem_width-1{1'b0}});
    
    always @(posedge clk) begin 
        if(!reset) begin
            Rout <= 0;
        end
        else if(we) begin
            Rout <= Rin;
        end
    end
    
endmodule

