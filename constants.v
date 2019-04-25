
`define SELECT_NONE		5'h00
`define SELECT_A 		5'h01
`define SELECT_B 		5'h02
`define SELECT_ALU 		5'h03
`define SELECT_MEM		5'h04
`define SELECT_IP		5'h05
`define SELECT_INC 		5'h06
`define SELECT_DEC 		5'h07
`define SELECT_IMM		5'h08
`define SELECT_IR		5'h09
`define SELECT_SP		5'h0A
`define SELECT_ZERO		5'h1F

`define STATE_RESET 	5'h00
`define STATE_FETCH1	5'h01
`define STATE_FETCH2	5'h02
`define STATE_EXEC		5'h03
`define STATE_TRAP		5'h04
`define STATE_IMM2		5'h05
`define STATE_IMM3		5'h06
`define STATE_ARITH1_1	5'h07
`define STATE_ARITH1_2	5'h08
`define STATE_ARITH1_3	5'h09
`define STATE_ARITH2_1	5'h0A
`define STATE_ARITH2_2	5'h0B
`define STATE_ARITH2_3	5'h0C
`define STATE_ARITH2_4	5'h0D
`define STATE_ARITH2_5	5'h0E
`define STATE_ARITH2_6	5'h0F
`define STATE_SETREG_1	5'h10
`define STATE_GETREG_1	5'h11
`define STATE_SETREG_2	5'h12
`define STATE_GETREG_2	5'h13

`define PLEVEL_PRIVILIGED	0
`define PLEVEL_UNPRIVILIGED	1

`define OP_GROUP_NOP	6'h00
`define OP_GROUP_IMM	6'h01
`define OP_GROUP_ARITH1	6'h02
`define OP_GROUP_ARITH2	6'h03
`define OP_GROUP_GETREG	6'h04
`define OP_GROUP_SETREG	6'h05

`define ALU_NOP			6'h00
`define ALU_ADD			6'h20
`define ALU_ADDC		6'h21
`define ALU_SUB			6'h22
`define ALU_SUBC		6'h23
`define ALU_AND			6'h24
`define ALU_OR			6'h25

`define ALU_NOT			6'h01



`define BOOL_PAGING_ENABLED(f) (16'd1 & f)
