`timescale 1 ps / 1 fs
`include "../liberty/D_CELLS_3V/verilog/D_CELLS_3V.v"
`include "../liberty/D_CELLS_3V/verilog/VLG_PRIMITIVES.v"

module Datapath_tb;
	parameter sdfFile = "../synth/Datapath/results/Datapath.sdf";
	parameter Data_initFile = "/home/miskin/Desktop/ensar_iskin/Homeworks/HW7/sim/tb/init_data.hex"; 
	parameter size = 32;
	//register and wires for datapath
	
	reg clk;
    reg reset = 1'b0;
    reg we = 1'b0;
	reg MB_select = 1'b0;
	reg MD_select = 1'b0 ;
	reg MR_select = 1'b0;
	reg [3:0] Sel = 4'd0; 
    reg [$clog2(size)-1 : 0] A_select = 5'd0;
	reg [$clog2(size)-1 : 0] B_select = 5'd0;
	reg [$clog2(size)-1 : 0] D_addr = 5'd0;
	reg [size-1 : 0] PC_in = 32'd0;
	reg [size-1 : 0] Constant_in = 32'd0;
	wire [size-1 : 0] Addr_out;
	wire C;
    wire V;
    wire N;
	wire Z;

	//regs and wires of memory
	wire RDY;
	reg CE,WE_mem,HS,HR, POR;

	//wires for connecting datapath and memory
	
	wire [size-1 : 0] Data_out_dp;
	wire [size-1 : 0] Data_out_mem;
	wire [size-1 : 0] Data_out_dp_organized;
	wire [size-1 : 0] Data_out_mem_organized;
	 
	// Memory dummy clock
	reg dummy_clk;
	integer DATA_READ = 0;
	integer DATA_WRITE = 0;
		
	// -- Instantiate Modules
	defparam Datapath_to_Memory.size = size;
	defparam Memory_to_Datapath.size = size;

    Datapath UUT(
        .clk(clk),
        .reset(reset),
        .we(we),
        .MB_select(MB_select),
        .MD_select(MD_select),
		.MR_select(MR_select),
        .Sel(Sel), 
        .A_select(A_select),
        .B_select(B_select),
        .D_addr(D_addr),
		.PC_in(PC_in),
        .Data_in(Data_out_mem_organized),
        .Constant_in(Constant_in),
        .Addr_out(Addr_out),
        .Data_out(Data_out_dp),
        .C(C),
        .V(V),
        .N(N),
        .Z(Z));
	
	Data_organizer Datapath_to_Memory(
		.data_in(Data_out_dp),
		.Type_sel(3'b110),
		.data_out(Data_out_dp_organized));
	
	Data_organizer Memory_to_Datapath(
		.data_in(Data_out_mem),
		.Type_sel(3'b110),
		.data_out(Data_out_mem_organized));

	NVR_TOP DATA_MEM(
	    .A(Addr_out[6:0]),
	    .DIN(Data_out_dp_organized),
	    .TM_NVCP(4'h0), 
	    .CE(CE), 
	    .HR(HR), 
	    .HS(HS), 
	    .MEM_ALLC(1'b0),   
	    .NVREF_EXT(1'b0), 	
	    .PEIN(1'b0), 		
	    .POR(POR), 
	    .WE(WE_mem),
	    .MEM_SEL(4'd0),  
	    .DUP(1'b0), 	
	    .DSCLK(1'b0), 
	    .DRSTN(1'b1), 
	    .DSI(1'b0), 
	    .DSO(), 
	    .CLK4M(),
	    .DOUT(Data_out_mem),
	    .RDY(RDY));

	initial $sdf_annotate(sdfFile,UUT,,,"TYPICAL");
        
    parameter PERIOD = 30000; //30ns clk period
    
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

	// -- Test procedure
	initial
	begin
		
		$timeformat(-6,6," ns");

		$readmemh(Data_initFile, DATA_MEM.XNVR._SR_MEMORY, 0, 127); // --- Use this if you've written the instructions in hex
		//$readmemb(initFile, UUT.XNVR._SR_MEMORY, 0, 127);  // --- Use this if you've written the instructions in binary
				
		

		
		
		//----System Inıt And System Reset----//
		system_init;
		#(1.3*PERIOD);	
		sys_reset;
		$display("%.1fns XNVR %m : INFO : Loading Initial File ... %s \n", $realtime, Data_initFile);
		#PERIOD;
		//read C (LW R1 , 1(R0)) 
		reset = 1'b1;
		we = 1'b1;
        MB_select = 1'b1;
        MD_select = 1'b1;
		MR_select = 1'b0;
        Sel = 4'b0000;
        A_select = 5'd0;
        B_select = 5'd0;
        D_addr = 5'd1;
        Constant_in = 32'd1;
		DATA_READ = 1;
	
		#PERIOD;
		//read N (LW R2 , 2(R0)) 
		we = 1'b1;
        MB_select = 1'b1;
        MD_select = 1'b1;
		MR_select = 1'b0;
        Sel = 4'b0000;
        A_select = 5'd0;
        B_select = 5'd0;
        D_addr = 5'd2;
        Constant_in = 32'd2;
		DATA_READ = 1;


		#PERIOD;
		//read A (LW R3 , 3(R0)) 
		we = 1'b1;
        MB_select = 1'b1;
        MD_select = 1'b1;
		MR_select = 1'b0;
        Sel = 4'b0000;
        A_select = 5'd0;
        B_select = 5'd0;
        D_addr = 5'd3;
        Constant_in = 32'd3;
		DATA_READ = 1;



		#PERIOD;
		//reset C (SUB R1,R1,R1) 
		we = 1'b1;
        MB_select = 1'b0;
        MD_select = 1'b0;
		MR_select = 1'b0;
        Sel = 4'b0001;
        A_select = 5'd1;
        B_select = 5'd1;
        D_addr = 5'd1;
        Constant_in = 32'd0;
		DATA_READ = 0;


		#PERIOD;
		//C = C*2 (SLL R1,R1, 1) 
		we = 1'b1;
        MB_select = 1'b1;
        MD_select = 1'b0;
		MR_select = 1'b0;
        Sel = 4'b1000;
        A_select = 5'd1;
        B_select = 5'd0;
        D_addr = 5'd1;
        Constant_in = 32'd1;
		DATA_READ = 0;

		#PERIOD;
		//C = C - N (SUB R1,R1,R2) 
		we = 1'b1;
        MB_select = 1'b0;
        MD_select = 1'b0;
		MR_select = 1'b0;
        Sel = 4'b0001;
        A_select = 5'd1;
        B_select = 5'd2;
        D_addr = 5'd1;
        Constant_in = 32'd0;
		DATA_READ = 0;
		

		#PERIOD;
		//C = C + A (ADD R1,R1,R3) 
		we = 1'b1;
        MB_select = 1'b0;
        MD_select = 1'b0;
		MR_select = 1'b0;
        Sel = 4'b0000;
        A_select = 5'd1;
        B_select = 5'd3;
        D_addr = 5'd1;
        Constant_in = 32'd0;
		DATA_READ = 0;
		
		#PERIOD;
		//C = C - N (SUB R1,R1,R2) 
		we = 1'b1;
        MB_select = 1'b0;
        MD_select = 1'b0;
		MR_select = 1'b0;
        Sel = 4'b0001;
        A_select = 5'd1;
        B_select = 5'd2;
        D_addr = 5'd1;
        Constant_in = 32'd0;
		DATA_READ = 0;
		
		#(3*PERIOD);
		$finish();
	
	end
	

	always @(posedge dummy_clk) begin
		if(DATA_READ == 1) begin
			dataMemoryRead;
		end
		else if (DATA_WRITE == 1)begin
			dataMemoryWrite;
		end
	end

	// -- TB Tasks
	task sys_reset;
	/* Description: Apply a low-active reset pulse
	*/
		begin
			POR=0;
			$display("Applying system reset at %t",$time);
			#10000;
			POR = 1;
			#10000;
			POR = 0;
			#10000;
		end
	endtask

	task system_init;
		begin
			CE = 1'b0;
			WE_mem = 1'b0;
			HS = 1'b0;
			HR = 1'b0;
			POR	= 1'b0;
		end
	endtask

	task dataMemoryRead;
		begin
			WE_mem = 1'b0;
			#2000;
			CE = 1'b1;
			#1000;
			CE = 1'b0;
			#(PERIOD-3000);
		end
	endtask
	
	task dataMemoryWrite;
		begin
			WE_mem = 1'b1;
			#2000;
			CE = 1'b1;
			#1000;
			CE = 1'b0;
			#7000;
			WE_mem = 0;
			#20000;
		end
	endtask

	
endmodule
