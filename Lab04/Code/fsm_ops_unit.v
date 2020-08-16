`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   Fsm Ops Unit
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
module fsm_ops_unit (clk,reset,trans_act,trans_end,op_sel,addr_data,LCD_RS,LCD_RW,LCD_E,SF_D);
input clk,reset,trans_act;
input [2:0] op_sel;
input [7:0] addr_data;

output LCD_RW,LCD_E,LCD_RS,trans_end;//LCD control signals
output reg [3:0] SF_D;

//Counters to be used
reg [3:0] op_counter;
reg [5:0] del_op_counter;
reg [10:0] del_max_counter;

//state reg
reg [4:0] state;

//Selection of Ops (Input from op_sel)
parameter   CLEAR_DISPLAY = 3'b000,
				ENTRY_MODE_SET = 3'b001,
				FUNCTION_SET = 3'b010,
				SET_DDRAM_ADDRESS = 3'b011,
				WRITE_DATA_TO_DDRAM  = 3'b100,
				DISPLAY_ON_OFF = 3'b101;

            //UPPER OP STATES
parameter   UPPER_CLEAR_DISPLAY = 5'b01000,
				UPPER_ENTRY_MODE_SET = 5'b01001,
				UPPER_FUNCTION_SET = 5'b01010,
				UPPER_SET_DDRAM_ADDRESS = 5'b01011,
				UPPER_WRITE_DATA_TO_DDRAM  = 5'b01100,
				UPPER_DISPLAY_ON_OFF = 5'b01101;
				//LOWER OP STATES
parameter   LOWER_CLEAR_DISPLAY = 5'b10000,
				LOWER_ENTRY_MODE_SET = 5'b10001,
				LOWER_FUNCTION_SET = 5'b10010,
				LOWER_SET_DDRAM_ADDRESS = 5'b10011,
				LOWER_WRITE_DATA_TO_DDRAM  = 5'b10100,
				LOWER_DISPLAY_ON_OFF = 5'b10101;

				//EXTRA STATES
parameter   DELAY_1 = 5'b00000,
				DELAY_2 = 5'b00001,
				IDLE = 5'b00010,
				TRANS_END = 5'b00011;

//counter for LCD Enable
//The values are 0-40ns LCD->0
//as follows     40-280ns LCD->1
//					  280-300ns LCD->0
//So we need 15 cycles and 4-bit counter(300ns/20ns = 15)
always @(posedge clk or posedge reset) begin
  if(reset==1)
    op_counter<=0;
  else if(op_counter==14 || state==DELAY_1 || state==DELAY_2 ||state==TRANS_END ||state==IDLE) //max value 15 cycles
    op_counter<=0;
  else
    op_counter<=op_counter+1;
end

//Counter for 1�s delay between upper and lower bits
//Counter Size is 6 bits (1�s/20ns = 50 cycles)
always @(posedge clk or posedge reset) begin
  if(reset==1)
    del_op_counter<=0;
  else if(del_op_counter==49 || state!=DELAY_1)//max value 50cycles
    del_op_counter<=0;
  else
    del_op_counter<=del_op_counter+1;
end

//Counter for 40�s delay for the assignment of next op
//Counter Size is 11 bits (40�s/20ns = 2000 cycles)
always @(posedge clk or posedge reset) begin
  if(reset==1)
    del_max_counter<=0;
  else if(del_max_counter==1999 || state!=DELAY_2)//max value 2000cycles
    del_max_counter<=0;
  else
    del_max_counter<=del_max_counter+1;
end

//State Machine state handling
always @(posedge clk or posedge reset) begin
  if(reset==1)
    state<=IDLE;
  else begin
		casex(state)
		 5'b1xxxx://LOWER OPS STATES
			if(op_counter==14)
			   state<=DELAY_2;
	    5'b01xxx://UPPER OPS STATES
			if(op_counter==14)
				state<=DELAY_1;
		 IDLE://Idle state gets the trigers and chooses which op to move on to
			if(trans_act==1) begin
			  case(op_sel)
				 CLEAR_DISPLAY:state<=UPPER_CLEAR_DISPLAY;
				 ENTRY_MODE_SET:state<=UPPER_ENTRY_MODE_SET;
				 FUNCTION_SET:state<=UPPER_FUNCTION_SET;
				 SET_DDRAM_ADDRESS:state<=UPPER_SET_DDRAM_ADDRESS;
				 WRITE_DATA_TO_DDRAM:state<=UPPER_WRITE_DATA_TO_DDRAM;
				 DISPLAY_ON_OFF:state<=UPPER_DISPLAY_ON_OFF;
			  endcase
			end
		 DELAY_1://from delay we branch out again to the lower op bits
			if(del_op_counter==49) begin
			  case(op_sel)
				 CLEAR_DISPLAY:state<=LOWER_CLEAR_DISPLAY;
				 ENTRY_MODE_SET:state<=LOWER_ENTRY_MODE_SET;
				 FUNCTION_SET:state<=LOWER_FUNCTION_SET;
				 SET_DDRAM_ADDRESS:state<=LOWER_SET_DDRAM_ADDRESS;
				 WRITE_DATA_TO_DDRAM:state<=LOWER_WRITE_DATA_TO_DDRAM;
				 DISPLAY_ON_OFF:state<=LOWER_DISPLAY_ON_OFF;
			  endcase
			end
		  DELAY_2://we go to intermediate state TRANS_END
			 if(del_max_counter==1999)
				state<=TRANS_END;
		  TRANS_END://state where we let the main we finished
				state<=IDLE;
		  default:state<=IDLE;
		endcase
	end
end

//State Machine outputs for every state
always @(state or addr_data) begin

  case(state)
    //SPECIAL STATES
    IDLE: SF_D = 4'b0000;
	 DELAY_1: SF_D = 4'b0000;
	 DELAY_2: SF_D = 4'b0000;
	 TRANS_END: SF_D = 4'b0000;
	 //UPPER OP STATES
	 UPPER_CLEAR_DISPLAY: SF_D = 4'b0000;
	 UPPER_ENTRY_MODE_SET:SF_D = 4'b0000;
	 UPPER_FUNCTION_SET:SF_D = 4'b0010;
	 UPPER_DISPLAY_ON_OFF:SF_D = 4'b0000;
	 UPPER_SET_DDRAM_ADDRESS:SF_D = {1'b1,addr_data[6:4]};
	 UPPER_WRITE_DATA_TO_DDRAM:SF_D = addr_data[7:4];
	 /////LOWER OP STATES
	 LOWER_CLEAR_DISPLAY:SF_D = 4'b0001;
	 LOWER_ENTRY_MODE_SET:SF_D = 4'b0110;
	 LOWER_FUNCTION_SET:SF_D = 4'b1000;
	 LOWER_DISPLAY_ON_OFF:SF_D = 4'b1100;
	 LOWER_SET_DDRAM_ADDRESS:SF_D = addr_data[3:0];
	 LOWER_WRITE_DATA_TO_DDRAM:SF_D = addr_data[3:0];
	 default: SF_D = 4'b0000;
  endcase
end

//**Control Signals**

//** Read/Write signal always high except when we are sending the upper or lower op command
assign LCD_RW = 1'b0;

//** Register Select signal ,only high during sending upper/lower data to DDRAM
assign LCD_RS = (op_counter <15 && ( state==LOWER_WRITE_DATA_TO_DDRAM || state==UPPER_WRITE_DATA_TO_DDRAM))?1'b1:1'b0;

//** LCD Enable signal,active for a specific time
assign LCD_E = (op_counter>1 && op_counter <14)?1'b1:1'b0;

//Handshake signal for the main FSM
//When high the Mom Fsm knows we are done
assign trans_end = (state==TRANS_END)?1'b1:1'b0;

endmodule