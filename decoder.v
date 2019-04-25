`include "constants.v"



module decoder(
	input Clk,
	input Rst, 
	input [4:0] SrcIR,
	input [15:0] MemIn,
	output [5:0] OpGrp,
	output [5:0] ALUOp,
	output [4:0] RegSelect,
	output [15:0] Imm
	);
	
	reg [15:0] RegIR;
	
	assign OpGrp =
		(RegIR[15]) ? `OP_GROUP_IMM :
		(RegIR == 0) ? `OP_GROUP_NOP :
			RegIR[14:9];
	assign Imm = {RegIR[14], RegIR[14:0]};
	assign ALUOp = (OpGrp == `OP_GROUP_ARITH1 || OpGrp == `OP_GROUP_ARITH2) ? { (OpGrp == `OP_GROUP_ARITH2) ? 1'b1 : 1'b0 , RegIR[4:0] } : `ALU_NOP;
	assign RegSelect = (OpGrp == `OP_GROUP_GETREG || OpGrp == `OP_GROUP_SETREG) ? RegIR[4:0] : `SELECT_NONE;
	
	always @(posedge Clk)
	begin
			
		case (SrcIR)
			`SELECT_NONE:
				RegIR <= RegIR;
			`SELECT_ZERO:
				RegIR <= 0;
			`SELECT_MEM:
				RegIR <= MemIn;
			default:
				RegIR <= RegIR;
		endcase
	
	end
	
endmodule
