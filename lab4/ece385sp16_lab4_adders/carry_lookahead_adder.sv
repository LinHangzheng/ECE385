module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic  	c4, c8, c12;
	  logic		PG0, PG4, PG8, PG12;
	  logic 		GG0, GG4, GG8, GG12;
	  
	  always_comb
	  begin
	  c4 = GG0;
	  c8 = GG4 | GG0 & PG4;
	  c12 = GG8 | GG4 & PG8 & PG4;
	  end
	  
	  
	  
	  CLA4 ADDER1(.A(A[3:0]), .B(B[3:0]), .C_in(1'b0), .Sum(Sum[3:0]), .PG(PG0), .GG(GG0));
	  CLA4 ADDER2(.A(A[7:4]), .B(B[7:4]), .C_in(c4), .Sum(Sum[7:4]), .PG(PG4), .GG(GG4));
	  CLA4 ADDER3(.A(A[11:8]), .B(B[11:8]), .C_in(c8), .Sum(Sum[11:8]), .PG(PG8), .GG(GG8));
	  CLA4 ADDER4(.A(A[15:12]), .B(B[15:12]), .C_in(c12), .Sum(Sum[15:12]), .PG(PG12), .GG(GG12));
     
endmodule


module CLA4 
(
    input   logic[3:0]     A,
    input   logic[3:0]     B,
	 input 	logic				C_in,
    output  logic[3:0]     Sum,
	 output 	logic				PG,
	 output  logic				GG
);

	logic    c1, c2, c3;
	logic		P0, P1, P2, P3;
	logic 	G0, G1, G2, G3;
	
	always_comb
	begin
	P0 = A[0] ^ B[0];				
	P1 = A[1] ^ B[1];
	P2 = A[2] ^ B[2];
	P3 = A[3] ^ B[3];
	PG = P0 & P1 & P2 & P3;			// get the group P
	
	G0 = A[0] & B[0];
	G1 = A[1] & B[1];
	G2 = A[2] & B[2];
	G3 = A[3] & B[3];
	GG = G3 | G2 & P3 | G1 & P2 & P3 | G0 & P1 & P2 & P3;	// get the group G
	
	// calculate each carray out
	c1 = C_in & P0 | G0;
	c2 = C_in & P0 & P1 | G0 & P1 | G1;
	c3 = C_in & P0 & P1 & P2 | G0 & P1 & P2 | G1 & P2 | G2;
	
	// calculate the sum
	Sum[0] = P0 ^ C_in;
	Sum[1] = P1 ^ c1;
	Sum[2] = P2 ^ c2;
	Sum[3] = P3 ^ c3;
	end
endmodule
