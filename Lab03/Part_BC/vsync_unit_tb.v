`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   Vsync testbench
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
module vsync_unit_tb;
reg clk,reset;
wire VSYNC,v_rgb_enable;

//Instatiate vram_unit
vsync_unit instance_name (
    .clk(clk), 
    .reset(reset), 
    .VSYNC(VSYNC), 
    .v_rgb_enable(v_rgb_enable)
    );

initial begin
clk=0;

//$monitor("red: %1b, green: %1b,blue: %1b" ,r_pixel,g_pixel,b_pixel);
clk=0;
reset=1;

#50 reset=0;
end

always  begin
  #10 clk=~clk;
end

endmodule