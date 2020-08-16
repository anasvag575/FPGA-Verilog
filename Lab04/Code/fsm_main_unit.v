`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   Fsm Main Unit
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
module fsm_main_unit (clk,reset,SF_D,LCD_E,trans_act,trans_end,addr_act,op_sel);
input clk,reset,trans_end;
output reg [3:0] SF_D;
output reg LCD_E,trans_act,addr_act;
output reg [2:0] op_sel;

//flags for reusal of states
reg [1:0] state_op_flag;
reg state_wait_flag;

//counters used for the delay states
reg [19:0] b_delay_counter;
reg [12:0] s_delay_counter;
reg [3:0] e_delay_counter;

//state register
reg [4:0] state;

//parameters of initialization
parameter IDLE=5'b00000,
			 WAIT_15_MS =5'b00001,
			 WAIT_4_1_MS=5'b00010,
			 WAIT_100_MIC_S=5'b00011,
			 WAIT_40_MIC_S=5'b00100,
			 SEND_LCD_E_0X03=5'b00101,
			 SEND_LCD_E_0X02=5'b00110;

//parameters of Configuration 
parameter SEND_FUNCTION_SET=5'b01000,
			 SEND_ENTRY_MODE_SET=5'b01001,
			 SEND_DISPLAY_ON_OFF=5'b01010,
			 SEND_CLEAR_DISPLAY=5'b01011,
			 WAIT_1_64_MS=5'b01100;
			 
//parameters of drawing to screen
parameter SEND_SET_DDRAM_ADDRESS = 5'b01101,
			 SEND_WRITE_DATA_TO_DDRAM = 5'b01110;
			 
//Selection of Ops (Outputs for op_sel)
parameter   CLEAR_DISPLAY = 3'b000,
				ENTRY_MODE_SET = 3'b001,
				FUNCTION_SET = 3'b010,
				SET_DDRAM_ADDRESS = 3'b011,
				WRITE_DATA_TO_DDRAM  = 3'b100,
				DISPLAY_ON_OFF = 3'b101;

//TIME CONSTANTS 
parameter DELAY_15_MS = 749999,
			 DELAY_4_1_MS = 204999,
			 DELAY_100_MIC_S = 4999,
			 DELAY_40_MIC_S = 1999,
			 DELAY_1_64_MS = 81999,
			 DELAY_LCD_E = 11;

//big delay counter
//Counter used for the Milisecond delays
always @(posedge clk or posedge reset) begin
  if(reset)
    b_delay_counter<=0;
  else if(state!=WAIT_15_MS && state!=WAIT_4_1_MS && state!=WAIT_1_64_MS)
    b_delay_counter<=0;
  else
    b_delay_counter<=b_delay_counter+1;	
end

//small delay counter
//Counter use for the microsecond delays
always @(posedge clk or posedge reset) begin
  if(reset)
    s_delay_counter<=0;
  else if(state!=WAIT_100_MIC_S && state!=WAIT_40_MIC_S)
    s_delay_counter<=0;
  else
    s_delay_counter<=s_delay_counter+1;	
end

//LCD_E delay counter (the 12 cycles we need for it)
always @(posedge clk or posedge reset) begin
  if(reset)
    e_delay_counter<=0;
  else if(state!=SEND_LCD_E_0X02 && state!=SEND_LCD_E_0X03)
    e_delay_counter<=0;
  else
    e_delay_counter<=e_delay_counter+1;	
end

//State Flags
//They are used as inputs for the state machine
//state_wait_flag is for the reuse of WAIT_40_MIC_S state
always @(posedge clk or posedge reset) begin
  if(reset)
    state_wait_flag<=0;
  else begin
    if(state==SEND_LCD_E_0X02)
      state_wait_flag<=1'b1;
    else if(state!=WAIT_40_MIC_S)
      state_wait_flag<=1'b0;
    else
      state_wait_flag<=state_wait_flag;
  end
end

//state_op_flag is for the reuse of SEND_LCD_E_0X03 state
always @(posedge clk or posedge reset) begin
  if(reset)
    state_op_flag<=2'b00;
  else begin
    if(state==WAIT_4_1_MS)
      state_op_flag<=2'b01;
    else if(state==WAIT_100_MIC_S)
      state_op_flag<=2'b10;
	 else if(state!=SEND_LCD_E_0X03)
      state_op_flag<=2'b00;
	 else
	   state_op_flag<=state_op_flag;
  end
end

//State handling
//Main Fsm state handling where we handle the transitions between the states
//and what are the triggers of each one transition
always @(posedge clk or posedge reset) begin
  if(reset)
    state<=IDLE;
  else begin
    case(state)
	 ///***********INIT PHASE**************
	 ///***********************************
	   IDLE:state<=WAIT_15_MS;
		WAIT_15_MS:
		  if(b_delay_counter == DELAY_15_MS)
		    state<=SEND_LCD_E_0X03;
		SEND_LCD_E_0X03://we have multiple choices if its the 1st,2nd or 3rd time we visit this state
		  if(state_op_flag == 2'b00 && e_delay_counter == DELAY_LCD_E)
		    state<=WAIT_4_1_MS;
		  else if(state_op_flag == 2'b01 && e_delay_counter == DELAY_LCD_E)
			 state<=WAIT_100_MIC_S;
		  else if(state_op_flag == 2'b10 && e_delay_counter == DELAY_LCD_E)
	       state<=WAIT_40_MIC_S;
		WAIT_4_1_MS:
		  if(b_delay_counter == DELAY_4_1_MS)
		    state<=SEND_LCD_E_0X03;
		WAIT_100_MIC_S:
		  if(s_delay_counter == DELAY_100_MIC_S)
		    state<=SEND_LCD_E_0X03;
	   WAIT_40_MIC_S://we have 2 choices choices if its the 1st or 2nd time we visit this state
		  if(s_delay_counter == DELAY_40_MIC_S && state_wait_flag==1'b0)
		    state<=SEND_LCD_E_0X02;
		  else if(s_delay_counter == DELAY_40_MIC_S && state_wait_flag==1'b1)
		    state<=SEND_FUNCTION_SET;//We exit init phase
		SEND_LCD_E_0X02:
		  if(e_delay_counter == DELAY_LCD_E)
	       state<=WAIT_40_MIC_S;
	///***********CONFIGURATION PHASE***********
	///*****************************************
		SEND_FUNCTION_SET:
		  if(trans_end)
		    state<=SEND_ENTRY_MODE_SET;
		SEND_ENTRY_MODE_SET:
		  if(trans_end)
		    state<=SEND_DISPLAY_ON_OFF;
		SEND_DISPLAY_ON_OFF:
		  if(trans_end)
		    state<=SEND_CLEAR_DISPLAY;
      SEND_CLEAR_DISPLAY:
        if(trans_end)
          state<=WAIT_1_64_MS;
      WAIT_1_64_MS:
		  if(b_delay_counter == DELAY_1_64_MS)
		    state<=SEND_SET_DDRAM_ADDRESS;
	 ///**********DRAWING TO SCREEN*************
	 ///****************************************
	   SEND_SET_DDRAM_ADDRESS:
		  if(trans_end)
		     state<=SEND_WRITE_DATA_TO_DDRAM;
		SEND_WRITE_DATA_TO_DDRAM:
		  if(trans_end)
		     state<=SEND_SET_DDRAM_ADDRESS;
	 endcase
  end
end

//Output of the state machine
//The signals we output in every state
always @(state) begin
	casex(state)
	//***********INIT PHASE**************
	//***********************************
	  5'b000xx://bundled states(idle or delay states)
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b0;
		  op_sel=3'bxxx;
		  addr_act=1'b0;
		end
	  WAIT_40_MIC_S:
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b0;
		  op_sel=3'bxxx;
		  addr_act=1'b0;
		end
	  SEND_LCD_E_0X03:
	    begin
	     SF_D=4'b0011;
		  LCD_E=1'b1;
		  trans_act=1'b0;
		  op_sel=3'bxxx;
		  addr_act=1'b0;
		end
	  SEND_LCD_E_0X02:
	   begin
	     SF_D=4'b0010;
		  LCD_E=1'b1;
		  trans_act=1'b0;
		  op_sel=3'bxxx;
		  addr_act=1'b0;
		end
	//***********CONFIG PHASE**************
	//*************************************
	  SEND_FUNCTION_SET:
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b1;
		  op_sel=FUNCTION_SET;
		  addr_act=1'b0;
		end
	  SEND_ENTRY_MODE_SET:
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b1;
		  op_sel=ENTRY_MODE_SET;
		  addr_act=1'b0;
		end
	  SEND_DISPLAY_ON_OFF:
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b1;
		  op_sel=DISPLAY_ON_OFF;
		  addr_act=1'b0;
		end
	  SEND_CLEAR_DISPLAY:
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b1;
		  op_sel=CLEAR_DISPLAY;
		  addr_act=1'b0;
		end
	  WAIT_1_64_MS:
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b0;
		  op_sel=3'bxxx;
		  addr_act=1'b0;
		end
	  default:
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b0;
		  op_sel=3'bxxx;
		  addr_act=1'b0;
		end
	//***********DRAWING TO SCREEN*********
	//*************************************
	  SEND_SET_DDRAM_ADDRESS:
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b1;
		  op_sel=SET_DDRAM_ADDRESS;
		  addr_act=1'b1;
		end   
	  SEND_WRITE_DATA_TO_DDRAM:
	   begin
	     SF_D=4'b0000;
		  LCD_E=1'b0;
		  trans_act=1'b1;
		  op_sel=WRITE_DATA_TO_DDRAM;
		  addr_act=1'b0;
		end
	endcase
end

endmodule