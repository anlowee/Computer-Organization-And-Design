# 多周期图阻塞示例
```
IF  ID  EX  MEM WB                                                  # lw  r1, 0(r1)
    IF  ID  **  EX  MEM WB                                          # and r1, r1, r2
        IF  **  ID  **  EX  MEM WB                                  # lw  r1, 0(r1)
                IF  **  ID  **  EX  MEM WB                          # lw  r1, 0(r1)
                        IF  **  ID  **  EX  MEM WB                  # beq r1, r0, loop
``` 
注意到需要阻塞的时候，当且列（即当前周期）下面（即之后）执行的指令都需要在这个地方阻塞。这是因为上面的指令阻塞的时候状态时是保留的，必须等阻塞过后改部件才能再次工作。下面的指令如果不跟着阻塞，就会把寄存器内保存的状态冲掉。比如第二行的ID和第三行的ID，第三行的ID必须跟着第二行阻塞才能工作。

# 一些提示
+ 冒险检测和冒险检测单元是两个概念，冒险检测是在旁路单元里完成的（产生forward信号，用相应的流水线寄存器值代替通用寄存器的值），冒险检测单元是用来锁死PC和IF/ID寄存器的写入以及用全0代替控制信号（产生阻塞）。
+ 旁路冒险在EX级产生信号，如果当前周期EX没有工作，则信号位X。而冒险检测单元在ID级工作。
+ 有旁路数据可从流水线寄存器连出来，没有旁路数据只能从级上连出来（如从WB级连出，代表写入后使用），线不能往回走。
+ Branch在哪一级执行则下一条指令IF必须在这一级之后，比如Branch在EX级执行，下一条指令的IF必须等到Branch的MEM级。
+ 对于IF  **  **这种阻塞，ID执行一半发现有问题，然后可以将原来从IF/ID写的内容重新写回IF/ID（可能要加控制信号，控制写入IF/ID的是来自PC的还是来自。
+ 旁路必须从流水线寄存器出来（alu的结果从EX/MEM寄存器出来），但是可以直接到其他原件或者其他流水线寄存器。