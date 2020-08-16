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

module uart_receiver(reset, clk, Rx_DATA, baud_select, Rx_EN, RxD,
Rx_FERROR, Rx_PERROR, Rx_VALID);
input reset, clk;
input [2:0] baud_select;
input Rx_EN;
input RxD;

output reg [7:0] Rx_DATA;
output reg Rx_FERROR; // Framing Error //
output reg Rx_PERROR; // Parity Error //
output Rx_VALID; // Rx_DATA is Valid //
wire Rx_sample_ENABLE;

parameter COUNT_MAX=4'b1111, //counter that counts tx_sample_enables
          COUNT_HALF=4'b0111,  //counter value only for start bit
		    START_BIT=4'b0001, //STATES the receiver goes through
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

reg [3:0]state = IDLE;
reg [3:0]counter;
reg [2:0]counter_s;
reg trans_act;
reg parity_bit;
reg stop_bit;

baud_controller baud_controller_rx_instance(reset, clk, baud_select, Rx_sample_ENABLE);

//Counter that counts baud rate ticks
//It counts after START_BIT state change till end of transmission
//Hence the 4-bit size
always @(posedge clk or posedge reset) begin
  if(reset==1)
    counter<=0;
  else begin
    if(state==IDLE ||state==START_BIT)
      counter<=0;
    else if(Rx_sample_ENABLE==1)
      counter<=counter+1;
  end
end

//Counter that counts baud rate ticks
//It counts only for START_BIT state
//Hence the 3-bit size
always @(posedge clk or posedge reset) begin
  if(reset==1)
    counter_s<=0;
  else begin
    if(state!=START_BIT)
      counter_s<=0;
    else if(Rx_sample_ENABLE==1)
      counter_s<=counter_s+1;
  end
end

//activation signal for the IDLE STATE (IDLE ->START BIT)
always @(negedge RxD or posedge Rx_sample_ENABLE) begin
   if(state==IDLE && Rx_EN == 1 && RxD==0)
	  trans_act<=1;
	else
	  trans_act<=0;
end

///state machine that handles the operation of the receiver
//the state machine is circular
//so we start at idle state and we end at idle state
always @(posedge Rx_sample_ENABLE) begin

		case(state) //we change state in the middle of the bit we sample
		  IDLE:if(trans_act) state<=START_BIT;
		  START_BIT:if(counter_s==COUNT_HALF) state<=DATA_8;
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

//Output DATA to system handling
always @(posedge Rx_sample_ENABLE or posedge reset) begin
    if(reset == 1) begin
	    Rx_DATA<=0;
		 parity_bit<=0;
		 stop_bit<=0;
	 end
	 else begin
	   case(state)//we sample in the middle of the bit we are in
		  IDLE:Rx_DATA<=Rx_DATA;
		  START_BIT:Rx_DATA<=Rx_DATA;
		  DATA_8:if(counter==COUNT_MAX) Rx_DATA[0]<=RxD;
		  DATA_7:if(counter==COUNT_MAX) Rx_DATA[1]<=RxD;
		  DATA_6:if(counter==COUNT_MAX) Rx_DATA[2]<=RxD;
		  DATA_5:if(counter==COUNT_MAX) Rx_DATA[3]<=RxD;
		  DATA_4:if(counter==COUNT_MAX) Rx_DATA[4]<=RxD;
		  DATA_3:if(counter==COUNT_MAX) Rx_DATA[5]<=RxD;
		  DATA_2:if(counter==COUNT_MAX) Rx_DATA[6]<=RxD;
		  DATA_1:if(counter==COUNT_MAX) Rx_DATA[7]<=RxD;
		  PARITY:if(counter==COUNT_MAX) parity_bit<=RxD;
		  STOP_TRANS:if(counter==COUNT_MAX-1) stop_bit<=RxD;
		endcase
	 end
end


//Output signals for system
always @(posedge Rx_sample_ENABLE or posedge reset) begin
//we reset signals when transmission starts
   if(reset==1 || state==START_BIT) begin
	  Rx_FERROR<=1;
     Rx_PERROR<=1;
	end
	//and we calculate them every time transmission ends
	else begin
	   if(state==STOP_TRANS && counter==COUNT_MAX) begin

       //Stop bit correct or not
			if(stop_bit == 1'b1)
			  Rx_FERROR<=1'b0;
			else
			  Rx_FERROR<=1'b1;

       //parity bit correct or not
			if(parity_bit == ^Rx_DATA)
			  Rx_PERROR<=1'b0;
			else
			  Rx_PERROR<=1'b1;

	   end
	 end
end

//assigning Valid data signal
//Only during IDLE time (after transmission ends till next start of another one)
assign Rx_VALID = ~(Rx_PERROR || Rx_FERROR) && (state==IDLE);

endmodule
