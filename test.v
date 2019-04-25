
module test;
	
	reg Clk = 0;
	
	initial begin
	
		$dumpfile("test.vcd");
		$dumpvars;
		
		#20 c <= 1;
		#20 c <= 0;
		
		#20 $finish;
	
	end
	
	always begin
	
		#5 Clk <= ~Clk;
	
	end
	
	reg c = 0;
	reg a, b;
	
	always@(posedge Clk) begin
		
		a <= 0;
		b <= 0;
		
		if (c) begin
			a <= 1;
		end else begin
			b <= 1;
		end
		
	end

endmodule
