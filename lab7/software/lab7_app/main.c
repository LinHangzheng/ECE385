// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	volatile unsigned int *KEY_PIO = (unsigned int*)0x50; //make a pointer to access the PIO block
	volatile unsigned int *SW_PIO  = (unsigned int*)0x60; //make a pointer to access the PIO block
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the PIO block

	*LED_PIO = 0; //clear all LEDs
	int Reset_pressed = 0; // initialize the condition of reset button
	int Accumulate_pressed = 0; // initialize the condition of accumulate button.
	unsigned int Accumulate = 0; // initialize the accumulate value

	while ( (1+1) != 3) //infinite loop
	{
		// Reset button: Key[2]
		if ((*KEY_PIO & 0x1)!=0 && Reset_pressed==0){
			Accumulate = 0; 			// Reset the value
			*LED_PIO = 0; 				// clear all LEDs
			Reset_pressed = 1; 			// set the reset button as pressed
		}

		// Accumulate button: Key[3]
		if ((*KEY_PIO & 0x2)!=0 && Accumulate_pressed==0){
			Accumulate += *SW_PIO; 		// update the value
			if (Accumulate >= 256){
				Accumulate -= 256; 		// loop the accumulate value
			}
			Accumulate_pressed = 1;		// set the accumulate button as pressed
		}


		*LED_PIO = Accumulate; 			//set LSB

		if ((*KEY_PIO & 0x1)==0){
			Reset_pressed = 0;			// release reset button
		}
		if ((*KEY_PIO & 0x2)==0){
			Accumulate_pressed = 0; 	// release accumulate button
		}
	}
	return 1; //never gets here
}
