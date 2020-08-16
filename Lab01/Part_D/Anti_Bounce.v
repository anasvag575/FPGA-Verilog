`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   anti_bounce_reset
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

//The anti_bounce module takes a input signal which has jitter
//filters it and outputs a pulse when its stable
module anti_bounce(input clk, in_bit, output reg out_state);

parameter N=15;  // counter size
parameter COUNTER_DELAY =15'd32767;  // Delay in cycles ->about 10ms in real time (2^N-1)
reg sync_1 ,sync_2;
reg [N-1:0] counter;
wire count_en;

//sychronizer Flip Flops
always @(posedge clk) begin
  sync_1<=in_bit;
  sync_2<=sync_1;
end
//count enable signal
assign count_en = (sync_1 && sync_2);

//debouncer logic
always @(posedge clk)
begin
  if(count_en == 1'b0) begin  //signal not stable yet or 0
    out_state<=0;
	  counter<=0;
	end
  else if (counter == COUNTER_DELAY) begin  //counter maxed =>output signal
    out_state<=sync_2;
	  counter<=0;
	end
  else
    counter <=counter+1;   //signal stable counter not filled yet
end

endmodule
