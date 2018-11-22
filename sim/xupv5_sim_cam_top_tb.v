////////////////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson Mon Jul 16 15:55:46 EDT 2018
//
// xupv5_sim_cap_top_tb.v
//
// Top level Verilog firmware for verifying 
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////////////////////////////////
// Test cases
///////////////////////////////////////////////////////////////////////////////////////////////////
// `define TEST_CASE_GET_VNUM_UART
// `define TEST_CASE_GET_VNUM
// `define TEST_CASE_SIMPLE_EVT
// `define TEST_CASE_TEST_PATTERN
// `define TEST_CASE_DE_NOP
`define TEST_CASE_SIMPLE_EVT2
module xupv5_sim_cam_top_tb;
`include "../hdl/inc_params.v"   
   reg         clk;
   wire        led;
   wire        gse_uart_tx; // TX wrt FT232R: this is from the FT232R to the FPGA
   wire        gse_uart_rx; // RX wrt FT232R: this is from the FPGA to the FT232
   reg [7:0]   nu_cmd_data;
   reg 	       nu_cmd_req;
   wire        nu_cmd_ack;
   wire [7:0]  nu_rsp_data;
   wire        nu_rsp_req;
   reg 	       nu_rsp_ack; 
   wire        de_tx_0;
   wire        de_tx_1;
   wire        de_tx_2;
   wire        de_tx_3;
   wire        de_clk;
   wire        de_rst; 
   localparam CLK_PERIOD = 10; // ns
   always #(CLK_PERIOD/2) clk = ~clk;

   // UUT
   xupv5_sim_cam_top XSCT0
     (
      .USER_CLK(clk),
      .FPGA_SERIAL2_TX(gse_uart_rx),
      .FPGA_SERIAL2_RX(gse_uart_tx),
      .nu_cmd_data(nu_cmd_data),
      .nu_cmd_req(nu_cmd_req),
      .nu_cmd_ack(nu_cmd_ack),
      .nu_rsp_data(nu_rsp_data),
      .nu_rsp_req(nu_rsp_req),
      .nu_rsp_ack(nu_rsp_ack),
      .DE_TX_0_P(de_tx_0),
      .DE_TX_1_P(de_tx_1),
      .DE_TX_2_P(de_tx_2),
      .DE_TX_3_P(de_tx_3),
      .DE_CLK_P(de_clk),
      .DE_RST_P(de_rst),
      .GPIO_LED_N(led)
      );
   

   wire [11:0] drx_data_0;
   wire        drx_wr_0; 
   detector_rx DRX_0(.clk(de_clk),.rst_n(!de_rst),.rx(de_tx_0),.data(drx_data_0),.wr(drx_wr_0));
   wire [11:0] drx_data_1;
   wire        drx_wr_1; 
   detector_rx DRX_1(.clk(de_clk),.rst_n(!de_rst),.rx(de_tx_1),.data(drx_data_1),.wr(drx_wr_1));
   wire [11:0] drx_data_2;
   wire        drx_wr_2; 
   detector_rx DRX_2(.clk(de_clk),.rst_n(!de_rst),.rx(de_tx_2),.data(drx_data_2),.wr(drx_wr_2));
   wire [11:0] drx_data_3;
   wire        drx_wr_3; 
   detector_rx DRX_3(.clk(de_clk),.rst_n(!de_rst),.rx(de_tx_3),.data(drx_data_3),.wr(drx_wr_3));
   

   wire ro_sp_wr;
   wire ro_data_wr;
   wire ro_oc_wr;
   wire [11:0] ro_data;
   wire [2:0]  ro_node;
   wire [11:0] ro_x; 
   wire [11:0] ro_y;
   wire [11:0] ro_fn;
   row_reorder RR_0
     (
      .clk(de_clk),
      .rst_n(!de_rst),
      .cmd_x_loc_max(12'd2047),
      .cmd_y_loc_max(12'd1023),
      .cmd_nsp(16'd11),
      .cmd_noc(16'd10),
      .rx_data(drx_data_0),
      .rx_wr(drx_wr_0),
      .ro_sp_wr(ro_sp_wr),
      .ro_data_wr(ro_data_wr),
      .ro_oc_wr(ro_oc_wr),
      .ro_data(ro_data),
      .ro_node(ro_node),
      .ro_cnt(ro_cnt),
      .ro_x(ro_x),
      .ro_y(ro_y),
      .ro_fn(ro_fn),
      .ro_row_done(),
      .ro_frame_done()); 
   
   //////////////////////////////////////////////////////////////////////
   // Testbench
   //////////////////////////////////////////////////////////////////////
   // Note: RX/TX here are wrt the FT232R: 
   //       RX means data coming in to the chip/fpga
   //       TX means data comping out of the chip/fpga
   localparam FT232R_RX_BUFFER_SIZE = 128;
   reg [8*FT232R_RX_BUFFER_SIZE-1:0] uart_rx_buffer_data;
   reg [31:0] uart_rx_buffer_nbytes;
   reg 	      GSE_UART_MUTE = 0;
   reg [7:0] gse_uart_rx_data;
   reg 	     gse_uart_rx_req;
   reg [31:0] uart_tx_buffer_nbytes;
   wire [7:0] gse_uart_tx_data;
   wire       gse_uart_tx_req; 

   // For the no uart communications
   localparam NU_RX_BUFFER_SIZE = 128;
   reg [8*NU_RX_BUFFER_SIZE-1:0] nu_rx_buffer_data;
   reg [31:0] nu_rx_buffer_nbytes;
   reg 	      GSE_NU_MUTE = 0;
   reg [31:0] nu_tx_buffer_nbytes;
      
   initial
     begin
	clk = 0;
	gse_uart_rx_data = 0;
	gse_uart_rx_req = 0;
	uart_rx_buffer_nbytes = 0;
	uart_tx_buffer_nbytes = 0;	
	nu_rx_buffer_nbytes = 0;
	nu_tx_buffer_nbytes = 0;
	nu_cmd_data = 0;
	nu_cmd_req = 0;
	nu_rsp_ack = 0; 
     end

`ifdef TEST_CASE_GET_VNUM_UART
   initial
     begin
	#(10*CLK_PERIOD);
	$display("");
	$display("-----------------------------------------------");
	$display("Test Case: Get VNUM UART");
	uart_rx_buffer_data = {C_GET,C_VNUM,48'd0,72'd0};
	uart_rx_buffer_nbytes = 17;
	uart_tx_buffer_nbytes = 17; 
	fork
	   gse_uart_send();
	   gse_uart_receive(); 
	join	
     end
`endif
   
`ifdef TEST_CASE_GET_VNUM
   initial
     begin
	#(10*CLK_PERIOD);
	$display("");
	$display("-----------------------------------------------");
	$display("Test Case: Get VNUM");
	nu_rx_buffer_data = {C_GET,C_VNUM,48'd0,72'd0};
	nu_rx_buffer_nbytes = 17;
	nu_tx_buffer_nbytes = 17; 
	fork
	   gse_nu_send();
	   gse_nu_receive(); 
	join	
     end
`endif


`ifdef TEST_CASE_SIMPLE_EVT
   initial
     begin
	#(10*CLK_PERIOD);
	$display("");
	$display("-----------------------------------------------");
	$display("Test Case: Simple Event");
	nu_rx_buffer_data = {C_EVT,16'h0001,16'h0001,16'h0001};
	nu_rx_buffer_nbytes = 7;
	nu_tx_buffer_nbytes = 0; 
	fork
	   gse_nu_send();
	   gse_nu_receive(); 
	join
	nu_rx_buffer_data = {C_SET,C_EL_RUN,48'd0,72'd0};
	nu_rx_buffer_nbytes = 17;
	nu_tx_buffer_nbytes = 17; 
	fork
	   gse_nu_send();
	   gse_nu_receive(); 
	join
     end   
`endif
   
`ifdef TEST_CASE_TEST_PATTERN
   initial
     begin
	#(10*CLK_PERIOD);
	$display("");
	$display("-----------------------------------------------");
	$display("Test Case: Simple Event");
	// nu_rx_buffer_data = {C_EVT,16'h0000,16'h0001,16'h0000};
	// nu_rx_buffer_nbytes = 7;
	// nu_tx_buffer_nbytes = 0; 
	// fork
	//    gse_nu_send();
	//    gse_nu_receive(); 
	// join
	nu_rx_buffer_data = {C_SET,C_EL_TP,48'd0,72'd1}; // datarg == 1 means EL sends the test pattern
	nu_rx_buffer_nbytes = 17;
	nu_tx_buffer_nbytes = 17; 
	fork
	   gse_nu_send();
	   gse_nu_receive(); 
	join
	nu_rx_buffer_data = {C_SET,C_EL_RUN,48'd0,72'd0};
	nu_rx_buffer_nbytes = 17;
	nu_tx_buffer_nbytes = 17; 
	fork
	   gse_nu_send();
	   gse_nu_receive(); 
	join
     end   
`endif

      
`ifdef TEST_CASE_DE_NOP
   initial
     begin
	#(10*CLK_PERIOD);
	$display("");
	$display("-----------------------------------------------");
	$display("Test Case: Get VNUM");
	nu_rx_buffer_data = {C_SET,C_DE_NOP,48'd0,72'd0};
	nu_rx_buffer_nbytes = 17;
	nu_tx_buffer_nbytes = 17; 
	fork
	   gse_nu_send();
	   gse_nu_receive(); 
	join	
     end
`endif


`ifdef TEST_CASE_SIMPLE_EVT2
   initial
     begin
	#(10*CLK_PERIOD);
	$display("");
	$display("-----------------------------------------------");
	$display("Test Case: Simple Event 2");
	nu_rx_buffer_data = {C_EVT2,16'h0001,16'h0001,16'h0001,16'habcd};
	nu_rx_buffer_nbytes = 9;
	nu_tx_buffer_nbytes = 0; 
	fork
	   gse_nu_send();
	   gse_nu_receive(); 
	join
	nu_rx_buffer_data = {C_SET,C_EL_RUN_2,48'd0,72'd1};
	nu_rx_buffer_nbytes = 17;
	nu_tx_buffer_nbytes = 17; 
	fork
	   gse_nu_send();
	   gse_nu_receive(); 
	join
     end   
`endif
      
   // Simulate FT232R GSE NU sending data to the FPGA (hack in a handshake interface on fifo lines) 
   wire       gse_uart_rx_ack; 
   rs232_ser #(.P_CLK_FREQ_HZ(100_000_000),.P_BAUD_RATE(3_000_000)) RS232_SER_0
     (
      .clk(clk),
      .rst_n(1'b1),
      .tx(gse_uart_tx),
      .tx_fifo_data(gse_uart_rx_data),
      .tx_fifo_rd_en(gse_uart_rx_ack),
      .tx_fifo_empty(!gse_uart_rx_req)
      ); 

   // Simulate the FT232R GSE UART receiving data from the chip (hack in handshake interface on fifo lines)
   rs232_des #(.P_CLK_FREQ_HZ(100_000_000),.P_BAUD_RATE(3_000_000)) RS232_DES_0
     (
      .clk(clk),
      .rst_n(1'b1),
      .rx(gse_uart_rx),
      .rx_fifo_data(gse_uart_tx_data),
      .rx_fifo_wr_en(gse_uart_tx_req),
      .rx_fifo_full(1'b0)
      );
   
   // Send UART Bytes
   task gse_uart_send();
      begin
	 while(uart_rx_buffer_nbytes)
	   begin
	      gse_uart_rx_req = 1;
	      gse_uart_rx_data = uart_rx_buffer_data >> 8*(uart_rx_buffer_nbytes-1);
	      #1;
	      wait(gse_uart_rx_ack);
	      #1;
	      gse_uart_rx_req = 0; 
	      if(!GSE_UART_MUTE)
		$display("gse_uart_send: 0x%h",gse_uart_rx_data);
	      uart_rx_buffer_nbytes = uart_rx_buffer_nbytes-1;
	      wait(!gse_uart_rx_ack);
	      #400; 
	   end
      end
   endtask

   // Receive UART bytes
   task gse_uart_receive();
      while(uart_tx_buffer_nbytes)
	begin
	   wait(gse_uart_tx_req)
	     begin
		#1;
		if(1) // !GSE_UART_MUTE)
		  $display("gse_uart_receive: 0x%h",gse_uart_tx_data);
	     end
	   wait(!gse_uart_tx_req);
	   uart_tx_buffer_nbytes = uart_tx_buffer_nbytes - 1; 
	   #1;
	   
	end // while (usb_tx_buffer_nbytes)
   endtask

   // Send NU Bytes
   task gse_nu_send();
      begin
	 while(nu_rx_buffer_nbytes)
	   begin
	      nu_cmd_req = 1;
	      nu_cmd_data = nu_rx_buffer_data >> 8*(nu_rx_buffer_nbytes-1);
	      #1;
	      wait(nu_cmd_ack);
	      #1;
	      nu_cmd_req = 0; 
	      if(!GSE_NU_MUTE)
		$display("gse_nu_send: 0x%h",nu_cmd_data);
	      nu_rx_buffer_nbytes = nu_rx_buffer_nbytes-1;
	      wait(!nu_cmd_ack);
	      #1; 
	   end
      end
   endtask
	      
   // Receive NU bytes
   task gse_nu_receive();
      while(nu_tx_buffer_nbytes)
	begin
	   wait(nu_rsp_req)
	     begin
		#1;
		nu_rsp_ack = 1'b1; 
		if(1) // !GSE_NU_MUTE)
		  $display("gse_nu_receive: 0x%h",nu_rsp_data);
	     end
	   wait(!nu_rsp_req);
	   nu_tx_buffer_nbytes = nu_tx_buffer_nbytes - 1;
	   nu_rsp_ack = 1'b0; 
	   #1;
	   
	end // while (usb_tx_buffer_nbytes)
   endtask

   
endmodule
