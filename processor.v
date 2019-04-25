
`include "datapath.v"
`include "control.v"
`include "decoder.v"
`include "paging.v"
`include "alu.v"

module processor(
	input Clk,
	input Rst,
	input OK,
	output [19:0] Addr,
	output Ack,
	output RRq,
	output WRq,
	inout [15:0] Data
	);
	
	assign Data = (CU.MemOE) ? DP.RegMemData : 16'bZ;
	
	control CU(
		.Rst(Rst),
		.Clk(Clk),
		.MemRRq(RRq),
		.MemWRq(WRq),
		.MemOK(OK),
		.OpGrp(DU.OpGrp),
		.CurrPTE(ATU.PTE),
		.RegSelect(DU.RegSelect)
		);
		
	decoder DU(
		.Rst(Rst),
		.Clk(Clk),
		.SrcIR(CU.SrcIR),
		.MemIn(Data)
		);
		
	datapath DP(
		.Rst(Rst),
		.Clk(Clk),
		.SrcIP(CU.SrcIP),
		.SrcSP(CU.SrcSP),
		.SrcA(CU.SrcA),
		.SrcB(CU.SrcB),
		.SrcMemData(CU.SrcMemData),
		.SrcFlags(CU.SrcFlags),
		.ALUOut(ALU.Result),
		.ALUFlags(ALU.Flags),
		.Imm(DU.Imm),
		.SrcMemAddr(CU.SrcMemAddr),
		.MemData(Data)
		
	);
	
	paging ATU(
		.Clk(Clk),
		.Rst(Rst),
		//input WE,
		.PLevel(CU.PLevel),
		//input [5:0] WPTI,
		//input [15:0] WPTE,
		.VAddr(DP.RegMemAddr),
		.LAddr(Addr)
	);
	
	alu ALU(
		.A(DP.RegA),
		.B(DP.RegB),
		.CI(DP.RegFlags[0]),
		.Op(DU.ALUOp)
		//.Results
		//.Flags
	);
	
	
endmodule
