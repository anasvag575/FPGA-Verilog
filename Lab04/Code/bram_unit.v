`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   BRAM unit
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
module bram_unit (clk,char_out,addr);
input clk;
output [7:0] char_out;
input [10:0] addr;

   RAMB16_S9 #(
      .INIT(9'h000),  // Value of output RAM registers at startup
      .SRVAL(9'h000), // Output value upon SSR assertion
      .WRITE_MODE("WRITE_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

      //Message as follows -> ABCDEFGHIJKLMNOP <next line> abcdefghijklmno(cursor)
		//The 00s inbetween the first line and the second are the non displayed characters
      .INIT_00(256'hFF_6F_6E_6D_6C_6B_6A_69_68_67_66_65_64_63_62_61_50_4F_4E_4D_4C_4B_4A_49_48_47_46_45_44_43_42_41),
      .INIT_01(256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00)
   ) RAMB16_S9_inst (
      .DO(char_out),      // 8-bit Data Output
      .ADDR(addr),  // 11-bit Address Input
      .CLK(clk),    // Clock
      .EN(1'b1),      // RAM Enable Input
      .SSR(1'b0),    // Synchronous Set/Reset Input
      .WE(1'b0)       // Write Enable Input
   );

endmodule
