/*  Date Created: Mon Jan 25 2015.
 *  Written to correspond with the spring 2016 lab manual.
 *
 *  ECE 385 Lab 5 template code.  This is the top level entity which
 *  connects an adder circuit to LEDs and buttons on the device.  It also
 *  declares some registers on the inputs and outputs of the adder to help
 *  generate timing information (fmax) and multiplex the DE115's 16 switches
 *  onto the adder's 32 inputs.
 *
 *	 Make sure you instantiate only one of the modules for each demo! 
 *  See section called module instatiation below.
 

/* Module declaration.  Everything within the parentheses()
 * is a port between this module and the outside world */
 
module lab5_toplevel
(
    input   logic           Clk,        	// 50MHz clock is only used to get timing estimate data
    input   logic           Reset,      	// From push-button 0.  Remember the button is active low (0 when pressed)
    input   logic           Run,      		// From push-button 1
    input   logic           ClearA_LoadB, // From push-button 3.
    input   logic[7:0]      S,         	// From slider switches
    
    // all outputs are registered
    output  logic           X,  	         // extend of A
	 output  logic[7:0]		 Aval,			// A and B register output
	 output  logic[7:0]		 Bval,
	 output  logic[6:0]      AhexU,  	   // Hex drivers display both inputs to the adder.
    output  logic[6:0]      AhexL,
    output  logic[6:0]      BhexU,
    output  logic[6:0]      BhexL
);

    /* Declare Internal Registers */
    logic[7:0]     newA;  // use this as an input to your adder
    logic[7:0]     newB;  // use this as an input to your adder
    logic[7:0]		 Adder;
	 logic[7:0]		 Sum;
    /* Declare Internal Wires
     * Wheather an internal logic signal becomes a register or wire depends
     * on if it is written inside an always_ff or always_comb block respectivly */
    logic 		     newX;
    logic[6:0]      Ahex0_comb;
    logic[6:0]      Ahex1_comb;
    logic[6:0]      Bhex0_comb;
    logic[6:0]      Bhex1_comb;
    
	 logic Clr_Ld, Shift_En, Add, Sub, M, Clr_XA,AddX;
    /* Behavior of registers A, B, Sum, and CO */
    always_ff @(posedge Clk) begin
        // transfer data to output register
			Aval <= newA;
			Bval <= newB;
			X <= newX;
			
            // else, Sum and CO maintain their previous values
    end
    
    /* Decoders for HEX drivers and output registers
     * Note that the hex drivers are calculated one cycle after Sum so
     * that they have minimal interfere with timing (fmax) analysis.
     * The human eye can't see this one-cycle latency so it's OK. */
    always_ff @(posedge Clk) begin
        AhexL <= Ahex0_comb;
        AhexU <= Ahex1_comb;
        BhexL <= Bhex0_comb;
        BhexU <= Bhex1_comb;
    end
	 
	 // if it's the 8th bit, we need to subtract, thus we firstly
	 // let Adder be inverted S. Or if Sub = Add = 0, we do not need
	 // do any calculation, thus we set Adder to 0. Otherwise, we need
	 // to add the S to A, so let Adder be S.
	 always_comb begin
		if (Sub)
			Adder = ~S;
		else if (~Add)
			Adder = 8'h00;
		else
			Adder = S;
		
		if (Clr_XA)
			newX = 1'b0;
		else
			newX = AddX;
	 end

// two 8-bit shift registers.	 
   register_unit reg_unit
	(.Clk, 
	 .ResetA((~Clr_Ld)|(~Reset)| Clr_XA), 
	 .ResetB(~Reset), 
	 .A_In(newX), 
	 .B_In(newA[0]), 
	 .Ld_A(Add|Sub), 
	 .Ld_B(~Clr_Ld), 
    .Shift_En,
    .DA(Sum),
	 .DB(S),
    .A(newA),
    .B(newB)
	);

// control unit, decide whether to add or subtract two vectors
// also decide to shift and clear_load two vectors.	
	control	control_unit
	(
		 .Clk,        
		 .Reset,				//input
		 .Run,
		 .ClearA_LoadB,
		 .M(newB[0]),
		 
		 .Clr_Ld,			//output
		 .Shift_En,
		 .Add,
		 .Sub,
		 .Clr_XA
	);
	 
// 9-bit Adder
	full_adder_9 FA9
	(
		 .A({newA[7],newA}),		// A
		 .B({Adder[7],Adder}),	// S
		 .C_in(Sub),				// if it's subtraction, +1 for the C_in
		 .Sum,
		 .X(AddX)
	); 
	 

	 
    HexDriver Ahex0_inst
    (
        .In0(newA[3:0]),   // This connects the 4 least significant bits of 
                        // register A to the input of a hex driver named Ahex0_inst
        .Out0(Ahex0_comb)
    );
    
    HexDriver Ahex1_inst
    (
        .In0(newA[7:4]),
        .Out0(Ahex1_comb)
    );
 
    
    HexDriver Bhex0_inst
    (
        .In0(newB[3:0]),
        .Out0(Bhex0_comb)
    );
    
    HexDriver Bhex1_inst
    (
        .In0(newB[7:4]),
        .Out0(Bhex1_comb)
    );
    
endmodule
