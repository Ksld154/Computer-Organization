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


/**** ID stage ****/
wire [32-1:0] ID_pc_plus4;
wire [32-1:0] ID_instr;
wire [32-1:0] RsData;
wire [32-1:0] RtData;
wire [32-1:0] const_extended;

//control signal
wire RegDst;
wire ALUSrc;
wire [3-1:0] ALUop;
wire Branch;
wire MemRead;
wire MemWrite;
wire MemtoReg;
wire RegWrite;


/**** EX stage ****/
wire [32-1:0] EX_pc_plus4;
wire [32-1:0] EX_RsData;
wire [32-1:0] EX_RtData;
wire [32-1:0] EX_const_extended;
wire [5-1:0]  EX_RtNum;
wire [5-1:0]  EX_RdNum;
wire [32-1:0] const_shifted;
wire [32-1:0] ALUInput2;
wire [32-1:0] ALUResult;
wire [32-1:0] BranchAddress;
wire [5-1:0]  WriteRegNum;
wire [4-1:0]  ALUCtrl;
wire Zero;

//control signal
wire EX_RegDst;
wire EX_ALUSrc;
wire [3-1:0] EX_ALUop;
wire EX_Branch;
wire EX_MemRead;
wire EX_MemWrite;
wire EX_MemtoReg;
wire EX_RegWrite;


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
	.pc_in_i(pc_in) ,   
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
		
Pipe_Reg #(.size(32)) IF_ID_PC4(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(pc_plus4),
    .data_o(ID_pc_plus4)
);
Pipe_Reg #(.size(32)) IF_ID_instr(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(instr),
    .data_o(ID_instr)
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

Pipe_Reg #(.size(10)) ID_EX_Signals(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i({ 
        ALUSrc, ALUop, RegDst,
        Branch, MemRead, MemWrite,
        MemtoReg, RegWrite}),
    .data_o({ 
        EX_ALUSrc, EX_ALUop, EX_RegDst,
        EX_Branch, EX_MemRead, EX_MemWrite,
        EX_MemtoReg, EX_RegWrite})
);

Pipe_Reg #(.size(32)) ID_EX_PC4(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(ID_pc_plus4),
    .data_o(EX_pc_plus4)
);
Pipe_Reg #(.size(32)) ID_EX_RsData(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(RsData),
    .data_o(EX_RsData)
);
Pipe_Reg #(.size(32)) ID_EX_RtData(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(RtData),
    .data_o(EX_RtData)
);
Pipe_Reg #(.size(32)) ID_EX_const_extended(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(const_extended),
    .data_o(EX_const_extended)
);
Pipe_Reg #(.size(5)) ID_EX_RtNum(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(ID_instr[20:16]),
    .data_o(EX_RtNum)
);
Pipe_Reg #(.size(5)) ID_EX_RdNum(       //N is the total length of input/output
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(ID_instr[15:11]),
    .data_o(EX_RdNum)
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

MUX_2to1 #(.size(32)) Mux_ALUSrc(
    .data0_i(EX_RtData),
    .data1_i(EX_const_extended),
    .select_i(EX_ALUSrc),
    .data_o(ALUInput2)
);

ALU_Ctrl ALU_Ctrl(
    .funct_i(EX_const_extended[5:0]),   
    .ALUOp_i(EX_ALUop),   
    .ALUCtrl_o(ALUCtrl) 
);

ALU ALU(
    .src1_i(EX_RsData),
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

Pipe_Reg #(.size(5)) EX_MEM_signals(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i({ 
        EX_Branch, EX_MemRead, EX_MemWrite,
        EX_MemtoReg, EX_RegWrite}),
    .data_o({
        MEM_Branch, MEM_MemRead, MEM_MemWrite,
        MEM_MemtoReg, MEM_RegWrite})
);
Pipe_Reg #(.size(32)) EX_MEM_BranchAddress(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(BranchAddress),
    .data_o(MEM_BranchAddress)
);

Pipe_Reg #(.size(32)) EX_MEM_ALUResult(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(ALUResult),
    .data_o(MEM_ALUResult)
);
Pipe_Reg #(.size(32)) EX_MEM_RtData(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(EX_RtData),
    .data_o(MEM_RtData)
);
Pipe_Reg #(.size(5)) EX_MEM_WriteRegNum(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(WriteRegNum),
    .data_o(MEM_WriteRegNum)
);
Pipe_Reg #(.size(1)) EX_MEM_Zero(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(Zero),
    .data_o(MEM_Zero)
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
    .data_i({MEM_MemtoReg, MEM_RegWrite}),
    .data_o({WB_MemtoReg,  WB_RegWrite})
);
Pipe_Reg #(.size(32)) MEM_WB_MemoryData(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(MemoryData),
    .data_o(WB_MemoryData)
);
Pipe_Reg #(.size(32)) MEM_WB_ALUResult(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(MEM_ALUResult),
    .data_o(WB_ALUResult)
);
Pipe_Reg #(.size(5)) MEM_WB_WriteRegNum(
    .clk_i(clk_i),      
    .rst_i(rst_i),  
    .data_i(MEM_WriteRegNum),
    .data_o(WB_WriteRegNum)
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
????
****************************************/
assign PCSrc = MEM_Branch & MEM_Zero;
assign constant4 = 32'd4;
endmodule