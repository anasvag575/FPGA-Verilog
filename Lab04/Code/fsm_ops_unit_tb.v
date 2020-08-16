`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   Hsync testbench
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

//Testbench for led_decoder ->Its a simple combinational circuit so
//we just check output based on every input
`timescale 1ns / 10ps
module fsm_ops_unit_tb;
reg clk,reset;
wire LCD_E,LCD_RW,LCD_RS,trans_end;
wire [3:0] SF_D;
reg [2:0] op_sel;
reg trans_act;
reg [7:0] addr_data;

//Instatiate vram_unit
fsm_ops_unit dut2 (
    .clk(clk),
    .reset(reset),
    .trans_act(trans_act),
    .trans_end(trans_end),
    .op_sel(op_sel),
    .addr_data(addr_data),
    .LCD_RS(LCD_RS),
    .LCD_RW(LCD_RW),
    .LCD_E(LCD_E),
    .SF_D(SF_D)
    );


initial begin
clk=0;

clk=0;
reset=1;
op_sel = 3'b010;
addr_data = 8'bx;
trans_act=1'b1;
#50 reset=0;
#50 trans_act=0;

end

always  begin
  #10 clk=~clk;
end

endmodule
