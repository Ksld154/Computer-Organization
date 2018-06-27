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
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
wire 		   R_type;
wire		   addi;
wire           slti;
wire           beq;
//Parameter


//Main function

assign R_type = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&(~instr_op_i[2])&(~instr_op_i[1])&(~instr_op_i[0]);
assign addi   = (~instr_op_i[5])&(~instr_op_i[4])&(instr_op_i[3] )&(~instr_op_i[2])&(~instr_op_i[1])&(~instr_op_i[0]);
assign slti   = (~instr_op_i[5])&(~instr_op_i[4])&(instr_op_i[3] )&(~instr_op_i[2])&(instr_op_i[1] )&(~instr_op_i[0]);
assign beq    = (~instr_op_i[5])&(~instr_op_i[4])&(~instr_op_i[3])&(instr_op_i[2] )&(~instr_op_i[1])&(~instr_op_i[0]);

always @(instr_op_i)begin

	RegDst_o     <= R_type;
	RegWrite_o   <= R_type | addi | slti;
	Branch_o     <= beq;
	ALUSrc_o     <= addi | slti;
	ALU_op_o[2]  <= 0;
	ALU_op_o[1]  <= R_type | slti;
	ALU_op_o[0]  <= beq | slti; 

end
endmodule





                    
                    