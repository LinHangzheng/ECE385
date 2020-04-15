// 2-to-1 MUX
module Mux2 #(parameter w = 16)
				(input logic Select,
				input logic [w-1:0] A,
				input logic [w-1:0] B,
				output logic [w-1:0] Out);
	always_comb
	// use select to choose inputs
	begin
		if (Select)
			Out = B;
		else
			Out = A;	
	end
endmodule

// 4-to-1 MUX
module Mux4 #(parameter w = 16)
			  (input logic [1:0] Select,
				input logic [w-1:0] A,
				input logic [w-1:0] B,
				input logic [w-1:0] C,
				input logic [w-1:0] D,
				output logic [w-1:0] Out);
	always_comb
	begin
	// use select to choose inputs
		case(Select)
			2'b00: Out = A;
			2'b01: Out = B;
			2'b10: Out = C;
			2'b11: Out = D;
		endcase
	end
endmodule

// MUX for BUS only
module Mux_Bus #(parameter w = 16)
			  (input logic [3:0] Select,
				input logic [w-1:0] A,
				input logic [w-1:0] B,
				input logic [w-1:0] C,
				input logic [w-1:0] D,
				output logic [w-1:0] Out);
	always_comb
	begin
	// USE select (one hot structure) to choose inputs
		case(Select)
			4'b0001: Out = A;
			4'b0010: Out = B;
			4'b0100: Out = C;
			4'b1000: Out = D;
			default: Out = 16'h0000;
			
		endcase
	end
endmodule


