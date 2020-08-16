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
module LCD_driver (clk,reset,SF_D,LCD_E,LCD_RS,LCD_RW);
input clk,reset;
//outputs
output [3:0] SF_D;
output LCD_RW,LCD_RS,LCD_E;

//activation wire signals
//used for communication between modules
wire trans_act,trans_end,addr_act;

//Both main and op fsm units output these signals
//so we need these wires for the main assignment
wire op_LCD_E,main_LCD_E;
wire [3:0] op_SF_D,main_SF_D;

//Which op to do 
wire [2:0] op_sel;

//output of bram
wire [7:0] addr_data;

fsm_main_unit dut1 (
    .clk(clk),
    .reset(reset),
    .SF_D(main_SF_D),
    .LCD_E(main_LCD_E),
    .trans_act(trans_act),
    .trans_end(trans_end),
	 .addr_act(addr_act),
	 .op_sel(op_sel)
    );

// Instantiate the module
fsm_ops_unit dut2 (
    .clk(clk),
    .reset(reset),
    .trans_act(trans_act),
    .trans_end(trans_end),
    .op_sel(op_sel),
    .addr_data(addr_data),
    .LCD_RS(LCD_RS),
    .LCD_RW(LCD_RW),
    .LCD_E(op_LCD_E),
    .SF_D(op_SF_D)
    );

//instantiate the address control unit
address_control_unit dut4 (
    .clk(clk), 
    .reset(reset), 
    .trans_end(trans_end),
	 .addr_act(addr_act),
    .addr_data(addr_data)
    );
	 
	 
	 // Instantiate the module
//anti_bounce dut5 (
  //  .clk(clk), 
    //.in_bit(reset), 
    //.out_state(reset)
    //);

//assigning control signals for the output of the driver
assign LCD_E = op_LCD_E || main_LCD_E;
assign SF_D = op_SF_D | main_SF_D;

endmodule
