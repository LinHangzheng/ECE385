/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

	// 32bit 4 * (10+1)
	logic [1407:0]w;
	logic [127:0]state;
	logic [127:0]next_state;
	logic [127:0]copy_state;
	logic [127:0]Shift_Out;
	logic [127:0]Sub_Out;
	logic [127:0]AddRoundKey_Out;
	logic [31:0]MixColumns_In;
	logic [31:0]MixColumns_Out;
	logic [127:0]key;
	logic [4:0]Loop_counter;
	logic [4:0]Loop_counter_next;
	// FSM state
	enum logic [4:0]{
		WAIT,
		KEY_SCHEDULE,
		ADDROUNDKEY_BEFORE,
		// loop
		INV_SHIFTROWS,
		INV_SUBBYTES,
		ADDROUNDKEY,
		INV_MIXCOLUMNS1,
		INV_MIXCOLUMNS2,
		INV_MIXCOLUMNS3,
		INV_MIXCOLUMNS4,
		INV_MIXCOLUMNS_DONE,
		// loop end
		INV_SHIFTROWS_AFTER,
		INV_SUBBYTES_AFTER,
		ADDROUNDKEY_AFTER,
		DONE
	} AES_STATE, AES_NEXT_STATE;


	// prepare the words for AddRoundKey
	KeyExpansion ke(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(w));



	//-----------------------------loop-----------------------------
	// InvShiftRows
	InvShiftRows InvSR(.data_in(state), .data_out(Shift_Out));

	// InvSubBytes
	InvSubBytes sub0(.clk(CLK), .in(state[7:0]), .out(Sub_Out[7:0]));
	InvSubBytes sub1(.clk(CLK), .in(state[15:8]), .out(Sub_Out[15:8]));
	InvSubBytes sub2(.clk(CLK), .in(state[23:16]), .out(Sub_Out[23:16]));
	InvSubBytes sub3(.clk(CLK), .in(state[31:24]), .out(Sub_Out[31:24]));
	InvSubBytes sub4(.clk(CLK), .in(state[39:32]), .out(Sub_Out[39:32]));
	InvSubBytes sub5(.clk(CLK), .in(state[47:40]), .out(Sub_Out[47:40]));
	InvSubBytes sub6(.clk(CLK), .in(state[55:48]), .out(Sub_Out[55:48]));
	InvSubBytes sub7(.clk(CLK), .in(state[63:56]), .out(Sub_Out[63:56]));
	InvSubBytes sub8(.clk(CLK), .in(state[71:64]), .out(Sub_Out[71:64]));
	InvSubBytes sub9(.clk(CLK), .in(state[79:72]), .out(Sub_Out[79:72]));
	InvSubBytes sub10(.clk(CLK), .in(state[87:80]), .out(Sub_Out[87:80]));
	InvSubBytes sub11(.clk(CLK), .in(state[95:88]), .out(Sub_Out[95:88]));
	InvSubBytes sub12(.clk(CLK), .in(state[103:96]), .out(Sub_Out[103:96]));
	InvSubBytes sub13(.clk(CLK), .in(state[111:104]), .out(Sub_Out[111:104]));
	InvSubBytes sub14(.clk(CLK), .in(state[119:112]), .out(Sub_Out[119:112]));
	InvSubBytes sub15(.clk(CLK), .in(state[127:120]), .out(Sub_Out[127:120]));

	// AddRoundKey
	AddRoundKey ark(.state(state), .roundKey(key), .out(AddRoundKey_Out));

	// InvMixColumns
	InvMixColumns IMC(.in(MixColumns_In),.out(MixColumns_Out));


	always_ff @(posedge CLK)
	begin
		if (RESET) begin
			AES_STATE <= WAIT;
