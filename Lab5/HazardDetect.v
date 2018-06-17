//Subject:     CO project 5 - HazardDetect
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0516215 æž—äº®ç©Ž
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module HazardDetect(
    IDEX_MemRead_i,
    IDEX_Rt_i,
    IFID_Rs_i,
    IFID_Rt_i,
    Branch_i,
    ID_Flush_o,
    IF_Flush_o,
    EX_Flush_o,
    PCWrite_o,
    IFID_Write_o
);
input   IDEX_MemRead_i;		  
input   [5-1:0] IDEX_Rt_i;
input   [5-1:0] IFID_Rs_i;
input   [5-1:0] IFID_Rt_i;
input   Branch_i;


output reg ID_Flush_o;
output reg IF_Flush_o;
output reg EX_Flush_o;
output reg PCWrite_o;
output reg IFID_Write_o;

always@(*) begin
    if(IDEX_MemRead_i == 1 && (IDEX_Rt_i == IFID_Rs_i || IDEX_Rt_i == IFID_Rt_i)) begin
        ID_Flush_o = 1;
        IF_Flush_o = 0;
        EX_Flush_o = 0;
        PCWrite_o = 0;
        IFID_Write_o = 0;
    end
    else if (Branch_i == 1)begin
        ID_Flush_o = 1;
        IF_Flush_o = 1;
        EX_Flush_o = 1;
        PCWrite_o = 1;
        IFID_Write_o = 1;
    end
    else begin
        ID_Flush_o = 0;
        IF_Flush_o = 0;
        EX_Flush_o = 0;
        PCWrite_o = 1;
        IFID_Write_o = 1;  
    end
        
end

endmodule	