//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:       0516215 ???
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  signed[32-1:0]  src1_i;
input  signed[32-1:0]  src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
assign zero_o = (result_o == 0);

always @(*)begin
	case(ctrl_i)
		4'b0000: result_o <= src1_i & src2_i;
		4'b0001: result_o <= src1_i | src2_i;
		4'b0010: result_o <= src1_i + src2_i;
		4'b0110: result_o <= src1_i - src2_i;
		4'b0111: result_o <= (src1_i < src2_i) ? 1 : 0;
		4'b1000: result_o <= src1_i * src2_i;
		10:      result_o <= (src1_i != src2_i) ? 0 : 1;    //bne  when s1!=s2,set result = 0, zero = 1(same as beq)
		11:      result_o <= (src1_i >= src2_i) ? 0 : 1;    //bge  when s1>=s2,set result = 0, zero = 1
		12:      result_o <= (src1_i >  src2_i) ? 0 : 1;    //bgt  when s1> s2,set result = 0, zero = 1
	  	default: result_o <= 0;
	endcase
end
//($signed(a) < $signed(b))
endmodule




                    
                    