/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module home (
	input Clk, 
	input logic home_exist,
	input logic [9:0] DrawX, DrawY,
	output logic [3:0] home_data,
	output logic is_home
);
	// screen size
	 parameter [9:0] SCREEN_WIDTH =  10'd480;
    parameter [9:0] SCREEN_LENGTH = 10'd640;
	 parameter [9:0] RESHAPE_LENGTH = 10'd320;

	//--------------------load memory-----------------//
	logic [18:0] read_address;
	assign read_address = DrawX/2 + DrawY/2*RESHAPE_LENGTH;
	home_RAM home_RAM(.*);

	always_comb begin
		is_home = 1'b0;
		if (home_exist == 1'b1)
			is_home = 1'b1;
	end

endmodule

module  home_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] home_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:76799];
initial
begin
	 $readmemh("home.txt", mem);
end


always_ff @ (posedge Clk) begin
	home_data<= mem[read_address];
end

endmodule
