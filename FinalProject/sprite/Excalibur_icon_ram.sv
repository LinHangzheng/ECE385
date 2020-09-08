/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module Excalibur_icon (
	input Clk, Excalibur_icon_exist,
	input logic [1:0] Excalibur_icon_number,
	input logic [9:0] DrawX, DrawY,
	output logic [3:0] Excalibur_icon_data,
	output logic is_Excalibur_icon
	);
	// screen size
	parameter [9:0] Excalibur_icon_SIZE = 50;
	parameter [9:0] Y_START = 370;
	parameter [9:0] Y_END = 420;
	parameter [9:0] X_START= 180;
	parameter [9:0] INTERVAL = 20;
		
	//--------------------load memory-----------------//
	logic [18:0] read_address;
	always_comb begin
		is_Excalibur_icon = 1'b0;
		read_address = 19'b0;
		if (Excalibur_icon_exist) begin
			if (Excalibur_icon_number >= 2'd1) begin
				if (DrawX >= X_START  && DrawX < X_START+Excalibur_icon_SIZE &&
					DrawY >= Y_START && DrawY < Y_END)begin
					read_address = DrawX-X_START + (DrawY-Y_START)*Excalibur_icon_SIZE;
					is_Excalibur_icon = 1'b1;
				end
			end

			if (Excalibur_icon_number >= 2'd2) begin
				if (DrawX >= X_START+Excalibur_icon_SIZE+INTERVAL  && DrawX < X_START+Excalibur_icon_SIZE+INTERVAL+Excalibur_icon_SIZE &&
					DrawY >= Y_START && DrawY < Y_END)begin
					read_address = DrawX-X_START-INTERVAL + (DrawY-Y_START)*Excalibur_icon_SIZE;
					is_Excalibur_icon = 1'b1;
				end
			end

			if (Excalibur_icon_number >= 2'd3) begin
				if (DrawX >= X_START+Excalibur_icon_SIZE+Excalibur_icon_SIZE+INTERVAL+INTERVAL  && DrawX < X_START+Excalibur_icon_SIZE+Excalibur_icon_SIZE+Excalibur_icon_SIZE+INTERVAL+INTERVAL &&
					DrawY >= Y_START && DrawY < Y_END)begin
					read_address = DrawX-X_START-INTERVAL-INTERVAL + (DrawY-Y_START)*Excalibur_icon_SIZE;
					is_Excalibur_icon = 1'b1;
				end
			end
		end
	end
	Excalibur_icon_RAM Excalibur_icon_RAM(.*);


endmodule

module  Excalibur_icon_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] Excalibur_icon_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:2499];
initial
begin
	 $readmemh("sprite/Excalibur_icon.txt", mem);
end


always_ff @ (posedge Clk) begin
	Excalibur_icon_data<= mem[read_address];
end

endmodule
