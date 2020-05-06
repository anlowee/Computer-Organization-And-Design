# 多周期图阻塞示例
```
IF  ID  EX  MEM WB                                                  # lw  r1, 0(r1)
    IF  ID  **  EX  MEM WB                                          # and r1, r1, r2
        IF  **  ID  **  EX  MEM WB                                  # lw  r1, 0(r1)
                IF  **  ID  **  EX  MEM WB                          # lw  r1, 0(r1)
                        IF  **  ID  **  EX  MEM WB                  # beq r1, r0, loop
``` 
注意到需要阻塞的时候，当且列（即当前周期）下面（即之后）执行的指令都需要在这个地方阻塞。这是因为上面的指令阻塞的时候状态时是保留的，必须等阻塞过后改部件才能再次工作。下面的指令如果不跟着阻塞，就会把寄存器内保存的状态冲掉。比如第二行的ID和第三行的ID，第三行的ID必须跟着第二行阻塞才能工作。
