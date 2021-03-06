/*
This file contains my registers and muxes.
*/
module mux2_1(out, in, sel);
	output out;
	input [1:0] in;
	input sel;
	
	wire[1:0] m;
	not (nsel, sel);
	and (m[0], in[1], sel);
	and (m[1], in[0], nsel);
	or (out, m[0],m[1]);
endmodule

module mux2_r (d0, d1, A, Y);
	input d0, d1;
	input A; 
	output Y; 
	not (notA, A); 
	and (y0, d0, notA); 
	and (y1, d1, A); 
	or (Y, y0, y1); 
endmodule 

module mux4_1(out, in1, sel);
	output out;
	input [3:0] in1;
	input [1:0] sel;
	wire [1:0] v;
	mux2_1 m0 (v[0], in1[1:0], sel[0]);
	mux2_1 m1(v[1], in1[3:2], sel[0]);
	mux2_1 m(out, v[1:0], sel[1]);
endmodule

module mux8_1(out, in2, sel);
	output out;
	input [7:0] in2;
	input [2:0] sel;
	wire [1:0] v;
	mux4_1 m0 (v[0], in2[3:0], sel[1:0]);
	mux4_1 m1(v[1], in2[7:4], sel[1:0]);
	mux2_1 m(out, v[1:0], sel[2]);
endmodule


module mux32_1(out, in3, sel);
	output out;
	input [31:0] in3;
	input [4:0] sel;
	wire [3:0] v;
	
	mux8_1 m0 (v[0], in3[7:0],sel[2:0]);
	mux8_1 m1 (v[1], in3[15:8],sel[2:0]);
	mux8_1 m2 (v[2], in3[23:16],sel[2:0]);
	mux8_1 m3 (v[3], in3[31:24],sel[2:0]);
	mux4_1 m4 (out, v[3:0],sel[4:3]);
endmodule

module mux32_32(out, in, sel);
	output [31:0]out;
	input [31:0][31:0] in;
	input [4:0] sel;
	reg [31:0][31:0]temp;
	
	genvar row, col;
	generate
		for(row = 0; row < 32; row++) begin : eachrow
			for(col = 0; col < 32; col++) begin: eachcol
				buf (temp[row][col], in[col][row]);
			end
		end
	endgenerate
	
	genvar data;
	generate
		for(data = 0; data < 32; data++) begin : eachbit
			mux32_1 m(.out(out[data]), .in3(temp[data]), .sel);		
		end
	endgenerate
endmodule

module D_FF (q, d, reset, clk);
	output reg q;
	input d, reset, clk;
	
	always @(posedge clk)
		if (reset)
			q <= 0; // On reset, set to 0
		else
			q <= d; // Otherwise out = d
endmodule 

module register (out, in, En, clk, reset);
 	input in, clk, En, reset;
	output wire out;
	reg mux_out;
	
	mux2_r m (out, in , En, mux_out);
	D_FF d (out, mux_out, reset, clk);
	
endmodule 

module register_32 (out, in, En, clk, reset);
 	input [31:0] in;
	input clk, reset, En;
	output wire [31:0] out;
	
	genvar i;
	generate
		for(i = 0; i < 32; i++) begin : eachregister
			register r(out[i], in[i], En, clk, reset);
		end
	endgenerate
endmodule 

module register_module (out, in, En, clk);
 	input [31:0] in;
	input [31:0] En;
	input clk;
	output [31:0][31:0] out;
	reg reset;
	reg [31:0]zero;

	assign out[0] = 0;
	genvar data;
	generate
		for(data = 1; data < 32; data++) begin : eachbit
			 register_32 r  (.out(out[data]), .in(in), .En(En[data]), .clk, .reset);		
		end
	endgenerate
endmodule


module register32(out, in, reset, clk);
	input [31:0] in;
	input reset, clk;
	output [31:0] out;
	genvar i;
	generate 	
		for(i = 0; i < 32; i++) begin : eachDFF
			D_FF d(.q(out[i]), .d(in[i]), .reset(reset), .clk(clk));
		end
	endgenerate
endmodule

module register16(out, in, reset, clk);
	input [15:0] in;
	input reset, clk;
	output [15:0] out;
	genvar i;
	generate 	
		for(i = 0; i < 16; i++) begin : eachDFF
			D_FF d(.q(out[i]), .d(in[i]), .reset(reset), .clk(clk));
		end
	endgenerate
endmodule

module register5(out, in, reset, clk);
	input [4:0] in;
	input reset, clk;
	output [4:0] out;
	genvar i;
	generate 	
		for(i = 0; i < 5; i++) begin : eachDF
			D_FF d(.q(out[i]), .d(in[i]), .reset(reset), .clk(clk));
		end
	endgenerate
