`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    led_decoder_tb
// Project Name: FourDigitLEDdriver Lab01 Project
// Target Devices: FPGA Spartan 3
// Tool versions: -----
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

//Testbench for led_decoder ->Its a simple combinational circuit so
//we just check output based on every input
`timescale 1ns / 10ps
module led_decoder_tb;
reg [3:0] char;
wire [6:0] LED;
integer i;

//Instatiate LEDdecoder module
LEDdecoder un1(.char(char), .LED(LED));

initial
  begin

$monitor("char: %4b, LED: %7b" ,char, LED);
    for(i=0;i<16;i=i+1)
	begin
	  #5 char=i;
	end
end

endmodule
