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
wire [28-1:0] JumpAddress28;
wire [2-1:0]  RegDst;
wire RegWrite;
wire ALUSrc;
wire Branch;
wire Zero;
wire Jump;
wire MemRead;
wire MemWrite;
wire [2-1:0]  MemtoReg;
wire [32-1:0] Memory_data;
wire [32-1:0] pc_in_step1;
wire [32-1:0] pc_in_step2;
wire [32-1:0] Write_data;

wire [3-1:0] ALU_op;
wire [4-1:0] ALU_Ctrl;
wire [5-1:0] Mux_Write_Reg_o;
wire Jr_Ctrl;

assign constant4 = 32'd4;
assign constant_reg31 = 5'd31;
assign JumpAddress = {pc_plus4[31:28], JumpAddress28};
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

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .data2_i(5'b11111),
        .select_i(RegDst),
        .data_o(Mux_Write_Reg_o)
);	
		
Reg_File Registers(
        .clk_i(clk_i),      
	.rst_i(rst_i),     
        .RSaddr_i(instr[25:21]),  
        .RTaddr_i(instr[20:16]),  
        .RDaddr_i(Mux_Write_Reg_o),  
        .RDdata_i(Write_data),           //need to modify (Done)
        .RegWrite_i(RegWrite & (~Jr_Ctrl)),
        .RSdata_o(RsData),  
        .RTdata_o(RtData)   
);
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	.RegWrite_o(RegWrite), 
        .ALU_op_o(ALU_op),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),   
	.Branch_o(Branch),
        .Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .MemtoReg_o(MemtoReg)   
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
        .data_o(pc_in_step1)
);	


Shift_Left_Two_26 Shifter2(                    //for the address field of jump
        .data_i(instr[25:0]),
        .data_o(JumpAddress28)
); 

MUX_2to1 #(.size(32)) Mux_PC_Source2(          //choose jump address or (branch address/Pc+4)
        .data0_i(pc_in_step1),
        .data1_i({pc_plus4[31:28], JumpAddress28}),
        .select_i(Jump),
        .data_o(pc_in_step2)
);

Data_Memory Data_Memory(
        .clk_i(clk_i),      
        .addr_i(ALU_Result),
	.data_i(RtData),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(Memory_data)
);
MUX_3to1 #(.size(32)) Write_back_reg(          
        .data0_i(ALU_Result),
        .data1_i(Memory_data),
        .data2_i(pc_plus4),
        .select_i(MemtoReg),
        .data_o(Write_data)
);

Jr_Ctrl Jr(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),
        .JrCtrl_o(Jr_Ctrl)
);
MUX_2to1 #(.size(32)) Mux_PC_Source3(          //choose jal address or (branch address/Jump address/Pc+4)
        .data0_i(pc_in_step2),
        .data1_i(RsData),
        .select_i(Jr_Ctrl),
        .data_o(pc_in)
);
endmodule
		  


