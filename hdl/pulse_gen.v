///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson Tue Dec  4 14:55:51 EST 2018
//
// pulse_gen.v
//
// Possion pulse generator 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module pulse_gen
  (
   input 	clk,
   input [31:0] x_low,
   input 	x_low_wr, 
   input [31:0] x_high,
   input 	x_high_wr, 
   input [31:0] x,
   output reg pulse_out
   );

   ////////////////////////////////////////////
   // See the sw directory for the root script
   // LFSR 32b has 4,294,967,295 states
   // 15kHz
   reg [31:0] 	i_x_low  = 32'd2149322586;
   reg [31:0] 	i_x_high = 32'd2147644709; 

   // // 8kHz
   // reg [31:0] 	i_x_low  = 32'd2147397748;
   // reg [31:0] 	i_x_high = 32'd2147569547; 
   
   always @(posedge clk) if(x_low_wr) i_x_low <= x_low;
   always @(posedge clk) if(x_high_wr) i_x_high <= x_high;
   // always @(posedge clk) pulse_out <= (x >= i_x_low) && (x < i_x_high) && !pulse_out;
   always @(posedge clk) pulse_out <= (x >= i_x_low) && (x < i_x_high); 
         
endmodule
