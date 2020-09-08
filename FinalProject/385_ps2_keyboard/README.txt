Ensure that these pin assignments exist in your Pin Planner: 
PS2_CLK PIN_G6
PS2_DAT PIN_H5

To use PS/2 keyboard, add PS2_CLK and PS2_DAT as 1-bit inputs to your top level entity. Add the files in this folder (keyboard.sv, Dreg.sv, and 11_reg.sv) to your project, and create an instance of "keyboard" in your top level entity. Set the keyboard's psClk input to PS2_CLK, and set the psData input to PS2_DAT. 

The "keyCode" and "press" outputs describe the most recent key press or key release. keyCode outputs a value corresponding to the specific key (see Scan Codes in Resources), and press indicates whether the key was pressed or released. For more details, see the overview in resources. 

Be sure to remove your hpi_io_intf.sv instance from your top level entity and OTG signals from your NIOS when you get this working. 

Resources: 
Overview: www.computer-engineering.org/ps2keyboard
Scan Codes: www.computer-engineering.org/ps2keyboard/scancodes2.html