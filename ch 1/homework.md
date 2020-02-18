# 1.5 [4] <§1.6> 
Consider three diff erent processors P1, P2, and P3 executing the same instruction set. P1 has a 3 GHz clock rate and a CPI of 1.5. P2 has a 2.5 GHz clock rate and a CPI of 1.0. P3 has a 4.0 GHz clock rate and has a CPI of 2.2.

**a**. Which processor has the highest performance expressed in instructions per second? 

**A:** The time cost per instruction is:

* P1: 1.5/3.0e9 = 5e-10 s -> 2.0e9 ins/s
* P2: 1.0/2.5e9 = 4e-10 s -> 2.5e9 ins/s
* P3: 2.2/4.0e9 = 5.4e-10 s -> 1.9e9 ins/s

so **P2** is the fastest.

b. If the processors each execute a program in 10 seconds, fi nd the number of cycles and the number of instructions.

**A:** According to question a:

* P1: 2.0e9 * 10 = 2.0e10 ins, 2.0e10 * 1.5 = 3.0e10 cyc
* P2: 2.5e9 * 10 = 2.5e10 ins, 2.5e10 * 1.0 = 2.5e10 cyc
* P3: 1.9e9 * 10 = 1.9e10 ins, 1.9e10 * 2.2 = 4.0e10 cyc

c. We are trying to reduce the execution time by 30% but this leads to an increase of 20% in the CPI. What clock rate should we have to get this time reduction?

**A:** CPU cycles = I * CPI

CPU times = cycles / rate = I * CPI / rate

assume that rate->rate * x, 

CPU times = I * CPI * 1.2 / rate * x = (1.2 / x) * I * CPI / rate

1.2 / x = 1 - 0.3 = 0.7 -> x = 1.71

so rate must be improved 71%,

+ P1: 3 + 3 * 71% = 5.13 GHz
+ P2: 2.5 + 2.5 * 71% = 4.28 GHz
+ P3: 4 + 4 * 71% = 6.84 GHz

 # 1.6 [20] <§1.6> 
 Consider two different implementations of the same instruction set architecture. Th e instructions can be divided into four classes according to their CPI (class A, B, C, and D). P1 with a clock rate of 2.5 GHz and CPIs of 1, 2, 3, and 3, and P2 with a clock rate of 3 GHz and CPIs of 2, 2, 2, and 2. Given a program with a dynamic instruction count of 1.0E6 instructions divided into classes as follows: 10% class A, 20% class B, 50% class C, and 20% class D, which implementation is faster? 
 
 **a**. What is the global CPI for each implementation? 
 
 **A:** The instruction count are class-A: 1.0e5, class-B: 2.0e5, class-C: 5.0e5, class-D: 2.0e5.

 + P1: CPI = (1 * 1.0e5 + 2 * 2.0e5 + 3 * 5.0e5 + 3 * 2.0e5) / 1.0e6 = 2.6
 + P2: CPI = (2 * 1.0e5 + 2 * 2.0e5 + 2 * 2.0e5 + 2 * 2.0e5) / 1.0e6 = 2.0
 
 **b**. Find the clock cycles required in both cases.

 **A:** According to question a:

 + P1: cycles = I * CPI = 1.0e6 * 2.6 = 2.6e6
 + P2: cycles = I * CPI = 1.0e6 * 2.0 = 2.0e6

# 1.9 

Assume for arithmetic, load/store, and branch instructions, a processor has CPIs of 1, 12, and 5, respectively. Also assume that on a single processor a program requires the execution of 2.56E9 arithmetic instructions, 1.28E9 load/store instructions, and 256 million branch instructions. Assume that each processor has a 2 GHz clock frequency. Assume that, as the program is parallelized to run over multiple cores, the number of arithmetic and load/store instructions per processor is divided by 0.7 x p (where p is the number of processors) but the number of branch instructions per processor remains the same.

## 1.9.1 [5] <§1.7> 

Find the total execution time for this program on 1, 2, 4, and 8 processors, and show the relative speedup of the 2, 4, and 8 processor result relative to the single processor result.

**A:**
| Processors | Arith  | L/S    | Branch | Cycles  | Exe Time | Speedup |
|------------|--------|--------|--------|---------|----------|---------|
| 1          | 2.56e9 | 1.28e9 | 2.56e8 | 1.92e10 | 9.6      | 1.0     |
| 2          | 1.82e9 | 9.14e8 | 2.56e8 | 1.41e10 | 7.0      | 1.37    |
| 4          | 9.14e8 | 4.57e8 | 2.56e8 | 7.68e9  | 3.8      | 2.52    |
| 8          | 4.57e8 | 2.29e8 | 2.56e8 | 4.49e9  | 2.2      | 4.36    |

