
//`include "paging.v"

module tb_paging;

	reg Clk = 0;
	reg Rst = 0;
	reg WE = 0;
	wire [19:0] LogicAddr;
	reg [15:0] VirtAddr = 0;
	reg [5:0] WriteIndex ;
	reg [15:0] WriteData;
	
	initial
	begin
			$dumpfile("tb_paging.vcd");
			$dumpvars;
						
			Rst <= 1;
			#2 Rst <= 0;
			WE = 1;
			#1 WriteIndex = 0;
			#1 WriteData = 1;
			#1 WriteIndex = 1;
			#1 WriteData = 0;
			#1 WE = 0;
			#10000 $finish;
			
	end
	
	always
	begin
		#5 Clk <= ~Clk;
		#1 VirtAddr <= VirtAddr + 2;
	end
	
	paging PT(
		.Clk(Clk),
		.Rst(Rst),
		.WE(WE),
		.LAddr(LogicAddr),
		.VAddr(VirtAddr),
		.WPTI(WriteIndex),
		.WPTE(WriteData)
	);

endmodule