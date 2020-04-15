module datapath(input logic Clk,
					 input logic Reset,
					 input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
					 input logic GatePC, GateMDR, GateALU, GateMARMUX,
					 input logic [1:0] PCMUX, ADDR2MUX, ALUK,
					 input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
					 input logic MIO_EN,
					 input logic [15:0]MDR_In,
					 output logic BEN,
					 output logic [11:0]LED,
					 output logic [15:0]IR,
					 output logic [15:0]MAR,
					 output logic [15:0]MDR,
					 output logic [15:0]PC);
					 
	logic [15:0] Bus, Adder_Out, ALU_Out;	// Bus and the input of Bus
	logic [15:0] PC_In, MAR_In;
	logic [15:0] SEXT11, SEXT9, SEXT6, SEXT5;			// Different SEXT from IR
	logic [15:0] Add2, Add1;								// Adder input 
	logic [15:0] ALUB;										// Left input of ALU
	logic [15:0] SR1_Out, SR2_Out;						// Output from register file
	logic [15:0] MDR_Val;
	logic [2:0] DR_In, SR1;
	logic [2:0] NZP,NZP_com;								// NZP 1 for ture for each
	logic BEN_com;												// 1 or 0 for BEN
	logic [15:0]PC_Next;												// PC+1


						  
	/*-----------------------Registers-------------------------*/
	// MAR
	register Reg_MAR (.*, .Load(LD_MAR),.In(Bus),.Out(MAR));
	// MDR
	register Reg_MDR (.*, .Load(LD_MDR),.In(MDR_Val),.Out(MDR));
	// PC
	register Reg_PC  (.*, .Load(LD_PC),.In(PC_In),.Out(PC));
	// IR
	register Reg_IR  (.*, .Load(LD_IR),.In(Bus),.Out(IR));
	// LED
	register #(12) Reg_LED (.*, .Load(LD_LED),.In(IR[11:0]),.Out(LED));
	// NZP
	register #(3)  Reg_NZP (.*, .Load(LD_CC),.In(NZP_com),.Out(NZP));
	// BEN
	register #(1)  Reg_BEN (.*, .Load(LD_BEN),.In(BEN_com),.Out(BEN));
	
	/*--------------------------SEXT----------------------------*/
	SEXT SEXT_IR(.*);
	
	/*--------------------------Mux-----------------------------*/
	// Bus
	Mux_Bus Mux_bus( .Select({GatePC, GateMDR, GateALU, GateMARMUX}),
						  .A(Adder_Out),.B(ALU_Out),.C(MDR),.D(PC),
						  .Out(Bus));
	// Adder left input
	Mux4 Mux_ADDR2(.Select(ADDR2MUX),
				  .A(16'h0000),.B(SEXT6),.C(SEXT9),.D(SEXT11),
				  .Out(Add2));
	// PC 
	Mux4 Mux_PC(.Select(PCMUX),
					.A(PC_Next),
					.B(Bus),
					.C(Adder_Out),
					.D(16'h0000),
					.Out(PC_In));
	// Adder right input
	Mux2 MUX_ADDR1(.Select(ADDR1MUX),
				  .A(PC),
				  .B(SR1_Out),
				  .Out(Add1));
	// ALU left input
	Mux2 Mux_SR2(.Select(SR2MUX),
				  .A(SR2_Out),
				  .B(SEXT5),
				  .Out(ALUB));
	// REG FILE SR1 input
	Mux2 #(3) Mux_SR1 (.Select(SR1MUX),
				  .A(IR[11:9]),
				  .B(IR[8:6]),
				  .Out(SR1));
	// REG FILE DR input
	Mux2 #(3) Mux_DR (.Select(DRMUX),
				  .A(IR[11:9]),
				  .B(3'b111),
				  .Out(DR_In));
	Mux2 Mux_MDR(.Select(MIO_EN),
				  .A(Bus),
				  .B(MDR_In),
				  .Out(MDR_Val));
	/*--------------------------ALU-----------------------------*/
	ALU ALU0(.A(SR1_Out),
				.B(ALUB),
				.ALUK,
				.ALU_Out);
				
	/*----------------------REG FILE----------------------------*/	
	reg_file RF0(.*,
					 .SR2(IR[2:0]),
					 .Bus_In(Bus));
	
	/*----------------------Other path--------------------------*/	
	always_comb
	begin
		// Adder
		Adder_Out = Add2+Add1;
		// PC update
		PC_Next = PC + 1;
		// calculate NZP
		if (Bus==16'h0000)
			NZP_com = 3'b010;
		else if(Bus[15]==1'b1)
			NZP_com = 3'b100;
		else
			NZP_com = 3'b001;
		// calculate BEN
		BEN_com = (IR[11]&NZP[2])+(IR[10]&NZP[1])+(IR[9]&NZP[0]);
	end			 

					 
endmodule

