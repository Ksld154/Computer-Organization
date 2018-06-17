`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0516215 林亮穎
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/

/**** IF stage ****/
wire [32-1:0] pc_in;
wire [32-1:0] pc_out;
wire [32-1:0] constant4;
wire [32-1:0] pc_plus4;
wire [32-1:0] instr;
wire PCSrc;
wire [32-1:0] pc_plus4_1;
wire [32-1:0] instr_1;

/**** ID stage ****/
wire [32-1:0] ID_pc_plus4;
wire [32-1:0] ID_instr;
wire [32-1:0] RsData;
wire [32-1:0] RtData;
wire [32-1:0] const_extended;
wire IFID_Write;
wire PCWrite;
//wire Flush;
wire IF_Flush;
wire ID_Flush;
wire EX_Flush;


//control signal
wire RegDst;
wire ALUSrc;
wire [3-1:0] ALUop;
wire Branch;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire RegWrite;
wire RegDst_1;
wire ALUSrc_1;
wire [3-1:0] ALUop_1;
wire Branch_1;
wire MemRead_1;
wire MemWrite_1;
wire MemtoReg_1;
wire RegWrite_1;

/**** EX stage ****/
wire [32-1:0] EX_pc_plus4;
wire [32-1:0] EX_RsData;
wire [32-1:0] EX_RtData;
wire [32-1:0] EX_const_extended;
wire [5-1:0]  EX_RsNum;
wire [5-1:0]  EX_RtNum;
wire [5-1:0]  EX_RdNum;
wire [32-1:0] const_shifted;
wire [32-1:0] ALUInput2;
wire [32-1:0] ALUResult;
wire [32-1:0] BranchAddress;
wire [5-1:0]  WriteRegNum;
wire [4-1:0]  ALUCtrl;
wire [32-1:0] ALUInput1;
wire [32-1:0] EX_RtData_1;

wire Zero;
wire [2-1:0]  Forward_A;
wire [2-1:0]  Forward_B;

//control signal
wire EX_RegDst;
wire EX_ALUSrc;
wire [3-1:0] EX_ALUop;
wire EX_Branch;
wire EX_MemRead;
wire EX_MemWrite;
wire EX_MemtoReg;
wire EX_RegWrite;
wire EX_Branch_1;
wire EX_MemRead_1;
wire EX_MemWrite_1;
wire EX_MemtoReg_1;
wire EX_RegWrite_1;


/**** MEM stage ****/
wire [32-1:0] MEM_BranchAddress;
wire [32-1:0] MEM_ALUResult;
wire [32-1:0] MEM_RtData;
wire [5-1:0]  MEM_WriteRegNum;
wire [32-1:0] MemoryData;
wire MEM_Zero;

//control signal
wire MEM_Branch;
wire MEM_MemRead;
wire MEM_MemWrite;
wire MEM_MemtoReg;
wire MEM_RegWrite;
//wire WB_RegWrite;  //already declared in EX stage

/**** WB stage ****/
wire [32-1:0] WB_MemoryData;
wire [32-1:0] WB_ALUResult;
wire [5-1:0]  WB_WriteRegNum;
wire [32-1:0] WriteData;

//control signal
wire WB_RegWrite;
wire WB_MemtoReg;


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage	
MUX_2to1 #(.size(32)) Mux_PCSrc(    //choose branch address or PC+4
    .data0_i(pc_plus4), 
    .data1_i(MEM_BranchAddress),   //should put ALUResult from MEM stage                       
    .select_i(PCSrc),
    .data_o(pc_in)
);


ProgramCounter PC(
    .clk_i(clk_i),      
    .rst_i(rst_i),
    .pc_write_i(PCWrite),     
	.pc_in_i(pc_in),   
	.pc_out_o(pc_out) 
);

Adder Add_pc(
    .src1_i(pc_out),
    .src2_i(constant4),     
	.sum_o(pc_plus4)  
);

Instruction_Memory IM(
    .addr_i(pc_out),  
    .instr_o(instr)    
);		

MUX_2to1 #(.size(64)) Mux_IF_Flush(
    .data0_i({pc_plus4, instr}),
    .data1_i(64'b0),
    .select_i(IF_Flush),
    .data_o({pc_plus4_1, instr_1})
);

Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),
    .pipereg_write_i(IFID_Write),  
    .data_i({pc_plus4_1, instr_1}),
    .data_o({ID_pc_plus4, ID_instr})
);

//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),      
    .rst_i(rst_i),     
    .RSaddr_i(ID_instr[25:21]),  
    .RTaddr_i(ID_instr[20:16]),  
    .RDaddr_i(WB_WriteRegNum),  
    .RDdata_i(WriteData),           //need to modify (Done)
    .RegWrite_i(WB_RegWrite),
    .RSdata_o(RsData),  
    .RTdata_o(RtData)  
);

Decoder Control(
    .instr_op_i(ID_instr[31:26]), 
    .RegWrite_o(RegWrite), 
    .ALU_op_o(ALUop),   
    .ALUSrc_o(ALUSrc),   
    .RegDst_o(RegDst),   
    .Branch_o(Branch),
    .MemRead_o(MemRead),
    .MemWrite_o(MemWrite),
    .MemtoReg_o(MemtoReg) 
);

Sign_Extend Sign_Extend(
    .data_i(ID_instr[15:0]),
    .data_o(const_extended)
);	

HazardDetect HD(
    .IDEX_MemRead_i(EX_MemRead),
    .IDEX_Rt_i(EX_RtNum),
    .IFID_Rs_i(ID_instr[25:21]),
    .IFID_Rt_i(ID_instr[20:16]),
    .Branch_i(PCSrc),
    .ID_Flush_o(ID_Flush),
    .IF_Flush_o(IF_Flush),
    .EX_Flush_o(EX_Flush),
    //.Flush_o(Flush),
    .PCWrite_o(PCWrite),
    .IFID_Write_o(IFID_Write)
);

MUX_2to1 #(.size(10)) Control_Flush(
    .data0_i({ 
        ALUSrc, ALUop, RegDst,
        Branch, MemRead, MemWrite,
        MemtoReg, RegWrite}),
    .data1_i(10'b0),
    .select_i(ID_Flush),
    .data_o({ 
        ALUSrc_1, ALUop_1, RegDst_1,
        Branch_1, MemRead_1, MemWrite_1,
        MemtoReg_1, RegWrite_1})
);


Pipe_Reg #(.size(10)) ID_EX_Signals(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .pipereg_write_i(1'b1),  
    .data_i({ 
        ALUSrc_1, ALUop_1, RegDst_1,
        Branch_1, MemRead_1, MemWrite_1,
        MemtoReg_1, RegWrite_1}),
    .data_o({ 
        EX_ALUSrc, EX_ALUop, EX_RegDst,
        EX_Branch, EX_MemRead, EX_MemWrite,
        EX_MemtoReg, EX_RegWrite})
);

Pipe_Reg #(.size(143)) ID_EX(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),
    .pipereg_write_i(1'b1),  
    .data_i({ID_pc_plus4, RsData, RtData, const_extended, ID_instr[25:21], ID_instr[20:16], ID_instr[15:11]}),
    .data_o({EX_pc_plus4, EX_RsData, EX_RtData, EX_const_extended, EX_RsNum, EX_RtNum, EX_RdNum})
);


//Instantiate the components in EX stage	   

Shift_Left_Two_32 Shifter(
    .data_i(EX_const_extended),
    .data_o(const_shifted)
);
	
Adder Add_pc_branch(
    .src1_i(EX_pc_plus4),     
	.src2_i(const_shifted),     
	.sum_o(BranchAddress) 
);

ALU_Ctrl ALU_Ctrl(
    .funct_i(EX_const_extended[5:0]),   
    .ALUOp_i(EX_ALUop),   
    .ALUCtrl_o(ALUCtrl) 
);

MUX_3to1 #(.size(32)) Mux_ALU_input1(
    .data0_i(EX_RsData),
    .data1_i(WriteData),
    .data2_i(MEM_ALUResult),
    .select_i(Forward_A),
    .data_o(ALUInput1)
);

MUX_3to1 #(.size(32)) Mux_ALU_input2(
    .data0_i(EX_RtData),
    .data1_i(WriteData),
    .data2_i(MEM_ALUResult),
    .select_i(Forward_B),
    .data_o(EX_RtData_1)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
    .data0_i(EX_RtData_1),
    .data1_i(EX_const_extended),
    .select_i(EX_ALUSrc),
    .data_o(ALUInput2)
);


ALU ALU(
    .src1_i(ALUInput1),
	.src2_i(ALUInput2),
	.ctrl_i(ALUCtrl),
	.result_o(ALUResult),
	.zero_o(Zero)
);
		
MUX_2to1 #(.size(5)) Mux_WriteRegNum(
    .data0_i(EX_RtNum),
    .data1_i(EX_RdNum),
    .select_i(EX_RegDst),
    .data_o(WriteRegNum)
);

ForwardingUnit FW(
    .EXMEM_RegWrite_i(MEM_RegWrite),
    .MEMWB_RegWrite_i(WB_RegWrite),
    .IDEX_Rs_i(EX_RsNum),                 //need to modify ID/EX pipe_reg? (Done)
    .IDEX_Rt_i(EX_RtNum),
    .EXMEM_Rd_i(MEM_WriteRegNum),
    .MEMWB_Rd_i(WB_WriteRegNum),
    .Forward_A_o(Forward_A),
    .Forward_B_o(Forward_B)
);


MUX_2to1 #(.size(5)) Mux_EX_Flush(
    .data0_i({ 
        EX_Branch, EX_MemRead, EX_MemWrite,
        EX_MemtoReg, EX_RegWrite}),
    .data1_i(5'b0),
    .select_i(EX_Flush),
    .data_o({ 
        EX_Branch_1, EX_MemRead_1, EX_MemWrite_1,
        EX_MemtoReg_1, EX_RegWrite_1})
);


Pipe_Reg #(.size(5)) EX_MEM_signals(
    .clk_i(clk_i),      
    .rst_i(rst_i),
    .pipereg_write_i(1'b1),  
    .data_i({ 
        EX_Branch_1, EX_MemRead_1, EX_MemWrite_1,
        EX_MemtoReg_1, EX_RegWrite_1}),
    .data_o({
        MEM_Branch, MEM_MemRead, MEM_MemWrite,
        MEM_MemtoReg, MEM_RegWrite})
);
Pipe_Reg #(.size(102)) EX_MEM(
    .clk_i(clk_i),      
    .rst_i(rst_i), 
    .pipereg_write_i(1'b1), 
    .data_i({BranchAddress, ALUResult, EX_RtData, WriteRegNum, Zero}),
    .data_o({MEM_BranchAddress, MEM_ALUResult, MEM_RtData, MEM_WriteRegNum, MEM_Zero})
);



//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),      
    .addr_i(MEM_ALUResult),
	.data_i(MEM_RtData),
	.MemRead_i(MEM_MemRead),
	.MemWrite_i(MEM_MemWrite),
	.data_o(MemoryData)
);

Pipe_Reg #(.size(2)) MEM_WB_Signals(
    .clk_i(clk_i),      
    .rst_i(rst_i),
    .pipereg_write_i(1'b1),    
    .data_i({MEM_MemtoReg, MEM_RegWrite}),
    .data_o({WB_MemtoReg,  WB_RegWrite})
);
Pipe_Reg #(.size(69)) MEM_WB(
    .clk_i(clk_i),      
    .rst_i(rst_i),
    .pipereg_write_i(1'b1),  
    .data_i({MemoryData, MEM_ALUResult, MEM_WriteRegNum}),
    .data_o({WB_MemoryData, WB_ALUResult, WB_WriteRegNum})
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux_WriteData(
    .data0_i(WB_ALUResult),
    .data1_i(WB_MemoryData),
    .select_i(WB_MemtoReg),
    .data_o(WriteData)
);

/****************************************
signal assignment
****************************************/
assign PCSrc = MEM_Branch & MEM_Zero;
assign constant4 = 32'd4;
endmodule