## 1.9.2 [10] <§§1.6, 1.8> 
If the CPI of the arithmetic instructions was doubled, what would the impact be on the execution time of the program on 1, 2, 4, or 8 processors?

**A:**
| Processors | Arith  | L/S    | Branch | Cycles  | Exe Time | Speeddown |
|------------|--------|--------|--------|---------|----------|-----------|
| 1          | 2.56e9 | 1.28e9 | 2.56e8 | 2.18e10 | 10.9     | 0.88      |
| 2          | 1.82e9 | 9.14e8 | 2.56e8 | 1.59e10 | 8.0      | 0.88      |
| 4          | 9.14e8 | 4.57e8 | 2.56e8 | 8.60e9  | 4.3      | 0.88      |
| 8          | 4.57e8 | 2.29e8 | 2.56e8 | 4.95e9  | 2.5      | 0.88      |

They are all slower, and the rate is almost same as 0.88.

## 1.9.3 [10] <§§1.6, 1.8> 
To what should the CPI of load/store instructions be reduced in order for a single processor to match the performance of four processors using the original CPI values?

**A:** 4 processores' cycles is 7.68e9. When single processor's arithmetic and branch instruction CPI remain, the load/store instructions total cycles is: 7.68e9 - 2.56e9 * 1 - 2.56e8 * 5 = 3.84e9, thus, **CPI = 3.84e9 / 1.28e9 = 3** 

# 1.11 
The results of the SPEC CPU2006 bzip2 benchmark running on an AMD Barcelona has an instruction count of 2.389E12, an execution time of 750 s, and a reference time of 9650 s. 

## 1.11.1 [5] <§§1.6, 1.9> 
Find the CPI if the clock cycle time is 0.333 ns. 

**A:**

cycles = 750 s / 0.333 ns = 2.250e12

CPI = cycles / I = 0.942

## 1.11.2 [5] <§1.9> 
Find the SPEC ratio. 

**A:** 9650 / 750 = 12.87

## 1.11.3 [5] <§§1.6, 1.9> 
Find the increase in CPU time if the number of instructions of the benchmark is increased by 10% without affecting the CPI. 

**A:** 10% * 750 = 75 s

## 1.11.4 [5] <§§1.6, 1.9> 
Find the increase in CPU time if the number of instructions of the benchmark is increased by 10% and the CPI is increased by 5%.

**A:** (1 + 10%) * (1 + 5%) * 750 - 750 = 116.25 s, increase 15.5%.

## 1.11.5 [5] <§§1.6, 1.9> 
Find the change in the SPEC ratio for this change. 

**A:** 1 / (1 + 15.5%) = 0.86, decrease 14%.

## 1.11.6 [10] <§1.6> 
Suppose that we are developing a new version of the AMD Barcelona processor with a 4 GHz clock rate. We have added some additional instructions to the instruction set in such a way that the number of instructions has been reduced by 15%.  The execution time is reduced to 700 s and the new SPEC ratio is 13.7.  Find the new CPI.

**A:** 

cycles = time * rate = 700 * 4e9 = 2.8e12

I = 2.389e12 * 85% = 2.031e12

CPI = cycles / I = 1.378

## 1.11.7 [10] <§1.6> 
This CPI value is larger than obtained in 1.11.1 as the clock rate was increased from 3 GHz to 4 GHz. Determine whether the increase in the CPI is similar to that of the clock rate. If they are dissimilar, why? 

**A:** CPI increase rate is 1.45, clock rate increase is 1.33. They are dissimilar, the difference is caused by 15% instruction decrease.

## 1.11.8 [5] <§1.6> 
By how much has the CPU time been reduced?

**A:** (750 - 700) / 750 = 6.7%

## 1.11.9 [10] <§1.6>
For a second benchmark, libquantum, assume an execution time of 960 ns, CPI of 1.61, and clock rate of 3 GHz.  If the execution time is reduced by an additional 10% without affecting to the CPI and with a clock rate of 4 GHz, determine the number of instructions. 

**A:** I = time * rate / CPI = 960e-9 * 0.9 * 4GHz / 1.61 = 2.146e12  


## 1.11.10 [10] <§1.6>
Determine the clock rate required to give a further 10% reduction in CPU time while maintaining the number of instructions and with the CPI unchanged. 

