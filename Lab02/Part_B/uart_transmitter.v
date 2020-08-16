`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   uart_transmitter
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

module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);
input reset, clk;
input [7:0] Tx_DATA;
input [2:0] baud_select;
input Tx_EN;
input Tx_WR;

output reg TxD;
output Tx_BUSY;
wire Tx_sample_ENABLE;

parameter COUNT_MAX=15, //counter that counts tx_sample_enables
		    START_BIT=4'b0001, //STATES the transmitter goes through
		    DATA_1=4'b0010,
		    DATA_2=4'b0011,
		    DATA_3=4'b0100,
		    DATA_4=4'b0101,
		    DATA_5=4'b0110,
		    DATA_6=4'b0111,
		    DATA_7=4'b1000,
		    DATA_8=4'b1001,
		    PARITY=4'b1010,
		    STOP_TRANS=4'b1011,
		    IDLE=4'b1100;

reg [8:0]DATA_Symbol;   //register that hold the data to sent
reg [3:0]counter;       //counter that counts 16 baud ticks
reg [3:0]state = IDLE;  //state that handles the transmission
reg trans_act;

baud_controller baud_controller_tx_instance(reset, clk, baud_select, Tx_sample_ENABLE);

//receive data from system
always @(posedge clk or posedge reset) begin
  if(reset==1) begin
    DATA_Symbol <=9'b1;
  end
  else begin
    if(Tx_WR == 1 && Tx_BUSY==0 && Tx_EN == 1) begin
	    DATA_Symbol[7:0] <= Tx_DATA;
       DATA_Symbol[8] <= ^Tx_DATA;
	 end
  end
end

//Counter that counts tx_sample_enable ticks
always @(posedge clk or posedge reset) begin
  if(reset == 1)
    counter<=0;
  else begin
    if(Tx_EN == 0 && state==IDLE)
	  counter<=0;
    else if(Tx_BUSY==0)
     counter<=0;
    else if(Tx_sample_ENABLE==1)
     counter<=counter+1;
  end
end

//register that activates state machine
always @(posedge clk or posedge reset) begin
  if (reset==1)
    trans_act<=1'b0;
  else begin
	 if(Tx_WR == 1 && Tx_BUSY==0 && Tx_EN == 1)
      trans_act<=1'b1;
    else if(state!=IDLE)
      trans_act <=1'b0;
  end
end

//if system is not in idle state then we are busy
assign Tx_BUSY = ~(state == IDLE);

//State handling for the transmitter
//the state machine is circular
//so we start at idle state and we end at idle state
always @(posedge Tx_sample_ENABLE) begin

		case(state)
		  IDLE:if(trans_act==1) state<=START_BIT;
		  START_BIT:if(counter==COUNT_MAX) state<=DATA_8;
		  DATA_8:if(counter==COUNT_MAX) state<=DATA_7;
		  DATA_7:if(counter==COUNT_MAX) state<=DATA_6;
		  DATA_6:if(counter==COUNT_MAX) state<=DATA_5;
		  DATA_5:if(counter==COUNT_MAX) state<=DATA_4;
		  DATA_4:if(counter==COUNT_MAX) state<=DATA_3;
		  DATA_3:if(counter==COUNT_MAX) state<=DATA_2;
		  DATA_2:if(counter==COUNT_MAX) state<=DATA_1;
		  DATA_1:if(counter==COUNT_MAX) state<=PARITY;
			PARITY:if(counter==COUNT_MAX) state<=STOP_TRANS;
		  STOP_TRANS:if(counter==COUNT_MAX) state<=IDLE;
		endcase
end

//assigning TxD based on the state we are in
always @(state) begin
  case(state)
	START_BIT:TxD=1'b0;
	DATA_8:TxD=DATA_Symbol[0];
	DATA_7:TxD=DATA_Symbol[1];
	DATA_6:TxD=DATA_Symbol[2];
	DATA_5:TxD=DATA_Symbol[3];
	DATA_4:TxD=DATA_Symbol[4];
	DATA_3:TxD=DATA_Symbol[5];
	DATA_2:TxD=DATA_Symbol[6];
	DATA_1:TxD=DATA_Symbol[7];
	PARITY:TxD=DATA_Symbol[8];
	STOP_TRANS:TxD=1'b1;
	IDLE:TxD=1'b1;
	default:TxD=1'b1;
  endcase
end

endmodule
