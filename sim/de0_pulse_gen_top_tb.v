///////////////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson Tue Nov 13 13:47:31 EST 2018
//
// de0_pulse_gen_top_tb.v
//
// Pulse generator
//////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

///////////////////////////////////////////////////////////////////////////////////////////////////
// Test cases
///////////////////////////////////////////////////////////////////////////////////////////////////
`define TEST_CASE_CONFIG_IND

module de0_pulse_gen_top_tb;
   
   //////////////////////////////////////////////////////////////////////
   // I/O
   //////////////////////////////////////////////////////////////////////   
   parameter CLK_PERIOD = 20;
   reg clk;
   reg rst;

   // Connections
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			CLOCK4_50;		// To/From de0_0 of de0_pulse_gen_top.v
   wire [12:0]		DRAM_ADDR;		// From de0_0 of de0_pulse_gen_top.v
   wire [1:0]		DRAM_BA;		// From de0_0 of de0_pulse_gen_top.v
   wire			DRAM_CAS_N;		// From de0_0 of de0_pulse_gen_top.v
   wire			DRAM_CKE;		// From de0_0 of de0_pulse_gen_top.v
   wire			DRAM_CLK;		// From de0_0 of de0_pulse_gen_top.v
   wire			DRAM_CS_N;		// From de0_0 of de0_pulse_gen_top.v
   wire [15:0]		DRAM_DQ;		// To/From de0_0 of de0_pulse_gen_top.v
   wire			DRAM_LDQM;		// From de0_0 of de0_pulse_gen_top.v
   wire			DRAM_RAS_N;		// From de0_0 of de0_pulse_gen_top.v
   wire			DRAM_UDQM;		// From de0_0 of de0_pulse_gen_top.v
   wire			DRAM_WE_N;		// From de0_0 of de0_pulse_gen_top.v
   wire [35:0]		GPIO_0;			// To/From de0_0 of de0_pulse_gen_top.v
   wire [35:0]		GPIO_1;			// To/From de0_0 of de0_pulse_gen_top.v
   wire [6:0]		HEX0;			// From de0_0 of de0_pulse_gen_top.v
   wire [6:0]		HEX1;			// From de0_0 of de0_pulse_gen_top.v
   wire [6:0]		HEX2;			// From de0_0 of de0_pulse_gen_top.v
   wire [6:0]		HEX3;			// From de0_0 of de0_pulse_gen_top.v
   wire [6:0]		HEX4;			// From de0_0 of de0_pulse_gen_top.v
   wire [6:0]		HEX5;			// From de0_0 of de0_pulse_gen_top.v
   wire [9:0]		LEDR;			// From de0_0 of de0_pulse_gen_top.v
   wire			PS2_CLK;		// To/From de0_0 of de0_pulse_gen_top.v
   wire			PS2_CLK2;		// To/From de0_0 of de0_pulse_gen_top.v
   wire			PS2_DAT;		// To/From de0_0 of de0_pulse_gen_top.v
   wire			PS2_DAT2;		// To/From de0_0 of de0_pulse_gen_top.v
   wire			SD_CLK;			// From de0_0 of de0_pulse_gen_top.v
   wire			SD_CMD;			// To/From de0_0 of de0_pulse_gen_top.v
   wire [3:0]		SD_DATA;		// To/From de0_0 of de0_pulse_gen_top.v
   wire [3:0]		VGA_B;			// From de0_0 of de0_pulse_gen_top.v
   wire [3:0]		VGA_G;			// From de0_0 of de0_pulse_gen_top.v
   wire			VGA_HS;			// From de0_0 of de0_pulse_gen_top.v
   wire [3:0]		VGA_R;			// From de0_0 of de0_pulse_gen_top.v
   wire			VGA_VS;			// From de0_0 of de0_pulse_gen_top.v
   // End of automatics
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg			CLOCK2_50;		// To de0_0 of de0_pulse_gen_top.v
   reg			CLOCK3_50;		// To de0_0 of de0_pulse_gen_top.v
   reg			CLOCK_50;		// To de0_0 of de0_pulse_gen_top.v
   reg [3:0]		KEY;			// To de0_0 of de0_pulse_gen_top.v
   reg			RESET_N;		// To de0_0 of de0_pulse_gen_top.v
   reg [9:0]		SW;			// To de0_0 of de0_pulse_gen_top.v
   // End of automatics

   always @(*) begin
      CLOCK_50 <= clk;
      KEY[0] <= !rst;
   end
  

   
   //////////////////////////////////////////////////////////////////////
   // Clock Driver
   //////////////////////////////////////////////////////////////////////
   always @(clk)
     #(CLK_PERIOD / 2.0) clk <= !clk;
				   
   //////////////////////////////////////////////////////////////////////
   // Simulated interfaces
   //////////////////////////////////////////////////////////////////////   
      
   //////////////////////////////////////////////////////////////////////
   // UUT
   //////////////////////////////////////////////////////////////////////   
   de0_pulse_gen_top de0_0(/*AUTOINST*/
			   // Outputs
			   .DRAM_ADDR		(DRAM_ADDR[12:0]),
			   .DRAM_BA		(DRAM_BA[1:0]),
			   .DRAM_CAS_N		(DRAM_CAS_N),
			   .DRAM_CKE		(DRAM_CKE),
			   .DRAM_CLK		(DRAM_CLK),
			   .DRAM_CS_N		(DRAM_CS_N),
			   .DRAM_LDQM		(DRAM_LDQM),
			   .DRAM_RAS_N		(DRAM_RAS_N),
			   .DRAM_UDQM		(DRAM_UDQM),
			   .DRAM_WE_N		(DRAM_WE_N),
			   .HEX0		(HEX0[6:0]),
			   .HEX1		(HEX1[6:0]),
			   .HEX2		(HEX2[6:0]),
			   .HEX3		(HEX3[6:0]),
			   .HEX4		(HEX4[6:0]),
			   .HEX5		(HEX5[6:0]),
			   .LEDR		(LEDR[9:0]),
			   .SD_CLK		(SD_CLK),
			   .VGA_B		(VGA_B[3:0]),
			   .VGA_G		(VGA_G[3:0]),
			   .VGA_HS		(VGA_HS),
			   .VGA_R		(VGA_R[3:0]),
			   .VGA_VS		(VGA_VS),
			   // Inouts
			   .CLOCK4_50		(CLOCK4_50),
			   .DRAM_DQ		(DRAM_DQ[15:0]),
			   .GPIO_0		(GPIO_0[35:0]),
			   .GPIO_1		(GPIO_1[35:0]),
			   .PS2_CLK		(PS2_CLK),
			   .PS2_CLK2		(PS2_CLK2),
			   .PS2_DAT		(PS2_DAT),
			   .PS2_DAT2		(PS2_DAT2),
			   .SD_CMD		(SD_CMD),
			   .SD_DATA		(SD_DATA[3:0]),
			   // Inputs
			   .CLOCK2_50		(CLOCK2_50),
			   .CLOCK3_50		(CLOCK3_50),
			   .CLOCK_50		(CLOCK_50),
			   .KEY			(KEY[3:0]),
			   .RESET_N		(RESET_N),
			   .SW			(SW[9:0])); 
   
   //////////////////////////////////////////////////////////////////////
   // Testbench
   //////////////////////////////////////////////////////////////////////   
   initial
     begin
	// Initializations
	clk = 1'b0;
	rst = 1'b1;
     end

   //////////////////////////////////////////////////////////////////////
   // Test case
   //////////////////////////////////////////////////////////////////////   
   `ifdef TEST_CASE_CONFIG_IND
   initial
     begin
	// Reset	
	#(10 * CLK_PERIOD);
	rst = 1'b0;
	#(20* CLK_PERIOD);

	// Logging
	$display("");
	$display("------------------------------------------------------");
	$display("Test Case: CONFIG_IND");

	// Stimulate UUT
     end
   `endif

   //////////////////////////////////////////////////////////////////////
   // Tasks (e.g., writing data, etc.)
   //////////////////////////////////////////////////////////////////////   
   
   
   
endmodule

// Local Variables:
// verilog-library-directories:("." ".." "../hdl")
// verilog-library-flags:("-y ../hdl/")
// End:
   
