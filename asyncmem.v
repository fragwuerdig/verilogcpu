
module asyncmem(
	input [19:0] Addr,
	input Ack,
	input RRq,
	input WRq,
	inout [15:0] Data,
	output reg OK
	);
	
	reg [15:0] DataOut;
	reg [15:0] Array [0:1048575];
	assign Data = RRq ? DataOut : 16'bZ;
	
	initial begin
		$readmemh("mem.txt", Array);
	end
	
	always @(posedge RRq or posedge WRq)
	begin
	
		OK = 0;
		
		if (RRq)
		begin 
			DataOut <= Array[Addr];
			OK <= 1;
		end
		
		if (WRq)
		begin
			Array[Addr] <= Data;
			OK <= 1;
		end
		
	end

endmodule