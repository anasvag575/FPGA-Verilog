`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    FourDigitLEDdriver
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

//Top level Module that implements the function tested for lab1 project part B
module FourDigitLEDdriver_tb;
reg clk, reset ;
wire an3, an2, an1, an0;
wire a, b, c, d, e, f, g, dp;

//Instatiate LEDdecoder module
FourDigitLEDdriver instance_name (
    .reset(reset),
    .clk(clk),
    .an3(an3),
    .an2(an2),
    .an1(an1),
    .an0(an0),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .g(g),
    .dp(dp)
    );


initial
  begin
   clk=0;
   reset = 0;
   #10;
   reset=1;
   #20;
   reset = 0;
   #10;
   reset=1;
   #30;
   reset = 0;
   #10;
   reset=1;
   #40;
   reset = 0;
   #10;
   reset=1;
   #30;
   reset = 0;
   #10;
   reset=1;
   #400;
   reset = 0;
   #10;
   reset=1;
   #20;
   reset = 0;
   #10;
   reset=1;
   #30;
   reset = 0;
   #10;
   reset=1;
   #40;
   reset = 0;
	#400;
	reset = 1;
	#400;
	reset=0;
end

always begin
  #1 clk=~clk;
end

endmodule
