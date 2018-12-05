#include <stdio.h>
#include <math.h>
#define BSEL(x,n) ((x >> n)&1)

int main()
{
  unsigned int init_reg = 0xffffffff;
  unsigned int lsb = 0; 
  unsigned int lfsr = init_reg;
  unsigned long period = 0;
  unsigned int bw = (0x100000000/128);
  unsigned int cnts[129];
  for(int i = 0; i < 129; i++)
    cnts[i] = 0; 
  unsigned int pulse_cnt = 0;
  float dt = 0; 
  unsigned int t0 = 0; 
  do
    {
      lsb = BSEL(lfsr,31) ^ BSEL(lfsr,6) ^ BSEL(lfsr,5) ^ BSEL(lfsr,1); 
      lfsr = (lfsr << 1) | lsb;
      cnts[lfsr/bw]+=1;
      period++;
      // printf("%08x: %08x\n",period,lfsr); if(period == 100) return 0; 
      // if(lfsr == 1) printf("Found 1\n"); 
      // if(period%1000 == 0)
      // printf("period = %lu, pulse_cnt = %d \n",period,pulse_cnt);
      if(period%int(0.01/(20.E-9)) == 0)
	{
	  printf("period = %lu, pulse_cnt = %d \n",period,pulse_cnt);
	}
      if(lfsr < 858993)
	{
	  if(pulse_cnt != 0)
	    dt = ((float)dt*((float)pulse_cnt) + ((float)period - (float)t0))/((float)(pulse_cnt+1));
	  t0 = period; 
	  pulse_cnt+=1; 
	}
    }
  while(lfsr != init_reg);
  printf("period = %lu\n",period) ;
  
  /* printf("-------------------------------\n");  */
  /* for(int i = 0; i < 129; i++) */
  /*   printf("%d\n",cnts[i]); */

  printf("pulse_cnt = %d\n",pulse_cnt); 
  printf("dt = %f, freq = %f\n",dt*20.E-9,1./(dt*20.E-9)); 
  return 0; 
}
