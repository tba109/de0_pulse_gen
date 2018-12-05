///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tyler Anderson
// Wed Dec  5 15:46:25 EST 2018
// This simulates a poisson pulse generartor using a 32b linear feedback shift register.
// The LFSR function comes from "Bebop to the Boolean Boogie", 2nd Ed. p.384. 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

void root_lfsr_32b()
{
  #define BSEL(x,n) ((x >> n)&1)

  // These are the simulation inputs
  unsigned long lfsr_period_cc = 4294967295; // how often the lfsr repeats
  double clock_period_sec = 5.E-9;
  double event_rate_hz = 8.E3;

  // These are derived
  unsigned long mean_period_cc = (unsigned long)((double)lfsr_period_cc*clock_period_sec*event_rate_hz);
  // unsigned long lfsr_low = (unsigned long)gRandom->Uniform(lfsr_period_cc/2.5,lfsr_period_cc - mean_period_cc);
  // unsigned long lfsr_low = mean_period_cc*10;
  // unsigned long lfsr_high = lfsr_low + mean_period_cc; 
  unsigned long lfsr_low =  lfsr_period_cc/2 - mean_period_cc/2;
  unsigned long lfsr_high = lfsr_period_cc/2 + mean_period_cc/2;
  
  unsigned int init_reg = 0xffffffff;
  unsigned int lsb = 0; 
  unsigned int lfsr = init_reg;
  unsigned int pulse_cnt = 0;
  double dt = 0;
  unsigned int t0_cc = 0;
  unsigned long ti_cc = 0;
  unsigned long ti_cc_break = 1E9; 
  
  TH1D * h1 = new TH1D("h1","",100,100.E-9,2./event_rate_hz); 
  
  do
    {
      lsb = BSEL(lfsr,31) ^ BSEL(lfsr,6) ^ BSEL(lfsr,5) ^ BSEL(lfsr,1); 
      lfsr = (lfsr << 1) | lsb;
      // if(ti_cc == ti_cc_break) break; 
      if(lfsr > lfsr_low && lfsr < lfsr_high)
	{
	  if(pulse_cnt != 0)
	    {
	      dt = ((double)ti_cc - (double)t0_cc)*clock_period_sec;
	      if(1)
		{
		  h1->Fill(dt);
		  // printf("%f\n",dt*1.E9);
		}
	    }
	  t0_cc = ti_cc; 
	  pulse_cnt+=1;
      }
      ti_cc++;
      if( (ti_cc%1000000)==0 )
	printf("%lu\n",ti_cc); 
  }
  while(lfsr != init_reg);
  printf("ti_cc = %lu\n",ti_cc) ;
  printf("pulse_cnt = %d\n",pulse_cnt); 
  printf("Average Rate = %f\n",(double)pulse_cnt/((double)lfsr_period_cc*clock_period_sec));
  printf("lfsr low, high = %lu, %lu\n",lfsr_low,lfsr_high); 
  h1->Draw();
  h1->Fit("expo"); 
}
