/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module HP (
	input Clk, HP_exist,
	input logic [1:0] hp,
	input logic [9:0] DrawX, DrawY,
	output logic [3:0] HP_data,
	output logic is_HP
	);
	// screen size
	parameter [9:0] HP_SIZE = 50;
	parameter [9:0] Y_START = 420;
	parameter [9:0] Y_END = 470;
	parameter [9:0] X_START= 180;
	parameter [9:0] INTERVAL = 20;
		
	//--------------------load memory-----------------//
	logic [18:0] read_address;
	always_comb begin
		is_HP = 1'b0;
		read_address = 19'b0;
		if (HP_exist) begin
			if (hp >= 2'd1) begin
				if (DrawX >= X_START  && DrawX < X_START+HP_SIZE &&
					DrawY >= Y_START && DrawY < Y_END)begin
					read_address = DrawX-X_START + (DrawY-Y_START)*HP_SIZE;
					is_HP = 1'b1;
				end
			end

			if (hp >= 2'd2) begin
				if (DrawX >= X_START+HP_SIZE+INTERVAL  && DrawX < X_START+HP_SIZE+INTERVAL+HP_SIZE &&
					DrawY >= Y_START && DrawY < Y_END)begin
					read_address = DrawX-X_START-INTERVAL + (DrawY-Y_START)*HP_SIZE;
					is_HP = 1'b1;
				end
			end

			if (hp >= 2'd3) begin
				if (DrawX >= X_START+HP_SIZE+HP_SIZE+INTERVAL+INTERVAL  && DrawX < X_START+HP_SIZE+HP_SIZE+HP_SIZE+INTERVAL+INTERVAL &&
					DrawY >= Y_START && DrawY < Y_END)begin
					read_address = DrawX-X_START-INTERVAL-INTERVAL + (DrawY-Y_START)*HP_SIZE;
					is_HP = 1'b1;
				end
			end
		end
	end
	HP_RAM HP_RAM(.*);


endmodule

module  HP_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] HP_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:2499];
initial
begin
	 $readmemh("sprite/HP.txt", mem);
end


always_ff @ (posedge Clk) begin
	HP_data<= mem[read_address];
end

endmodule
