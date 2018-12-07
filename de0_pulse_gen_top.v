//////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson Tue Nov 13 11:10:07 EST 2018
// de0_pulse_gen_top.v
//
//////////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps
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
   wire 	 rx; 
   wire 	 tx; 
   wire 	 clk; // 50MHz
   wire 	 clk_200MHz; // 200MHz
   wire 	 rst_n; 
   
`ifdef MODEL_TECH
   assign clk = CLOCK_50; 
   reg 		 sim_clk_200MHz;
   always @(sim_clk_200MHz) #(5.0) sim_clk_200MHz <= !sim_clk_200MHz; 
   initial begin sim_clk_200MHz = 1; end
   assign clk_200MHz = sim_clk_200MHz;
   assign rst_n = 1'b1; 
`else
   PLL0 PLL0_0(
	       .refclk(CLOCK_50),
	       .rst(!KEY[0]),
	       .outclk_0(clk),
	       .outclk_1(clk_200MHz),
	       .locked(rst_n)
	       );
`endif
   assign GPIO_1[29] = 1'b1 ? tx : 1'bz; 
   assign rx         = GPIO_1[28];

   
   wire 	 rst_pg;
   wire 	 run_pg;  		
`ifdef MODEL_TECH
   debounce #(.P_DEFVAL(0),.P_DELAY(32'd250)) DB_0(.clk(clk),.rst_n(1'b1),.a(!KEY[1]),.y(rst_pg));
   debounce #(.P_DEFVAL(0),.P_DELAY(32'd250)) DB_1(.clk(clk),.rst_n(1'b1),.a(!KEY[2]),.y(run_pg)); 
