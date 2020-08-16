`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    led_decoder_tb
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

`timescale 1ns / 10ps
module uart_receiver_tb;
reg clk,reset;
reg [2:0] baud_select;
reg Rx_EN;
wire Rx_FERROR,Rx_PERROR,Rx_VALID;
reg [7:0] Rx_DATA;

reg Tx_EN,Tx_WR;
reg [7:0] Tx_DATA;

//Instatiate uart_transmitter
uart_receiver instance_name (
    .reset(reset),
    .clk(clk),
    .Rx_DATA(Rx_DATA),
    .baud_select(baud_select),
    .Rx_EN(Rx_EN),
    .RxD(TxD), //we short this input to TxD output of transmitter
    .Rx_FERROR(Rx_FERROR),
    .Rx_PERROR(Rx_PERROR),
    .Rx_VALID(Rx_VALID)
    );

//Instatiate uart_receiver
uart_transmitter instance_name2 (
    .reset(reset),
    .clk(clk),
    .Tx_DATA(Tx_DATA),
    .Tx_WR(Tx_WR),
    .Tx_EN(Tx_EN),
    .TxD(TxD),
    .Tx_BUSY(Tx_BUSY),
    .baud_select(baud_select)
    );

initial begin
clk=0;
reset=1;
baud_select=3'b111;
Rx_EN=1;

//First Input
Tx_EN=1;
Tx_WR=0;
Tx_DATA=8'b10101010;
#5 reset = 0;
#100 Tx_WR=1;
#2 Tx_WR=0;

//Test for disable
//Rx_EN=0;

//second input
#14000 Tx_WR=1;
Tx_DATA=8'b00111000;
#2 Tx_WR=0;

end

always  begin
  #1 clk=~clk;
end

endmodule
