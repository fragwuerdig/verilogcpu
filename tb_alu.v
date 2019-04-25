
`include "constants.v"
`include "alu.v"

module tb_paging;
	
	reg Clk = 0;
	reg [15:0] A, B;
	reg [5:0] Op;
	reg C;
	
	initial
	begin
			$dumpfile("tb_alu.vcd");
			$dumpvars;
						
			A <= 16'b1111111111111111;
			B <= 16'b1000000000000000;
			Op <= `ALU_ADD;
			#10 A <= 16'b0111111111111111;
			B <= 16'b0000000000000001;
			Op <= `ALU_ADD;
			#10 A <= 16'b1111111111111111;
			B <= 16'b0000000000000001;
			Op <= `ALU_ADD;
			
			#10 A <= 16'b1111111111111110;
			B <= 16'b1000000000000000;
			C <= 1;
			Op <= `ALU_ADDC;
			#10 A <= 16'b0111111111111111;
			B <= 16'b0000000000000000;
			Op <= `ALU_ADDC;
			#10 A <= 16'b1111111111111111;
			B <= 16'b0000000000000000;
			Op <= `ALU_ADDC;
			
			#10 A <= -32768;
			B <= 1;
			C <= 1;
			Op <= `ALU_SUB;
			
			#10 A <= 1;
			B <= 2;
			C <= 1;
			Op <= `ALU_SUB;
			
			#10 A <= 32767;
			B <= -20000;
			C <= 1;
			Op <= `ALU_SUB;
			
			#10000 $finish;
			
	end
	
	always
	begin
		#5 Clk <= ~Clk;
	end
	
	alu ALU(
		.A(A),
		.B(B),
		.Op(Op),
		.CI(C)
	);

endmodule