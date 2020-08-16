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
module vram_unit_tb;
reg clk;
reg [13:0] addr;
wire r_pixel,g_pixel,b_pixel;

//Instatiate vram_unit
vram_unit instance_name (
    .clk(clk),
    .addr(addr),
    .r_pixel(r_pixel),
    .g_pixel(g_pixel),
    .b_pixel(b_pixel)
    );

initial begin
clk=0;

$monitor("red: %1b, green: %1b,blue: %1b" ,r_pixel,g_pixel,b_pixel);

#40 addr=10; //white

#200 addr=6048;  //green

#200 addr=3072;   //white

#200 addr=120;    //red

#200 addr=9120;    //blue

end

always  begin
  #10 clk=~clk;
end

endmodule
