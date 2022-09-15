`timescale 1 ps / 1 fs


module NVRAM_tb;

	parameter Data_initFile    = "/home/miskin/Desktop/ensar_iskin/Homeworks/HW7/sim/tb/init_data.hex"; 
	parameter Ins_initFile    = "/home/miskin/Desktop/ensar_iskin/Homeworks/HW7/sim/tb/init_ins.hex"; 
	// UUT I/O 
	//register and wires for data memory
	reg [6:0] A;
	reg [31:0] DIN;
	reg CE,WE,HS,HR, POR;
	
	wire [31:0] DOUT;
	wire RDY;

	//register and wires for data memory
	reg [6:0] A_1;
	reg [31:0] DIN_1;
	reg CE_1,WE_1,HS_1,HR_1, POR_1;
	
	wire [31:0] DOUT_1;
	wire RDY_1;
	
	//
	reg dummy_clk;
	integer DATA_READ = 0;
	integer DATA_WRITE = 0;
	integer INS_READ = 0;
		
	// -- Instantiate UUT
	NVR_TOP 
	DATA_MEM
	(
	    .A(A),
	    .DIN(DIN),
	    .TM_NVCP(4'h0), 
	    .CE(CE), 
	    .HR(HR), 
	    .HS(HS), 
	    .MEM_ALLC(1'b0),   
	    .NVREF_EXT(1'b0), 	
	    .PEIN(1'b0), 		
	    .POR(POR), 
	    .WE(WE),
	    .MEM_SEL(4'd0),  
	    .DUP(1'b0), 	
	    .DSCLK(1'b0), 
	    .DRSTN(1'b1), 
	    .DSI(1'b0), 
	    .DSO(), 
	    .CLK4M(),
	    .DOUT(DOUT),
	    .RDY(RDY)
	);
	

	NVR_TOP 
	INS_MEM
	(
	    .A(A_1),
	    .DIN(DIN_1),
	    .TM_NVCP(4'h0), 
	    .CE(CE_1), 
	    .HR(HR_1), 
	    .HS(HS_1), 
	    .MEM_ALLC(1'b0),   
	    .NVREF_EXT(1'b0), 	
	    .PEIN(1'b0), 		
	    .POR(POR_1), 
	    .WE(WE_1),
	    .MEM_SEL(4'd0),  
	    .DUP(1'b0), 	
	    .DSCLK(1'b0), 
	    .DRSTN(1'b1), 
	    .DSI(1'b0), 
	    .DSO(), 
	    .CLK4M(),
	    .DOUT(DOUT_1),
	    .RDY(RDY_1)
	);
	 always begin
        dummy_clk = 1'b1;
        #(500) dummy_clk = 1'b0;
        #(500);
    end
	// -- Test procedure
	initial
	begin
		
		$timeformat(-6,6," us");

		$readmemh(Data_initFile, DATA_MEM.XNVR._SR_MEMORY, 0, 127); // --- Use this if you've written the instructions in hex
		$readmemh(Ins_initFile, INS_MEM.XNVR._SR_MEMORY, 0, 127); // --- Use this if you've written the instructions in hex
		//$readmemb(initFile, UUT.XNVR._SR_MEMORY, 0, 127);  // --- Use this if you've written the instructions in binary
				
		

		$display("%.1fns XNVR %m : INFO : Loading Initial File ... %s \n", $realtime, Data_initFile);
		
		//----System Inıt And System Reset----//
		system_init;
		#10000;	
		sys_reset;
		#10000;
		//Start Reading from Data and Instruction Memories
		for(A = 0; A < 127; A = A+1)begin
			DATA_READ = 1;
			#10000;
			DATA_READ = 0;
			#20000;
		end
		for(A_1 = 0; A_1 < 127; A_1 = A_1+1)begin
			INS_READ = 1;
			#10000;
			INS_READ = 0;
			#20000;
		end
		A = 0;
		for(A = 0; A < 127; A = A+1)begin
			DIN = DIN +1;
			DATA_WRITE = 1;
			#10000;
			DATA_WRITE = 0;
			#20000;
		end
		for(A = 0; A < 127; A = A+1)begin
			DATA_READ = 1;
			#10000;
			DATA_READ = 0;
			#20000;
		end
		// ------------------------------------------- //

		$finish();
	
	end
	

	always @(posedge dummy_clk) begin
		if(DATA_READ == 1) begin
			dataMemoryRead;
		end
		else if (DATA_WRITE == 1)begin
			dataMemoryWrite;
		end
		if(INS_READ == 1) begin
			insMemoryRead;
		end

	end

	// -- TB Tasks
	task sys_reset;
	/* Description: Apply a low-active reset pulse
	*/
		begin
			POR=0;
			POR_1 = 0;
			$display("Applying system reset at %t",$time);
			#10000;
			POR = 1;
			POR_1 = 1;
			#10000;
			POR = 0;
			POR_1 = 0;
			#10000;
		end
	endtask

	task system_init;
		begin
			DIN = 32'd0;
			CE = 1'b0;
			WE = 1'b0;
			HS = 1'b0;
			HR = 1'b0;
			POR	= 1'b0;
			A = 7'd0;

			DIN_1 = 32'd0;
			CE_1 = 1'b0;
			WE_1 = 1'b0;
			HS_1 = 1'b0;
			HR_1 = 1'b0;
			POR_1 = 1'b0;
			A_1 = 7'd0;

		end
	endtask

	task dataMemoryRead;
		begin
			WE = 1'b0;
			#2000;
			CE = 1'b1;
			#1000;
			CE = 1'b0;
			#27000;
		end
	endtask
	
	task dataMemoryWrite;
		begin
			WE = 1'b1;
			#2000;
			CE = 1'b1;
			#1000;
			CE = 1'b0;
			#7000;
			WE = 0;
			#20000;
		end
	endtask

	task insMemoryRead;
		begin
			WE_1 = 1'b0;
			#2000;
			CE_1 = 1'b1;
			#1000;
			CE_1 = 1'b0;
			#27000;
		end
	endtask
	

	
endmodule
