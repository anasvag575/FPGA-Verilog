`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   baud_controller_tb
// Project Name: UART Lab02 Project
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
module vga_driver_tb;
reg clk,reset;
wire VGA_RED,VGA_BLUE,VGA_GREEN,VGA_HSYNC,VGA_VSYNC;

//Instatiate vram_unit
vga_driver instance_name (
    .reset(reset),
    .clk(clk),
    .VGA_RED(VGA_RED),
    .VGA_GREEN(VGA_GREEN),
    .VGA_BLUE(VGA_BLUE),
    .VGA_HSYNC(VGA_HSYNC),
    .VGA_VSYNC(VGA_VSYNC)
    );

initial begin
clk=0;
reset=0;
#5 reset=1;
#1 reset=0;

end

always  begin
  #10 clk=~clk;
end

endmodule
