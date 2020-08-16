`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   Hsync testbench
// Project Name: VGA Driver Lab03 Project
// Target Devices: FPGA Spartan 3E
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

//Testbench for led_decoder ->Its a simple combinational circuit so
//we just check output based on every input
`timescale 1ns / 10ps
module LCD_driver_tb;
reg clk,reset;
wire LCD_RS,LCD_RW,LCD_E;
wire [3:0] SF_D;

LCD_driver instance_name (
    .clk(clk),
    .reset(reset),
    .SF_D(SF_D),
    .LCD_E(LCD_E),
    .LCD_RS(LCD_RS),
    .LCD_RW(LCD_RW)
    );

initial begin
clk=0;

reset=1;
#50 reset=0;

end

always  begin
  #10 clk=~clk;
end

endmodule
