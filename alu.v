
`include "constants.v"

module alu(
	input [15:0] A,
	input [15:0] B,
 	input [5:0] Op,
	input CI,			// Carry in, to be taken from the flags register
	output [15:0] Result,
	output [15:0] Flags
	);
		
	reg [16:0] WResult;	// 17bit-wide result -> contains carry over of 16bit operation
	reg CO;				// Carry over to be saved in the flags register
	reg V;				// overflow bit to be saved in the flags register
	wire [16:0] WA, WB;
	wire [16:0] nWBc = {1'b0, ~B + CI};
	wire [16:0] nWB1 = {1'b0, ~B + 16'd1};
	assign WA = {1'b0, A};
	assign WB = {1'b0, B};
	assign Result = WResult[15:0];
	assign Flags = {14'b0, V, CO};		// Flags that are about to be saved in the flags register
	wire [16:0] jo = ~WB + 1;
	
	always @(*) begin
		
		case (Op)
			`ALU_ADD: begin
				WResult <= WA + WB;
				CO <= WResult[16];
				V <= WA[15] && WB[15] && !WResult[15] || !WA[15] && !WB[15] && WResult[15];
			end
			`ALU_ADDC: begin
				WResult <= WA + WB + {16'b0, CI};
				CO <= WResult[16];
				V <= WA[15] && WB[15] && !WResult[15] || !WA[15] && !WB[15] && WResult[15];
			end
			`ALU_SUB: begin
				WResult <= WA + nWB1;
				CO <= WResult[16];
				V <= WA[15] && !WB[15] && !WResult[15] || !WA[15] && WB[15] && WResult[15];
			end
			`ALU_SUBC: begin
				WResult <= WA + nWBc;
				CO <= WResult[16];
				V <= WA[15] && !WB[15] && !WResult[15] || !WA[15] && WB[15] && WResult[15];
			end
		endcase
	
	end
	
endmodule
