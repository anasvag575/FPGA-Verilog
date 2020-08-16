`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    fsm
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

//Given clk and reset signals ,the module outputs the 4-BIT signal
//that drives every LED part ,out of the 4 of the display.
module fsm(input clk, reset,output reg AN3, AN2, AN1, AN0,output reg [3:0] state);


//State Register (counter)
//Counter that goes in reverse with asychronous reset.
always @(posedge clk or posedge reset)
begin
  if (reset)
	state<=4'b1111;
  else
	state<=state-1;
end

//Output logic used for lighting up each part out
//of the 4 of the LED display correctly
always @(posedge clk or posedge reset)
begin
  if(reset)
    begin
      AN3<=1; AN2<=1; AN1<=1; AN0<=1;
    end
  else if(state==4'b1110)
    begin
      AN3<=0; AN2<=1; AN1<=1; AN0<=1;
    end
  else if(state==4'b1010)
    begin
      AN3<=1; AN2<=0; AN1<=1; AN0<=1;
    end
  else if(state==4'b0110)
    begin
      AN3<=1; AN2<=1; AN1<=0; AN0<=1;
    end
  else if(state==4'b0010)
    begin
      AN3<=1; AN2<=1; AN1<=1; AN0<=0;
    end
	else
    begin
      AN3<=1; AN2<=1; AN1<=1; AN0<=1;
	 end
  end

endmodule
