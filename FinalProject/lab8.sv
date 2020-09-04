//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
				 input 		  [18:0] SW,			  // only for test
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6,
				 output logic [7:0]  LEDG,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
	 
    logic Reset_h, Clk;
    logic [7:0] keycode;
	 logic [7:0] led;
	 logic [2047:0] game_file;
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  LEDG <= led;
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
 

    //------------home------------//
	 logic [7:0]home_data;
    logic is_home, home_exit;

    //------------background------------//
	 logic [7:0]background_data;
    logic is_background,background_exit;

    //------------saber------------//
	 logic saber_exit;
	 logic [9:0]saber_x,saber_y;
	 logic [5:0]saber_state;
    logic [7:0]saber_data;
    logic is_saber;
	 //------------monster1------------//
	 logic monster1_exit;
	 logic [9:0]monster1_x,monster1_y;
	 logic [5:0]monster1_state;
    logic [7:0]monster1_data;
    logic is_monster1;
	 
	 //------------monster2------------//
	 logic monster2_exit;
	 logic [9:0]monster2_x,monster2_y;
	 logic [5:0]monster2_state;
    logic [7:0]monster2_data;
    logic is_monster2;
	 
	 //------------portrait------------//
	 logic is_portrait1,is_portrait2;
	 logic saber_portrait;
	 logic [7:0]portrait1_data,portrait2_data;
	
//------------------- assign data -------------------//
	 //------------home------------//
	 assign home_exit = game_file[640];
	 
	 //------------background------------//
	 assign background_exit = game_file[608];

	 //------------saber------------//
	 assign saber_exit = game_file[0];
	 assign saber_x = game_file[41:32];
	 assign saber_y = game_file[73:64];
	 assign saber_state = game_file[101:96];
	 assign saber_portrait = game_file[128]; // 1 for portrait 1 and 0 for portrait 2

	 //------------monster1------------//
	 assign monster1_exit = game_file[224];
	 assign monster1_x = game_file[265:256];
	 assign monster1_y = game_file[297:288];
	 assign monster1_state = game_file[325:320];
	 
	 	 //------------monster2------------//
	 assign monster2_exit = game_file[416];
	 assign monster2_x = game_file[457:448];
	 assign monster2_y = game_file[489:480];
	 assign monster2_state = game_file[517:512];
	 
	 logic [9:0] DrawX, DrawY;
	 
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),       
									  .game_export_readdata(game_file),
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk, 
														 .Reset(Reset_h), 
														 .VGA_HS, 
														 .VGA_VS,
														 .VGA_CLK,
														 .VGA_BLANK_N,
														 .VGA_SYNC_N,
														 .DrawX,
														 .DrawY);
    
    home home( .Clk,
				   .home_exit,
				   .DrawX,
				   .DrawY,
				   .home_data, //output
				   .is_home); 		 //output
								  
    background background(.Clk,
								  .background_exit,
								  .DrawX,
								  .DrawY,
								  .background_data, //output
								  .is_background); 		 //output

    saber saber (.Clk,
					  .saber_exit(game_file[0]),
                 .DrawX, 
                 .DrawY,
					  .saber_x,
					  .saber_y,
					  .saber_state,
                 .saber_data,	//output
                 .is_saber);  //output

	 portrait1 portrait1(.Clk, 
								.portrait1_exit(saber_portrait), //for test
								.DrawX, 
								.DrawY,
								.portrait1_data,	//output
								.is_portrait1);		//output
	
	 portrait2 portrait2(.Clk, 
								.portrait2_exit(~saber_portrait), //for test
								.DrawX, 
								.DrawY,
								.portrait2_data,	//output
								.is_portrait2);		//output
		
	 monster1 monster1(.Clk, 
							 .monster1_exit,
							 .DrawX, 
							 .DrawY,
							 .monster1_x,
							 .monster1_y,
							 .monster1_state,
							 .monster1_data,
							 .is_monster1);

	 monster2 monster2(.Clk, 
							 .monster2_exit,
							 .DrawX, 
							 .DrawY,
							 .monster2_x,
							 .monster2_y,
							 .monster2_state,
							 .monster2_data,
							 .is_monster2);
									
//	 SaberFSM FSM (.Clk,
//						.Reset(Reset_h),
//						.frame_clk(VGA_VS),
//						.sw(SW[5:0]),
//						.saber_state);

    color_mapper color_instance(.is_home,
										  .is_background,
                                .is_saber,
										  .is_portrait1,
										  .is_portrait2,
										  .is_monster1,
										  .is_monster2,
										  .home_data,
                                .background_data,
                                .saber_data,
										  .portrait1_data,
										  .portrait2_data,
										  .monster1_data,
										  .monster2_data,
                                .DrawX,
                                .DrawY,
                                .VGA_R,
                                .VGA_G,
                                .VGA_B);
    
	 

    // Display keycode on hex display
    HexDriver hex_inst_0 ({3'b000,is_home}, HEX0);
    HexDriver hex_inst_1 ({3'b000,is_background}, HEX1);
	 HexDriver hex_inst_2 (monster2_data[3:0], HEX2);
	 HexDriver hex_inst_3 (monster2_data[7:4], HEX3);
//	 HexDriver hex_inst_4 ({3'b000,monster1_exit}, HEX4);
//	 HexDriver hex_inst_5 ({2'b00,saber_state[5:4]}, HEX5);
//	 HexDriver hex_inst_6 ({2'b00,saber_state[5:4]}, HEX6);
	 
	 
	
	 
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