endmodule
 
module register2(out, in, reset, clk);
	input [1:0] in;
	input reset, clk;
	output [1:0] out;
	genvar i;
	generate 	
		for(i = 0; i < 2; i++) begin : eachDF
			D_FF d(.q(out[i]), .d(in[i]), .reset(reset), .clk(clk));
		end
	endgenerate
endmodule



module dec2_4 (out, in, En);
	input [1:0] in;
	input En;
	output [3:0] out;
	reg [3:0] out;
	reg [1:0] v;
	
	not(v[0], in[0]);
	not(v[1], in[1]);
	
	and(out[0],v[0],v[1],En);
	and(out[1],in[0],v[1],En);
	and(out[2],v[0],in[1],En);
	and(out[3],in[0],in[1],En);
	
endmodule

module dec3_8 (out, in, En);
	input [2:0] in;
	input En;
	output [7:0] out;
	reg [7:0] out;
	reg [2:0] v;
	
	not(v[0],in[0]);
	not(v[1],in[1]);
	not(v[2],in[2]);
	
	and(out[0],v[0],v[1],v[2],En);
	and(out[1],in[0],v[1],v[2],En);
	and(out[2],v[0],in[1],v[2],En);
	and(out[3],in[0],in[1],v[2],En);
	and(out[4],v[0],v[1],in[2],En);
	and(out[5],in[0],v[1],in[2],En);
	and(out[6],v[0],in[1],in[2],En);
	and(out[7],in[0],in[1],in[2],En);
	
endmodule

module dec5_32 (out, in, En);
	input [4:0] in;
	input En;
	output [31:0] out;
	reg [3:0] temp;
	reg [31:0] out;
	
	dec2_4 m0 (temp[3:0], in[4:3],En);
	dec3_8 m1 (out[31:24], in[2:0], temp[3]);
	dec3_8 m2 (out[23:16], in[2:0], temp[2]);
	dec3_8 m3 (out[15:8], in[2:0], temp[1]);
	dec3_8 m4 (out[7:0], in[2:0], temp[0]);
	
endmodule


module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input RegWrite, clk;
	input [4:0] WriteRegister;
	input [31:0] WriteData;
	input [4:0] ReadRegister1;
	input [4:0] ReadRegister2;
	output [31:0] ReadData1;
	output [31:0] ReadData2;

	reg [31:0] dec_out;
	reg [31:0][31:0] regi_out;

	dec5_32 dec (dec_out, WriteRegister, RegWrite);
	register_module register1 (regi_out, WriteData, dec_out, clk);
	mux32_32 mux_1 (ReadData1, regi_out, ReadRegister1);
	mux32_32 mux_2 (ReadData2, regi_out, ReadRegister2);
	
endmodule

module regfile_testbench(); 		

	parameter ClockDelay = 5000;

	reg [4:0] ReadRegister1, ReadRegister2, WriteRegister;
	reg [31:0] WriteData;
	reg RegWrite, clk;
	wire [31:0] ReadData1, ReadData2;

	integer i;

	// Your register file MUST be named "regfile".
	// Also you must make sure that the port declarations
	// match up with the module instance in this stimulus file.
	regfile reg1(.ReadData1, .ReadData2, .WriteData, 
			  .ReadRegister1, .ReadRegister2, .WriteRegister,
			  .RegWrite, .clk);

	initial clk = 0;
	always begin
		#(ClockDelay/2); 
		clk = ~clk;
	end

	initial begin
		// Try to write the value 0xA0 into register 0.
		// Register 0 should always be at the value of 0.
		RegWrite <= 0;
		ReadRegister1 <= 0;
		ReadRegister2 <= 0;
		WriteRegister <= 0;
		WriteData <= 32'hA0;				@(posedge clk);
		RegWrite <= 1;					@(posedge clk);

		// Write a value into each  register.
		for (i=1; i<32; i=i+1) begin
			RegWrite <= 0;
			ReadRegister1 <= i-1;
			ReadRegister2 <= i;
			WriteRegister <= i;
			WriteData <= i*32'h01020408;	@(posedge clk);
			RegWrite <= 1;				@(posedge clk);
		end

		// Go back and verify that the registers
		// retained the data.
		for (i=0; i<32; i=i+1) begin
			RegWrite <= 0;
			ReadRegister1 <= i-1;
			ReadRegister2 <= i;
			WriteRegister <= i;
			WriteData <= i*32'h100+i;		@(posedge clk);
		end
		$stop;
	end
endmodule
