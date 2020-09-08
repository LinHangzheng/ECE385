/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module blood (
	input Clk, blood1_exist, blood2_exist,
	input logic [9:0] monster1_attackx,
	input logic [9:0] monster1_attacky,
	input logic [9:0] monster2_attackx,
	input logic [9:0] monster2_attacky,
	input logic [1:0] blood1_state,
	input logic [1:0] blood2_state,
	input logic [9:0] DrawX, DrawY,
	output logic [3:0] blood1_data,
	output logic [3:0] blood2_data,
	output logic is_blood1, is_blood2);

	// screen size
	parameter [9:0] BLOOD_SIZE = 10'd70;
	parameter [9:0] BLOOD_SIZE_HALF = 10'd35;
	
	//--------------------load memory-----------------//
	logic [18:0] read_address1, read_address2;
	logic [3:0] blood1_1data, blood1_2data, blood1_3data;
	logic [3:0] blood2_1data, blood2_2data, blood2_3data;
	logic [3:0] data1_in, data2_in;
	blood1_RAM blood1_RAM(.*);
	blood2_RAM blood2_RAM(.*);
	blood3_RAM blood3_RAM(.*);
	assign blood1_data = data1_in;
	assign blood2_data = data2_in;
	assign read_address1 = DrawX - (monster1_attackx - BLOOD_SIZE_HALF) + (DrawY - (monster1_attacky - BLOOD_SIZE_HALF))*BLOOD_SIZE;
	assign read_address2 = DrawX - (monster2_attackx - BLOOD_SIZE_HALF) + (DrawY - (monster2_attacky - BLOOD_SIZE_HALF))*BLOOD_SIZE;		
	always_comb begin
		is_blood1 = 1'b0;
		is_blood2 = 1'b0;
		data1_in = 4'b0;
		data2_in = 4'b0;
		if (DrawX + BLOOD_SIZE_HALF >= monster1_attackx  && DrawX < monster1_attackx+ BLOOD_SIZE_HALF &&
		  	DrawY + BLOOD_SIZE_HALF >= monster1_attacky  && DrawY < monster1_attacky+ BLOOD_SIZE_HALF)begin
			is_blood1 = 1'b1;
		end

		if (DrawX + BLOOD_SIZE_HALF>= monster2_attackx  && DrawX < monster2_attackx+ BLOOD_SIZE_HALF &&
		  	DrawY + BLOOD_SIZE_HALF>= monster2_attacky  && DrawY < monster2_attacky+ BLOOD_SIZE_HALF)begin
			is_blood2 = 1'b1;
		end

		if (blood1_exist)begin
			unique case (blood1_state)
				2'd0: data1_in = blood1_1data;
				2'd1: data1_in = blood1_2data;
				2'd2: data1_in = blood1_3data;
				default: data1_in = 2'd0;
			endcase
		end	

		if (blood2_exist)begin
			unique case (blood2_state)
				2'd0: data2_in = blood2_1data;
				2'd1: data2_in = blood2_2data;
				2'd2: data2_in = blood2_3data;
				default: data2_in = 2'd0;
			endcase
		end
	end
endmodule

module  blood1_RAM
(
		input [18:0] read_address1,
		input [18:0] read_address2,
		input Clk,

		output logic [3:0] blood1_1data,
		output logic [3:0] blood2_1data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:4899];
initial
begin
	 $readmemh("sprite/blood1.txt", mem);
end


always_ff @ (posedge Clk) begin
	blood1_1data<= mem[read_address1];
	blood2_1data<= mem[read_address2];
end

endmodule



module  blood2_RAM
(
		input [18:0] read_address1,
		input [18:0] read_address2,
		input Clk,

		output logic [3:0] blood1_2data,
		output logic [3:0] blood2_2data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:4899];
initial
begin
	 $readmemh("sprite/blood2.txt", mem);
end


always_ff @ (posedge Clk) begin
	blood1_2data<= mem[read_address1];
	blood2_2data<= mem[read_address2];
end

endmodule



module  blood3_RAM
(
		input [18:0] read_address1,
		input [18:0] read_address2,
		input Clk,

		output logic [3:0] blood1_3data,
		output logic [3:0] blood2_3data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:4899];
initial
begin
	 $readmemh("sprite/blood3.txt", mem);
end


always_ff @ (posedge Clk) begin
	blood1_3data<= mem[read_address1];
	blood2_3data<= mem[read_address2];
end
endmodule