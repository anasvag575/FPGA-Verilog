`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:  address_control
// Project Name: LCD Driver Lab04 Project
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
module address_control_unit (clk,reset,trans_end,addr_act,addr_data);
input clk,reset,trans_end,addr_act;
output reg [7:0] addr_data;

//address pointers for ddram and bram respectively
reg [7:0] addr_ddram;
reg [5:0] addr_bram;

reg [14:0]refresh_count;
reg cursor_flag;

reg [1:0]state;
wire [7:0]char_out;

parameter IDLE=2'b00,
			 SEND_ADDRESS=2'b01,
			 WRITE_DATA=2'b11,
			 MAX_BRAM_ADDRESS = 31,
			 END_LINE_DDRAM_ADDRESS = 15,
			 MAX_DDRAM_ADDRESS = 79,
			 DELAY_1_S = 24000;

///Bram unit instance
bram_unit instance_name (
    .clk(clk),
    .char_out(char_out),
    .addr({5'b0,addr_bram})
    );

//State Machine state handling
always @(posedge clk or posedge reset) begin
  if(reset)
    state<=IDLE;
  else begin
     case(state)
	    IDLE:if(addr_act) state<=SEND_ADDRESS;
		 SEND_ADDRESS:if(trans_end) state<=WRITE_DATA;
		 WRITE_DATA:if(trans_end) state<=SEND_ADDRESS;
	  endcase
  end
end

//Outputs of the state machine based on the state we are on
always @ (state or addr_ddram or char_out) begin
  case(state)
    IDLE:addr_data = 8'bx;
    SEND_ADDRESS:addr_data = addr_ddram;
	 WRITE_DATA:addr_data = char_out;
	 default:addr_data = 8'bx;
  endcase
end

///Bram address pointer
always @ (posedge clk or posedge reset) begin
  if(reset)
    addr_bram<=0;
  else begin
  	if(state == WRITE_DATA && trans_end && cursor_flag && addr_bram == MAX_BRAM_ADDRESS-1)
	 addr_bram<=addr_bram+2;
   else if(state==IDLE || (state == WRITE_DATA && addr_bram >=MAX_BRAM_ADDRESS && trans_end))
	 addr_bram<=0;
	else if(state == WRITE_DATA && trans_end)
	 addr_bram<=addr_bram+1;
	else
	 addr_bram<=addr_bram;
  end
end

///DDram address pointer
always @ (posedge clk or posedge reset) begin
  if(reset)
    addr_ddram<=0;
  else begin
   if(state==IDLE || (addr_ddram == MAX_DDRAM_ADDRESS && trans_end && state == SEND_ADDRESS))
	 addr_ddram<=0;
	else if(state == SEND_ADDRESS && trans_end && addr_bram == END_LINE_DDRAM_ADDRESS)
	 addr_ddram<=7'h40;
	else if(state == SEND_ADDRESS && trans_end)
	 addr_ddram<=addr_ddram+1;
	else
	 addr_ddram<=addr_ddram;
  end
end

///Counter that counts the delay of 1s for the blinking cursor
always @ (posedge clk or posedge reset) begin
  if(reset)
    refresh_count<=0;
  else begin
    if(refresh_count == DELAY_1_S || state==IDLE)//only when maxed out or in idle
	   refresh_count<=0;
	 else if(trans_end)//The counter changes at the end of every state
	   refresh_count<=refresh_count+1;
  end
end

///Blinking cursor
always @ (posedge clk or posedge reset) begin
  if(reset)
    cursor_flag<=0;
  else begin
    if(refresh_count == DELAY_1_S)//when counter is maxed toggle the value
	   cursor_flag<=~cursor_flag;
  end
end

endmodule
