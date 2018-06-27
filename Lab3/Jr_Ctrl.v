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

module Jr_Ctrl(
        funct_i,
        ALUOp_i,
        JrCtrl_o
);
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     JrCtrl_o;    
     
//Internal Signals

//Parameter
       
//Select exact operation
/*
always @(funct_i, ALUOp_i)begin
    if(funct_i == 6'b001000 && ALUOp_i == 2'b10)
        JrCtrl_o = 1;
    else
        JrCtrl_o = 0;
end
*/
assign  JrCtrl_o = (funct_i == 6'b001000 && ALUOp_i == 2'b10) ? 1'b1 : 1'b0;
endmodule     





                    
                    