`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    mem_tb
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

//testbench for memory ->
//When a trigger signal is high (either a physical button or a state machine)
//the memory has to change its output to the next letter
`timescale 1ns / 10ps
module mem_tb;
wire [3:0] character;
reg reset,clk,button;
integer i;

mem un1(.clk(clk),
        .reset(reset),
        .add_trig(button),
        .char_out(character));

initial
  begin
	  reset=1;
	  clk=0;
	  button=0;
	  #1 reset=0;
	  #6 button=1;
  	#26 button=0;
    //#15 button=1;
	  $monitor("character:%b ,button:%b ",character,button);
end

always
  begin
    #1 clk=~clk;
  end
endmodule
