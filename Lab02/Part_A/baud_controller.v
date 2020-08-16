`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   baud_controller
// Project Name: UART Lab02 Project
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

module baud_controller(reset,clk,baud_select,sample_ENABLE);
input reset,clk;
input[2:0] baud_select;
output reg sample_ENABLE;
reg [13:0] cycle_counter;

//cycles to count for count_max
//more info on the report and excel spreadsheet
parameter COUNT_MAX_000 = 10416,
			 COUNT_MAX_001 = 2603,
			 COUNT_MAX_010 = 650,
			 COUNT_MAX_011 = 325,
			 COUNT_MAX_100 = 162,
			 COUNT_MAX_101 = 80,
			 COUNT_MAX_110 = 53,
			 COUNT_MAX_111 = 26;

//counter loop ->choose when to reset its value based on baud
//rate and its maximum counter value
always @(posedge clk or posedge reset) begin
  if(reset ==1'b1) begin //initialize counter
    cycle_counter<=0;
    sample_ENABLE<=0;
  end
  else if(baud_select == 3'b000 && cycle_counter == COUNT_MAX_000) begin
    cycle_counter<=0;
	  sample_ENABLE<=1;
  end
  else if(baud_select == 3'b001 && cycle_counter == COUNT_MAX_001) begin
    cycle_counter<=0;
	  sample_ENABLE<=1;
  end
  else if(baud_select == 3'b010 && cycle_counter == COUNT_MAX_010) begin
    cycle_counter<=0;
	  sample_ENABLE<=1;
  end
  else if(baud_select == 3'b011 && cycle_counter == COUNT_MAX_011) begin
    cycle_counter<=0;
	  sample_ENABLE<=1;
  end
  else if(baud_select == 3'b100 && cycle_counter == COUNT_MAX_100) begin
    cycle_counter<=0;
	  sample_ENABLE<=1;
  end
  else if(baud_select == 3'b101 && cycle_counter == COUNT_MAX_101) begin
    cycle_counter<=0;
	  sample_ENABLE<=1;
  end
  else if(baud_select == 3'b110 && cycle_counter == COUNT_MAX_110) begin
    cycle_counter<=0;
	  sample_ENABLE<=1;
  end
  else if(baud_select == 3'b111 && cycle_counter == COUNT_MAX_111) begin
    cycle_counter<=0;
	  sample_ENABLE<=1;
  end
  else begin//haven't reach any max
    cycle_counter<=cycle_counter+1;
	  sample_ENABLE<=0;
  end
end


endmodule
