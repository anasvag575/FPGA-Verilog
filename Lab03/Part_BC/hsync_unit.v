`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   Hsync
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
module hsync_unit (clk,reset,VSYNC,HSYNC,VPIXEL,HPIXEL,h_rgb_enable,v_rgb_enable);
input clk,reset;
output HSYNC;
input VSYNC;
input v_rgb_enable;
output h_rgb_enable;
output reg [6:0] HPIXEL;
output reg [6:0] VPIXEL;
reg [10:0] h_count;
reg [3:0] h_pix;
reg [2:0] v_pix;

parameter SCANLINE_TIME_A = 1599,    //HSYNC Timings
          HSYNC_PULSE_WIDTH_B = 192,
			 BACK_PORCH_C = 96,
			 DISPLAY_TIME_D = 1280,
			 FRONT_PORCH_E = 32,
			 H_RESOLUTION = 127, //The Horizontal max resolution
          V_RESOLUTION =95;
			 
parameter LOW_RGB = HSYNC_PULSE_WIDTH_B + BACK_PORCH_C-1; //Bounds where we show RGB Color
parameter UPPER_RGB = SCANLINE_TIME_A - FRONT_PORCH_E+1;  //They are based on HSYNC timings

//hcounter implementation
always @ (posedge clk or posedge reset) begin
  if(reset == 1)
    h_count<=0;
	else begin
	  //we reached the apropriate time
	  if(h_count == SCANLINE_TIME_A || VSYNC==0)
	    h_count<=0;
	  else
		 h_count<=h_count+1;
	end
end

//HPIXEL (part of vram address we are showing)
//it changes inside hsync active time
always @ (posedge clk or posedge reset) begin
  if(reset == 1)
    HPIXEL<=0;
  else if(v_rgb_enable == 0 ||h_rgb_enable == 0)//deacttivate when video is inactive
	 HPIXEL<=0;
  else if(h_pix ==9)
	 HPIXEL<=HPIXEL+1;
end

//VPIXEL (part of vram address we are showing)
always @ (posedge clk or posedge reset) begin
  if(reset == 1)
    VPIXEL<=0;
  else if(v_rgb_enable == 0)//reset when vsync rgb is down
	 VPIXEL<=0;
  else if(HPIXEL == H_RESOLUTION && v_pix==4 && h_pix==9) begin
      if(VPIXEL==V_RESOLUTION)//we reached the end line
	     VPIXEL<=0;
	   else
	     VPIXEL<= VPIXEL+1;//else increment
  end
end

//counter for y axis
//It multiplies the pixel we are showing by 5
always @ (posedge clk or posedge reset) begin
  if(reset == 1) begin
	 v_pix<=0;
  end
  else if(v_rgb_enable == 0 )begin
	 v_pix<=0;
  end
	else begin//do something after every hsync
     if(h_count == SCANLINE_TIME_A) begin
	     if(v_pix == 4)
		    v_pix<=0;
		  else
		    v_pix<=v_pix+1;
	  end
	end
end

//counter for x axis or HPIXEL
//It multiplies the pixel we are showing by 5
//We count 10 cycles using h_pix (25.6us = 128HPIXELS x 10)
always @ (posedge clk or posedge reset) begin
  if(reset == 1)
	 h_pix<=0;
  else if(h_rgb_enable == 0)//set to 0 when rgb inactive
	 h_pix<=0;
	else begin
	  if(h_pix == 9) //max value of h_pix
		 h_pix<=0;
	  else
		 h_pix<=h_pix+1;//increment
	end
end

//hsync is active low
assign HSYNC = ((h_count<HSYNC_PULSE_WIDTH_B))?1'b0:1'b1;
//Enable RGB for DISPLAY_TIME_D
assign h_rgb_enable = (h_count >LOW_RGB && h_count<UPPER_RGB)?1'b1:1'b0;

endmodule