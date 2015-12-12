module control(RegDst, ALUSrc, MemToReg, RegWr, MemWr, Jump, JumpR, ALUcntrl, op, func, readRs, readRt);
	output reg RegDst, ALUSrc, MemToReg, RegWr, MemWr, Jump, JumpR, readRs, readRt;
	output reg [1:0] ALUcntrl;
	input [5:0] op, func;
 
	always @(op or func) 
		case(op)
			6'b000000: 
				if(func == 6'b000000) begin //0000000
					RegDst = 0; ALUSrc = 0; MemToReg = 0; RegWr = 0; MemWr = 0; Jump = 0; JumpR = 0; ALUcntrl = 2'b00; readRs = 0; readRt = 0;
				end else if (func == 6'b001000) begin //jumpR
					RegDst = 1'bx; ALUSrc = 1'bx; MemToReg = 1'bx; RegWr = 0; MemWr = 0; Jump = 0; JumpR = 1; ALUcntrl = 2'bxx; readRs = 1; readRt = 0;
				end else if(func == 6'b100011) begin //subu
					RegDst = 1; ALUSrc = 0; MemToReg = 0; RegWr = 1; MemWr = 0; Jump = 0; JumpR = 0; ALUcntrl = 2'b01; readRs = 1; readRt = 1;
				end else if(func == 6'b101011) begin //sltu
					RegDst = 1; ALUSrc = 0; MemToReg = 0; RegWr = 1; MemWr = 0; Jump = 0; JumpR = 0; ALUcntrl = 2'b11; readRs = 1; readRt = 1;
				end else if(func == 6'b100111) begin //norOp 
					RegDst = 1; ALUSrc = 0; MemToReg = 0; RegWr = 1; MemWr = 0; Jump = 0; JumpR = 0; readRs = 1; readRt = 1;
					ALUcntrl = 2'b10;
				end
			
			6'b100011: 
				begin //lw
					RegDst = 0; ALUSrc = 1; MemToReg = 1; RegWr = 1; MemWr = 0; Jump = 0; JumpR = 0; ALUcntrl = 2'b00; readRs = 1; readRt = 0;
				end
				
			6'b101011: 
				begin //sw
					RegDst = 1'bx; ALUSrc = 1; MemToReg = 1'bx; RegWr = 0; MemWr = 1; Jump = 0; JumpR = 0; ALUcntrl = 2'b00; readRs = 1; readRt = 1;
				end
				
			6'b000010: 
				begin //jump
					RegDst = 1'bx; ALUSrc = 1'bx; MemToReg = 1'bx; RegWr = 0; MemWr = 0; Jump = 1; JumpR = 0; ALUcntrl = 2'bxx; readRs = 0; readRt = 0;
				end
			
			6'b000001: 
				begin //bltz 
					RegDst = 1'bx; ALUSrc = 0; MemToReg = 1'bx; RegWr = 0; MemWr = 0; Jump = 0; JumpR = 0; ALUcntrl = 2'b01; readRs = 1; readRt = 1;
				end
				
			6'b001000: 
				begin //addi 
					RegDst = 0; ALUSrc = 1; MemToReg = 0; RegWr = 1; MemWr = 0; Jump = 0; JumpR = 0; readRs = 1; readRt = 1; ALUcntrl = 2'b00;
				end
			
			default: 
				begin //default
					RegDst = 1'b0; ALUSrc = 1'b0; MemToReg = 1'b0; RegWr = 1'b0; MemWr = 1'b0; Jump = 1'b0; JumpR = 1'b0; ALUcntrl = 2'b00;readRs = 0; readRt = 0;
				end
				
		endcase		
			
endmodule
