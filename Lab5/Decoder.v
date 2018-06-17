//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0516215 ???
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	//Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
//output 		   Jump_o;
output		   MemRead_o;
output		   MemWrite_o;
output		   MemtoReg_o;

 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//reg 		   Jump_o;
reg			   MemRead_o;
reg		   	   MemWrite_o;
reg		       MemtoReg_o;
//reg		   	   BranchType_o;
//reg 		   Jr_o;

wire 		   R_type;
wire		   addi;
wire           slti;
wire           beq;
wire		   lw;
wire		   sw;
//wire		   jump;
//wire		   jal;
//wire		   jr;


//Parameter


//Main function

assign R_type = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&(~instr_op_i[2])&(~instr_op_i[1])&(~instr_op_i[0]);  //000000
assign addi   = (~instr_op_i[5])&(~instr_op_i[4])&( instr_op_i[3])&(~instr_op_i[2])&(~instr_op_i[1])&(~instr_op_i[0]);  //001000
assign slti   = (~instr_op_i[5])&(~instr_op_i[4])&( instr_op_i[3])&(~instr_op_i[2])&( instr_op_i[1])&(~instr_op_i[0]);  //001010
assign beq    = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&( instr_op_i[2])&(~instr_op_i[1])&(~instr_op_i[0]);  //000100
assign lw     = ( instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&(~instr_op_i[2])&( instr_op_i[1])&( instr_op_i[0]);  //100011
assign sw     = ( instr_op_i[5])&(~instr_op_i[4])&( instr_op_i[3])&(~instr_op_i[2])&( instr_op_i[1])&( instr_op_i[0]);  //101011


assign bne    = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&( instr_op_i[2])&(~instr_op_i[1])&( instr_op_i[0]);  //000101 5
assign bge    = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&(~instr_op_i[2])&(~instr_op_i[1])&( instr_op_i[0]);  //000001 6 
assign bgt    = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&( instr_op_i[2])&( instr_op_i[1])&( instr_op_i[0]);  //000111 7

//assign jump   = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&(~instr_op_i[2])&( instr_op_i[1])&(~instr_op_i[0]);  //000010
//assign jal    = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&(~instr_op_i[2])&( instr_op_i[1])&( instr_op_i[0]);  //000011
//assign jr     = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&(~instr_op_i[2])&(~instr_op_i[1])&(~instr_op_i[0]);  //000000


always @(instr_op_i)begin

	RegDst_o     <= R_type;
	RegWrite_o   <= R_type |  addi | slti | lw;
	Branch_o     <= beq | bne | bge | bgt;
	ALUSrc_o     <= addi | slti | lw | sw;

	MemRead_o	 <= lw;
	MemWrite_o   <= sw;
	MemtoReg_o   <= lw;
	//Jump_o       <= jump;
	//Jr_o         <= jr;

	ALU_op_o[2]  <= bne | bge | bgt;
	ALU_op_o[1]  <= R_type | slti | bge | bgt;
	ALU_op_o[0]  <= beq | slti | bne | bgt; 

end
endmodule





                    
                    