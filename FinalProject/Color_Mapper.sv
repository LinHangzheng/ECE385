//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper (  input logic Clk,
								input logic [3:0]home_data,
                        input logic [3:0]background_data,
								input logic [3:0]win_data,
								input logic [3:0]gameover_data,
                        input logic [3:0]saber_data,
								input logic [3:0]Excalibur_data,
								input logic [3:0]HP_data,
								input logic [3:0]Excalibur_icon_data,
								input logic [3:0]portrait1_data,
								input logic [3:0]portrait2_data,
								input logic [3:0]monster1_data,
								input logic [3:0]monster2_data,
								input logic [3:0]blood1_data,
								input logic [3:0]blood2_data,
								input logic 	  is_home,
                        input logic      is_background,            // Whether current pixel belongs to background
                        input logic 	  is_win,
								input logic      is_gameover,
								input logic      is_saber,             // pixel for saber
								input logic 	  is_Excalibur,
								input logic 	  is_HP,
								input logic		  is_Excalibur_icon,
								input logic      is_portrait1,
								input logic      is_portrait2,
								input logic 	  is_monster1,
								input logic 	  is_monster2,
								input logic 	  is_blood1,
								input logic 	  is_blood2,
                        input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                        output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
						  );
    
    logic [7:0] Red, Green, Blue;
    logic [23:0] home_color, background_color,gameover_color,saber_color, HP_color,
					  portrait1_color, portrait2_color, monster1_color, monster2_color,
					  blood1_color, blood2_color, Excalibur_color, win_color, Excalibur_icon_color;
	 logic [23:0] color;
	 //----------------color palette----------------//
	 logic  [23:0] palette [0:255]; 
	 logic [23:0] background_palette [0:15];
	 logic [23:0] home_palette [0:15];
	 logic [23:0] monster1_palette [0:15];
	 logic [23:0] monster2_palette [0:15];
	 logic [23:0] portrait_palette [0:15];
	 logic [23:0] saber_palette [0:15];
	 logic [23:0] gameover_palette[0:15];
	 logic [23:0] blood_palette[0:15];
	 logic [23:0] Excalibur_palette[0:15];
	 logic [23:0] win_palette[0:15];
	 logic [23:0] Excalibur_icon_palette[0:15];
	 assign background_palette = '{24'hbda168, 24'h56a5ba, 24'h7dc7c9, 24'h2c3c17, 
											 24'h94723b, 24'h6b975a, 24'h377475, 24'h645223, 
											 24'h4c752b, 24'h5A4E14, 24'h394d44, 24'h277381, 
											 24'hBCE2F5, 24'hd88c12, 24'h58d571, 24'h9ab75c};
	
  	 assign home_palette = '{24'h7e8fb0, 24'h2c446b, 24'hece4d6, 24'hc3942d,
									 24'h99326f, 24'hb0e0f0, 24'hbdbccd, 24'h746f6f, 
									 24'h38b8f5, 24'h192d68, 24'hfaf9fe, 24'hbfafca,
									 24'hffc90d, 24'h8c86c4, 24'h569290, 24'hf2b890};
									 
	 assign monster1_palette = '{24'hff00ff, 24'h1c2832, 24'hd2ddeb, 24'h782b2e,
										  24'h7697c3, 24'h1b9896, 24'hc7b145, 24'h9cb1d2,
										  24'h9799a1, 24'he4d98a, 24'h5e1e85, 24'hededed,
										  24'h7799cc, 24'hf80000, 24'hededed, 24'h198282};
									
	 assign monster2_palette = '{24'hff00ff, 24'h110b08, 24'h91321c, 24'heccfac,
										  24'h09a318, 24'h7d28c2, 24'hd15d4d, 24'h582016,
										  24'ha97764, 24'h8e5463, 24'h5d2d2d, 24'hffddad,
										  24'h09871b, 24'hb13f3f, 24'hffffff, 24'hd00000};
									 
	 assign portrait_palette = '{24'hff00ff, 24'h11294c, 24'hf1e3c9, 24'h6a533f,
										  24'h847c7e, 24'hc49e71, 24'h876c4d, 24'hdab88d,
										  24'ha49389, 24'h4eb69b, 24'h123a44, 24'heeae8c,
										  24'h666eb0, 24'hffedd5, 24'haa9280, 24'h014e6a};
					
	 assign saber_palette = '{24'hff00ff, 24'hd1c286, 24'h313945, 24'h4cacd4, 
									  24'h7474c4, 24'hfcf59c, 24'hc0b6ac, 24'h3253bd, 
									  24'hffeed4, 24'hffffff, 24'hcad7ff, 24'h4c567e, 
									  24'he1db2b, 24'h928884, 24'hcad7ff, 24'hFFC08B};
	
	 assign gameover_palette = '{24'hff00ff, 24'ha0040a, 24'h600408, 24'h040404,
										  24'h300404, 24'h170404, 24'hdd0404, 24'h0c0404, 
										  24'h080410, 24'h080404, 24'h7d0000, 24'h460007, 
										  24'h5c0000, 24'h480008, 24'h5e0000, 24'h000000};
	
	 assign blood_palette ='{24'hff00ff, 24'h9c0404, 24'hb10404, 24'h940404, 
									 24'ha40404, 24'ha00404, 24'hdd0404, 24'h0c0404, 
									 24'h080410, 24'h080404, 24'h7d0000, 24'h460007, 
									 24'h5c0000, 24'h480008, 24'h5e0000, 24'h000000};
									 
	 assign Excalibur_palette = '{24'hff00ff, 24'hfcfae7, 24'hf8c24e, 24'hfad489, 
									  24'hfbe4b6, 24'hfcedcc, 24'hfcccad, 24'hf38511, 
									  24'hfcdccc, 24'hecac74, 24'hFFFFFF, 24'hFFDD99, 
									  24'hFFCBAA, 24'hffefcd, 24'hfdcba8, 24'hec9a56};
									  
	 assign win_palette = '{24'heaa890, 24'h251630, 24'h99484f, 24'hc34544, 
									24'h6b2f3d, 24'h5a3a77, 24'h745ab0, 24'haa99b2,
									24'h775e5a, 24'hFFAEC9, 24'hFEFFBD, 24'hFFFFFB, 
									24'hB3A9FF, 24'h5841B6, 24'hA26376, 24'h0C0F2E};
			
	 assign Excalibur_icon_palette = '{24'hff00ff, 24'h1c447f, 24'he8d9af, 24'h818b9d,
												  24'h7f6943, 24'h66657a, 24'hf6f5e9, 24'h1d1d35, 
												  24'hc0a56f, 24'hac9e9d, 24'h3B3453, 24'hEFEDE0, 
												  24'h8D8ED1, 24'hFFFFFD, 24'hC2BC82, 24'h493E42};
