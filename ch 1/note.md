# ISA
`ISA`, `Instruction Set Architecture`. First, there's another concept `Micro Architecture` is refer to how instructions excuted on hardware. So `ISA` is design to **oriented to programer**(just like oop), they donot need to know how each instruction executing, but directly use the executing result. Thus, `ISA` is very significant in `Abstraction` design mode.

# Execution Time & Bandwidth
+ `Execution Time` or `Response Time` is the time-comsume of entire progress of a program, not only include CPU running time.
+ `Bandwidth` or `Throughput` is a number equal to missons completed in a unit time.

Warning that shorter `execution time` may not correspond with better `throughput`(just like **pipline**, `throughput` is the result of pipline, but a single mission may cost a lot time, which is exactly `execution time`). So, a better CPU can improve both of them, but add more CPU can only improve `throughput`.

+ `CPU Execution Time` is subset of `Execution Time`, it's only stand for the time cost in CPU, but except in I/O or some other places. But actually user can only feel `Execution Time`.

# Time Caculation
`Clock Cycle` is a unit, just like a class is 45mins, then **class** is correspond with `clock cycle`.