`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    dcm_manag
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

//Dcm_manage module that is given the 100Mhz clock of the FPGA
//divides it by 16 and outputs as the new clock of the project
module dcm_manage (input clk,output clk_new);

	//Helps in reseting the DCM Properly and locking
	//16-bit shift register LUT operating on posedge of clock
	SRL16 #(
      .INIT(16'h000F) // Initial Value of Shift Register
   ) SRL16_inst (
      .Q(RST),       // SRL data output
      .A0(1'b0),     // Select[0] input
      .A1(1'b0),     // Select[1] input
      .A2(1'b0),     // Select[2] input
      .A3(1'b1),     // Select[3] input
      .CLK(CLKIN),   // Clock input
      .D(1'b0)        // SRL data input
   );

	//buffer for the clock feedback
	BUFG IBUFG_inst (
      .O(CLKFB),     // Clock buffer output
      .I(CLK0)      // Clock buffer input
   );

	//input clock buffer
	IBUFG #(
      .IOSTANDARD("DEFAULT")
   ) IBUFG_inst2 (
      .O(CLKIN),     // Clock buffer output
      .I(clk)      // Clock buffer input
   );

	//Global clock buffer which outputs
	//the new clock for the FPGA
	BUFG BUFG_inst (
      .O(clk_new),     // Clock buffer output
      .I(CLKDV)      // Clock buffer input
   );

//dcm
//Input goes through a buffer and then to the DCM
//In order to have a functional DCM we connect the clk output (CLK0) to feedback (CLKFB)
//Our output clock to be used is CLKDV which goes through a buffer and then the buffered clock (clk_new)
//is to be used for the LED_DRIVER circuit as the new clock
DCM #(
      .CLKDV_DIVIDE(16),   // Can be any integer from 1 to 32
      .CLK_FEEDBACK("1X")  // Specify clock feedback of NONE, 1X or 2X
   ) DCM_inst (
      .CLK0(CLK0),     // 0 degree DCM CLK output
      .CLKDV(CLKDV),   // Divided DCM CLK out (CLKDV_DIVIDE)
      .CLKFB(CLKFB),   // DCM clock feedback
      .CLKIN(CLKIN),   // Clock input (from IBUFG, BUFG or DCM)
      .RST(RST)        // DCM asynchronous reset input
   );
endmodule
