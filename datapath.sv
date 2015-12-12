/*
This file contains my datapath. It is essentially a schematic of a pipelined processor in verilog.
It has each individual section of the pipelined processor and is commented for ease of reading.
*/
module datapath(clk, reset);
	input reset, clk;
	reg [25:0] targetInstr;
	reg [15:0] imm16, BranchImm16;
	reg [5:0] Op, Func;
	reg [4:0] Rs, Rt, Rd, RegDstFrom4, RegDstTo2,RegDstFrom2, RegDstFrom3;
	reg [31:2] addr;
	
	/***********************************reg variables for use***********************************************************/
	reg jump, jumpR, RegWrFrom4, MemToRegFrom2, RegWrFrom2, MemWrFrom2, readRs, readRt,branchFrom1, branchTo1,
	RegDst, ALUSrc, MemToRegTo2, RegWr, MemWr, Cout, overflow, Z, neg, MemToRegFrom3, RegWrFrom3, MemWrFrom3;
	
	/********************************32 bit re values for use in storage************************************************/
	reg [31:0] instruction, instr1out, dataToStage2, address, Da, Db, dataFrom4, SE_1mm16, DbFrom2, DaFrom2, aluDataTo2, 
	aluDataFrom2, ALUoutTo3, ALUoutFrom3, memOut, dataTo4, DbFrom3, fwdedDa, fwdedDb;
	
	/************************************assigning values for inputs****************************************************/
	reg [1:0] temp, ALUcntrl, ALUcntrlFrom2;
	buf tem1(temp[0], 1'b0);
	buf tem2(temp[1], 1'b0);
	assign address = {addr, temp[1:0]};
 
	assign Op = instr1out[31:26];
	assign Rs = instr1out[25:21];
	assign Rt = instr1out[20:16];
	assign Rd = instr1out[15:11]; 
	assign imm16 = instr1out[15:0];
	assign Func =  instr1out[5:0];
	assign targetInstr = instr1out[25:0];
 
	/*************************************** IF/ID **************************************************/
	fetchUnit fetchU (addr, targetInstr, fwdedDa[31:2], neg, branchTo1, jump, jumpR, imm16, reset, clk);
	InstructionMem inst(instruction, address); 
	checkIfbranch check(Op,branchTo1); 								//check if it is branch and set a flag
	//save instruction read from stage 1
	register32 regi32(instr1out, instruction, reset, clk);	
	
	/*************************************** ID/EX **************************************************/
	control controlU (RegDst, ALUSrc, MemToRegTo2, RegWr, MemWr, jump, jumpR, ALUcntrl, Op, Func, readRs, readRt);
	
	//choose desitination of writeto regfile
	genvar m;
	generate 	
		for(m = 0; m < 5; m++) begin : dest
			mux2_r muxs2(Rt[m], Rd[m], RegDst, RegDstTo2[m]);
		end
	endgenerate

	register5 regdstto2 (RegDstFrom2, RegDstTo2, reset, clk);		//save RegDstTo2
	regfile reg1(Da, Db, dataFrom4, Rs, Rt, RegDstFrom4, RegWrFrom4, ~clk);
	//ForwardingUnit
	forwardingUnit fwrd(Da, Db, ALUoutTo3, dataTo4, Rs, Rt, RegDstFrom2, RegDstFrom3, readRs, readRt, fwdedDa, fwdedDb);

	D_FF memtoreg2 (MemToRegFrom2, MemToRegTo2, reset, clk); 	//save MemToRegTo2
	D_FF regwr2 (RegWrFrom2, RegWr, reset, clk);						//save RegWr
	D_FF MemWr2 (MemWrFrom2, MemWr, reset, clk);						//save MemWr				
	
	register2 alufrom2 (ALUcntrlFrom2, ALUcntrl, reset, clk);	//save ALUcntrl

	SE se32(SE_1mm16, imm16);
	
	genvar i;
	generate 	
		for(i = 0; i < 32; i++) begin : alu
			mux2_r mux2(fwdedDb[i], SE_1mm16[i], ALUSrc, aluDataTo2[i]);
		end
	endgenerate
	
	register32 aluDatato2 (aluDataFrom2, aluDataTo2, reset, clk);	// save aluDataTo2	
	register32 Dafrom2 (DaFrom2, fwdedDa, reset, clk);					// save Da from stage 2
	register32 Dbfrom2 (DbFrom2, fwdedDb, reset, clk); 				// save Db from stage 2

	/*************************************** EX/MEM **************************************************/
	ALU ALU3 (DaFrom2, aluDataFrom2, ALUcntrlFrom2, Cout, ALUoutTo3, overflow, Z, neg);
	register32 aluoutto3 (ALUoutFrom3, ALUoutTo3, reset, clk);		//save aluoutTo3
	register5 regdstto3 (RegDstFrom3, RegDstFrom2, reset, clk);		//save RegDstFrom3
	D_FF memtoreg3 (MemToRegFrom3, MemToRegFrom2, reset, clk);		//save MemToRegFrom3
	D_FF regwr3 (RegWrFrom3, RegWrFrom2, reset, clk);					//save RegWrFrom3
	D_FF MemWr3 (MemWrFrom3, MemWrFrom2, reset, clk);					//save MemWrFrom3
	register32 Db3 (DbFrom3, DbFrom2, reset, clk);						//save DbFrom3
	
	/*************************************** MEM/WB **************************************************/
	dataMem datamem4 (memOut, ALUoutFrom3, DbFrom3, MemWrFrom3, clk);
	
	//mux of MemToReg
	genvar j;
	generate 	
		for(j = 0; j < 32; j++) begin : alu1
			mux2_r mux4(ALUoutFrom3[j], memOut[j], MemToRegFrom3, dataTo4[j]);
		end
	endgenerate

	register32 datato4(dataFrom4, dataTo4, reset, clk); 				//save dataFrom4
	D_FF regwrfrom4 (RegWrFrom4, RegWrFrom3, reset, clk); 			//save RegWrFrom4
	register5 regdstfrom4 (RegDstFrom4, RegDstFrom3, reset, clk); 	//save RegDstFrom4
	
endmodule


module datapath_testbench();
	reg reset, clk;

	datapath datapath1(.clk, .reset);

	parameter ClockDelay = 1000;
	initial clk = 1;
	always begin
		#(ClockDelay/2); 
		clk = ~clk;
	end
	
	initial begin
		reset = 1;  # (ClockDelay/2);
		reset = 0;  # (ClockDelay/2);# (800*ClockDelay); 
		$stop();
	end
	
endmodule