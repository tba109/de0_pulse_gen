// ============================================================================
// Copyright (c) 2014 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
// ----------------------------------------------------------------------------
//
// Major Functions:	DE0_CV_PS2_DEMO
//
// ============================================================================
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| xinxian           :| 11/17/2014:| Rev B
// ============================================================================


module DE0_CV_PS2_DEMO(

      ///////// CLOCK2 /////////
      input              CLOCK2_50,

      ///////// CLOCK3 /////////
      input              CLOCK3_50,

      ///////// CLOCK4 /////////
      inout              CLOCK4_50,

      ///////// CLOCK /////////
      input              CLOCK_50,

      ///////// DRAM /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,

      ///////// GPIO /////////
      inout       [35:0] GPIO_0,
      inout       [35:0] GPIO_1,

      ///////// HEX0 /////////
      output      [6:0]  HEX0,

      ///////// HEX1 /////////
      output      [6:0]  HEX1,

      ///////// HEX2 /////////
      output      [6:0]  HEX2,

      ///////// HEX3 /////////
      output      [6:0]  HEX3,

      ///////// HEX4 /////////
      output      [6:0]  HEX4,

      ///////// HEX5 /////////
      output      [6:0]  HEX5,

      ///////// KEY /////////
      input       [3:0]  KEY,

      ///////// LEDR /////////
      output      [9:0]  LEDR,

      ///////// PS2 /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,

      ///////// RESET /////////
      input              RESET_N,

      ///////// SD /////////
      output             SD_CLK,
      inout              SD_CMD,
      inout       [3:0]  SD_DATA,

      ///////// SW /////////
      input       [9:0]  SW,

      ///////// VGA /////////
      output      [3:0]  VGA_B,
      output      [3:0]  VGA_G,
      output             VGA_HS,
      output      [3:0]  VGA_R,
      output             VGA_VS
);


//=======================================================
//  REG/WIRE declarations
//=======================================================
wire HEX0P;
wire HEX1P;
wire HEX2P;
wire HEX3P;
wire HEX4P;
wire HEX5P;

//=======================================================
//  Structural coding
//=======================================================

///////////////////////////////////////////
// VGA
assign VGA_BLANK_N = 1'b1;
assign VGA_SYNC_N = 1'b1;

///////////////////////////////////////////
//ps2
//////////////////////////////////////
///intantiation
 ps2 U1(
			  .iSTART(KEY[0]),     //press the button for transmitting instrucions to device;
           .iRST_n(KEY[1]),     //global reset signal;
           .iCLK_50(CLOCK_50),  //clock source;
           .PS2_CLK(PS2_CLK),   //ps2_clock signal inout;
           .PS2_DAT(PS2_DAT),   //ps2_data  signal inout;
           .oLEFBUT(LEDR[0]),   //left button press display;
           .oRIGBUT(LEDR[1]),   //right button press display;
           .oMIDBUT(LEDR[2]),   //middle button press display;
           .oX_MOV1(HEX0),      //lower SEG of mouse displacement display for X axis.
           .oX_MOV2(HEX1),      //higher SEG of mouse displacement display for X axis.
           .oY_MOV1(HEX2),      //lower SEG of mouse displacement display for Y axis.
           .oY_MOV2(HEX3)       //higher SEG of mouse displacement display for Y axis
		 ); 
		 
endmodule
