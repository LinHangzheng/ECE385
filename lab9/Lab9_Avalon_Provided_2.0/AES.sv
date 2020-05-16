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
	logic [127:0]state_before_loop;
	logic [127:0]state;
	logic [127:0]ShiftOut;
	logic [127:0]state_after_sub;
	logic [127:0]AddRoundOut;
	logic [127:0]state_after_loop;
//	logic [127:0]next_state;
	logic [127:0]key;
//	logic [127:0]next_key;
	// FSM state
	enum logic [4:0]{
		WAIT,
		BEFORE_LOOP,
		LOOP1,
		LOOP2,
		LOOP3,
		LOOP4,
		LOOP5,
		LOOP6,
		LOOP7,
		LOOP8,
		LOOP9,
		AFTER_LOOP,
		DONE
	} AES_STATE, AES_NEXT_STATE;


	// prepare the words for AddRoundKey
	KeyExpansion ke(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(w));

	// AddRoundKey before the loop
	AddRoundKey ark0(.state, .roundKey(key), .out(state_before_loop));


	//-----------------------------loop-----------------------------
	// InvShiftRows
	InvShiftRows (.data_in(state), .data_out(ShiftOut));

	// InvSubBytes
	InvSubBytes sub0(.clk(CLK), .in(ShiftOut[7:0]), .out(state_after_sub[7:0]));
	InvSubBytes sub1(.clk(CLK), .in(ShiftOut[15:8]), .out(state_after_sub[15:8]));
	InvSubBytes sub2(.clk(CLK), .in(ShiftOut[23:16]), .out(state_after_sub[23:16]));
	InvSubBytes sub3(.clk(CLK), .in(ShiftOut[31:24]), .out(state_after_sub[31:24]));
	InvSubBytes sub4(.clk(CLK), .in(ShiftOut[39:32]), .out(state_after_sub[39:32]));
	InvSubBytes sub5(.clk(CLK), .in(ShiftOut[47:40]), .out(state_after_sub[47:40]));
	InvSubBytes sub6(.clk(CLK), .in(ShiftOut[55:48]), .out(state_after_sub[55:48]));
	InvSubBytes sub7(.clk(CLK), .in(ShiftOut[63:56]), .out(state_after_sub[63:56]));
	InvSubBytes sub8(.clk(CLK), .in(ShiftOut[71:64]), .out(state_after_sub[71:64]));
	InvSubBytes sub9(.clk(CLK), .in(ShiftOut[79:72]), .out(state_after_sub[79:72]));
	InvSubBytes sub10(.clk(CLK), .in(ShiftOut[87:80]), .out(state_after_sub[87:80]));
	InvSubBytes sub11(.clk(CLK), .in(ShiftOut[95:88]), .out(state_after_sub[95:88]));
	InvSubBytes sub12(.clk(CLK), .in(ShiftOut[103:96]), .out(state_after_sub[103:96]));
	InvSubBytes sub13(.clk(CLK), .in(ShiftOut[111:104]), .out(state_after_sub[111:104]));
	InvSubBytes sub14(.clk(CLK), .in(ShiftOut[119:112]), .out(state_after_sub[119:112]));
	InvSubBytes sub15(.clk(CLK), .in(ShiftOut[127:120]), .out(state_after_sub[127:112]));

	// AddRoundKey
	AddRoundKey ark1(.state(state_after_sub), .roundKey(cur_key), .out(AddRoundOut));

	// InvMixColumns
	InvMixColumns IMC(.in(AddRoundOut),.out(state_after_loop));


	always_ff @(posedge CLK)
	begin
		if (RESET) begin
			AES_STATE <= WAIT;
			state <= 128'b0;
			cur_key <= 128'b0;
			w <= 1407'b0;
		end
		
		else begin
			AES_STATE <= AES_NEXT_STATE;
		end
	end
	
	always_comb begin
		case (AES_STATE)
			WAIT: begin
				AES_DONE = 1'b0;
				if (AES_START == 1'b1) begin
					AES_NEXT_STATE = BEFORE_LOOP;
				end
				else begin
					AES_NEXT_STATE = WAIT;
				end	
			end	
			
			BEFORE_LOOP: begin
				state = AES_MSG_ENC;
				key = w[1407:1280];
				AES_NEXT_STATE = LOOP1;
			end
			LOOP1: begin
				state = state_before_loop;
				key = w[1279:1152];
				AES_NEXT_STATE = LOOP2;
			end
			LOOP2: begin
				state = state_after_loop;
				key = w[1151:1024];
				AES_NEXT_STATE = LOOP3;
			end
			LOOP3: begin
				state = state_after_loop;
				key = w[1203:896];
				AES_NEXT_STATE = LOOP4;
			end
			LOOP4: begin
				state = state_after_loop;
				key = w[895:768];
				AES_NEXT_STATE = LOOP5;
			end
			LOOP5: begin
				state = state_after_loop;
				key = w[767:640];
				AES_NEXT_STATE = LOOP6;
			end
			LOOP6: begin
				state = state_after_loop;
				key = w[639:512];
				AES_NEXT_STATE = LOOP7;
			end
			LOOP7: begin
				state = state_after_loop;
				key = w[511:384];
				AES_NEXT_STATE = LOOP8;
			end
			LOOP8: begin
				state = state_after_loop;
				key = w[383:256];
				AES_NEXT_STATE = LOOP9;
			end
			LOOP9: begin
				state = state_after_loop;
				key = w[255:128];
				AES_NEXT_STATE = AFTER_LOOP;
			end
			AFTER_LOOP: begin
				state = state_after_loop;
				key = w[127:0];
				AES_NEXT_STATE = DONE;
			end
			DONE: begin
				AES_MSG_DEC = AddRoundOut;
				AES_DONE = 1'b1;
				if (AES_START ==0) begin
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
	end
endmodule
