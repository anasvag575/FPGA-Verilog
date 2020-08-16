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

//Top level Module that implements the function tested for lab1 project
module FourDigitLEDdriver(reset, clk, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);
input clk, reset;
wire clk_new , reset_new;
output an3, an2, an1, an0;
output a, b, c, d, e, f, g, dp;
wire [3:0] char, fsm_state;

//dcm instance
dcm_manage dcm_manag_instance (.clk(clk),
                               .clk_new(clk_new));

//fsm instance
fsm fsm_instance (.clk(clk_new),
                  .reset(reset_new),
                  .state(fsm_state),
                  .AN3(an3),
                  .AN2(an2),
                  .AN1(an1),
                  .AN0(an0));

//anti bounce for reset instance
anti_bounce anti_bounce_instance(.clk(clk_new),
                  .in_bit(reset),
                  .out_state(reset_new));


//driving decimal point (turn off)
assign dp = 1'b1;

//led decoder instance
LEDdecoder LEDdecoderINSTANCE (.char(char),
                               .LED({a,b,c,d,e,f,g}));

//Memory and fsm instance
mem mem_instance (.clock(clk_new),
                  .reset(reset_new),
                  .state(fsm_state),
                  .char_out(char));

endmodule
