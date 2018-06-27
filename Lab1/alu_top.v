`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout        //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;
reg			  cout;
reg 		  src1_not, src2_not;

always@(*)
	begin
		assign 		src1_not = ~src1;
		assign 		src2_not = ~src2;

		case(operation)
			2'b00:
					begin
						if(A_invert == 1'b0 && B_invert == 1'b0)
							{cout, result} = src1 && src2;
						else if(A_invert == 1'b1 && B_invert == 1'b1)
							{cout, result} = src1_not && src2_not;       
					end	
			
			2'b01:	{cout, result} = src1 | src2;
			2'b10:	
					begin
						if(A_invert == 1'b0 && B_invert == 1'b0)	     
							{cout, result} = src1 + src2 + cin;
						else if(A_invert == 1'b0 && B_invert == 1'b1)	 
							{cout, result} = src1 + (src2_not) + cin; 
					end
			
			2'b11:	begin
						result = less;                       		 /*slt*/	
						cout = (src1_not & src2) | cin&(src1_not^src2);
					end
		endcase
	end

endmodule
