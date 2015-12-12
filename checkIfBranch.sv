/*
Check if branch module: Useful in pipelining because you need to know whether you are branching or not without using ALU and 
the extra clock cycle. In this, we make sure that the OP code is that of the BLTZ and if it is then we are good.
*/
module checkIfbranch(in, branchFlag);
	input[5:0] in;
	output branchFlag;
	reg [5:0] temp, op; 
	assign op = 6'b000001;
	genvar i;
	generate
		for (i=0; i<6; i++)begin : eachxor
			xor x (temp[i], in[i],op[i]);
		end
	endgenerate
	nor n(branchFlag, temp[0],temp[1],temp[2],temp[3],temp[4],temp[5]);
	
endmodule

