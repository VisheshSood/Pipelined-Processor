/*
This is my ALU modules. As far as I remember, nothing was changed here.
*/
module ALU (A, B, sel, Cout, out, overflow, Z, neg);
	output [31:0] out;
	output Cout, overflow, Z, neg;
	input[31:0] A, B;
	input [1:0] sel;
	reg [31:0] tempC, S;
	wire tempOver, sltFlag, sltOn;
	wire S0, S1;
	
	buf buf0 (S0, sel[0]);
	buf buf1 (S1, sel[1]);
	
	bit1 b(.A(A[0]), .B(B[0]), .Cin(S0), .S0(S0), .S1(S1), .Cout(tempC[0]), .S(S[0]));

	genvar i;
	generate 	
		for(i = 1; i < 32; i++) begin : eachbit1
			bit1 b(.A(A[i]), .B(B[i]), .Cin(tempC[i-1]), .S0(S0), .S1(S1), .Cout(tempC[i]), .S(S[i]));
		end
	endgenerate
	
	buf b1(neg, S[31]);
	buf b2(Cout, tempC[31]);
	xor x1(overflow, tempC[30], tempC[31]);
	not n2(sltFlag, Cout);
	//module zero (S, out);
	zero z1(.S(S),.out(Z));
	//slt
	and a1 (sltOn, S0, S1);
	mux2_alu mux0 (.out(out[0]), .A(S[0]), .B(sltFlag), .sel(sltOn));
	
   genvar j;
	generate
		 for(j=1; j<32; j++) begin : eachMux
			mux2_alu m(.out(out[j]), .A(S[j]), .B(1'b0), .sel(sltOn));
	end
 endgenerate
   		
endmodule

module adder (A, B, Cin, Cout,S);
	input A,B,Cin;
	output Cout;
	output S;
	wire temp1, temp2, temp3, temp4, temp5;
	
	xor s1 (temp1, A, B);
	xor s2 (S, temp1, Cin);
	
	and a1 (temp2, A, B);
	and a2 (temp3, B, Cin);
	and a3 (temp4, A, Cin);
	
	or or1 (temp5, temp2, temp3);
	or or2 (Cout, temp5, temp4);
endmodule

module bit1 (A, B, Cin, S0, S1, Cout, S);
	input A,B,Cin,S0,S1;
	output Cout,S;
	wire notB, out1, out2, out3;
	reg [1:0] sel;
	
	buf (sel[0], S0);
	buf (sel[1], S1);
	
	nor x1 (out3, A, B);
	//and(out4,0,0);
	
	not n (notB, B);
	mux2_alu m(.out(out1), .A(B), .B(notB), .sel(S0));
	adder add1 (.A(A), .B(out1), .Cin(Cin), .Cout(Cout), .S(out2));
	mux4_alu m1 (.out(S), .A(out2),.B(out2),.C(out3),.D(out2), .sel(sel));
	
endmodule

module mux2_alu(out, A,B, sel);
 output out;
 input A,B,sel;
 wire[1:0] m;

 not (nsel, sel);
  and (m[0], B, sel);
  and (m[1], A, nsel);
  or (out, m[0],m[1]);
  
endmodule

module mux4_alu(out, A,B,C,D, sel);
 output out;
 input A,B,C,D;
 input [0:1] sel;
 wire [1:0] v;
 
 mux2_alu m0 (v[0], A,C, sel[0]);
 mux2_alu m1(v[1], B,D, sel[0]);
 mux2_alu m(out, v[0],v[1], sel[1]);
endmodule

module zero (S, out);
	input [0:31] S;
	output out;
	wire [0:7] x;
	wire [1:0] y;
	
	nor (x[0], S[0], S[1], S[2], S[3]);
	nor (x[1], S[4], S[5], S[6], S[7]);
	nor (x[2], S[8], S[9], S[10], S[11]);
	nor (x[3], S[12], S[13], S[14], S[15]);
	
	nor (x[4], S[16], S[17], S[18], S[19]);
	nor (x[5], S[20], S[21], S[22], S[23]);
	nor (x[6], S[24], S[25], S[26], S[27]);
	nor (x[7], S[28], S[29], S[30], S[31]);
	
	and (y[0], x[0], x[1], x[2], x[3]);
	and (y[1], x[4], x[5], x[6], x[7]);
	
	and (out, y[0], y[1]);
endmodule 

module zero_testbench();
	reg [31:0] S;
	wire out;

	zero dut (.S,.out);

	initial begin
		for(int i=0; i<600; i++) begin
			{S} = i; #10;
		end
	end
endmodule 

module adder32(A, B, Cin, Cout, out);
	input [31:0] A, B;
	input Cin;
	output [31:0] out;
	wire [31:0] tempC;
	output Cout;

	adder add1(.A(A[0]), .B(B[0]), .Cin(Cin), .Cout(tempC[0]), .S(out[0]));

	genvar i;
	generate 	
		for(i = 1; i < 32; i++) begin : eachbit
			adder add(.A(A[i]), .B(B[i]), .Cin(tempC[i-1]), .Cout(tempC[i]), .S(out[i]));
		end
	endgenerate
	
endmodule


/*
// Test bench for ALU file
`timescale 1 ps / 100 fs
module ALU_testbench();

	parameter ClockDelay = 100000;

	reg [31:0] A, B;
	reg [1:0] sel;

	wire [31:0] out;
	wire Z, overflow, Cout, neg;

	integer i;

	// If your register file module is not named "alu" then you will
	// have to change the following line in order to create an instance of
	// your register file.  Also you must make sure that the port declarations
	// match up with the module instance in this stimulus file.
	

	ALU ALU1(.A, .B, .sel, .Cout, .out, .overflow, .Z, .neg);

	initial begin

	
		sel=00; 
		A=32'h00000DEF; B=32'h00000ABC; #(ClockDelay); // Should output 000018AB
		A=32'h00001234; B=32'h00000105; #(ClockDelay); // Should output 00001339
		A=32'h7FFFFFFF; B=32'h00000001; #(ClockDelay); // Should output 80000000, overflow, negative	
		A=32'h700000000; B=32'h00000000; #(ClockDelay);

		sel=10;
		A=32'h00000DEF; B=32'h00000ABC; #(ClockDelay); // Should output 00000333	
		A=32'h00001234; B=32'h00000105; #(ClockDelay); // Should output 0000112F
		A=32'h80000000; B=32'h00000001; #(ClockDelay); // Should output 7FFFFFFF, overflow
		
		sel=11;
		A=32'h80000000; B=32'h00000001; #(ClockDelay); // Should output 7FFFFFFF, overflow
		A=32'h7FFFFFFF; B=32'h00000001; #(ClockDelay); // Should output 80000000, overflow, negative	
		
	
	end
endmodule
*/

module ALU_testbench();

	parameter ClockDelay = 100000;

	reg [31:0] A, B;
	reg [1:0] sel;

	//module ALU (A, B, sel, Cout, out, overflow, Z, neg);
	wire [31:0] out;
	wire Z, overflow, Cout, neg;

	integer i;

	// If your register file module is not named "alu" then you will
	// have to change the following line in order to create an instance of
	// your register file.  Also you must make sure that the port declarations
	// match up with the module instance in this stimulus file.
	ALU alu1(.A, .B, .sel, .Cout, .out, .overflow, .Z, .neg);

	initial begin

		/* Addition unit testing */
		sel=00; 
		A=32'h00000DEF; B=32'h00000ABC; #(ClockDelay); // Should output 000018AB
		A=32'h00001234; B=32'h00000105; #(ClockDelay); // Should output 00001339
		A=32'h7FFFFFFF; B=32'h00000001; #(ClockDelay); // Should output 80000000, overflow, negative
		
		/* NOR unit testing */
		sel=10; 
		A=32'h00000DEF; B=32'h00000ABC; #(ClockDelay);
		A=32'h00001234; B=32'h00000105; #(ClockDelay); 
		A=32'h7FFFFFFF; B=32'h00000001; #(ClockDelay); 
		
		/* Subtraction unit testing */
		sel=01; 
		A=32'h00000DEF; B=32'h00000ABC; #(ClockDelay); // Should output 00000333	
		A=32'h00001234; B=32'h00000105; #(ClockDelay); // Should output 0000112F
		A=32'h80000000; B=32'h00000001; #(ClockDelay); // Should output 7FFFFFFF, overflow
		A=32'h00000035; B=32'h000000B5; #(ClockDelay); // Should output 10000000 in binary with neg set
		A=32'h000000B5; B=32'h00000035; #(ClockDelay); // Should output 10000000 in binary
		
		sel=11;
		A=32'h80000000; B=32'h00000001; #(ClockDelay); // Should output 7FFFFFFF, overflow
		A=32'h7FFFFFFF; B=32'h00000001; #(ClockDelay); // Should output 80000000, overflow, negative	
		A=32'h00000000; B=32'h00000001; #(ClockDelay); // Should output slt set	
		A=32'h00000001; B=32'h00000000; #(ClockDelay); // Should output slt not set	
		A=32'h00000AAA; B=32'h00000BBB; #(ClockDelay);
		A=32'h00000AAA; B=32'h00000AAA; #(ClockDelay);
		A=32'h00000CCC; B=32'h00000BBB; #(ClockDelay);
		A=32'h00000DEF; B=32'h00000ABC; #(ClockDelay); 
		A=32'h00001234; B=32'h00000105; #(ClockDelay); 
		A=32'hF0030020; B=32'h00050001; #(ClockDelay); // A is a negative number; MSB set
		A=32'h7FFFFFFF; B=32'h80000000; #(ClockDelay); // A -> largest +ve number; B -> largest -ve; slt=0
		A=32'h80000000; B=32'h7FFFFFFF; #(ClockDelay); // A -> largest -ve number; B -> largest +ve; slt=1
		A=32'h00000000; B=32'h7FFFFFFF; #(ClockDelay); // A -> 0; B -> largest +ve; slt=1
		A=32'h7FFFFFFF; B=32'h00000000; #(ClockDelay); // A -> largest +ve; B -> 0; slt=0
		A=32'h00000000; B=32'h80000000; #(ClockDelay); // A -> 0; B -> largest -ve; slt=0		
		A=32'h80000000; B=32'h00000000; #(ClockDelay); // A -> largest -ve; B -> 0; slt=1
		A=32'h80000000; B=32'h00000001; #(ClockDelay); // 0 < smallest 32-bit number
		A=32'h00000000; B=32'h80000000; #(ClockDelay); // 1 < smallest 32-bit number
		A=32'h00000001; B=32'h80000000; #(ClockDelay); // 1 < smallest 32-bit number
		A=32'h80000000; B=32'h80000000; #(ClockDelay); // smallest 32-bit number < smallest 32-bit number
		A=32'h80000000; B=32'h7FFFFFFF; #(ClockDelay); // smallest 32-bit number < largest 32-bit number
		A=32'h7FFFFFFF; B=32'h80000000; #(ClockDelay); // largest 32-bit number < smallest 32-bit number
		A=32'h7FFFFFFF; B=32'h7FFFFFFF; #(ClockDelay); // largest 32-bit number < largest 32-bit number
		A=32'h00000001; B=32'h00000001; #(ClockDelay); // 1 < 1
		A=32'h000027FA; B=32'h0000F7E7; #(ClockDelay);
		A=32'h00030020; B=32'h00050001; #(ClockDelay);
		
		/* You should test your units EXTENSIVELY here.  We just gave a few ideas
         above to get you started.  Make sure you've checked all outputs for all
         "interesting" cases. */

	end
endmodule