//	 assign palette = '{24'hff00ff,24'h800000,24'h008000,24'h808000,24'h000080,24'h800080,24'h008080,24'hc0c0c0,24'h808080,24'hff0000,24'h00ff00,24'hffff00,24'h0000ff,24'h000000,24'h00ffff,24'hffffff,24'h000000,24'h00005f,24'h000087,24'h0000af,24'h0000d7,24'h0000ff,24'h005f00,24'h005f5f,24'h005f87,24'h005faf,24'h005fd7,24'h005fff,24'h008700,24'h00875f,24'h008787,24'h0087af,24'h0087d7,24'h0087ff,24'h00af00,24'h00af5f,24'h00af87,24'h00afaf,24'h00afd7,24'h00afff,24'h00d700,24'h00d75f,24'h00d787,24'h00d7af,24'h00d7d7,24'h00d7ff,24'h00ff00,24'h00ff5f,24'h00ff87,24'h00ffaf,24'h00ffd7,24'h00ffff,24'h5f0000,24'h5f005f,24'h5f0087,24'h5f00af,24'h5f00d7,24'h5f00ff,24'h5f5f00,24'h5f5f5f,24'h5f5f87,24'h5f5faf,24'h5f5fd7,24'h5f5fff,24'h5f8700,24'h5f875f,24'h5f8787,24'h5f87af,24'h5f87d7,24'h5f87ff,24'h5faf00,24'h5faf5f,24'h5faf87,24'h5fafaf,24'h5fafd7,24'h5fafff,24'h5fd700,24'h5fd75f,24'h5fd787,24'h5fd7af,24'h5fd7d7,24'h5fd7ff,24'h5fff00,24'h5fff5f,24'h5fff87,24'h5fffaf,24'h5fffd7,24'h5fffff,24'h870000,24'h87005f,24'h870087,24'h8700af,24'h8700d7,24'h8700ff,24'h875f00,24'h875f5f,24'h875f87,24'h875faf,24'h875fd7,24'h875fff,24'h878700,24'h87875f,24'h878787,24'h8787af,24'h8787d7,24'h8787ff,24'h87af00,24'h87af5f,24'h87af87,24'h87afaf,24'h87afd7,24'h87afff,24'h87d700,24'h87d75f,24'h87d787,24'h87d7af,24'h87d7d7,24'h87d7ff,24'h87ff00,24'h87ff5f,24'h87ff87,24'h87ffaf,24'h87ffd7,24'h87ffff,24'haf0000,24'haf005f,24'haf0087,24'haf00af,24'haf00d7,24'haf00ff,24'haf5f00,24'haf5f5f,24'haf5f87,24'haf5faf,24'haf5fd7,24'haf5fff,24'haf8700,24'haf875f,24'haf8787,24'haf87af,24'haf87d7,24'haf87ff,24'hafaf00,24'hafaf5f,24'hafaf87,24'hafafaf,24'hafafd7,24'hafafff,24'hafd700,24'hafd75f,24'hafd787,24'hafd7af,24'hafd7d7,24'hafd7ff,24'hafff00,24'hafff5f,24'hafff87,24'hafffaf,24'hafffd7,24'hafffff,24'hd70000,24'hd7005f,24'hd70087,24'hd700af,24'hd700d7,24'hd700ff,24'hd75f00,24'hd75f5f,24'hd75f87,24'hd75faf,24'hd75fd7,24'hd75fff,24'hd78700,24'hd7875f,24'hd78787,24'hd787af,24'hd787d7,24'hd787ff,24'hd7af00,24'hd7af5f,24'hd7af87,24'hd7afaf,24'hd7afd7,24'hd7afff,24'hd7d700,24'hd7d75f,24'hd7d787,24'hd7d7af,24'hd7d7d7,24'hd7d7ff,24'hd7ff00,24'hd7ff5f,24'hd7ff87,24'hd7ffaf,24'hd7ffd7,24'hd7ffff,24'hff0000,24'hff005f,24'hff0087,24'hff00af,24'hff00d7,24'hff00ff,24'hff5f00,24'hff5f5f,24'hff5f87,24'hff5faf,24'hff5fd7,24'hff5fff,24'hff8700,24'hff875f,24'hff8787,24'hff87af,24'hff87d7,24'hff87ff,24'hffaf00,24'hffaf5f,24'hffaf87,24'hffafaf,24'hffafd7,24'hffafff,24'hffd700,24'hffd75f,24'hffd787,24'hffd7af,24'hffd7d7,24'hffd7ff,24'hffff00,24'hffff5f,24'hffff87,24'hffffaf,24'hffffd7,24'hffffff,24'h080808,24'h121212,24'h1c1c1c,24'h262626,24'h303030,24'h3a3a3a,24'h444444,24'h4e4e4e,24'h585858,24'h626262,24'h6c6c6c,24'h767676,24'h808080,24'h8a8a8a,24'h949494,24'h9e9e9e,24'ha8a8a8,24'hb2b2b2,24'hbcbcbc,24'hc6c6c6,24'hd0d0d0,24'hdadada,24'he4e4e4,24'heeeeee};

	 assign home_color = home_palette[home_data];
	 assign background_color = background_palette[background_data];
	 assign win_color = win_palette[win_data];
	 assign saber_color = saber_palette[saber_data];
	 assign Excalibur_color = Excalibur_palette[Excalibur_data];
	 assign portrait1_color = portrait_palette[portrait1_data];
	 assign portrait2_color = portrait_palette[portrait2_data];
	 assign monster1_color = monster1_palette[monster1_data];
	 assign monster2_color = monster2_palette[monster2_data];
	 assign blood1_color = blood_palette[blood1_data];
	 assign blood2_color = blood_palette[blood2_data];
	 assign gameover_color = gameover_palette[gameover_data];
	 assign HP_color = portrait_palette[HP_data];
	 assign Excalibur_icon_color = Excalibur_icon_palette[Excalibur_icon_data];
