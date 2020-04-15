module control
(
    input   logic           Clk,        	// 50MHz clock is only used to get timing estimate data
    input   logic           Reset,      	// From push-button 0.  Remember the button is active low (0 when pressed)
    input   logic           Run,      		// From push-button 1
    input   logic           ClearA_LoadB, // From push-button 3.
	 input 	logic 			 M,				// B[0]
    output 	logic 			 Clr_Ld,
	 output 	logic 			 Shift_En,
	 output 	logic 			 Add,
	 output 	logic 			 Sub,
	 output	logic				 Clr_XA
);
	//A,J: steady state, no shift and no calculation
	//B,C,D,E,F,G,H,I: add state, no shift
	//B1,C1,D1,E1,F1,G1,H1,I1: only for shift
    enum logic [4:0] {A, B, C, D, E, F, G, H, I, J, B1, C1, D1, E1, F1, G1, H1, I1}   curr_state, next_state; 
    always_ff @(posedge Clk) begin
        if (~Reset)
				curr_state <= A;			
        else 
            curr_state <= next_state;
	 end
        
    // Assign outputs based on state
	always_comb
    begin
        
		  next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        unique case (curr_state) 
		  
            A :    if (~Run)
                       next_state = B;
							  
            B :    next_state = B1;
				B1: 	 next_state = C;
				
				C :    next_state = C1;
				C1: 	 next_state = D;
				
				D :    next_state = D1;
				D1: 	 next_state = E;
				
				E :    next_state = E1;
				E1: 	 next_state = F;
				
				F :    next_state = F1;
				F1: 	 next_state = G;
				
				G :    next_state = G1;
				G1: 	 next_state = H;
				
				H :    next_state = H1;
				H1: 	 next_state = I;
				
				I :    next_state = I1;
				I1: 	 next_state = J;
				
            J :    if (Run) 
                       next_state = A;
							  
        endcase
   
		  
		  // Assign outputs based on ‘state’
		  // for B,C,D,E,F,G,H,I states, they are used to add two vectors
		  // for B1,C1,D1,E1,F1,G1,H1,I1, they are only used to shift
		  Clr_XA = 1'b0;
        case (curr_state) 
	   	   A: 
	         begin
					 Clr_XA = 1'b1;
                Clr_Ld = ClearA_LoadB;
                Shift_En = 1'b0;
					 Add = 1'b0;
					 Sub = 1'b0;
		      end
				
				B:
				begin
                Clr_Ld =  1'b1;;
                Shift_En = 1'b0;
					 Add = M;
					 Sub = 1'b0;
		      end
				C:
				begin
                Clr_Ld =  1'b1;;
                Shift_En = 1'b0;
					 Add = M;
					 Sub = 1'b0;
		      end
				D:
				begin
                Clr_Ld =  1'b1;;
                Shift_En = 1'b0;
					 Add = M;
					 Sub = 1'b0;
		      end
				E: 
				begin
                Clr_Ld =  1'b1;;
                Shift_En = 1'b0;
					 Add = M;
					 Sub = 1'b0;
		      end
				F:
				begin
                Clr_Ld =  1'b1;;
                Shift_En = 1'b0;
					 Add = M;
					 Sub = 1'b0;
		      end
				G: 
				begin
                Clr_Ld =  1'b1;;
                Shift_En = 1'b0;
					 Add = M;
					 Sub = 1'b0;
		      end	
				H: 
				begin
                Clr_Ld =  1'b1;;
                Shift_En = 1'b0;
					 Add = M;
					 Sub = 1'b0;
		      end
				I:
				begin
					Add = 1'b0;
					Clr_Ld =  1'b1;;
               Shift_En = 1'b0;
					if (M)begin
						Sub = 1'b1;
					end else
						Sub = 1'b0; 
				end
	   	   J: 
		      begin
                Clr_Ld =  1'b1;;
                Shift_En = 1'b0;
					 Add = 1'b0;
					 Sub = 1'b0;
		      end
				
	   	   default:  //default case, can also have default assignments for Ld_A and Ld_B before case
		      begin 
					 Add = 1'b0;
					 Sub = 1'b0;
                Clr_Ld = 1'b1;
                Shift_En = 1'b1;
		      end
        endcase
    end
endmodule
