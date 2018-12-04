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

  do
    {
      lsb = BSEL(lfsr,31) ^ BSEL(lfsr,6) ^ BSEL(lfsr,5) ^ BSEL(lfsr,1); 
      lfsr = (lfsr << 1) | lsb;
      cnts[lfsr/bw]+=1;
      period++;
      printf("%08x: %08x\n",period,lfsr); if(period == 100) return 0; 
      // if(lfsr == 1) printf("Found 1\n"); 
      if(period%1000000 == 0)
	printf("period = %lu\n",period);
    }
  while(lfsr != init_reg);
  printf("period = %lu\n",period) ;

  printf("-------------------------------\n"); 
  for(int i = 0; i < 129; i++)
    printf("%d\n",cnts[i]);
  
  return 0; 
}