//			state <= 128'b0;
			Loop_counter <=4'b0;
		end
		
		else begin
			state <= next_state;
			AES_STATE <= AES_NEXT_STATE;
			Loop_counter <= Loop_counter_next;
		end
	end
	
	always_comb begin
			Loop_counter_next = Loop_counter;
			AES_NEXT_STATE = AES_STATE;
			unique case (AES_STATE)
			WAIT:begin
				if (AES_START ==1'b1)begin
					Loop_counter_next = 4'b0;
					AES_NEXT_STATE = KEY_SCHEDULE;
				end 
				else begin
					AES_NEXT_STATE = WAIT;
				end
			end
			
			// give ten clocks to generate keys
			KEY_SCHEDULE:begin
				if (Loop_counter == 10) begin
					AES_NEXT_STATE = ADDROUNDKEY_BEFORE;
					Loop_counter_next = 0;
				end
				else begin
					AES_NEXT_STATE = KEY_SCHEDULE;
					Loop_counter_next = Loop_counter + 4'b1;
				end
			end
			
			ADDROUNDKEY_BEFORE: AES_NEXT_STATE = INV_SHIFTROWS;
			
			INV_SHIFTROWS: AES_NEXT_STATE = INV_SUBBYTES;
			
			INV_SUBBYTES: AES_NEXT_STATE = ADDROUNDKEY;

			ADDROUNDKEY:AES_NEXT_STATE = INV_MIXCOLUMNS1;

			INV_MIXCOLUMNS1: AES_NEXT_STATE = INV_MIXCOLUMNS2;
			
			INV_MIXCOLUMNS2: AES_NEXT_STATE = INV_MIXCOLUMNS3;
						
			INV_MIXCOLUMNS3: AES_NEXT_STATE = INV_MIXCOLUMNS4;
			
			INV_MIXCOLUMNS4: AES_NEXT_STATE = INV_MIXCOLUMNS_DONE;

			INV_MIXCOLUMNS_DONE:begin
				if (Loop_counter == 4'd8)begin
					AES_NEXT_STATE = INV_SHIFTROWS_AFTER;
				end
				else begin
					AES_NEXT_STATE = INV_SHIFTROWS;
					Loop_counter_next = Loop_counter + 4'b1;
				end
			end
			
			INV_SHIFTROWS_AFTER: AES_NEXT_STATE = INV_SUBBYTES_AFTER;
			
			INV_SUBBYTES_AFTER: AES_NEXT_STATE = ADDROUNDKEY_AFTER;
	
			ADDROUNDKEY_AFTER: AES_NEXT_STATE = DONE;
			
			DONE:begin
				if (AES_START==0) begin
					AES_NEXT_STATE = WAIT;
				end
				else begin
					AES_NEXT_STATE = DONE;
				end
			end
			
			default: begin
				AES_NEXT_STATE = WAIT;
			end
		endcase
		
		
		
		
		next_state = state;
		AES_DONE = 1'b0;
		AES_MSG_DEC = 128'b0;
		MixColumns_In = 32'b0;
		key = 128'b0;
		case (AES_STATE)
			WAIT:begin
			end
			
			KEY_SCHEDULE:begin
				next_state = AES_MSG_ENC;
			end
			
			ADDROUNDKEY_BEFORE:begin
				key = w[127:0];
				next_state = AddRoundKey_Out;
			end
			
			INV_SHIFTROWS:begin
				next_state = Shift_Out;
			end
			
			INV_SUBBYTES:begin
				next_state = Sub_Out;
			end
			
			ADDROUNDKEY:begin
				case (Loop_counter)
					4'd8:key = w[1279:1152];
					4'd7:key = w[1151:1024];
					4'd6:key = w[1023:896];
					4'd5:key = w[895:768];
					4'd4:key = w[767:640];
					4'd3:key = w[639:512];
					4'd2:key = w[511:384];
					4'd1:key = w[383:256];
					4'd0:key = w[255:128];
					default: key = 128'b0;
				endcase
				next_state = AddRoundKey_Out;
			end
			
			INV_MIXCOLUMNS1:begin
				MixColumns_In = state[31:0];
				next_state[31:0] = MixColumns_Out;
			end
			
			INV_MIXCOLUMNS2:begin
				MixColumns_In = state[63:32];
				next_state[63:32] = MixColumns_Out;
			end
			
			INV_MIXCOLUMNS3:begin
				MixColumns_In = state[95:64];
				next_state[95:64] = MixColumns_Out;
			end
			
			INV_MIXCOLUMNS4:begin
				MixColumns_In = state[127:96];
				next_state[127:96] = MixColumns_Out;
			end
			
			INV_MIXCOLUMNS_DONE:begin
			end
			
			INV_SHIFTROWS_AFTER:begin
				next_state = Shift_Out;
			end
			
			INV_SUBBYTES_AFTER:begin
				next_state = Sub_Out;
			end
			
			ADDROUNDKEY_AFTER:begin
				key = w[1407:1280];
				next_state =AddRoundKey_Out;
			end
			
			DONE:begin
				AES_MSG_DEC = AddRoundKey_Out;
				AES_DONE = 1'b1;
			end
			
			default: begin
			end
		endcase
	end
endmodule
