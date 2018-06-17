//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0516215 ???
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(funct_i, ALUOp_i)begin
    if(ALUOp_i == 3)      ALUCtrl_o <= 4'b0111;  //slti
    else if(ALUOp_i == 0) ALUCtrl_o <= 4'b0010;  //lw sw
    else if(ALUOp_i == 1) ALUCtrl_o <= 4'b0110;  //beq
    else if(ALUOp_i == 2) begin
        case (funct_i)
            6'b100000: ALUCtrl_o <= 4'b0010;   //add  2
            6'b100010: ALUCtrl_o <= 4'b0110;   //sub  6
            6'b100100: ALUCtrl_o <= 4'b0000;   //and  0
            6'b100101: ALUCtrl_o <= 4'b0001;   //or   1
            6'b101010: ALUCtrl_o <= 4'b0111;   //slt  7
            6'b011000: ALUCtrl_o <= 4'b1000;   //mult 8
        endcase
    end
    else if(ALUOp_i == 5) ALUCtrl_o <= 10;  //bne
    else if(ALUOp_i == 6) ALUCtrl_o <= 11;  //bge
    else if(ALUOp_i == 7) ALUCtrl_o <= 12;  //bgt
    /*
	ALUCtrl_o[3] <= 0;
    ALUCtrl_o[2] <= (ALUOp_i[1]&funct_i[1]) | (ALUOp_i[0]);
	ALUCtrl_o[1] <= (ALUOp_i[1]&ALUOp_i[0]) | (~ALUOp_i[1]) | (~funct_i[2]);
	ALUCtrl_o[0] <= (ALUOp_i[1]&ALUOp_i[0]) | (ALUOp_i[1]&(~ALUOp_i[0])&(funct_i[3]|funct_i[0]));
    */
end
endmodule     





                    
                    