`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   Vga_driver
// Project Name: VGA Driver Lab03 Project
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

//top level module that we instatiate every module
module vga_driver (reset,clk,VGA_RED,VGA_GREEN,VGA_BLUE,VGA_HSYNC,VGA_VSYNC);

input clk,reset;
wire reset_new;
wire VSYNC;
wire [13:0]addr;
wire r_pixel,g_pixel,b_pixel;
output VGA_RED,VGA_GREEN,VGA_BLUE,VGA_HSYNC,VGA_VSYNC;
wire [6:0] HPIXEL,VPIXEL;

//vram instance
vram_unit unit_ram (
    .clk(clk),
    .addr(addr),
    .r_pixel(r_pixel),
    .g_pixel(g_pixel),
    .b_pixel(b_pixel)
    );

//anti bounce circuit
    anti_bounce anti_unit (
     .in_bit(reset),
     .clk(clk),
     .out_state(reset_new)
    );
	 
//hsync unit
	 hsync_unit hsync_uut (
    .clk(clk), 
    .reset(reset),
	 .VSYNC(VSYNC),
    .HSYNC(VGA_HSYNC),
	 .VPIXEL(VPIXEL), 
    .HPIXEL(HPIXEL), 
    .h_rgb_enable(h_rgb_enable),
	 .v_rgb_enable(v_rgb_enable)
    );

//Vsync unit
vsync_unit vsync_uut (
    .clk(clk), 
    .reset(reset), 
    .VSYNC(VSYNC), 
    .v_rgb_enable(v_rgb_enable)
    );

//ram enable => when to read from ram (active during display time)
assign ram_enable = v_rgb_enable && h_rgb_enable;
//ram addr is the concat of VPIXEL and HPIXELS
assign addr = {VPIXEL,HPIXEL};
assign VGA_VSYNC = VSYNC;

//assigning color output based on ram enable signal
assign VGA_RED = (ram_enable==1)?r_pixel:1'b0;
assign VGA_GREEN = (ram_enable==1)?g_pixel:1'b0;
assign VGA_BLUE = (ram_enable==1)?b_pixel:1'b0;

endmodule