# 2.4 [5] <§§2.2, 2.3>(wrong) 
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
B[g] = A[f] + A[f + 1]
f = A[f]


# 2.5 [5] <§§2.2, 2.3>(wrong) 
For the MIPS assembly instructions in Exercise 2.4, rewrite the assembly code to minimize the number if MIPS instructions (if possible) needed to carry out the same function.

**A:**
```
sll  $t0, $s0, 2     # $t0 = f * 4 
add  $t0, $s6, $t0   # $t0 = &A[f] 
sll  $t1, $s1, 2     # $t1 = g * 4 
add  $t1, $s7, $t1   # $t1 = &B[g] 
lw   $s0, 0($t0)     # f = A[f]    
lw   $t0, 4($t0)    
add  $t0, $t0, $s0   
sw   $t0, 0($t1)  
```


# 2.25 Th e following instruction is not included in the MIPS instruction set:
```
rpt $t2, loop # if(R[rs]>0) R[rs]=R[rs]−1, PC=PC+4+BranchAddr
```

## 2.25.1 [5] <§2.7> 
If this instruction were to be implemented in the MIPS instruction set, what is the most appropriate instruction format? 

**A:**
I.

## 2.25.2 [5] <§2.7> 
What is the shortest sequence of MIPS instructions that performs the same operation?

**A:**
```
slt   $t0, $zero, $t2
beq   $t0, $zero, LOOP   
addi  $t2, $t2, -1        # R[rs]--
```

# 2.39 [5] <§2.10> 
Write the MIPS assembly code that creates the 32-bit constant `0010 0000 0000 0001 0100 1001 0010 0100` and stores that value to register `$t1`.

**A:**
```
lui   $t1, 0x2001
ori   $t1, $t1, 0x4924
```

# 2.40 [5] <§§2.6, 2.10> 
If the current value of the PC is `0x00000000`, can you use a single jump instruction to get to the PC address as shown in Exercise 2.39?

**A:**
No. The maximum address is `0x0FFFFFFC`, which is less than destination.

# 2.41 [5] <§§2.6, 2.10>
If the current value of the PC is `0x00000600`, can you use a single branch instruction to get to the PC address as shown in Exercise 2.39?

**A:**
No. The maximum address is PC+4+0x1FFFC equals to `0x40000`, the minimum address is max(PC+4-0x1FFFC, 0) equals to `0x0`, but destination is out of range `0x0` to `0x40000`.

# 2.42 [5] <§§2.6, 2.10> 
If the current value of the PC is `0x1FFFf000`, can you use a single branch instruction to get to the PC address as shown in Exercise 2.39?

**A:**
Yes. The offset(bytes) is `01 0100 1001 0010 0000` which add PC+4 equals to destination. Transfer into words it's `0101 0010 0100 1000` which is a 16 bits operator can be used in `beq` or `bne`.

# 2.43 [5] <§2.11>
Write the MIPS assembly code to implement the following C code:
```
lock(lk);      
shvar=max(shvar,x);      
unlock(lk); 
```
Assume that the address of the lk variable is in `$a0`, the address of the shvar variable is in `$a1`, and the value of variable `x` is in `$a2`. Your critical section should not contain any function calls. Use ll/sc instructions to implement the `lock()` operation, and the `unlock()` operation is simply an ordinary store instruction.

**A:**
TRYLK:  ll   $t0, 0($a0)        
        bne  $t0, $zero, TRYLK  # if lk = 0, that is, thread is spare, or keep waiting until it's spare
        ori  $t1, $zero, 1      
        sc   $t1, 0($a0)        # set lk as 1 when there is no noise, or $t1 -> 0
        beq  $t1, $zero, TRYLK  # if $t1 = 0, there is noise, then try lock again
CMP:    lw   $t2, 0($a1)        # load shvar
        lw   $t3, 0($a2)        # load x
        slt  $t4, $t2, $t3      
        bne  $t4, $zero, ENDLK
        sw   $t3, 0($a1)        # x > shvar, shvar = x
ENDLK:  sw   $zero, 0($a0)      # set lk as 0, that is restore to spare

# 2.44 [5] <§2.11> 
Repeat Exercise 2.43, but this time use ll/sc to perform an atomic update of the shvar variable directly, without using `lock()` and `unlock()`. Note that in this problem there is no variable lk.

**A:**
TRYUP:  ll   $t0, 0($a1)        # load shvar elementally
        lw   $t1, 0($a2)        # load x
        slt  $t2, $t0, $t1      
        bne  $t2, $zero, ENDUP   
        sw   $t1, $t0           # x > shvar, shvar = x
        sc   $t0, 0($a1)        # if successful, set shvar, and $t0 -> 1, else $t0 -> 0
        beq  $t0, $zero, TRYUP  # update failed, try again
ENDUP:

# X86与MIPS32过程调用异同的比较

**A:**
