/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module gameover (
	input Clk, 
	input logic gameover_exist,
	input logic [9:0] DrawX, DrawY,
	output logic [3:0] gameover_data,
	output logic is_gameover
);
	// screen size 
	// gameover original size = 170 96 , we need 340 * 192
	 parameter [9:0] SCREEN_WIDTH =  10'd480;
    parameter [9:0] SCREEN_LENGTH = 10'd640;
	 parameter [9:0] ORIGINAL_LENGTH = 10'd170;
	 parameter [9:0] RESHAPE_LENGTH = 10'd340;
	 parameter [9:0] GAMEOVER_LEFT = 10'd149;
	 parameter [9:0] GAMEOVER_RIGHT = 10'd488;
	 parameter [9:0] GAMEOVER_UP = 10'd143;
	 parameter [9:0] GAMEOVER_DOWN = 10'd334;
	//--------------------load memory-----------------//
	logic [18:0] read_address;
	always_comb begin
		is_gameover = 1'b0;
		if (gameover_exist == 1'b1 && 
			DrawX >=GAMEOVER_LEFT && DrawX <= GAMEOVER_RIGHT &&
		    DrawY >=GAMEOVER_UP && DrawY <= GAMEOVER_DOWN)begin
				is_gameover = 1'b1;
		end
	end
	assign read_address = (DrawX-GAMEOVER_LEFT)/2 + (DrawY-GAMEOVER_UP)/2*ORIGINAL_LENGTH;
	gameover_RAM gameover_RAM(.*);
endmodule

module  gameover_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] gameover_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:16319];
initial
begin
	 $readmemh("gameover.txt", mem);
end


always_ff @ (posedge Clk) begin
	gameover_data<= mem[read_address];
end

endmodule
