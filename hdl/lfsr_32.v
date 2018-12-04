///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson Tue Dec  4 14:19:44 EST 2018
//
// lfsr_32.v
//
// Pseudo random number generator based on "Bebop to the Boolean Boogie", Appendix E, Figure E.4. 
// This is a maximum length sequence. 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module lfsr_32
  (
   input 	 clk,
   input [31:0]  seed,
   input 	 seed_wr, 
   output 	 y,
   output [31:0] lfsr
   );

   parameter P_INIT_SEED=32'hffffffff;
   reg [31:0] 	     sr = P_INIT_SEED; 
   
   assign y = sr[31] ^ sr[6] ^ sr[5] ^ sr[1]; 
   assign lfsr = sr; 
   
   always @(posedge clk)
     if(seed_wr && (seed != 32'd0))
       sr <= seed;
     else
       sr <= {sr[30:0],y};
      
endmodule
