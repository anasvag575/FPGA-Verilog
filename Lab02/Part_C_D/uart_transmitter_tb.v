`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    uart_transmitter_tb
// Project Name: UART Lab02 Project
// Target Devices: UART Lab02 Project
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
module uart_transmitter_tb;
reg clk,reset;
reg [2:0] baud_select;
reg Tx_EN,Tx_WR;
reg [7:0] Tx_DATA;

//Instatiate uart_transmitter
uart_transmitter instance_name (
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
Tx_EN=1;
Tx_WR=0;
Tx_DATA=8'b10101010;
#5 reset = 0;

#100 Tx_WR=1;
#2 Tx_WR=0;

/*Test W_R
#2 Tx_WR=1;
#500 Tx_WR=0;
*/

/*/Test EN
#2 Tx_EN=1;
#500 Tx_EN=0;
*/

/*Test New Data after old
#2 Tx_DATA=8'b00100101;
#2 Tx_EN=1;
#2 Tx_WR=0;

#2 Tx_WR=1;
*/

end

always  begin
  #1 clk=~clk;
end

endmodule
