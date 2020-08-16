`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   LEDdecoder
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

module LEDdecoder(char, LED);
input wire[3:0] char;
output reg[6:0] LED;

//Every character code
parameter char_0 = 7'b0000001,
			 char_1 = 7'b1001111,
			 char_2 = 7'b0010010,
			 char_3 = 7'b0000110,
			 char_4 = 7'b1001100,
			 char_5 = 7'b0100100,
			 char_6 = 7'b0100000,
			 char_7 = 7'b0001111,
			 char_8 = 7'b0000000,
			 char_9 = 7'b0000100,
			 char_A = 7'b0001000,
			 char_b = 7'b1100000,
			 char_C = 7'b0110001,
			 char_d = 7'b1000010,
			 char_E = 7'b0110000,
			 char_F = 7'b0111000;

//Led decoder decodes 4-bit character code into 7-bit input signal
//for the active 7-segment led display part
always @(char)
begin
  case(char)
    4'd0:LED = char_0;
    4'd1:LED = char_1;
    4'd2:LED = char_2;
    4'd3:LED = char_3;
    4'd4:LED = char_4;
    4'd5:LED = char_5;
    4'd6:LED = char_6;
    4'd7:LED = char_7;
    4'd8:LED = char_8;
    4'd9:LED = char_9;
    4'd10:LED = char_A;
    4'd11:LED = char_b;
    4'd12:LED = char_C;
    4'd13:LED = char_d;
    4'd14:LED = char_E;
    4'd15:LED = char_F;
  endcase
end

endmodule
