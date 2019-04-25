
module paging(
	input Clk,
	input Rst,
	input WE,
	input PLevel,
	input [5:0] WPTI,
	input [15:0] WPTE,
	input [15:0] VAddr,
	output [19:0] LAddr,
	output [15:0] PTE
	);
	
	integer i;
	reg [15:0] PageTable [0:63];
	
	wire [5:0] PageTableIndex = VAddr[15:10];
	wire [9:0] PageOffset = VAddr[9:0];
	wire [15:0] PTE = PageTable[PageTableIndex];
	wire [9:0] PageBase = PTE[9:0];
	assign LAddr = {PageBase, PageOffset};
	
	always @(posedge WE or posedge Rst)
	begin
		
		if (WE)
		begin
			PageTable[WPTI] <= WPTE;
		end
		
		if (Rst)
		begin
			for (i = 0; i < 64; i = i + 1)
				PageTable[i] <= {6'b000100, 10'b0 + i[9:0]};
		end
	
	end
	
endmodule