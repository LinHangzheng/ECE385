module full_adder
(
    input   logic     A, B, C_in,
    output  logic     Sum, C_out
);

	 assign Sum = A^B^C_in;								// get sum
	 assign C_out = (A&B)|(A&C_in)|(B&C_in);		// get carray out
	 
endmodule

module full_adder4
(
    input   logic     [3:0]A,
	 input   logic     [3:0]B,
	 input 	logic		 		C_in,
    output  logic     [3:0]Sum,
	 output 	logic				C_out
);

	 logic 	 c1,c2,c3;
	 
	 // Here, we combine four full adders 
	 
	 full_adder FA0(.A(A[0]),.B(B[0]),.C_in(C_in),.Sum(Sum[0]),.C_out(c1));
	 full_adder FA1(.A(A[1]), .B(B[1]), .C_in(c1), .Sum(Sum[1]), .C_out(c2));
	 full_adder FA2(.A(A[2]), .B(B[2]), .C_in(c2), .Sum(Sum[2]), .C_out(c3));
	 full_adder FA3(.A(A[3]), .B(B[3]), .C_in(c3), .Sum(Sum[3]), .C_out(C_out));
	 
endmodule
