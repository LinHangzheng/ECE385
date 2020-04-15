module full_adder_9
(
    input   logic[8:0]     A,
    input   logic[8:0]     B,
	 input 	logic				C_in,
    output  logic[7:0]     Sum,
    output  logic          X
);
	 // This 9-bit adder are combined from 2 4-bit full adders and one 1-bit full adder
	 logic c1, c2, c3;
	 full_adder4 FA40(.A(A[3:0]), .B(B[3:0]), .C_in, .Sum(Sum[3:0]), .C_out(c1));
	 full_adder4 FA41(.A(A[7:4]), .B(B[7:4]), .C_in(c1),   .Sum(Sum[7:4]), .C_out(c2));
	 
	 // calculate the last bit for output X 
	 full_adder  FA(.A(A[8]), .B(B[8]), .C_in(c2), .Sum(X),.C_out(c3));
endmodule
