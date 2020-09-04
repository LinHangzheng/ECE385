/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module background (
	input Clk, 
	input logic background_exit,
	input logic [9:0] DrawX, DrawY,
	output logic [7:0] background_data,
	output logic is_background
);
	// screen size
	parameter [9:0] SCREEN_WIDTH =  10'd480;
   parameter [9:0] SCREEN_LENGTH = 10'd640;
	parameter [9:0] RESHAPE_LENGTH = 10'd160;
	//--------------------load memory-----------------//
	logic [18:0] read_address;
	assign read_address = DrawX/4 + DrawY/4*RESHAPE_LENGTH;
	background_RAM background_RAM(.*);


	always_comb begin
		is_background = 1'b0;
		if (background_exit == 1'b1)
			is_background = 1'b1;
	end

endmodule

module  background_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] background_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [7:0] mem [0:19199];
initial
begin
	 $readmemh("sprite/background.txt", mem);
end


always_ff @ (posedge Clk) begin
	background_data<= mem[read_address];
end

endmodule
