/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module portrait1 (
	input Clk, portrait1_exit,
	input logic [9:0] DrawX, DrawY,
	output logic [7:0] portrait1_data,
	output logic is_portrait1
	);
	// screen size
	parameter [9:0] PORTRAIT1_SIZE= 160;
	parameter [9:0] Y_START= 320;
		
	//--------------------load memory-----------------//
	logic [18:0] read_address;
	always_comb begin
		read_address = 19'b0;
		is_portrait1 = 1'b0;
		if (portrait1_exit && DrawX < PORTRAIT1_SIZE && DrawY > Y_START)begin
			read_address = DrawX/2 + (DrawY-Y_START)/2*PORTRAIT1_SIZE/2;
			is_portrait1 = 1'b1;
		end
	end
	portrait1_RAM portrait1_RAM(.*);


endmodule

module  portrait1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [7:0] portrait1_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [7:0] mem [0:6399];
initial
begin
	 $readmemh("sprite/portrait1.txt", mem);
end


always_ff @ (posedge Clk) begin
	portrait1_data<= mem[read_address];
end

endmodule
