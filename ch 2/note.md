# 地址标准
涉及数组元素，如：`lw  $s1, 20($s2)`，其中20对应**字节地址**，若`$s2`中基地址对应的数组为`int`类型数组，则表示`a[5]`。

涉及跳转指令，如：`beq  $s1, $s2, 25`，其中25表示从`PC+4`开始的`offset`，是**字地址**，在内存中的字节地址实际上为`PC+4+100`。

# 32个寄存器
| 寄存器号  | 符号名  | 用途                                                                    |
|-----------|---------|-------------------------------------------------------------------------|
| **0**     | 始终为0 | 看起来象浪费,其实很有用                                                 |
| 1         | at      | 保留给汇编器使用                                                        |
| 2-3       | v0,v1   | 函数返回值                                                              |
| 4-7       | a0-a3   | 前头几个函数参数                                                        |
| **8-15**  | t0-t7   | 临时寄存器,子过程可以不保存就使用                                       |
| 24-25     | t8,t9   | 同上                                                                    |
| **16-23** | s0-s7   | 寄存器变量,子过程要使用它必须先保存然后在退出前恢复以保留调用者需要的值 |
| 26,27     | k0,k1   | 保留给异常处理函数使用                                                  |
| 28        | gp      | global pointer;用于方便存取全局或者静态变量                             |
| 29        | sp      | stack pointer                                                           |
| 30        | s8/fp   | 第9个寄存器变量;子过程可以用它做frame pointer                           |
| **31**    | ra      | 返回地址                                                                |

# 立即数
因为`add`命令操作常数涉及取数操作，速度很慢，所以设计一个专门对常数的算术指令`addi`，因为常数可以是负数，因此没有减法的立即数操作。特别的，`0`只能用`$zero`寄存器表示，MIPS中无`mov`指令，因为这与`add $s0,$s1,$zero`等效。

# R型和I型指令
`rs/rt/rs`都是五位是因为**只有32个寄存器**；`shamt`根据机器类型，32位机则为五位，因为最多移位31位；

I型指令中，`rt`寄存器**可能代表源寄存器也可能是目的寄存器**，如在取字指令中为目的寄存器（因为只需要一个源寄存器，必然是`rs`，所以`rt`为目的寄存器），**注意：先往`rt`寄存器中填，若只用到一个寄存器，则`rs`为0**。

**逻辑移位操作都是R型**，因为需要用到`shamt`位。

# MIPS中无数据类型

# 寻址相关
`bne`和`beq`的16位地址与**PC+4**相加，得到跳转地址，且单位为**字**，并且改16位为**有符号数**，范围正负2^15 words。

注意，branch指令操作数先符号位扩展到30位，再左移两位，再与PC+4相加，得到一个32位数。

`j`的操作数是**无符号数**。

# 一道例题
```
addi  $11, $0, 0x83F5
sw    $11, 0($5)
lb    $12, 1($5)
```

MIPS32使用大端法存储，而0x83F5是一个有符号数，进行符号位扩展，因为`sw`命令，所以扩展为一个字的长度，变为0xFFFF83F5。在内存中结构如下：

F5
83
FF ←1($5)
FF ←0($5)

注意此处的0和1均为字节单位（因为`lb`命令），所以`lb`的结果是FF；这里做符号位扩展的原因是0x83F5是`addi`的操作数，因此有负有正，所以必须做符号位扩展。

# lui
addi命令对lui命令操作后的寄存器操作后会**先进行符号位扩展再相加**。

# 原子操作
[link](https://blog.csdn.net/leishangwen/article/details/41262509)

原子操作当作独占cpu，其他线程必须等原子操作结束后才能进行；临界区就是代码段访问临界资源，是线程安全的，此时其他线程也可以进行。

原子操作，ll和sc之间的是原子操作，这两个操作的寄存器最好不一样（书上给的例子是不一样的）。

`lock()`通过`ll/sc`实现，`unlock()`不妨视为简单地使用存数命令，模板：
```
trylk:  ll   $t0, 0($a0)        # 线程锁变量lk，多个线程共用一个进程锁lk，当某一进程正在工作时，lk被占用，为1
        bne  $t0, $zero, trylk  # lk为0说明当前空闲，继续执行下一步指令，否则继续等待
        ori  $t1, $zero, 1      
        sc   $t1, 0($a0)        # 当没受到干扰时，将lk赋值为1；受到干扰时，不修改信号量，并将$t1置零
        beq  $t1, $zero, trylk  # 此时为0说明受到干扰
opt     ...                     # 进入临界区域
endlk:  sw   $zero, 0($a0)      # 将线程锁变量置零，恢复空闲
```

# 基本块(basic block)
中间不能有bne，beq，然后开头可以有label，结尾也可以有bne，beq

# 读写操作
l操作必须从地址中读取值到寄存器中，这个寄存器中可能

# 关于PC寻址的几个问题
+ 如果代码移动了，branch指令的操作数需要改变吗？-需要，因为PC变了。
+ 如果目标地址与PC相差大于2^15怎么办？-跳两次。
+ 我们为什么要使用多种寻址指令？一个不行吗？-因为代码之间调用很灵活，所以需要多个指令提高灵活性。
+ 如果确实需要一个32位转移地址怎么办？-使用寄存器跳转，将目的地址保存在寄存器中。
+ 如果把A和B的C语言程序分别编译再合成一个执行程序，jump和branch指令变化吗？-branch指令不变，jump指令会变。A和B分别编译后可能存在A中需要调用B中函数之类的情况，此类调用程序外部代码需要使用jump指令，因此在分别编译后未进行链接重定位，所以合成一个执行程序（也就是链接后）jump指令的操作数会变；而branch指令只会跳转到程序内部，因此即使链接后也不会影响跳转位置。

# 课后题答案疑问
+ 2.9， 答非所问
+ 2.10，前面少了一步，A[1] = &A
+ 2.19，第一问，答案只左移4位（已解决，题目是4），但应该44 mod 32 = 12位；第二问，进行符号扩展（已解决，是0扩展）；
+ 2.20，可以只用五步
+ 2.26，第三题5*N + 2，slt和beq最后还要执行
+ 2.28，算出来1+15*10+2=153
+ 2.29，MemArray[i]
+ 2.35，为什么能最后不用jr $ra?
+ 2.36，我觉得一个都不知道，因为func里可能还调用了其他东西，所以这些都可能改变
+ 2.47，后两题算的和答案都不一样