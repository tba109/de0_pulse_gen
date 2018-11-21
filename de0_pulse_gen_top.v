//////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson Tue Nov 13 11:10:07 EST 2018
// de0_pulse_gen_top.v
//

module de0_pulse_gen_top
  (
   
   ///////// CLOCK2 /////////
   input 	 CLOCK2_50,
   
   ///////// CLOCK3 /////////
   input 	 CLOCK3_50,
   
   ///////// CLOCK4 /////////
   inout 	 CLOCK4_50,
   
   ///////// CLOCK /////////
   input 	 CLOCK_50,
   
   ///////// DRAM /////////
   output [12:0] DRAM_ADDR,
   output [1:0]  DRAM_BA,
   output 	 DRAM_CAS_N,
   output 	 DRAM_CKE,
   output 	 DRAM_CLK,
   output 	 DRAM_CS_N,
   inout [15:0]  DRAM_DQ,
   output 	 DRAM_LDQM,
   output 	 DRAM_RAS_N,
   output 	 DRAM_UDQM,
   output 	 DRAM_WE_N,

   ///////// GPIO /////////
   inout [35:0]  GPIO_0,
   inout [35:0]  GPIO_1,
   
   ///////// HEX0 /////////
   output [6:0]  HEX0,
   
   ///////// HEX1 /////////
   output [6:0]  HEX1,
   
   ///////// HEX2 /////////
   output [6:0]  HEX2,
   
   ///////// HEX3 /////////
   output [6:0]  HEX3,
   
   ///////// HEX4 /////////
   output [6:0]  HEX4,
   
   ///////// HEX5 /////////
   output [6:0]  HEX5,

   ///////// KEY /////////
   input [3:0] 	 KEY,

   ///////// LEDR /////////
   output [9:0]  LEDR,

   ///////// PS2 /////////
   inout 	 PS2_CLK,
   inout 	 PS2_CLK2,
   inout 	 PS2_DAT,
   inout 	 PS2_DAT2,

   ///////// RESET /////////
   input 	 RESET_N,

   ///////// SD /////////
   output 	 SD_CLK,
   inout 	 SD_CMD,
   inout [3:0] 	 SD_DATA,
   
   ///////// SW /////////
   input [9:0] 	 SW,

   ///////// VGA /////////
   output [3:0]  VGA_B,
   output [3:0]  VGA_G,
   output 	 VGA_HS,
   output [3:0]  VGA_R,
   output 	 VGA_VS
   );

   
   ///////////////////////////////////////////////////////////////////////////////////////////
   // Clocks, etc
   wire 	 clk = CLOCK_50; 
   wire 	 rst_n = KEY[0]; 	 
   
   ///////////////////////////////////////////////////////////////////////////////////////////
   // Configuration indicator
   config_ind #(.P_CLK_FREQ_HZ(50_000_000)) CONFIG_IND_0
     (
      .blink_configed	(LEDR[0]),
      .clk	        (clk),
      .rst_n		(rst_n)
      ); 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // RS232 deserializer
   wire [7:0] 	 rx_fifo_data;		
   wire 	 rx_fifo_wr_en;		
   reg 		 rx;			
   reg 		 rx_fifo_full;
   rs232_des 
     #(.P_CLK_FREQ_HZ(50_000_000)) 
   RS232_DES_0(
	       .clk(clk),
	       .rst_n(rst_n),
	       .rx_fifo_data(rx_fifo_data[7:0]),
	       .rx_fifo_wr_en(rx_fifo_wr_en),
	       .rx(rx),
	       .rx_fifo_full(rx_fifo_full)); 
   
   ///////////////////////////////////////////////////////////////////////////////////////////
   // RS232 serializer
   reg [7:0]		tx_fifo_data;
   reg			tx_fifo_empty;
   wire			tx;	
   wire			tx_fifo_rd_en;
   rs232_ser 
     #(.P_CLK_FREQ_HZ(50_000_000)) 
   RS232_SER_0(
	       .clk(clk),
	       .rst_n(rst_n),
	       .tx(tx),
	       .tx_fifo_rd_en(tx_fifo_rd_en),
	       .tx_fifo_data(tx_fifo_data[7:0]),
	       .tx_fifo_empty(tx_fifo_empty)); 


   
endmodule

// For emacs verilog-mode
// Local Variables:
// verilog-library-directories:("." "../hdl" "./hdl")
// End:
