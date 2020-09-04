module SaberFSM(input        Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
					 input logic [5:0]sw,
					 output	[5:0] saber_state);
	 logic [5:0]state_in;
	 logic frame_clk_delayed, frame_clk_rising_edge;
	 logic [5:0]count, count_in;
	 
	 always_ff @ (posedge Clk)
    begin
		saber_state <= state_in;
		count <= count_in;
	 end
		  
	 always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    

	 always_comb begin
		state_in = saber_state;
		count_in = count;
		if (frame_clk_rising_edge) begin
		//------------Switch test------------//
//			state_in = sw[5:0];
		
		//------------Count test------------//
			count_in = count +1;
			if (count == 4'd10) begin
				count_in = 0;
				state_in = saber_state+ 1;
			end
		end
		if (saber_state > 5'd31)begin
			state_in = 0;
		end
		
	 end
endmodule
