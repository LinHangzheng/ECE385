module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
	  logic  c8_0, c8_1, c12_0, c12_1, cout_0, cout_1;
	  logic 	c4, c8, c12;
	  logic[11:0]	Sum0, Sum1;
	  always_comb
	  begin
	  
	  // calculate the carray out
	  c8  = (c4 & c8_1) | c8_0;
	  c12 = (c8 & c12_1) | c12_0;
	  CO  = (c12 & cout_1) | cout_0;
	  
	  // choose the correct sum value for Sum[7:4]
	  if (c4)
			Sum[7:4] = Sum1[3:0];
	  else
			Sum[7:4] = Sum0[3:0];
			
	  // choose the correct sum value for Sum[11:8]
	  if (c8)
			Sum[11:8] = Sum1[7:4];
	  else
			Sum[11:8] = Sum0[7:4];
			
			
	  // choose the correct sum value for Sum[15:8]
	  if (c12)
			Sum[15:12] = Sum1[11:8];
	  else
			Sum[15:12] = Sum0[11:8];
	  end
	  
	  // 7 full adder to calculate add result before getting the carry in
	  // The first full adder will assign the first four bit for sum.
	  full_adder4 FA4(.A(A[3:0]),.B(B[3:0]),.C_in(1'b0),.Sum(Sum[3:0]),.C_out(c4));
	  
	  full_adder4 FA80(.A(A[7:4]),.B(B[7:4]),.C_in(1'b0),.Sum(Sum0[3:0]),.C_out(c8_0));
	  full_adder4 FA81(.A(A[7:4]),.B(B[7:4]),.C_in(1'b1),.Sum(Sum1[3:0]),.C_out(c8_1));
	  
	  full_adder4 FA120(.A(A[11:8]),.B(B[11:8]),.C_in(1'b0),.Sum(Sum0[7:4]),.C_out(c12_0));
	  full_adder4 FA121(.A(A[11:8]),.B(B[11:8]),.C_in(1'b1),.Sum(Sum1[7:4]),.C_out(c12_1));
	  
	  full_adder4 FA160(.A(A[15:12]),.B(B[15:12]),.C_in(1'b0),.Sum(Sum0[11:8]),.C_out(cout_0));
	  full_adder4 FA161(.A(A[15:12]),.B(B[15:12]),.C_in(1'b1),.Sum(Sum1[11:8]),.C_out(cout_1));
	  
endmodule
