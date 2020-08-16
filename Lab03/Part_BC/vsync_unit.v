`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   Vsync
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
module vsync_unit (clk,reset,VSYNC,v_rgb_enable);
input clk,reset;
output VSYNC,v_rgb_enable;
reg [19:0] v_count;

parameter TOTAL_FRAME_TIME_O = 833499,    //VSYNC Timings
          VSYNC_PULSE_WIDTH_P = 3200,
          BACK_PORCH_Q = 46400,
          ACTIVE_VIDEO_TIME_R = 768000,
          FRONT_PORCH_S =16000;

parameter LOW_RGB = VSYNC_PULSE_WIDTH_P + BACK_PORCH_Q; //Bounds where we show RGB Color
parameter UPPER_RGB = TOTAL_FRAME_TIME_O - FRONT_PORCH_S+102;  //They are based on HSYNC timings

//v_count for VSYNC implementation
always @ (posedge clk or posedge reset) begin
  if(reset == 1)
    v_count<=0;
	else begin
	  //we reached the apropriate time
	  if(v_count == TOTAL_FRAME_TIME_O)
	    v_count<=0;
	   else
		 v_count<=v_count+1;
	end
end

//VSYNC is active low
assign VSYNC = (v_count < VSYNC_PULSE_WIDTH_P)?1'b0:1'b1;
//Enable RGB for ACTIVE_VIDEO_TIME_R
assign v_rgb_enable = (v_count >LOW_RGB && v_count< UPPER_RGB)?1'b1:1'b0;

endmodule