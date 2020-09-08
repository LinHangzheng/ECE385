//-------------------------------------------------------------------------
//      1-bit register                                                   --
//      Sai Ma                                                           --
//      11-13-2014                                                       --
//                                                                       --
//      For use with ECE 385 Final Project                     			 --
//      ECE Department @ UIUC                                            --
//-------------------------------------------------------------------------
module reg_11 (input logic    Clk, Reset, Shift_In, Load, Shift_En,
               input logic [10:0] D,
               output logic    Shift_Out,
               output logic [10:0] Data_Out);

always_ff @ (posedge Clk or posedge Load or posedge Reset)
begin
	if (Reset)
		Data_Out <= 11'h0;
	else if (Load)
		Data_Out <= D;
	else if (Shift_En)
		Data_Out <= {Shift_In,Data_Out[10:1]};
end

assign Shift_Out = Data_Out[0];
	
endmodule
