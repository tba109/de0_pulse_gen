///////////////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson Tue Nov 13 13:47:31 EST 2018
// de0_pulse_gen_top_tb.v
//
//////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

///////////////////////////////////////////////////////////////////////////////////////////////////
// Test cases
///////////////////////////////////////////////////////////////////////////////////////////////////
// `define TEST_CASE_CONFIG_IND
`define TEST_CASE_GET_VNUM_UART
// `define TEST_CASE_GET_VNUM

module de0_pulse_gen_top_tb;

   `include "inc_params.v"
   
   //////////////////////////////////////////////////////////////////////
   // I/O
   //////////////////////////////////////////////////////////////////////   
   parameter CLK_PERIOD = 20;
   reg clk;
   reg rst;
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
   reg			CLOCK2_50;		// To de0_0 of de0_pulse_gen_top.v
   reg			CLOCK3_50;		// To de0_0 of de0_pulse_gen_top.v
   reg			CLOCK_50;		// To de0_0 of de0_pulse_gen_top.v
   reg [3:0]		KEY;			// To de0_0 of de0_pulse_gen_top.v
   reg			RESET_N;		// To de0_0 of de0_pulse_gen_top.v
   reg [9:0]		SW;			// To de0_0 of de0_pulse_gen_top.v
   wire                 gse_uart_tx; // TX wrt FT232R: this is from the FT232R to the FPGA
   wire                 gse_uart_rx; // RX wrt FT232R: this is from the FPGA to the FT232
   reg [7:0]            nu_cmd_data;
   reg 	                nu_cmd_req;
   wire                 nu_cmd_ack;
   wire [7:0]           nu_rsp_data;
   wire                 nu_rsp_req;
   reg 	                nu_rsp_ack; 
   
   always @(*) begin
      CLOCK_50 <= clk;
      KEY[0] <= !rst;
   end
  
   assign GPIO_1[28] = gse_uart_tx;
   assign gse_uart_rx = GPIO_1[29]; 
   
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
   
`ifdef TEST_CASE_GET_VNUM_UART
   initial
     begin
	#(10*CLK_PERIOD);
	rst = 0; 
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
	rst = 0; 
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


   //////////////////////////////////////////////////////////////////////
   // Tasks (e.g., writing data, etc.)
   //////////////////////////////////////////////////////////////////////   
   // Simulate FT232R GSE NU sending data to the FPGA (hack in a handshake interface on fifo lines) 
   wire       gse_uart_rx_ack; 
   rs232_ser #(.P_CLK_FREQ_HZ(50_000_000),.P_BAUD_RATE(3_000_000)) RS232_SER_0
     (
      .clk(clk),
      .rst_n(1'b1),
      .tx(gse_uart_tx),
      .tx_fifo_data(gse_uart_rx_data),
      .tx_fifo_rd_en(gse_uart_rx_ack),
      .tx_fifo_empty(!gse_uart_rx_req)
      ); 

   // Simulate the FT232R GSE UART receiving data from the chip (hack in handshake interface on fifo lines)
   rs232_des #(.P_CLK_FREQ_HZ(50_000_000),.P_BAUD_RATE(3_000_000)) RS232_DES_0
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

// Local Variables:
// verilog-library-directories:("." ".." "../hdl")
// verilog-library-flags:("-y ../hdl/")
// End:
   
