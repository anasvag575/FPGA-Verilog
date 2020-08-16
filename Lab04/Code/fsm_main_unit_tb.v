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
module fsm_main_unit_tb;
reg clk,reset;
wire [3:0]SF_D;
wire LCD_E;

fsm_main_unit instance_name (
    .clk(clk),
    .reset(reset),
    .SF_D(main_SF_D),
    .LCD_E(main_LCD_E),
    .trans_act(trans_act),
    .trans_end(trans_end),
	 .op_sel(op_sel)
    );

initial begin
clk=0;

reset=1;
#50 reset=0;

end

always  begin
  #10 clk=~clk;
end

endmodule
