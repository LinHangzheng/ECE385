module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

	  	 
	 logic c1, c2, c3;
	 full_adder4 FA40(.A(A[3:0]),.B(B[3:0]),.C_in(1'b0), .Sum(Sum[3:0]),.C_out(c1));
	 full_adder4 FA41(.A(A[7:4]),   .B(B[7:4]),   .C_in(c1),   .Sum(Sum[7:4]),   .C_out(c2));
	 full_adder4 FA42(.A(A[11:8]),  .B(B[11:8]),  .C_in(c2),   .Sum(Sum[11:8]),  .C_out(c3));
	 full_adder4 FA43(.A(A[15:12]), .B(B[15:12]), .C_in(c3),   .Sum(Sum[15:12]), .C_out(CO));
	
	
endmodule
