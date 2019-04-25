
`include "constants.v"

module control(
	input Clk,
	input Rst,
	
	output reg [4:0] SrcA,
	output reg [4:0] SrcB,
	output reg [4:0] SrcIP,
	output reg [4:0] SrcIR,
	output reg [4:0] SrcSP,
 	output reg [4:0] SrcMemAddr,
	output reg [4:0] SrcMemData,
	output reg [4:0] SrcFlags,
	
	input MemOK,
	output reg MemOE,
	output reg MemRRq,
	output reg MemWRq,
	output reg MemAck,
	input [15:0] CurrPTE,
	input [5:0] OpGrp,
	input [4:0] RegSelect,
	output reg PLevel
	
	);
		
	reg [4:0] State;
	reg [4:0] NewState;
	
	//wire Page
	
	wire x = (PLevel == `PLEVEL_PRIVILIGED && CurrPTE[12] == 1) ? 1 : 
				(PLevel == `PLEVEL_UNPRIVILIGED && CurrPTE[13] == 1) ? 1 : 0;
	wire r = (PLevel == `PLEVEL_PRIVILIGED) ? 1 : 
				(PLevel == `PLEVEL_UNPRIVILIGED && CurrPTE[15] == 1) ? 1 : 0;
	wire w = (PLevel == `PLEVEL_PRIVILIGED ) ? 1 : 
				(PLevel == `PLEVEL_UNPRIVILIGED && CurrPTE[14] == 1) ? 1 : 0;
	
	task MemRead0;
	input [4:0] AddrSrc;
	begin
		MemOE <= 0;
		SrcMemAddr <= AddrSrc;
	end
	endtask
	
	task MemWrite0;
	input [4:0] AddrSrc;
	input [4:0] DataSrc;
	begin
		MemOE <= 1;
		SrcMemData <= DataSrc;
		SrcMemAddr <= AddrSrc;
	end
	endtask
	
	task MemRead1;
	input [4:0] ReadTgt;
	input [4:0] StateOnOK;
	input [4:0] StateOnWait;
	input [4:0] StateOnFail;
	begin
		MemRRq <= 1;
		if (ReadTgt == `SELECT_IR) begin
			if (~x) begin
				if (PLevel == `PLEVEL_PRIVILIGED)
					NewState <= `STATE_RESET;
				else
					NewState <= StateOnFail;
			end else begin
				if (MemOK) begin
					SrcIR <= `SELECT_MEM;
					NewState <= StateOnOK;
				end else
					NewState <= StateOnWait;
			end
		end else begin
			if (~r) begin
				if (PLevel == `PLEVEL_PRIVILIGED)
					NewState <= `STATE_RESET;
				else
					NewState <= StateOnFail;
			end else begin
				if (MemOK) begin
					case (ReadTgt)
						`SELECT_IR: SrcIR <= `SELECT_MEM; 
						`SELECT_IP: SrcIP <= `SELECT_MEM;
						`SELECT_SP: SrcSP <= `SELECT_MEM;
						`SELECT_A: SrcA <= `SELECT_MEM;
						`SELECT_B: SrcB <= `SELECT_MEM;
					endcase
					NewState <= StateOnOK;
				end else
					NewState <= StateOnWait;
			end
		end
	end
	endtask
	
	task MemWrite1;
	input [4:0] StateOnOK;
	input [4:0] StateOnWait;
	input [4:0] StateOnFail;
	begin
		MemWRq <= 1;
		if (~w) begin
			if (PLevel == `PLEVEL_PRIVILIGED)
				NewState <= `STATE_RESET;
			else
				NewState <= StateOnFail;
		end else begin
			if (MemOK) begin
				NewState <= StateOnOK;
			end else
				NewState <= StateOnWait;
		end
		
	end
	endtask
	
	always @(negedge Clk)
	begin
		
		//SrcMemData <= `SELECT_NONE;
		SrcMemAddr <= `SELECT_NONE;
		SrcIP <= `SELECT_NONE;
		SrcIR <= `SELECT_NONE;
		SrcA <= `SELECT_NONE;
		SrcB <= `SELECT_NONE;
		SrcSP <= `SELECT_NONE;
		SrcFlags <= `SELECT_NONE;
		
		MemRRq <= 0;
		MemWRq <= 0;
		MemAck <= 0;
	
		case (State)
		
			
			`STATE_RESET: begin
				MemOE <= 0;
				SrcMemAddr <= `SELECT_ZERO;
				SrcIP <= `SELECT_ZERO;
				SrcIR <= `SELECT_ZERO;
				PLevel <= 0;
				if (Rst)
					NewState <= `STATE_RESET;
				else
					NewState <= `STATE_FETCH1;
			end
		
			//// FETCH CYCLE ////

			`STATE_FETCH1: begin
				MemRead0(`SELECT_IP);
				SrcIP <= `SELECT_INC;
				NewState <= `STATE_FETCH2;
			end
			
			`STATE_FETCH2:
				MemRead1(`SELECT_IR, `STATE_EXEC, `STATE_FETCH2, `STATE_TRAP);
			
			`STATE_EXEC: begin
				case(OpGrp)
					`OP_GROUP_NOP: begin
						NewState <= `STATE_FETCH1;
					end
					`OP_GROUP_IMM: begin
						SrcSP <= `SELECT_DEC;
						NewState <= `STATE_IMM2;
					end
					`OP_GROUP_ARITH1: begin
						NewState <= `STATE_ARITH1_1;
					end
					`OP_GROUP_ARITH2: begin
						NewState <= `STATE_ARITH2_1;
					end
					`OP_GROUP_GETREG: begin
						SrcSP <= `SELECT_DEC;
						NewState <= `STATE_GETREG_1;
					end
					`OP_GROUP_SETREG: begin
						NewState <= `STATE_SETREG_1;
					end
				endcase
			end
			
			//// IMM CYCLE ////
			
			`STATE_IMM2: begin
				MemWrite0(`SELECT_SP, `SELECT_IMM);
				NewState <= `STATE_IMM3;
			end
			
			
			`STATE_IMM3:
				MemWrite1(`STATE_FETCH1, `STATE_IMM3, `STATE_TRAP);
			
			//// ARITH1 CYCLE ////
			
			`STATE_ARITH1_1: begin
				MemRead1(`SELECT_A, `STATE_ARITH1_2, `STATE_ARITH1_1, `STATE_TRAP);
			end
			
			
			`STATE_ARITH1_2: begin
				MemWrite0(`SELECT_SP, `SELECT_ALU);
				SrcFlags <= `SELECT_ALU;
				NewState <= `STATE_ARITH1_3;
			end
			
			
			`STATE_ARITH1_3: begin
				MemWrite1(`STATE_FETCH1, `STATE_ARITH1_3, `STATE_TRAP);
			end
			
			//// ARITH2 CYCLE ////
			
			`STATE_ARITH2_1: begin
				SrcSP <= `SELECT_INC;
				MemRead0(`SELECT_SP);
				NewState <= `STATE_ARITH2_2;
			end
			
			`STATE_ARITH2_2: begin
				MemRead1(`SELECT_B, `STATE_ARITH2_3, `STATE_ARITH2_2, `STATE_TRAP);
			end
			
			`STATE_ARITH2_3: begin
				MemRead0(`SELECT_SP);
				NewState <= `STATE_ARITH2_4;
			end
			
			`STATE_ARITH2_4: begin
				MemRead1(`SELECT_A, `STATE_ARITH2_5, `STATE_ARITH2_4, `STATE_TRAP);
			end
			
			`STATE_ARITH2_5: begin
				MemWrite0(`SELECT_SP, `SELECT_ALU);
				SrcFlags <= `SELECT_ALU;
				NewState <= `STATE_ARITH2_6;
			end
			
			`STATE_ARITH2_6: begin
				MemWrite1(`STATE_FETCH1, `STATE_ARITH2_6, `STATE_TRAP);
			end
			
			//// GET REG CYCLE ////
			
			`STATE_GETREG_1: begin
				
				MemWrite0(`SELECT_SP, RegSelect);
				NewState <= `STATE_GETREG_2;
			end
			
			`STATE_GETREG_2: begin
				MemWrite1(`STATE_FETCH1, `STATE_GETREG_2, `STATE_TRAP);
			end
			
			//// PUT REG CYCLE ////
			
			default: NewState <= `STATE_RESET;
		endcase
	
	end
	
	always @(posedge Clk)
	begin
	
		State <= NewState;
	
	end
	
	
endmodule
