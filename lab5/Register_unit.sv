module register_unit (input  logic Clk, ResetA, ResetB, A_In, B_In, Ld_A, Ld_B, 
                            Shift_En,
                      input  logic [7:0]  DA, 
							 input  logic [7:0]  DB, 
                      output logic A_out, B_out, 
                      output logic [7:0]  A,
                      output logic [7:0]  B);


    reg_8  reg_A (.Clk, .Reset(ResetA), .Shift_In(A_In), .Load(Ld_A),
	               .Shift_En, .D(DA), .Shift_Out(A_out), .Data_Out(A));
    reg_8  reg_B (.Clk, .Reset(ResetB), .Shift_In(B_In), .Load(Ld_B),
	               .Shift_En, .D(DB), .Shift_Out(B_out), .Data_Out(B));

endmodule
