`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   baud_controller_tb
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

//Testbench for led_decoder ->Its a simple combinational circuit so
//we just check output based on every input
`timescale 1ns / 10ps
module led_decoder_tb;
reg clk,reset;
wire sample_ENABLE;
reg [2:0] baud_select;

//Instatiate baud_controller
baud_controller instance_name (
    .reset(reset),
    .clk(clk),
    .baud_select(baud_select),
    .sample_ENABLE(sample_ENABLE)
    );

initial begin
clk=0;
reset=1;
baud_select=3'b000;

#5 reset = 0;

end

always  begin
  #1 clk=~clk;
end

endmodule
