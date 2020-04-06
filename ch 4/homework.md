# 4.3 
When processor designers consider a possible improvement to the processor datapath, the decision usually depends on the cost/performance trade-off . In the following three problems, assume that we are starting with a datapath from Figure 4.2, where I-Mem, Add, Mux, ALU, Regs, D-Mem, and Control blocks have latencies of 400 ps, 100 ps, 30 ps, 120 ps, 200 ps, 350 ps, and 100 ps, respectively, and costs of 1000, 30, 10, 100, 200, 2000, and 500, respectively. Consider the addition of a multiplier to the ALU.  Th is addition will add 300 ps to the latency of the ALU and will add a cost of 600 to the ALU.  Th e result will be 5% fewer instructions executed since we will no longer need to emulate the MUL instruction. 

![4.2](4.2.png)

## 4.3.1 [10] <§4.1> 
What is the clock cycle time with and without this improvement? 

**A:** Clock cycle time equals to the instrcution which takes the longest time. 

## 4.3.2 [10] <§4.1> 
What is the speedup achieved by adding this improvement? 

## 4.3.3 [10] <§4.1> 
Compare the cost/performance ratio with and without this improvement.
