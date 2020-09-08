/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module portrait2(
	input Clk, portrait2_exist,
	input logic [9:0] DrawX, DrawY,
	output logic [3:0] portrait2_data,
	output logic is_portrait2
	);
	// screen size
	parameter [9:0] PORTRAIT1_SIZE= 160;
	parameter [9:0] Y_START= 320;
		
	//--------------------load memory-----------------//
	logic [18:0] read_address;
	always_comb begin
		read_address = 19'b0;
		is_portrait2 = 1'b0;
		if (portrait2_exist && DrawX < PORTRAIT1_SIZE && DrawY > Y_START)begin
			read_address = DrawX/2 + (DrawY-Y_START)/2*PORTRAIT1_SIZE/2;
			is_portrait2 = 1'b1;
		end
	end
	portrait2_RAM portrait2_RAM(.*);



endmodule

module  portrait2_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] portrait2_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:6399];
initial
begin
	 $readmemh("sprite/portrait2.txt", mem);
end


always_ff @ (posedge Clk) begin
	portrait2_data<= mem[read_address];
end

endmodule
