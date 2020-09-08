/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module monster1 (
	input Clk, 
	input logic monster1_exist,
	input logic [9:0] DrawX, DrawY,
	input logic [9:0] monster1_x,
	input logic [9:0] monster1_y,
	input logic [5:0] monster1_state,
	output logic [3:0] monster1_data,
	output logic is_monster1
);
	// screen size
	parameter [9:0] SCREEN_WIDTH =  10'd480;
   parameter [9:0] SCREEN_LENGTH = 10'd640;
	parameter [9:0] MONSTER1_LENGTH = 10'd186;			//original size
	parameter [9:0] MONSTER1_WIDTH =  10'd126;			//original size
	parameter [9:0] MONSTER1_LENGTH_DOUBLE = 10'd186;			//double the size
	parameter [9:0] MONSTER1_WIDTH_DOUBLE =  10'd126;		//double the size
	parameter [9:0] CENTERX_DOUBLE =  10'd93;
	parameter [9:0] CENTERY_DOUBLE =  10'd63;
	parameter[3:0] RESHAPE_TIME = 8'd1;
	parameter [9:0] CORNERX =  10'd0;
	parameter [9:0] CORNERY =  10'd0;
	//--------------------load memory-----------------//
	logic [18:0] read_address;
	logic [3:0] monster1_1_data;
	logic [3:0] monster1_2_data;
	logic [3:0] monster1_3_data;
	logic [3:0] monster1_4_data;
	logic [3:0] monster1_hit_data;
	logic [3:0] monster1_dead1_data;
	logic [3:0] monster1_dead2_data;
	logic [3:0] monster1_attack1_data;
	logic [3:0] monster1_attack2_data;
	logic [3:0] monster1_attack3_data;
	logic [3:0] monster1_attack4_data;
	logic [3:0] data_in;
	assign read_address = (CENTERX_DOUBLE-(monster1_x - DrawX))/RESHAPE_TIME + (CENTERY_DOUBLE-(monster1_y - DrawY))/RESHAPE_TIME*MONSTER1_LENGTH;
	monster1_1_RAM monster1_1_RAM(.*);
	monster1_2_RAM monster1_2_RAM(.*);
	monster1_3_RAM monster1_3_RAM(.*);
	monster1_4_RAM monster1_4_RAM(.*);
	monster1_hit_RAM monster1_hit_RAM(.*);
	monster1_dead1_RAM monster1_dead1_RAM(.*);
	monster1_dead2_RAM monster1_dead2_RAM(.*);
	monster1_attack1_RAM monster1_attack1_RAM(.*);
	monster1_attack2_RAM monster1_attack2_RAM(.*);
	monster1_attack3_RAM monster1_attack3_RAM(.*);
	monster1_attack4_RAM monster1_attack4_RAM(.*);
	
	
	always_comb begin
		is_monster1 = 1'b0;
		monster1_data = data_in;
	   if (monster1_exist == 1'b1 &&
			 (DrawX >= monster1_x - (CENTERX_DOUBLE-CORNERX)||monster1_x < CENTERX_DOUBLE-CORNERX) && DrawX <= monster1_x + (CORNERX+MONSTER1_LENGTH_DOUBLE-CENTERX_DOUBLE) &&
			 DrawY >= monster1_y - (CENTERY_DOUBLE-CORNERY) && DrawY <= monster1_y + (CORNERY+MONSTER1_WIDTH_DOUBLE-CENTERY_DOUBLE))
		begin
			is_monster1 = 1'b1;
		end
		unique case (monster1_state) 
			6'd0: data_in = monster1_1_data;
			6'd1: data_in = monster1_2_data;
			6'd2: data_in = monster1_3_data;
			6'd3: data_in = monster1_4_data;
			6'd4: data_in = monster1_hit_data;
			6'd5: data_in = monster1_dead1_data;
			6'd6: data_in = monster1_dead2_data;
			6'd7: data_in = monster1_attack1_data;
			6'd8: data_in = monster1_attack2_data;
			6'd9: data_in = monster1_attack3_data;
			6'd10: data_in = monster1_attack4_data;

			default: data_in = 8'b0;
		endcase
	end

endmodule

module  monster1_1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_1_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_1.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_1_data<= mem[read_address];
end
endmodule


module  monster1_2_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_2_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_2.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_2_data<= mem[read_address];
end
endmodule


module  monster1_3_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_3_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_3.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_3_data<= mem[read_address];
end
endmodule


module  monster1_4_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_4_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_4.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_4_data<= mem[read_address];
end
endmodule


module  monster1_hit_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_hit_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_hit.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_hit_data<= mem[read_address];
end
endmodule


module  monster1_dead1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_dead1_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_1.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_dead1_data<= mem[read_address];
end
endmodule


module  monster1_dead2_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_dead2_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_dead2.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_dead2_data<= mem[read_address];
end
endmodule



module  monster1_attack1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_attack1_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_attack1.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_attack1_data<= mem[read_address];
end
endmodule


module  monster1_attack2_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_attack2_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_attack2.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_attack2_data<= mem[read_address];
end
endmodule


module  monster1_attack3_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_attack3_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_attack3.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_attack3_data<= mem[read_address];
end
endmodule


module  monster1_attack4_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] monster1_attack4_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:23435];
initial begin
	 $readmemh("sprite/monster1/monster1_attack4.txt", mem);
end

always_ff @ (posedge Clk) begin
	monster1_attack4_data<= mem[read_address];
end
endmodule

