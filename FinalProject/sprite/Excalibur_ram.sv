/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module Excalibur (
	input Clk, 
	input logic Excalibur_exist,
	input logic faceleft,
	input logic [9:0] DrawX, DrawY,
	input logic [9:0] Excalibur_x,
	input logic [9:0] Excalibur_y,
	input logic [5:0] Excalibur_state,
	output logic [3:0] Excalibur_data,
	output logic is_Excalibur
);
	// screen size
	parameter [9:0] SCREEN_WIDTH =  10'd480;
   parameter [9:0] SCREEN_LENGTH = 10'd640;
	parameter [9:0] ExcaliburLENGTH = 10'd200;			//original size
	parameter [9:0] ExcaliburWIDTH =  10'd91;			//original size
	parameter [9:0] ExcaliburLENGTH_DOUBLE = 10'd400;			//double the size
	parameter [9:0] ExcaliburWIDTH_DOUBLE =  10'd182;		//double the size
	parameter [9:0] CENTERX_DOUBLE =  10'd200;
	parameter [9:0] CENTERY_DOUBLE =  10'd91;
	parameter[3:0] RESHAPE_TIME = 8'd2;
	//--------------------load memory-----------------//
	logic [18:0] read_address;
	logic [3:0] Excalibur1_data;
	logic [3:0] Excalibur2_data;
	logic [3:0] Excalibur3_data;
	logic [3:0] Excalibur4_data;
	logic [3:0] Excalibur5_data;
	logic [3:0] Excalibur6_data;
	logic [3:0] Excalibur7_data;
	logic [3:0] Excalibur8_data;
	logic [3:0] data_in;
	
	Excalibur1_RAM Excalibur1_RAM(.*);
	Excalibur2_RAM Excalibur2_RAM(.*);
	Excalibur3_RAM Excalibur3_RAM(.*);
	Excalibur4_RAM Excalibur4_RAM(.*);
	Excalibur5_RAM Excalibur5_RAM(.*);
	Excalibur6_RAM Excalibur6_RAM(.*);
	Excalibur7_RAM Excalibur7_RAM(.*);
	Excalibur8_RAM Excalibur8_RAM(.*);
	
	
	always_comb begin
		is_Excalibur = 1'b0;
		read_address = 19'b0;
		Excalibur_data = data_in;
	   if (Excalibur_exist == 1'b1)begin
			if ((DrawX + CENTERX_DOUBLE >= Excalibur_x || Excalibur_x < CENTERX_DOUBLE) && DrawX <= Excalibur_x + CENTERX_DOUBLE &&
				DrawY + CENTERY_DOUBLE >= Excalibur_y  && DrawY <= Excalibur_y +ExcaliburWIDTH_DOUBLE-CENTERY_DOUBLE)begin
				is_Excalibur = 1'b1;
				if (faceleft == 1'b1)
					read_address = (CENTERX_DOUBLE-(Excalibur_x - DrawX))/RESHAPE_TIME + (CENTERY_DOUBLE-(Excalibur_y - DrawY))/RESHAPE_TIME*ExcaliburLENGTH;
				else
					read_address = (CENTERX_DOUBLE+(Excalibur_x - DrawX))/RESHAPE_TIME + (CENTERY_DOUBLE-(Excalibur_y - DrawY))/RESHAPE_TIME*ExcaliburLENGTH;
			end
	   end
		unique case (Excalibur_state) 
			6'd0: data_in = Excalibur1_data;
			6'd1: data_in = Excalibur2_data;
			6'd2: data_in = Excalibur3_data;
			6'd3: data_in = Excalibur4_data;
			6'd4: data_in = Excalibur5_data;
			6'd5: data_in = Excalibur6_data;
			6'd6: data_in = Excalibur7_data;
			6'd7: data_in = Excalibur8_data;
			default: data_in = 8'b0;
		endcase
	end

endmodule

module  Excalibur1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] Excalibur1_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:18199];
initial begin
	 $readmemh("sprite/Excalibur/Excalibur1.txt", mem);
end

always_ff @ (posedge Clk) begin
	Excalibur1_data<= mem[read_address];
end
endmodule


module  Excalibur2_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] Excalibur2_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:18199];
initial begin
	 $readmemh("sprite/Excalibur/Excalibur2.txt", mem);
end

always_ff @ (posedge Clk) begin
	Excalibur2_data<= mem[read_address];
end
endmodule


module  Excalibur3_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] Excalibur3_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:18199];
initial begin
	 $readmemh("sprite/Excalibur/Excalibur3.txt", mem);
end

always_ff @ (posedge Clk) begin
	Excalibur3_data<= mem[read_address];
end
endmodule


module  Excalibur4_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] Excalibur4_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:18199];
initial begin
	 $readmemh("sprite/Excalibur/Excalibur4.txt", mem);
end

always_ff @ (posedge Clk) begin
	Excalibur4_data<= mem[read_address];
end
endmodule

module  Excalibur5_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] Excalibur5_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:18199];
initial begin
	 $readmemh("sprite/Excalibur/Excalibur5.txt", mem);
end

always_ff @ (posedge Clk) begin
	Excalibur5_data<= mem[read_address];
end
endmodule

module  Excalibur6_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] Excalibur6_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:18199];
initial begin
	 $readmemh("sprite/Excalibur/Excalibur6.txt", mem);
end

always_ff @ (posedge Clk) begin
	Excalibur6_data<= mem[read_address];
end
endmodule


module  Excalibur7_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] Excalibur7_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:18199];
initial begin
	 $readmemh("sprite/Excalibur/Excalibur7.txt", mem);
end

always_ff @ (posedge Clk) begin
	Excalibur7_data<= mem[read_address];
end
endmodule



module  Excalibur8_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] Excalibur8_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:18199];
initial begin
	 $readmemh("sprite/Excalibur/Excalibur8.txt", mem);
end

always_ff @ (posedge Clk) begin
	Excalibur8_data<= mem[read_address];
end
endmodule
