module forwardingcntrl(Da, Db, ALUoutTo3, dataTo4,  Rs, Rt, RegDstFrom2, RegDstFrom3, readRs, readRt, fwdedDa, fwdedDb);
	input [31:0] Da, Db, ALUoutTo3, dataTo4;
	input [4:0] Rs, Rt, RegDstFrom2, RegDstFrom3;
	input readRs, readRt;
	output [31:0] fwdedDa, fwdedDb;
	reg rsSelA,rsSelB, rtSelA, rtSelB, rsDataSel1, rsDataSel2, rtDataSel1, rtDataSel2; 
	reg[31:0] Dasel1out, Dbsel1out; 

	//get rsSelA and rsSelB depending on if Rs or Rt is same to RegDest
	chooseData chooseRs (Rs, RegDstFrom2, RegDstFrom3, rsSelA, rsSelB);
	chooseData chooseRt (Rt, RegDstFrom2, RegDstFrom3, rtSelA, rtSelB);

	//select if alu or mem have been used depending on  readRs/Rt
	mux2_r rsdatasel1 (1'b0, rsSelB, readRs, rsDataSel2);
	mux2_r rsdatasel2 (1'b0, rsSelA, readRs, rsDataSel1);
	mux2_r rtdatasel1 (1'b0, rtSelB, readRt, rtDataSel2);
	mux2_r rtdatasel2 (1'b0, rtSelA, readRt, rtDataSel1);

	//choose data to output from Da, mem and Aluout
	mux32 rsdatasel1out (rsDataSel1, Da, ALUoutTo3, Dasel1out);
	mux32 rsDatasel2out (rsDataSel2, Dasel1out, dataTo4, fwdedDa);
	mux32 rtdatasel1out (rtDataSel1, Db, ALUoutTo3, Dbsel1out);
	mux32 rtDatasel2out (rtDataSel2, Dbsel1out, dataTo4, fwdedDb);
endmodule

module chooseData(R, d1, d2, sel1, sel2);
	input [4:0] R, d1, d2;
	output reg sel1, sel2;

	always @(*) begin 
		if(R == 5'b00000) begin
			sel1 = 0;
			sel2 = 0;
		end else if(R == d1) begin
			sel1 = 1;
			sel2 = 0;
		end else if(R == d2) begin
			sel1 = 0;
			sel2 = 1;
		end else begin
			sel1 = 0;
			sel2 = 0;
		end
	end
		
endmodule

module mux32 (S, A, B, Y);
	input [31:0] A, B;
	input S;
	output [31:0]Y;
	
	genvar i;
	generate
		for (i=0; i<32; i++)begin : eachMux2_32
		//mux2_r (d0, d1, A, Y);
			mux2_r m(A[i], B[i], S, Y[i]);
		end
	endgenerate
endmodule 