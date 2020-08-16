`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ---
// Engineer: Vagenas Anastasis 2496
//
// Create Date:    20:10:01 10/12/2019
// Design Name:  -----
// Module Name:   VRAM
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
module vram_unit (clk,addr,r_pixel,g_pixel,b_pixel);

input clk;
input [13:0] addr;
output r_pixel,g_pixel,b_pixel;

RAMB16_S1 #(
      .INIT(1'b0),  // Value of output RAM registers at startup
      .SRVAL(1'b0), // Output value upon SSR assertion
      .WRITE_MODE("READ_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

      //Start of red-white alternate lines (2 lines per line 12 in total)
      .INIT_00(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_01(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_02(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_03(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_04(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_05(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_06(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_07(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_08(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_09(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
      .INIT_0A(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
	   .INIT_0B(256'hffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff_ffffffff),
	  	//End of first set of red lines
		//Start of green-white alternate lines (2 lines per line 12 in total) 
      .INIT_0C(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0D(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0E(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0F(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_10(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_11(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_12(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_13(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_14(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_15(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_16(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	   .INIT_17(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
		//Blue-white alternate lines (2 lines per line 12 in total) 
      .INIT_18(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_19(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1A(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1B(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1C(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1D(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1E(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1F(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_20(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_21(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_22(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_23(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
		//Black with rgb vertical alternate lines (2 lines per line 12 in total) 
      .INIT_24(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_25(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_26(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_27(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_28(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_29(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2A(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2B(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2C(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2D(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2E(256'h99999999999999999999999999999999_11111111111111111111111111111111),
      .INIT_2F(256'h99999999999999999999999999999999_11111111111111111111111111111111)
   ) red_vram (
      .DO(r_pixel),       // 1-bit Data Output
      .ADDR(addr),       // 14-bit Address Input
      .CLK(clk),        // Clock
      .EN(1'b1),        // RAM Enable Input
		.SSR(1'b0) ,      // Synchronous Set/Reset Input
      .WE(1'b0)       // Write Enable Input
   );

	RAMB16_S1 #(
      .INIT(1'b0),  // Value of output RAM registers at startup
      .SRVAL(1'b0), // Output value upon SSR assertion
      .WRITE_MODE("READ_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE

       //Start of red-white alternate lines (2 lines per line 12 in total) 
      .INIT_00(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_01(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_02(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_03(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_04(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_05(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_06(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_07(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_08(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_09(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0A(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	   .INIT_0B(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
		//Start of green-white alternate lines (2 lines per line 12 in total) 
      .INIT_0C(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_0D(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_0E(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_0F(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_10(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_11(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_12(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_13(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_14(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_15(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_16(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
	   .INIT_17(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
		//Start of blue-white alternate lines (2 lines per line 12 in total) 
      .INIT_18(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_19(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1A(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1B(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1C(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1D(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1E(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_1F(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_20(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_21(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_22(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_23(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
		//Start of black with rgb vertical alternate lines (2 lines per line 12 in total) 
      .INIT_24(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_25(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_26(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_27(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_28(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_29(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2A(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2B(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2C(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2D(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2E(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222),
      .INIT_2F(256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_22222222222222222222222222222222)
   ) green_vram (
      .DO(g_pixel),       // 1-bit Data Output
      .ADDR(addr),       // 14-bit Address Input
      .CLK(clk),        // Clock
      .EN(1'b1),        // RAM Enable Input
		.SSR(1'b0) ,      // Synchronous Set/Reset Input
      .WE(1'b0)       // Write Enable Input
   );

	RAMB16_S1 #(
      .INIT(1'b0),  // Value of output RAM registers at startup
      .SRVAL(1'b0), // Output value upon SSR assertion
      .WRITE_MODE("READ_FIRST"), // WRITE_FIRST, READ_FIRST or NO_CHANGE
      
		 //Start of red-white alternate lines (2 lines per line 12 in total) 
		.INIT_00(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_01(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_02(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_03(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_04(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_05(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_06(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_07(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_08(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_09(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0A(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	   .INIT_0B(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
		//Start of green-white alternate lines (2 lines per line 12 in total) 
      .INIT_0C(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0D(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0E(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_0F(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_10(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_11(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_12(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_13(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_14(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_15(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
      .INIT_16(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
	   .INIT_17(256'h0000000000000000_0000000000000000_ffffffffffffffff_ffffffffffffffff),
		//Start of blue-white alternate lines (2 lines per line 12 in total) 
      .INIT_18(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_19(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1A(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1B(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1C(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1D(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1E(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_1F(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_20(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_21(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_22(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
      .INIT_23(256'hffffffffffffffff_ffffffffffffffff_ffffffffffffffff_ffffffffffffffff),
		//Start of black with rgb vertical alternate lines (2 lines per line 12 in total) 
      .INIT_24(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_25(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_26(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_27(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_28(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_29(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2A(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2B(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2C(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2D(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2E(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444),
      .INIT_2F(256'hcccccccccccccccccccccccccccccccc_44444444444444444444444444444444)
   ) blue_vram (
      .DO(b_pixel),       // 1-bit Data Output
      .ADDR(addr),       // 14-bit Address Input
      .CLK(clk),        // Clock
      .EN(1'b1),       // RAM Enable Input
      .WE(1'b0)       // Write Enable Input
   );

endmodule
