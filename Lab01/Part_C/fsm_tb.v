`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    fsm_tb
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

//Testbench for fsm ->Just a simple monitor over time
`timescale 1ns / 10ps
module fsm_tb;
reg clk,reset;
integer i;
wire AN3,AN2,AN1,AN0;

//instatiate fsm module
fsm un1(.clk(clk),
        .reset(reset),
        .AN3(AN3),
        .AN2(AN2),
        .AN1(AN1),
        .AN0(AN0));

initial
  begin
	reset=1;
	clk=0;
	#2 reset=0;
	$monitor("AN3:%b, AN2:%b, AN1:%b, AN0:%b" ,AN3,AN2,AN1,AN0);
end

always
  begin
    #1 clk=~clk;
  end

endmodule
