//////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson Sat Feb 15 15:02:40 EST 2014
// debounce.v
// Change output y when agreement is registered between the previous two consecutive 
// comparisons of input a.
// Delay consecutive samples by P_DELAY clock cycles.
// Output defaults to P_DEF_VAL on a reset.
//////////////////////////////////////////////////////////////////////////////////////

module debounce
  (
   ////////// inputs //////////
   input  clk, // clock
   input  rst_n, // active low reset
   input  a, // input to be debounced
   
   ////////// outputs //////////
   output y // debounced output
   );

   // parameter setup
   parameter P_DEFVAL = 1'b1; // the default value
   parameter P_DELAY = 0;    // the number of clock cycles between consecutive samples

   // ceiling(log2()), used to figure out counter size.   
   function integer clogb2;
      input integer value;
      for(clogb2=0;value>0;clogb2=clogb2+1)
	value = value >> 1;
   endfunction // for
   
   localparam NBITS = P_DELAY ? clogb2(P_DELAY) : 1; 

   // internal signals
   reg 		    a_old=0;
   reg 		    y_reg=0;
   
   // fsm
   reg [1:0] 	    fsm=0;
   localparam IDLE=3'd0, LATCH=3'd1;
      
   // timer
   wire 	    timer_on;
   wire 	    timer_done;
   reg [NBITS-1:0]  timer_cnt=0;
   assign timer_done = (timer_cnt == P_DELAY);
   assign timer_on = (fsm == LATCH);
   always @(posedge clk or negedge rst_n)
     if(!rst_n) timer_cnt <= {NBITS{1'b0}};
     else if(!timer_on) timer_cnt <= {NBITS{1'b0}};
     else timer_cnt <= timer_cnt + 1'b1;
      
   always@(posedge clk or negedge rst_n)
     begin
	if(!rst_n)
	  begin
	     fsm <= IDLE;
	     a_old <= P_DEFVAL;
	     y_reg <= P_DEFVAL;
	  end
	else
	  case(fsm)
	    IDLE:
	      if( y_reg != a )
		begin
		   a_old <= a;
		   fsm <= LATCH;
		end
	    
	    LATCH:
	      begin
		 if( timer_done )
		   begin
		      fsm <= IDLE;
		      if( a_old == a )
			y_reg <= a_old;
		   end
	      end
	  endcase
     end 
   assign y = y_reg;
   
endmodule // debounce