//    palette background_palette(.sprite_type(3'b0),
//										 .color_index({3'b000,background_data}),
//										 .color(background_color));
//	 palette saber_palette(.sprite_type(3'b1),
//								  .color_index({3'b000,saber_data}),
//								  .color(saber_color));
    // Output colors to VGA

    assign VGA_R = color[23:16];
    assign VGA_G = color[15:8];
    assign VGA_B = color[7:0];
    

    // Assign color based on is_ball signal
    always_comb begin
		if (is_home == 1'b1) begin
			color = home_color;
		end
		else if (is_win == 1'b1)begin
			color = win_color;
		end
		else if (is_gameover == 1'b1 && gameover_color != 24'hFF00FF)begin
			color = gameover_color;
		end
		else if (is_Excalibur == 1'b1 && Excalibur_color != 24'hFF00FF)begin
			color = Excalibur_color;
		end
      else if (is_saber ==1'b1 && saber_color != 24'hFF00FF)begin
			color = saber_color;
        end
		else if (is_blood1 == 1'b1 && blood1_color != 24'hFF00FF)begin
			color = blood1_color;
		end
		else if (is_blood2 == 1'b1 && blood2_color != 24'hFF00FF)begin
			color = blood2_color;
		end
		else if (is_monster1 == 1'b1 && monster1_color!= 24'hFF00FF) begin
			color = monster1_color;
        end
		else if (is_monster2 == 1'b1 && monster2_color!= 24'hFF00FF) begin
			color = monster2_color;
        end
		else if (is_portrait1 == 1'b1 && portrait1_color!= 24'hFF00FF) begin
			color = portrait1_color;
		end
		else if (is_portrait2 == 1'b1 && portrait2_color!= 24'hFF00FF) begin
			color = portrait2_color;
		end
		else if (is_HP == 1'b1 && HP_color != 24'hFF00FF)begin
			color = HP_color;
		end
		else if (is_Excalibur_icon == 1'b1 && Excalibur_icon_color != 24'hFF00FF)begin
			color = Excalibur_icon_color;
		end
	   else if (is_background == 1'b1) begin
			color = background_color;
	   end
      else begin
            // Background with nice color gradient
        	color = 24'hFFFFFF;
		end
    end 
    
endmodule
