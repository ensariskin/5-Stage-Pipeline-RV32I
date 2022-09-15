`timescale 1ns / 1ps
`include "../liberty/D_CELLS_3V/verilog/D_CELLS_3V.v"
`include "../liberty/D_CELLS_3V/verilog/VLG_PRIMITIVES.v"
module Controller_tb();
	parameter sdfFile = "../synth/CU/results/CU.sdf"; 
	parameter Ins_initFile    = "/home/miskin/Desktop/ensar_iskin/Homeworks/HW7/sim/tb/init_ins1.hex"; 
    parameter size = 32;
    parameter PERIOD = 50000; 
    


	reg clk;
    reg reset;
    reg [size-1 : 0] IMM_rs = 32'd100;
    reg Z = 0;
    reg N = 0;
	wire [31 : 0] instruction;
    wire [size-1 : 0] PC_Addr;
    wire [size-1 : 0] PC_Save;
    wire [size-1 : 0] IMM_out;
	wire [2:0] Mem_type_sel;
    wire [$clog2(size)-1 : 0] A_select;
	wire [$clog2(size)-1 : 0] B_select;
	wire [$clog2(size)-1 : 0] D_addr;
    wire we;
	wire MR;
	wire MD;
	wire MB;
	wire [3:0] FS;
    
	reg CE_1,HS_1,HR_1, POR_1;
	wire RDY_1;

	reg dummy_clk;

    defparam UUT.size = size;
    
    Controller UUT(
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .IMM_rs(IMM_rs),
        .Z(Z),
        .N(N),
        .PC_Addr(PC_Addr),
        .PC_Save(PC_Save),
        .IMM_out(IMM_out),
		.Mem_type_sel(Mem_type_sel),
        .A_select(A_select),
        .B_select(B_select),
        .D_addr(D_addr),
        .we(we),
        .MR(MR),
        .MD(MD),
        .MB(MB),
        .FS(FS));

    NVR_TOP INS_MEM(
	    .A(PC_Addr[6:0]),
	    .DIN(32'd0),
	    .TM_NVCP(4'h0), 
	    .CE(CE_1), 
	    .HR(HR_1), 
	    .HS(HS_1), 
	    .MEM_ALLC(1'b0),   
	    .NVREF_EXT(1'b0), 	
	    .PEIN(1'b0), 		
	    .POR(POR_1), 
	    .WE(1'b0),
	    .MEM_SEL(4'd0),  
	    .DUP(1'b0), 	
	    .DSCLK(1'b0), 
	    .DRSTN(1'b1), 
	    .DSI(1'b0), 
	    .DSO(), 
	    .CLK4M(),
	    .DOUT(instruction),
	    .RDY(RDY_1));
    
	initial $sdf_annotate(sdfFile,UUT,,,"TYPICAL");

    always begin
        clk = 1'b1;
        #(PERIOD/2) clk = 1'b0;
        #(PERIOD/2);
    end
	
	always begin
        dummy_clk = 1'b1;
        #(500) dummy_clk = 1'b0;
        #(500);
    end

    
	always @(posedge dummy_clk) begin
		insMemoryRead;
	end
    
    initial begin
        reset = 1'b0;
		$timeformat(-6,6," us");

		$readmemh(Ins_initFile, INS_MEM.XNVR._SR_MEMORY, 0, 127); // --- Use this if you've written the instructions in hex
				
		
		$display("%.1fns XNVR %m : INFO : Loading Initial File ... %s \n", $realtime, Ins_initFile);
		
		//----System Init And System Reset----//
		system_init;
		#PERIOD;	
		sys_reset;
		#(4*PERIOD);
		reset = 1'b1;
		#(18*PERIOD);
        $finish();
    
    end
    
	task sys_reset;
	/* Description: Apply a low-active reset pulse
	*/
		begin
			POR_1 = 0;
			$display("Applying system reset at %t",$time);
			#10000;
			POR_1 = 1;
			#10000;
			POR_1 = 0;
			#(PERIOD - 200000);
		end
	endtask

	task system_init;
		begin
			CE_1 = 1'b0;
			HS_1 = 1'b0;
			HR_1 = 1'b0;
			POR_1 = 1'b0;
		end
	endtask

	task insMemoryRead;
		begin
			#2000;
			CE_1 = 1'b1;
			#1000;
			CE_1 = 1'b0;
			#(PERIOD-3000);
		end
	endtask
    
    
    
endmodule
