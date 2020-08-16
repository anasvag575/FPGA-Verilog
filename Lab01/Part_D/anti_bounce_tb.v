`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    dcm_tb
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

//testbench for debounce module ->
//(Still has to be tested in practice)
module anti_bounce_tb;

 reg pb_1;//Input button signal
 reg clk;
 // Outputs
 wire pb_out;//Debounced button signal output

 // Instantiate the debouncing Verilog code
 anti_bounce uut (
  .in_bit(pb_1),
  .clk(clk),
  .out_state(pb_out)
 );

 initial begin
  clk = 0;
  forever #10 clk = ~clk;
 end
 initial begin
  pb_1 = 0;
  #10;
  pb_1=1;
  #20;
  pb_1 = 0;
  #10;
  pb_1=1;
  #30;
  pb_1 = 0;
  #10;
  pb_1=1;
  #40;
  pb_1 = 0;
  #10;
  pb_1=1;
  #30;
  pb_1 = 0;
  #10;
  pb_1=1;
  #400;
  pb_1 = 0;
  #10;
  pb_1=1;
  #20;
  pb_1 = 0;
  #10;
  pb_1=1;
  #30;
  pb_1 = 0;
  #10;
  pb_1=1;
  #40;
  pb_1 = 0;
 end

endmodule
