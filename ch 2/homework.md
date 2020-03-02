# 2.4 [5] <§§2.2, 2.3> 
For the MIPS assembly instructions below, what is the corresponding C statement? Assume that the variables `f`, `g`, `h`, `i`, and `j` are assigned to registers `$s0`, `$s1`, `$s2`, `$s3`, and `$s4`, respectively. Assume that the base address of the arrays `A` and `B` are in registers `$s6` and `$s7`, respectively.
```
sll  $t0, $s0, 2     # $t0 = f * 4 
add  $t0, $s6, $t0   # $t0 = &A[f] 
sll  $t1, $s1, 2     # $t1 = g * 4 
add  $t1, $s7, $t1   # $t1 = &B[g] 
lw   $s0, 0($t0)     # f = A[f] 
addi $t2, $t0, 4 
lw   $t0, 0($t2) 
add  $t0, $t0, $s0 
sw   $t0, 0($t1)
```

**A:**


# 2.5 [5] <§§2.2, 2.3> 
For the MIPS assembly instructions in Exercise 2.4, rewrite the assembly code to minimize the number if MIPS instructions (if possible) needed to carry out the same function.

**A:**


# 2.25 Th e following instruction is not included in the MIPS instruction set:
```
rpt $t2, loop # if(R[rs]>0) R[rs]=R[rs]−1, PC=PC+4+BranchAddr
```

## 2.25.1 [5] <§2.7> 
If this instruction were to be implemented in the MIPS instruction set, what is the most appropriate instruction format? 

**A:**


## 2.25.2 [5] <§2.7> 
What is the shortest sequence of MIPS instructions that performs the same operation?

**A:**


# 2.39 [5] <§2.10> 
Write the MIPS assembly code that creates the 32-bit constant `0010 0000 0000 0001 0100 1001 0010 0100` and stores that value to register `$t1`.

**A:**


# 2.40 [5] <§§2.6, 2.10> 
If the current value of the PC is `0x00000000`, can you use a single jump instruction to get to the PC address as shown in Exercise 2.39?

**A:**


# 2.41 [5] <§§2.6, 2.10> 
If the current value of the PC is `0x00000600`, can you use a single branch instruction to get to the PC address as shown in Exercise 2.39?

**A:**


# 2.42 [5] <§§2.6, 2.10> 
If the current value of the PC is `0x1FFFf000`, can you use a single branch instruction to get to the PC address as shown in Exercise 2.39?

**A:**


# 2.43 [5] <§2.11> 
Write the MIPS assembly code to implement the following C code:
```
lock(lk);      
shvar=max(shvar,x);      
unlock(lk); 
```
Assume that the address of the lk variable is in `$a0`, the address of the shvar variable is in `$a1`, and the value of variable `x` is in `$a2`. Your critical section should not contain any function calls. Use ll/sc instructions to implement the `lock()` operation, and the `unlock()` operation is simply an ordinary store instruction.

**A:**


# 2.44 [5] <§2.11> 
Repeat Exercise 2.43, but this time use ll/sc to perform an atomic update of the shvar variable directly, without using `lock()` and `unlock()`. Note that in this problem there is no variable lk.

**A:**


# X86与MIPS32过程调用异同的比较

**A:**