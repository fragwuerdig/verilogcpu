`include "constants.v"
`include "processor.v"
`include "asyncmem.v"

module main;
	
	// Clock
	reg Clk = 0;
	reg Rst = 0;
	integer idx;
			
	initial
	begin
			$dumpfile("main.vcd");
			$dumpvars;
			
			for (idx = 65535; idx > 65503; idx = idx - 1)
				$dumpvars(0,main.Mem.Array[idx]);
				
			for (idx = 0; idx < 64; idx = idx + 1)
				$dumpvars(0, main.CPU.ATU.PageTable[idx]);
						
			Rst <= 1;
			Clk <= 0;
			#10 Rst <= 0;
			
			#500 $finish;
	end
	
	always
	begin
			#5 Clk <= ~Clk;
	end
	
	wire Ack;
	wire RRq;
	wire WRq;
	wire [15:0] Data;
	wire OK;
	
	asyncmem Mem(
		.Addr(CPU.Addr),
		.Ack(Ack),
		.RRq(RRq),
		.WRq(WRq),
		.Data(Data),
		.OK(OK)
	);
	
	processor CPU(
		.Rst(Rst), 
		.Clk(Clk),
		.OK(OK),
		.Ack(Ack),
		.RRq(RRq),
		.WRq(WRq),
		.Data(Data)	
	);
	
	
endmodule