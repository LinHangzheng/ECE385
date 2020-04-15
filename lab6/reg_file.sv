module reg_file(input logic Clk,
					 input logic Reset,
					 input logic LD_REG,
					 input logic [2:0]DR_In,
					 input logic [2:0]SR2,
					 input logic [2:0]SR1,
					 input logic [15:0]Bus_In,
					 output logic [15:0] SR1_Out,
					 output logic [15:0] SR2_Out);
					 
	logic [7:0][15:0] Reg_unit;
	
	always_ff @ (posedge Clk)
	begin
		if (~Reset)				// if reset is active, clear all registers
		begin
			Reg_unit[0] <= 16'h0000;
			Reg_unit[1] <= 16'h0000;
			Reg_unit[2] <= 16'h0000;
			Reg_unit[3] <= 16'h0000;
			Reg_unit[4] <= 16'h0000;
			Reg_unit[5] <= 16'h0000;
			Reg_unit[6] <= 16'h0000;
			Reg_unit[7] <= 16'h0000;
		end
		else
		begin
			if(LD_REG)			// if load data into the target register
			begin
				case(DR_In)
					3'b000: Reg_unit[0] <= Bus_In;
					3'b001: Reg_unit[1] <= Bus_In;
					3'b010: Reg_unit[2] <= Bus_In;
					3'b011: Reg_unit[3] <= Bus_In;
					3'b100: Reg_unit[4] <= Bus_In;
					3'b101: Reg_unit[5] <= Bus_In;
					3'b110: Reg_unit[6] <= Bus_In;
					3'b111: Reg_unit[7] <= Bus_In;
				endcase
			end
		end
	end
		
	// tranfer the corresponding register to output
	always_comb
	begin
		case (SR1)
			3'b000: SR1_Out = Reg_unit[0];
			3'b001: SR1_Out = Reg_unit[1];
			3'b010: SR1_Out = Reg_unit[2];
			3'b011: SR1_Out = Reg_unit[3];
			3'b100: SR1_Out = Reg_unit[4];
			3'b101: SR1_Out = Reg_unit[5];
			3'b110: SR1_Out = Reg_unit[6];
			3'b111: SR1_Out = Reg_unit[7];
		endcase
		case (SR2)
			3'b000: SR2_Out = Reg_unit[0];
			3'b001: SR2_Out = Reg_unit[1];
			3'b010: SR2_Out = Reg_unit[2];
			3'b011: SR2_Out = Reg_unit[3];
			3'b100: SR2_Out = Reg_unit[4];
			3'b101: SR2_Out = Reg_unit[5];
			3'b110: SR2_Out = Reg_unit[6];
			3'b111: SR2_Out = Reg_unit[7];
		endcase
	end
endmodule
