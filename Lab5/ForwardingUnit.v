//Subject:     CO project 5 - ForwardingUnit
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0516215 æž—äº®ç©Ž
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module ForwardingUnit(
    EXMEM_RegWrite_i,
    MEMWB_RegWrite_i,
    IDEX_Rs_i,
    IDEX_Rt_i,
    EXMEM_Rd_i,
    MEMWB_Rd_i,
    Forward_A_o,
    Forward_B_o
);
input   EXMEM_RegWrite_i;		  
input   MEMWB_RegWrite_i;
input   [5-1:0] IDEX_Rs_i;
input   [5-1:0] IDEX_Rt_i;
input   [5-1:0] EXMEM_Rd_i;
input   [5-1:0] MEMWB_Rd_i;

output reg  [2-1:0] Forward_A_o;
output reg  [2-1:0] Forward_B_o;

always@(*) begin
    if(EXMEM_RegWrite_i == 1 && EXMEM_Rd_i != 0 && (EXMEM_Rd_i == IDEX_Rs_i))
        Forward_A_o = 2'b10;
    else if(MEMWB_RegWrite_i == 1 && MEMWB_Rd_i != 0 && MEMWB_Rd_i == IDEX_Rs_i)
        Forward_A_o = 2'b01;
    else
        Forward_A_o = 2'b00;

    if(EXMEM_RegWrite_i == 1 && EXMEM_Rd_i != 0 && (EXMEM_Rd_i == IDEX_Rt_i))
        Forward_B_o = 2'b10;
    else if(MEMWB_RegWrite_i == 1 && MEMWB_Rd_i != 0 && MEMWB_Rd_i == IDEX_Rt_i)
        Forward_B_o = 2'b01;
    else
        Forward_B_o = 2'b00;
end

endmodule	