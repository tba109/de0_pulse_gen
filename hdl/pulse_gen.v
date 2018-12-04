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
   
   reg [31:0] 	i_x_low = 0;
   reg [31:0] 	i_x_high = 32'd858993; // 10kHz

   always @(posedge clk) if(x_low_wr) i_x_low <= x_low;
   always @(posedge clk) if(x_high_wr) i_x_high <= x_high;
   // always @(posedge clk) pulse_out <= (x >= i_x_low) && (x < i_x_high) && !pulse_out;
   always @(posedge clk) pulse_out <= (x >= i_x_low) && (x < i_x_high); 
         
endmodule
