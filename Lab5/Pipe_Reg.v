`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0516215 林亮穎
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
    clk_i,
    rst_i,
    pipereg_write_i,
    data_i,
    data_o
    );
					
parameter size = 0;

input       clk_i;		  
input       rst_i;
input       pipereg_write_i;
input       [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else if(pipereg_write_i == 0)
        data_o <= data_o;
    else if(pipereg_write_i == 1)
        data_o <= data_i;
end

endmodule	