//Sign Extend Modules
//made some minor changes in names and formatting for easier use.
module SE(out, in);
	output [31:0] out;
	input [15:0] in;
	wire temp;
	
	buf tem(temp, in[15]);
	
	genvar i;
	generate 	
		for(i = 0; i < 16; i++) begin : copyvalue
			buf b1(out[i], in[i]);
		end
	endgenerate
	
	genvar j;
	generate 	
		for(j = 16; j < 32; j++) begin : copyzeros
			buf b2(out[j], temp);
		end
	endgenerate
	
endmodule

module SE30(out, in);
	output [29:0] out;
	input [15:0] in;
	wire temp;
	
	buf tem(temp, in[15]);
	
	genvar i;
	generate 	
		for(i = 0; i < 16; i++) begin : copyvalue
			buf b1(out[i], in[i]);
		end
	endgenerate
	
	genvar j;
	generate 	
		for(j = 16; j < 30; j++) begin : copyzeros
			buf b2(out[j], temp);
		end
	endgenerate
	
endmodule

module SE0(out, in);
	output [31:0] out;
	input [15:0] in;
	wire temp;
	
	buf tem(temp, 1'b0);
	
	genvar i;
	generate 	
		for(i = 0; i < 16; i++) begin : copyvalue
			buf b1(out[i], in[i]);
		end
	endgenerate
	
	genvar j;
	generate 	
		for(j = 16; j < 32; j++) begin : copyzeros
			buf b2(out[j], temp);
		end
	endgenerate
	
endmodule

/*
module SE0_testbench();

	parameter ClockDelay = 100000;
	reg [15:0] in;
	wire [31:0] out;
	

	SE0 SE1(.out, .in);

	initial begin

		in=16'b11111111111111111;  #(ClockDelay);
		in=16'b10111100110001111;  #(ClockDelay);
		in=16'b01111111111111111;  #(ClockDelay);
		in=16'b01111111000100101;  #(ClockDelay);
		in=16'b00000000000000000;  #(ClockDelay);
		in=16'b01111000000100111;  #(ClockDelay);

	end
endmodule*/