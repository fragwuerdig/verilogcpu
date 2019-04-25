//`include "constants.v"

module datapath(
	input Clk,
	input Rst,
	input [4:0] SrcIP,
	input [4:0] SrcMemAddr,
	input [4:0] SrcMemData,
	input [4:0] SrcSP,
	input [4:0] SrcFlags,
	input [4:0] SrcA,
	input [4:0] SrcB,
	input [15:0] ALUOut,
	input [15:0] ALUFlags,
	input [15:0] Imm,
	input [15:0] MemData,
	output reg [15:0] RegFlags,
	output reg [15:0] RegMemAddr,
	output reg [15:0] RegMemData,
	output reg [15:0] RegSP,
	output reg [15:0] RegA,
	output reg [15:0] RegB
	);
	
	reg [15:0] RegIP;		// Instruction pointer
	
//	always @(*)
//	begin
//	
//		if (Rst)
//		begin
//			RegMemAddr <= 0;
//			RegIP <= 0;
//		end
//	
//	end
	
	always @(posedge Clk or posedge Rst)
	begin
		
		if (Rst) begin
			RegIP <= 16'h0;
			RegMemAddr <= 16'h0;
			RegSP <= 16'h0;
		end else begin
			case (SrcIP)
				`SELECT_ZERO: 	RegIP <= 16'h0;
				`SELECT_NONE:	RegIP <= RegIP;
				`SELECT_INC:	RegIP <= RegIP + 1;
				`SELECT_DEC:	RegIP <= RegIP - 1;
				default: RegIP <= RegIP;
			endcase
			
			case (SrcMemAddr)
				`SELECT_ZERO: 	RegMemAddr <= 16'h0;
				`SELECT_NONE:	RegMemAddr <= RegMemAddr;
				`SELECT_IP:	RegMemAddr <= RegIP;
				`SELECT_SP:	RegMemAddr <= RegSP;
				default: RegMemAddr <= RegMemAddr;
			endcase
			
			case (SrcSP)
				`SELECT_ZERO: 	RegSP <= 16'h0;
				`SELECT_INC: 	RegSP <= RegSP + 16'h1;
				`SELECT_DEC:	RegSP <= RegSP - 16'h1;
				`SELECT_NONE:	RegSP <= RegSP;
				default: RegSP <= RegSP;
			endcase
			
			case (SrcA)
				`SELECT_ZERO: 	RegA <= 16'h0;
				`SELECT_NONE:	RegA <= RegA;
				`SELECT_ALU:	RegA <= ALUOut;
				`SELECT_MEM:	RegA <= MemData;
				default: RegA <= RegA;
			endcase
			
			case (SrcB)
				`SELECT_ZERO: 	RegB <= 16'h0;
				`SELECT_NONE:	RegB <= RegB;
				`SELECT_MEM:	RegB <= MemData;
				default: RegB <= RegB;
			endcase
			
			case(SrcMemData)
				`SELECT_IMM: RegMemData <= Imm;
				`SELECT_ALU: RegMemData <= ALUOut;
				`SELECT_SP: RegMemData <= RegSP;
				default: RegMemData <= RegMemData;
			endcase
			
			case(SrcFlags)
				`SELECT_ALU: RegFlags <= ALUFlags;
				default: RegFlags <= RegFlags;
			endcase
					
		end
		
	end
	
endmodule