**A:** 3 / 0.9 = 3.33 GHz(ps: here the rate is ambiguous, this '3' is from 1.11.9, if it's '4', the answer is 4 / 0.9 = 4.44 GHz)

## 1.11.11 [10] <§1.6>
Determine the clock rate if the CPI is reduced by 15% and the CPU time by 20% while the number of instructions is unchanged.

**A:** 3 * 0.85 / 0.8 = 3.19 GHz(ps: here the rate is ambiguous, this '3' is from 1.11.9, if it's '4', the answer is 4 * 0.85 / 0.8 = 4.25 GHz)

# 1.12 
Section 1.10 cites as a pitfall the utilization of a subset of the performance equation as a performance metric. To illustrate this, consider the following two processors. P1 has a clock rate of 4 GHz, average CPI of 0.9, and requires the execution of 5.0E9 instructions.  P2 has a clock rate of 3 GHz, an average CPI of 0.75, and requires the execution of 1.0E9 instructions. 

## 1.12.1 [5] <§§1.6, 1.10> 
One usual fallacy is to consider the computer with the largest clock rate as having the largest performance. Check if this is true for P1 and P2. 

**A:**
+ P1: time = I * CPI / rate = 5.0e9 * 0.9 / 4 GHz = 1.125 s
+ P2: time = I * CPI / rate = 1.0e9 * 0.75 / 3 GHz = 0.25 s

thus, P2 has better performance.

## 1.12.2 [10] <§§1.6, 1.10> 
Another fallacy is to consider that the processor executing the largest number of instructions will need a larger CPU time. Considering that processor P1 is executing a sequence of 1.0E9 instructions and that the CPI of processors P1 and P2 do not change, determine the number of instructions that P2 can execute in the same time that P1 needs to execute 1.0E9 instructions. 

**A:** 

I1 * CPI1 / rate1 = I2 * CPI2 / rate2 -> I2 = I1 * (CPI1 / CPI2) * (rate2 / rate1) = 9e8

## 1.12.3 [10] <§§1.6, 1.10> 
A common fallacy is to use MIPS (millions of instructions per second) to compare the performance of two different processors, and consider that the processor with the largest MIPS has the largest performance. Check if this is true for P1 and P2. 

**A:** According to question 1.12.1:
+ P1: MIPS = 5.0e3 / 1.125 = 4.44
+ P2: MIPS = 1.0e3 / 0.25 = 4

although MIPS of P1 > MIPS of P2, P2 CPU time is smaller.

## 1.12.4 [10] <§1.10> 
Another common performance fi gure is MFLOPS (millions of fl oating-point operations per second), defi ned as MFLOPS = No. FP operations / (execution time × 1E6) but this fi gure has the same problems as MIPS. Assume that 40% of the instructions executed on both P1 and P2 are fl oating-point instructions.  Find the MFLOPS fi gures for the programs.

**A:** According to question 1.12.1:
+ P1: MFLOPS = 5.0e9 * 40% / (1.125e6) = 1.78e3
+ P2: MFLOPS = 1.0e9 * 40% / (0.25e6) = 1.60e3

# 1.14 
Assume a program requires the execution of 50 × 10E6 FP instructions, 110 × 10E6 INT instructions, 80 × 10E6 L/S instructions, and 16 × 10E6 branch instructions.  Th e CPI for each type of instruction is 1, 1, 4, and 2, respectively. Assume that the processor has a 2 GHz clock rate. 

## 1.14.1 [10] <§1.10> 
By how much must we improve the CPI of FP instructions if we want the program to run two times faster? 

**A:** the original time = (5e7 * 1 + 1.1e8 * 1 + 8e7 * 4 + 1.6e7 * 2) / 2 GHz = 0.256 s

assume that new FP CPI is x, new time = (5e7 * x + 1.1e8 * 1 + 8e7 * 4 + 1.6e7 * 2) / 2 GHz = 0.128 s -> x is negtive, that's impossble.

## 1.14.2 [10] <§1.10>
By how much must we improve the CPI of L/S instructions if we want the program to run two times faster? 

**A:** Assume that new L/S CPI is x, 0.128 s = (5e7 * 1 + 1.1e8 * 1 + 8e7 * x + 1.6e7 * 2) / 2 GHz -> x = 0.8

## 1.14.3 [5] <§1.10> 
By how much is the execution time of the program improved if the CPI of INT and FP instructions is reduced by 40% and the CPI of L/S and Branch is reduced by 30%?

**A:** time = (5e7 * 0.6 * 1 + 1.1e8 * 0.6 * 1 + 8e7 * 0.7 * 4 + 1.6e7* 0.7 * 2) / 2 GHz = 0.1712 s, 0.256 / 0.1712 = 1.495.

so improve 49.5%