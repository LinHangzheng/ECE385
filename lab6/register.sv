module register #(parameter w = 16)
					 (input logic Clk,
					   input logic Reset,
						input logic Load,
						input logic [w-1:0]In,
						output logic [w-1:0]Out);
	// register module which can modify the input size
	logic [w-1:0]register;
	
	always_ff @ (posedge Clk)
	begin
		Out <= register;
	end
	
	always_comb 
	begin
		register = Out;
		if (~Reset)
			register = 0;
		else if(Load)
			register = In;
	end
endmodule

