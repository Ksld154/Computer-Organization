`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
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

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		   bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
);

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
input   [3-1:0] bonus_control; 

output  [32-1:0] result;
output           zero;
output           cout;
output           overflow;

reg     [32-1:0] result;
reg              zero;
reg              cout;
reg              overflow;

wire 	[31:0]   result_temp;
wire    [32-1:0] bit_cout;
wire             overflow_temp;
wire		  	 cout_temp;
wire 			 set;

		alu_top 		 ALU0(.src1(src1[0]), .src2(src2[0]), .less(set),   .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(ALU_control[2]), .operation(ALU_control[1:0]), .result(result_temp[0]), .cout(bit_cout[0]));
		alu_top 		 ALU1(.src1(src1[1]), .src2(src2[1]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[0]), .operation(ALU_control[1:0]), .result(result_temp[1]), .cout(bit_cout[1]));
		alu_top 		 ALU2(.src1(src1[2]), .src2(src2[2]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[1]), .operation(ALU_control[1:0]), .result(result_temp[2]), .cout(bit_cout[2]));
		alu_top 		 ALU3(.src1(src1[3]), .src2(src2[3]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[2]), .operation(ALU_control[1:0]), .result(result_temp[3]), .cout(bit_cout[3]));
		alu_top 		 ALU4(.src1(src1[4]), .src2(src2[4]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[3]), .operation(ALU_control[1:0]), .result(result_temp[4]), .cout(bit_cout[4]));
		alu_top 		 ALU5(.src1(src1[5]), .src2(src2[5]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[4]), .operation(ALU_control[1:0]), .result(result_temp[5]), .cout(bit_cout[5]));
		alu_top 		 ALU6(.src1(src1[6]), .src2(src2[6]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[5]), .operation(ALU_control[1:0]), .result(result_temp[6]), .cout(bit_cout[6]));
		alu_top 		 ALU7(.src1(src1[7]), .src2(src2[7]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[6]), .operation(ALU_control[1:0]), .result(result_temp[7]), .cout(bit_cout[7]));
		alu_top 		 ALU8(.src1(src1[8]), .src2(src2[8]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[7]), .operation(ALU_control[1:0]), .result(result_temp[8]), .cout(bit_cout[8]));
		alu_top 		 ALU9(.src1(src1[9]), .src2(src2[9]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[8]), .operation(ALU_control[1:0]), .result(result_temp[9]), .cout(bit_cout[9]));

		alu_top 		 ALU10(.src1(src1[10]), .src2(src2[10]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[9]), .operation(ALU_control[1:0]), .result(result_temp[10]), .cout(bit_cout[10]));
		alu_top 		 ALU11(.src1(src1[11]), .src2(src2[11]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[10]), .operation(ALU_control[1:0]), .result(result_temp[11]), .cout(bit_cout[11]));
		alu_top 		 ALU12(.src1(src1[12]), .src2(src2[12]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[11]), .operation(ALU_control[1:0]), .result(result_temp[12]), .cout(bit_cout[12]));
		alu_top 		 ALU13(.src1(src1[13]), .src2(src2[13]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[12]), .operation(ALU_control[1:0]), .result(result_temp[13]), .cout(bit_cout[13]));
		alu_top 		 ALU14(.src1(src1[14]), .src2(src2[14]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[13]), .operation(ALU_control[1:0]), .result(result_temp[14]), .cout(bit_cout[14]));
		alu_top 		 ALU15(.src1(src1[15]), .src2(src2[15]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[14]), .operation(ALU_control[1:0]), .result(result_temp[15]), .cout(bit_cout[15]));
		alu_top 		 ALU16(.src1(src1[16]), .src2(src2[16]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[15]), .operation(ALU_control[1:0]), .result(result_temp[16]), .cout(bit_cout[16]));
		alu_top 		 ALU17(.src1(src1[17]), .src2(src2[17]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[16]), .operation(ALU_control[1:0]), .result(result_temp[17]), .cout(bit_cout[17]));
		alu_top 		 ALU18(.src1(src1[18]), .src2(src2[18]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[17]), .operation(ALU_control[1:0]), .result(result_temp[18]), .cout(bit_cout[18]));
		alu_top 		 ALU19(.src1(src1[19]), .src2(src2[19]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[18]), .operation(ALU_control[1:0]), .result(result_temp[19]), .cout(bit_cout[19]));

		alu_top 		 ALU20(.src1(src1[20]), .src2(src2[20]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[19]), .operation(ALU_control[1:0]), .result(result_temp[20]), .cout(bit_cout[20]));
		alu_top 		 ALU21(.src1(src1[21]), .src2(src2[21]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[20]), .operation(ALU_control[1:0]), .result(result_temp[21]), .cout(bit_cout[21]));
		alu_top 		 ALU22(.src1(src1[22]), .src2(src2[22]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[21]), .operation(ALU_control[1:0]), .result(result_temp[22]), .cout(bit_cout[22]));
		alu_top 		 ALU23(.src1(src1[23]), .src2(src2[23]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[22]), .operation(ALU_control[1:0]), .result(result_temp[23]), .cout(bit_cout[23]));
		alu_top 		 ALU24(.src1(src1[24]), .src2(src2[24]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[23]), .operation(ALU_control[1:0]), .result(result_temp[24]), .cout(bit_cout[24]));
		alu_top 		 ALU25(.src1(src1[25]), .src2(src2[25]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[24]), .operation(ALU_control[1:0]), .result(result_temp[25]), .cout(bit_cout[25]));
		alu_top 		 ALU26(.src1(src1[26]), .src2(src2[26]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[25]), .operation(ALU_control[1:0]), .result(result_temp[26]), .cout(bit_cout[26]));
		alu_top 		 ALU27(.src1(src1[27]), .src2(src2[27]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[26]), .operation(ALU_control[1:0]), .result(result_temp[27]), .cout(bit_cout[27]));
		alu_top 		 ALU28(.src1(src1[28]), .src2(src2[28]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[27]), .operation(ALU_control[1:0]), .result(result_temp[28]), .cout(bit_cout[28]));
		alu_top 		 ALU29(.src1(src1[29]), .src2(src2[29]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[28]), .operation(ALU_control[1:0]), .result(result_temp[29]), .cout(bit_cout[29]));
		
		alu_top 		 ALU30(.src1(src1[30]), .src2(src2[30]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[29]), .operation(ALU_control[1:0]), .result(result_temp[30]), .cout(bit_cout[30]));
		alu_bottom 		 ALU31(.src1(src1[31]), .src2(src2[31]), .less(1'b0),  .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(bit_cout[30]), .operation(ALU_control[1:0]), .result(result_temp[31]), .cout(bit_cout[31]), .overflow(overflow_temp), .set(set));

		assign zero_temp = ~(result_temp[0]|result_temp[1]|result_temp[2]|result_temp[3]|result_temp[4]|result_temp[5]|result_temp[6]|result_temp[7]|result_temp[8]|result_temp[9]|result_temp[10]|result_temp[11]|result_temp[12]|result_temp[13]|result_temp[14]|result_temp[15]|result_temp[16]|result_temp[17]|result_temp[18]|result_temp[19]|result_temp[20]|result_temp[21]|result_temp[22]|result_temp[23]|result_temp[24]|result_temp[25]|result_temp[26]|result_temp[27]|result_temp[28]|result_temp[29]|result_temp[30]|result_temp[31]);

always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) begin
		result <= 0;
		zero <= 0;
		cout <= 0;
		overflow <= 0;
	end
	else begin
		result <= result_temp;
		zero <= zero_temp;
		
		if(ALU_control == 4'b0111)begin
			cout <= 0;
			overflow <= 0;
		end
		else begin
			cout <= bit_cout[31];
			overflow <= overflow_temp;
		end
	end
end

endmodule