`else
   debounce #(.P_DEFVAL(0),.P_DELAY(32'd2500000)) DB_0(.clk(clk),.rst_n(1'b1),.a(!KEY[1]),.y(rst_pg));
   debounce #(.P_DEFVAL(0),.P_DELAY(32'd2500000)) DB_1(.clk(clk),.rst_n(1'b1),.a(!KEY[2]),.y(run_pg)); 
`endif
         
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
   fcr_ctrl FCR_0
     (
      .clk(clk),
      .rst_n(rst_n),
`ifdef MODEL_TECH
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
      
   // We need adapter logic between the handshaking of FCR and the FIFO interfaces of the rs232
   pedge_req PEDGE_REQ_0(.clk(clk),.rst_n(1'b1),.a(rx_fifo_wr_en),.req(cmd_byte_req),.ack(cmd_byte_ack));

   ///////////////////////////////////////////////////////////////////////////////////////////
   // LFSR 32b 0
   wire [31:0] 		rnd_0; 
   localparam [31:0] L_SEED_0 = 32'hd6778938;
   // localparam [31:0] L_SEED_0 = 32'hFFFFFFFF; 
   lfsr_32 #(.P_INIT_SEED(L_SEED_0)) LFSR_32_0(
					       .clk(clk_200MHz),
					       .seed(),
					       .seed_wr(),
					       .y(),
					       .lfsr(rnd_0)
					       );    
   // Pulse generator
   wire 		pulse_out_0; 
   pulse_gen PG_0(
		  // Outputs
		  .pulse_out		(pulse_out_0),
		  // Inputs
		  .clk			(clk_200MHz),
		  .x_low		(0),
		  .x_low_wr		(0),
		  .x_high		(0),
		  .x_high_wr		(0),
		  .x			(rnd_0));
   reg [31:0] 		pulse_cnt_0 = 0; 
   
   ///////////////////////////////////////////////////////////////////////////////////////////
   // LFSR 32b 1
   wire [31:0] 		rnd_1;
   localparam [31:0] L_SEED_1 = 32'h2d0f3801;
   lfsr_32 #(.P_INIT_SEED(L_SEED_1)) LFSR_32_1(
					       .clk(clk_200MHz),
					       .seed(),
					       .seed_wr(),
					       .y(),
					       .lfsr(rnd_1)
					       );    
   // Pulse generator
   wire 		pulse_out_1; 
   pulse_gen PG_1(
		  // Outputs
		  .pulse_out		(pulse_out_1),
		  // Inputs
		  .clk			(clk_200MHz),
		  .x_low		(0),
		  .x_low_wr		(0),
		  .x_high		(0),
		  .x_high_wr		(0),
		  .x			(rnd_1));
   reg [31:0] 		pulse_cnt_1 = 0; 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // LFSR 32b 2
   wire [31:0] 		rnd_2;
   localparam [31:0] L_SEED_2 = 32'hf2338c85;
   lfsr_32 #(.P_INIT_SEED(L_SEED_2)) LFSR_32_2(
					       .clk(clk_200MHz),
					       .seed(),
					       .seed_wr(),
					       .y(),
					       .lfsr(rnd_2)
					       );    
   // Pulse generator
   wire 		pulse_out_2; 
   pulse_gen PG_2(
		  // Outputs
		  .pulse_out		(pulse_out_2),
		  // Inputs
		  .clk			(clk_200MHz),
		  .x_low		(0),
		  .x_low_wr		(0),
		  .x_high		(0),
		  .x_high_wr		(0),
		  .x			(rnd_2));
   reg [31:0] 		pulse_cnt_2 = 0; 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // LFSR 32b 3
   wire [31:0] 		rnd_3;
   localparam [31:0] L_SEED_3 = 32'hfd28533c;
   lfsr_32 #(.P_INIT_SEED(L_SEED_3)) LFSR_32_3(
					       .clk(clk_200MHz),
					       .seed(),
					       .seed_wr(),
					       .y(),
					       .lfsr(rnd_3)
					       );    
   // Pulse generator
   wire 		pulse_out_3; 
   pulse_gen PG_3(
		  // Outputs
		  .pulse_out		(pulse_out_3),
		  // Inputs
		  .clk			(clk_200MHz),
		  .x_low		(0),
		  .x_low_wr		(0),
		  .x_high		(0),
		  .x_high_wr		(0),
		  .x			(rnd_3));
   reg [31:0] 		pulse_cnt_3 = 0; 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // LFSR 32b 4 
   wire [31:0] 		rnd_4;
   localparam [31:0] L_SEED_4 = 32'h96f8a61a; 
   lfsr_32 #(.P_INIT_SEED(L_SEED_4)) LFSR_32_4(
					       .clk(clk_200MHz),
					       .seed(),
					       .seed_wr(),
					       .y(),
					       .lfsr(rnd_4)
					       );    
   // Pulse generator
   wire 		pulse_out_4; 
   pulse_gen PG_4(
		  // Outputs
		  .pulse_out		(pulse_out_4),
		  // Inputs
		  .clk			(clk_200MHz),
		  .x_low		(0),
		  .x_low_wr		(0),
		  .x_high		(0),
		  .x_high_wr		(0),
		  .x			(rnd_4));
   reg [31:0] 		pulse_cnt_4 = 0; 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // LFSR 32b 5 
   wire [31:0] 		rnd_5;
   localparam [31:0] L_SEED_5 = 32'h954dc0a3; 
   lfsr_32 #(.P_INIT_SEED(L_SEED_5)) LFSR_32_5(
					       .clk(clk_200MHz),
					       .seed(),
					       .seed_wr(),
					       .y(),
					       .lfsr(rnd_5)
					       );    
   // Pulse generator
   wire 		pulse_out_5; 
   pulse_gen PG_5(
		  // Outputs
		  .pulse_out		(pulse_out_5),
		  // Inputs
		  .clk			(clk_200MHz),
		  .x_low		(0),
		  .x_low_wr		(0),
		  .x_high		(0),
		  .x_high_wr		(0),
		  .x			(rnd_5));
   reg [31:0] 		pulse_cnt_5 = 0; 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // LFSR 32b 6 
   wire [31:0] 		rnd_6;
   localparam [31:0] L_SEED_6 = 32'h3b4137f7; 
   lfsr_32 #(.P_INIT_SEED(L_SEED_6)) LFSR_32_6(
					       .clk(clk_200MHz),
					       .seed(),
					       .seed_wr(),
					       .y(),
					       .lfsr(rnd_6)
					       );    
   // Pulse generator
   wire 		pulse_out_6; 
   pulse_gen PG_6(
		  // Outputs
		  .pulse_out		(pulse_out_6),
		  // Inputs
		  .clk			(clk_200MHz),
		  .x_low		(0),
		  .x_low_wr		(0),
		  .x_high		(0),
		  .x_high_wr		(0),
		  .x			(rnd_6));
   reg [31:0] 		pulse_cnt_6 = 0; 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // LFSR 32b 7
   wire [31:0] 		rnd_7; 
   localparam [31:0] L_SEED_7 = 32'ha0c3c5d5; 
   lfsr_32 #(.P_INIT_SEED(L_SEED_7)) LFSR_32_7(
					       .clk(clk_200MHz),
					       .seed(),
					       .seed_wr(),
					       .y(),
					       .lfsr(rnd_7)
					       );    
   // Pulse generator
   wire 		pulse_out_7; 
   pulse_gen PG_7(
		  // Outputs
		  .pulse_out		(pulse_out_7),
		  // Inputs
		  .clk			(clk_200MHz),
		  .x_low		(0),
		  .x_low_wr		(0),
		  .x_high		(0),
		  .x_high_wr		(0),
		  .x			(rnd_7));
   reg [31:0] 		pulse_cnt_7 = 0; 

   ///////////////////////////////////////////////////////////////////////////////////////////
   // gates
   localparam L_PULSE_CNT_MAX = 32'hffffffff;
   localparam 
     S_IDLE = 0,
     S_RUN = 1; 
     
   reg 			fsm = S_IDLE;
   always @(posedge clk or negedge rst_n)
     if(!rst_n)
       begin
	  fsm <= S_IDLE;
	  pulse_cnt_0 <= 0;
	  pulse_cnt_1 <= 0;
	  pulse_cnt_2 <= 0;
	  pulse_cnt_3 <= 0;
	  pulse_cnt_4 <= 0;
	  pulse_cnt_5 <= 0;
	  pulse_cnt_6 <= 0;
	  pulse_cnt_7 <= 0;
       end 
     else
       begin
	  if(pulse_out_0 && fsm == S_RUN && pulse_cnt_0 != L_PULSE_CNT_MAX) pulse_cnt_0 <= pulse_cnt_0 + 1;
	  if(pulse_out_1 && fsm == S_RUN && pulse_cnt_0 != L_PULSE_CNT_MAX) pulse_cnt_1 <= pulse_cnt_1 + 1;
	  if(pulse_out_2 && fsm == S_RUN && pulse_cnt_0 != L_PULSE_CNT_MAX) pulse_cnt_2 <= pulse_cnt_2 + 1;
	  if(pulse_out_3 && fsm == S_RUN && pulse_cnt_0 != L_PULSE_CNT_MAX) pulse_cnt_3 <= pulse_cnt_3 + 1;
	  if(pulse_out_4 && fsm == S_RUN && pulse_cnt_0 != L_PULSE_CNT_MAX) pulse_cnt_4 <= pulse_cnt_4 + 1;
	  if(pulse_out_5 && fsm == S_RUN && pulse_cnt_0 != L_PULSE_CNT_MAX) pulse_cnt_5 <= pulse_cnt_5 + 1;
	  if(pulse_out_6 && fsm == S_RUN && pulse_cnt_0 != L_PULSE_CNT_MAX) pulse_cnt_6 <= pulse_cnt_6 + 1;
	  if(pulse_out_7 && fsm == S_RUN && pulse_cnt_0 != L_PULSE_CNT_MAX) pulse_cnt_7 <= pulse_cnt_7 + 1; 
	  case(fsm)
	    S_IDLE: if(run_pg) fsm <= S_RUN;
	    S_RUN:
	      if(rst_pg)
		begin
		   fsm <= S_IDLE;
		   pulse_cnt_0 <= 0;
		   pulse_cnt_1 <= 0;
		   pulse_cnt_2 <= 0;
		   pulse_cnt_3 <= 0;
		   pulse_cnt_4 <= 0;
		   pulse_cnt_5 <= 0;
		   pulse_cnt_6 <= 0;
		   pulse_cnt_7 <= 0;
		end
	  endcase // case (fsm)
       end // else: !if(!KEY[1])

   
   ///////////////////////////////////////////////////////////////////////////////////////////
   // Output assignments
   assign GPIO_1[9]  = pulse_out_0 && pulse_cnt_0 != L_PULSE_CNT_MAX && fsm==S_RUN;
   assign GPIO_1[8]  = pulse_out_1 && pulse_cnt_1 != L_PULSE_CNT_MAX && fsm==S_RUN;
   assign GPIO_1[11] = pulse_out_2 && pulse_cnt_2 != L_PULSE_CNT_MAX && fsm==S_RUN;
   assign GPIO_1[10] = pulse_out_3 && pulse_cnt_3 != L_PULSE_CNT_MAX && fsm==S_RUN;
   assign GPIO_1[25] = pulse_out_4 && pulse_cnt_4 != L_PULSE_CNT_MAX && fsm==S_RUN; 
   assign GPIO_1[24] = pulse_out_5 && pulse_cnt_5 != L_PULSE_CNT_MAX && fsm==S_RUN;
   assign GPIO_1[27] = pulse_out_6 && pulse_cnt_6 != L_PULSE_CNT_MAX && fsm==S_RUN;
   assign GPIO_1[26] = pulse_out_7 && pulse_cnt_7 != L_PULSE_CNT_MAX && fsm==S_RUN;
   assign LEDR[1] = fsm == S_RUN;
   assign LEDR[2] = (pulse_cnt_0 == L_PULSE_CNT_MAX) &&
		    (pulse_cnt_1 == L_PULSE_CNT_MAX) &&
		    (pulse_cnt_2 == L_PULSE_CNT_MAX) &&
		    (pulse_cnt_3 == L_PULSE_CNT_MAX) &&
		    (pulse_cnt_4 == L_PULSE_CNT_MAX) &&
		    (pulse_cnt_5 == L_PULSE_CNT_MAX) &&
		    (pulse_cnt_6 == L_PULSE_CNT_MAX) &&
		    (pulse_cnt_7 == L_PULSE_CNT_MAX);
   
endmodule

// For emacs verilog-mode
// Local Variables:
// verilog-library-directories:("." "../hdl" "./hdl")
// End:
