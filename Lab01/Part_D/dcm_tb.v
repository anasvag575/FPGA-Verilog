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

//Module that tests the DCM module
module dcm_tb(
    );
reg clk,reset;
wire clk_new;

//Instantiate dcm_manage module
dcm_manage u1(.clk(clk),
              .clk_new(clk_new));

initial
  begin
    clk=0;
  end

always
  begin
    #1 clk=~clk;
  end

endmodule
