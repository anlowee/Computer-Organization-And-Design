# 判断无符号数运算溢出
```
addu  $t0, $t1, $t2              # $t0 = sum
nor   $t3, $t1, $zero            # $t3 = NOT $t1(反码) = 2^32 - $t1 - 1
sltu  $t3, $t3, $t2              # 2^32 - $t1 - 1 < $t2 <=> 2^32 - 1 < $t1 + $t2
bne   $t3, $zero, Overflow
```

# 浮点数相加，小阶向大阶看齐

