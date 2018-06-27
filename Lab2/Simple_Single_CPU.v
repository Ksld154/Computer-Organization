//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      0516215 ???
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [32-1:0] pc_in;
wire [32-1:0] pc_out;
wire [32-1:0] constant4;
wire [32-1:0] pc_plus4;
wire [32-1:0] instr;
wire [32-1:0] RsData;
wire [32-1:0] RtData;
wire [32-1:0] const_extended;
wire [32-1:0] const_shifted;
wire [32-1:0] Mux_ALUSrc_o;
wire [32-1:0] ALU_Result;
wire [32-1:0] BranchAddress;
wire RegDst;
wire RegWrite;
wire ALUSrc;
wire Branch;
wire Zero;
wire [3-1:0] ALU_op;
wire [4-1:0] ALU_Ctrl;
wire [5-1:0] Mux_Write_Reg_o;


assign constant4 = 32'd4;
//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
	.pc_in_i(pc_in) ,   
	.pc_out_o(pc_out) 
);
	
Adder Adder1(
        .src1_i(pc_out),
        .src2_i(constant4),     
	.sum_o(pc_plus4)    
);
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
        .instr_o(instr)    
);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(Mux_Write_Reg_o)
);	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i),     
        .RSaddr_i(instr[25:21]),  
        .RTaddr_i(instr[20:16]),  
        .RDaddr_i(Mux_Write_Reg_o),  
        .RDdata_i(ALU_Result), 
        .RegWrite_i(RegWrite),
        .RSdata_o(RsData),  
        .RTdata_o(RtData)   
);
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	.RegWrite_o(RegWrite), 
        .ALU_op_o(ALU_op),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),   
	.Branch_o(Branch)   
);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALU_Ctrl) 
);
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(const_extended)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RtData),
        .data1_i(const_extended),
        .select_i(ALUSrc),
        .data_o(Mux_ALUSrc_o)
);	
		
ALU ALU(
        .src1_i(RsData),
	.src2_i(Mux_ALUSrc_o),
	.ctrl_i(ALU_Ctrl),
	.result_o(ALU_Result),
	.zero_o(Zero)
);
		
Adder Adder2(                                   //add PC+4 and branch address
        .src1_i(pc_plus4),     
	.src2_i(const_shifted),     
	.sum_o(BranchAddress)      
);
		
Shift_Left_Two_32 Shifter(
        .data_i(const_extended),
        .data_o(const_shifted)
); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(            //choose PC+4 or branch address
        .data0_i(pc_plus4),
        .data1_i(BranchAddress),
        .select_i(Branch & Zero),
        .data_o(pc_in)
);	

endmodule
		  


