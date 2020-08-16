`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:    mem
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

//Memory Module with address pointer
module mem(input clock,reset,input [3:0]state,output reg [3:0]char_out);

parameter COUNT_MAX = 22'd4194303;  //2^22-1
reg [3:0] addr;
reg [3:0] message [15:0];
reg [21:0] count ;
wire add_trig;

//address pointer management
//If reseted goes to 0 /
//if add_trig is high increment by 1
//Else remains the same
always @(posedge clock or posedge reset)
  begin
    if(reset == 1'b1)
		addr<=4'b0000;
	 else if(add_trig)
	   addr<=addr+1;
	 else 
	   addr<=addr;
  end

//22-bit delay counter
always @(posedge clock or posedge reset)
  begin
    if(reset == 1'b1)
		count <= 0;
	 else
	   count<= count+1;
  end  

//triger the character movement
assign add_trig = (count == COUNT_MAX)?1'b1:1'b0;

//Memory output based on the state of the state machine
//Data is out 2 cycles before the anodes
always @(posedge clock or posedge reset)
  begin
    if(reset == 1'b1)
		char_out<=4'b0000;
	 else if(state == 4'b0000)
	   char_out <= message[addr];
	 else if(state == 4'b1100)
	   char_out <= message[addr+1];
	 else if(state == 4'b1000)
	   char_out <= message[addr+2];
	 else if(state == 4'b0100)
	   char_out <= message[addr+3];
	 else 
	   char_out<= char_out;
  end


//Memory Initialization
always @(posedge clock or posedge reset)
  begin
    if(reset)
	   begin
		  message[0]<=4'd0;
		  message[1]<=4'd1;
		  message[2]<=4'd2;
		  message[3]<=4'd3;
		  message[4]<=4'd4;
		  message[5]<=4'd5;
		  message[6]<=4'd6;
		  message[7]<=4'd7;
		  message[8]<=4'd8;
		  message[9]<=4'd9;
		  message[10]<=4'd10;
		  message[11]<=4'd11;
		  message[12]<=4'd12;
		  message[13]<=4'd13;
		  message[14]<=4'd14;
		  message[15]<=4'd15;
		end
  end

endmodule
