module AddRoundKey (
	input  logic [127:0]  state,
	input  logic [127:0]	 roundKey,
	output logic [127:0]	 out
);
	always_comb 
	begin
		out = state ^ roundKey;
	end


endmodule
