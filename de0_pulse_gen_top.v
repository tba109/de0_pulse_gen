//////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson Tue Nov 13 11:10:07 EST 2018
// de0_pulse_gen_top.v
//
//////////////////////////////////////////////////////////////////////////////////////
module de0_pulse_gen_top
  (
   
`ifdef MODEL_TECH
      input [7:0]   nu_cmd_data,
      input         nu_cmd_req,
      output        nu_cmd_ack,
      output [7:0]  nu_rsp_data,
      output        nu_rsp_req,
      input         nu_rsp_ack,
`endif
   
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
   wire 	 rx; 
   wire 	 tx; 
   assign GPIO_1[29] = 1'b1 ? tx : 1'bz; 
   assign rx         = GPIO_1[28];
   
   ///////////////////////////////////////////////////////////////////////////////////////////
   // Version Number
   wire [15:0] 	 vnum; 
   version_number VNUM_0(.vnum(vnum[15:0])); 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // Configuration indicator
   config_ind #(.P_CLK_FREQ_HZ(50_000_000)) CONFIG_IND_0
     (
      .blink_configed	(LEDR[0]),
      .clk	        (clk),
      .rst_n		(rst_n)
      ); 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // FPGA Command and Respon   
   wire [7:0] 	 rx_fifo_data;		
   wire 	 rx_fifo_wr_en;		
   wire 	 cmd_busy;
   wire 	 cmd_byte_req;
   wire 	 cmd_byte_ack;
   wire 	 rsp_byte_req;
   wire 	 rsp_byte_ack;
   wire [7:0] 	 rsp_byte_data;
   wire [31:0]	 lfsr_seed; 
   assign lfsr_seed = 32'hffffffff;
   wire 	 lfsr_seed_wr;
   assign lfsr_seed_wr = 0; 
   fcr_ctrl FCR_0
     (
      .clk(clk),
      .rst_n(rst_n),
`ifdef 0//MODEL_TECH
      .cmd_byte_req(nu_cmd_req),
      .cmd_byte_data(nu_cmd_data),
      .cmd_byte_ack(nu_cmd_ack),
      .rsp_byte_req(nu_rsp_req),
      .rsp_byte_ack(nu_rsp_ack),
      .rsp_byte_data(nu_rsp_data),
`else
      .cmd_byte_req(cmd_byte_req),
      .cmd_byte_data(rx_fifo_data),
      .cmd_byte_ack(cmd_byte_ack),
      .rsp_byte_req(rsp_byte_req),
      .rsp_byte_ack(rsp_byte_ack),
      .rsp_byte_data(rsp_byte_data),
`endif
      .cmd_busy(cmd_busy),
      .vnum(vnum[15:0])
      ); 
   
   ///////////////////////////////////////////////////////////////////////////////////////////
   // RS232 deserializer
   rs232_des 
     #(.P_CLK_FREQ_HZ(50_000_000),.P_BAUD_RATE(3_000_000)) 
   RS232_DES_0
     (
      .clk(clk),
      .rst_n(rst_n),
      .rx_fifo_data(rx_fifo_data[7:0]),
      .rx_fifo_wr_en(rx_fifo_wr_en),
      .rx(rx),
      .rx_fifo_full(1'b0)
      ); 
   
   ///////////////////////////////////////////////////////////////////////////////////////////
   // RS232 serializer
   wire 	 tx_fifo_rd_en;
   reg [7:0] 		rsp_byte_data_reg; 
   rs232_ser 
     #(.P_CLK_FREQ_HZ(50_000_000),.P_BAUD_RATE(3_000_000)) 
   RS232_SER_0
     (
      .clk(clk),
      .rst_n(rst_n),
      .tx(tx),
      .tx_fifo_rd_en(rsp_byte_ack),
      .tx_fifo_data(rsp_byte_data_reg),
      .tx_fifo_empty(!rsp_byte_req)
      ); 
      
   // We need a bit of adapter logic between the handshaking of FCR and the FIFO interfaces of the rs232
   pedge_req PEDGE_REQ_0(.clk(clk),.rst_n(1'b1),.a(rx_fifo_wr_en),.req(cmd_byte_req),.ack(cmd_byte_ack));
   always @(posedge clk) if(rsp_byte_ack) rsp_byte_data_reg <= rsp_byte_data; 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // LFSR 32b
   wire [31:0] 		rnd; 
   lfsr_32 LFSR_32_0(
		     .clk		(clk),
		     .seed		(lfsr_seed),
		     .seed_wr		(lfsr_seed_wr),
		     .y			(),
		     .lfsr              (rnd)
		     ); 
   

   ///////////////////////////////////////////////////////////////////////////////////////////
   // Pulse generator
   wire 		pulse_out; 
   pulse_gen PG_0(
		  // Outputs
		  .pulse_out		(pulse_out),
		  // Inputs
		  .clk			(clk),
		  .x_low		(0),
		  .x_low_wr		(0),
		  .x_high		(0),
		  .x_high_wr		(0),
		  .x			(rnd));
   reg [31:0] 		pulse_cnt = 0; 
   always @(posedge clk) if(pulse_out) pulse_cnt <= pulse_cnt + 1; 
 
   
   
endmodule

// For emacs verilog-mode
// Local Variables:
// verilog-library-directories:("." "../hdl" "./hdl")
// End:
