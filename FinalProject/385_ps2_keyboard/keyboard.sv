//-------------------------------------------------------------------------
//      PS2 Keyboard interface                                           --
//      Sai Ma, Marie Liu                                                           --
//      11-13-2014                                                       --
//                                                                       --
//      For use with ECE 385 Final Project                     --
//      ECE Department @ UIUC                                            --
//-------------------------------------------------------------------------
module keyboard(input logic Clk, psClk, psData, reset,
					 output logic [7:0] keyCode,
					 output logic press);


	logic Q1, Q2, en, enable, shiftout1, shiftout2, Press;
	logic [4:0] Count;
	logic [10:0] Byte_1, Byte_2;
	logic [7:0] Data, Typematic_Keycode;
	logic [9:0] counter;

	//Counter to sync ps2 clock and system clock
	always@(posedge Clk or posedge reset)
	begin
		if(reset)
		begin
			counter = 10'b0000000000;
			enable = 1'b1;
		end
		else if (counter == 10'b0111111111)
		begin
			counter = 10'b0000000000;
			enable = 1'b1;
		end
		else
		begin
			counter += 1'b1;
			enable = 1'b0;
		end
	end

	//edge detector of PS2 clock
	always@(posedge Clk)
	begin
		if(enable==1)
		begin
			if((reset)|| (Count==5'b01011))
				Count <= 5'b00000;
		else if(Q1==0 && Q2==1)
			begin
				Count += 1'b1;
				en = 1'b1;
			end
		end
	end

	always@(posedge Clk)
	begin
		if(Count == 5'd11)
		begin
			// An extended key code will be recieved. This driver does not fully support extended key codes, so these are ignored.
			if (Byte_2[9:2] == 8'hE0)
			begin
				// Do nothing
			end

			// An as-of-yet unknown key will be released.
			else if (Byte_2[9:2] == 8'hF0)
			begin
				// Do nothing
			end

			// A key has been released.
			else if (Byte_1[9:2] == 8'hF0)
			begin
				Data = Byte_2[9:2];
				Press = 1'b0;

				if (Data == Typematic_Keycode)
					Typematic_Keycode = 8'h00;
			end

			// This make code is a repeat.
			else if (Byte_2[9:2] == Typematic_Keycode)
			begin
				// Do nothing
			end

			// A key has been pressed.
			else if (Byte_1[9:2] != 8'hF0)
			begin
				Data = Byte_2[9:2];
				Press = 1'b1;
				Typematic_Keycode = Data;
			end
		end
	end

	Dreg Dreg_instance1 ( .*,
								 .Load(enable),
								 .Reset(reset),
								 .D(psClk),
								 .Q(Q1) );
   Dreg Dreg_instance2 ( .*,
								 .Load(enable),
								 .Reset(reset),
								 .D(Q1),
								 .Q(Q2) );

	reg_11 reg_B(
					.Clk(psClk),
					.Reset(reset),
					.Shift_In(psData),
					.Load(1'b0),
					.Shift_En(en),
					.D(11'd0),
					.Shift_Out(shiftout2),
					.Data_Out(Byte_2)
					);

	reg_11 reg_A(
					.Clk(psClk),
					.Reset(reset),
					.Shift_In(shiftout2),
					.Load(1'b0),
					.Shift_En(en),
					.D(11'd0),
					.Shift_Out(shiftout1),
					.Data_Out(Byte_1)
					);

	assign keyCode=Data;
	assign press=Press;

endmodule