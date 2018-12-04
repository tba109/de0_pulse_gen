import numpy as np
import matplotlib.pyplot as plt

init_reg = 0xffffffff
lsb = 0
lfsr = init_reg
period = 0

def bsel(x,n):
    return ((x >> n) & 1)

while True:
    lsb = bsel(lfsr,31) ^ bsel(lfsr,6) ^ bsel(lfsr,5) ^ bsel(lfsr,1)
    lfsr = ((lfsr << 1) | lsb) & 0xffffffff
    
    period+=1
    # print lfsr
    if(period%1000000==0):
        print "period = %d" % period

    if(lfsr == init_reg):
        break

print "period = %d" % period
