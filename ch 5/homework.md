# 5.1 
In this exercise we look at memory locality properties of matrix computation. The following code is written in C, where elements within the same row are stored contiguously.  Assume each word is a 32-bit integer.
```
for (I=0; I<8; I++)  
    for (J=0; J<8000; J++)    
        A[I][J]=B[I][0]+A[J][I]; 
```

## 5.1.1 [5] <§5.1> 
How many 32-bit integers can be stored in a 16-byte cache block? 

**A:** 16 / (32 / 8) = 4

## 5.1.2 [5] <§5.1> 
References to which variables exhibit temporal locality? 

**A:** I, J. Because in each loop, I and J are both referred.

## 5.1.3 [5] <§5.1> 
References to which variables exhibit spatial locality? 

**A:** A[I][J]. Because A[I][J + 1], A[I][J + 2]... are adjacent and will be referred soon.

## 5.1.4 [10] <§5.1> 
Locality is affected by both the reference order and data layout. The same computation can also be written below in Matlab, which diff ers from C by storing matrix elements within the same column contiguously in memory.
```
for I=1:8  
    for J=1:8000    
        A(I,J)=B(I,0)+A(J,I);  
    end 
end
```
How many 16-byte cache blocks are needed to store all 32-bit matrix elements being referenced? 

**A:**
Matrix A at least has 8000*8000 size, but we only use [1..8, 1..8000] and [1..8000, 1..8] two parts of it, which like the picture bellow. So, matrix A needs 8*8000*2 - 8*8 = 127936 words.<br> 
+--+--+--+
+--+--+--+
+--+
+--+
+--+
+--+<br>
Matrix B needs 8 words.<br>
So, the total blocks we need: (127936 + 8) / 4 = 31986

## 5.1.5 [5] <§5.1> 
References to which variables exhibit temporal locality? 

**A:** I, J. Same as 5.1.2.

## 5.1.6 [5] <§5.1> 
References to which variables exhibit spatial locality?

**A:** A[J][I]. Because A[J + 1][I], A[J + 2][I]... are adjacent and will be referred soon.

# 5.2 
Caches are important to providing a high-performance memory hierarchy to processors. Below is a list of 32-bit memory address references, given as word addresses.
```
3, 180, 43, 2, 191, 88, 190, 14, 181, 44, 186, 253 
```

## 5.2.1 [10] <§5.3> 
For each of these references, identify the binary address, the tag, and the index given a direct-mapped cache with 16 one-word blocks. Also list if each reference is a hit or a miss, assuming the cache is initially empty. 

**A:**
Consider that there are 16(2^4) cache word blocks, so there is no offset,the index is represent by WordAddr[3:0], and the rest of WordAddr is the tag.<br>
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss |
| ------------ | -------------- | ------ | ----- | --- | -------- |
| 3            | 0000 0011      | NaN    | 3     | 0   | M        |
| 180          | 1011 0100      | NaN    | 4     | 11  | M        |
| 43           | 0010 1011      | NaN    | 11    | 2   | M        |
| 2            | 0000 0010      | NaN    | 2     | 0   | M        |
| 191          | 1011 1111      | NaN    | 15    | 11  | M        |
| 88           | 0101 1000      | NaN    | 8     | 5   | M        |
| 190          | 1011 1110      | NaN    | 14    | 11  | M        |
| 14           | 0000 1110      | NaN    | 14    | 0   | M        |
| 181          | 1011 0101      | NaN    | 5     | 11  | M        |
| 44           | 0010 1100      | NaN    | 12    | 2   | M        |
| 186          | 1011 1010      | NaN    | 10    | 11  | M        |
| 253          | 1111 1101      | NaN    | 13    | 15  | M        |


## 5.2.2 [10] <§5.3> 
For each of these references, identify the binary address, the tag, and the index given a direct-mapped cache with two-word blocks and a total size of 8 blocks. Also list if each reference is a hit or a miss, assuming the cache is initially empty. 

**A:**
Consider that there are 8(2^3) cache word blocks with 2(2^1) words size, so the offset is WordAddr[0], and the index is represent by WordAddr[3:1], the rest og WordAddr is the tag.<br>
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss |
| ------------ | -------------- | ------ | ----- | --- | -------- |
| 3            | 0000 001 1     | 1      | 1     | 0   | M        |
| 180          | 1011 010 0     | 0      | 2     | 11  | M        |
| 43           | 0010 101 1     | 1      | 5     | 2   | M        |
| 2            | 0000 001 0     | 0      | 1     | 0   | H        |
| 191          | 1011 111 1     | 1      | 7     | 11  | M        |
| 88           | 0101 100 0     | 0      | 4     | 5   | M        |
| 190          | 1011 111 0     | 0      | 7     | 11  | H        |
| 14           | 0000 111 0     | 0      | 7     | 0   | M        |
| 181          | 1011 010 1     | 1      | 2     | 11  | H        |
| 44           | 0010 110 0     | 0      | 6     | 2   | M        |
| 186          | 1011 101 0     | 0      | 5     | 11  | M        |
| 253          | 1111 110 1     | 1      | 6     | 15  | M        |

## 5.2.3 [20] <§§5.3, 5.4> 
You are asked to optimize a cache design for the given references. Th ere are three direct-mapped cache designs possible, all with a total of 8 words of data: C1 has 1-word blocks, C2 has 2-word blocks, and C3 has 4-word blocks. In terms of miss rate, which cache design is the best? If the miss stall time is 25 cycles, and C1 has an access time of 2 cycles, C2 takes 3 cycles, and C3 takes 5 cycles, which is the best cache design? 

**A:**
C1 has 8(2^3) cache word blocks with 1-word size, so there is no offset, WordAddr[2:0] is index, the rest of WordAddr is tag.<br>
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss |
| ------------ | -------------- | ------ | ----- | --- | -------- |
| 3            | 00000 011      | NaN    | 3     | 0   | M        |
| 180          | 10110 100      | NaN    | 4     | 22  | M        |
| 43           | 00101 011      | NaN    | 3     | 5   | M        |
| 2            | 00000 010      | NaN    | 2     | 0   | M        |
| 191          | 10111 111      | NaN    | 7     | 23  | M        |
| 88           | 01011 000      | NaN    | 0     | 11  | M        |
| 190          | 10111 110      | NaN    | 6     | 23  | M        |
| 14           | 00001 110      | NaN    | 6     | 1   | M        |
| 181          | 10110 101      | NaN    | 5     | 22  | M        |
| 44           | 00101 100      | NaN    | 4     | 5   | M        |
| 186          | 10111 010      | NaN    | 2     | 23  | M        |
| 253          | 11111 101      | NaN    | 5     | 31  | M        |
miss rate: 12 / 12 = 1<br>
cycles: 25 * 12 + 2 * 12 = 324<br>
C2 has 4(2^2) cache blocks with 2-word size, so WordAddr[0] is offset, and WordAddr[2:1] is index, the rest of WordAddr is tag.<br>
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss |
| ------------ | -------------- | ------ | ----- | --- | -------- |
| 3            | 00000 01 1     | 1      | 1     | 0   | M        |
| 180          | 10110 10 0     | 0      | 2     | 22  | M        |
| 43           | 00101 01 1     | 1      | 1     | 5   | M        |
| 2            | 00000 01 0     | 0      | 1     | 0   | M        |
| 191          | 10111 11 1     | 1      | 3     | 23  | M        |
| 88           | 01011 00 0     | 0      | 0     | 11  | M        |
| 190          | 10111 11 0     | 0      | 3     | 23  | H        |
| 14           | 00001 11 0     | 0      | 3     | 1   | M        |
| 181          | 10110 10 1     | 1      | 2     | 22  | H        |
| 44           | 00101 10 0     | 0      | 2     | 5   | M        |
| 186          | 10111 01 0     | 0      | 1     | 23  | M        |
| 253          | 11111 10 1     | 1      | 2     | 31  | M        |
miss rate: 10 / 12 = 0.8333<br>
cycles: 25 * 10 + 3 * 12 = 286<br>
C3 has 2(2^1) cache blocks with 4-word size, so WordAddr[1:0] is offset, and WordAddr[2] is index, the rest of WordAddr is tag.<br>
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss |
| ------------ | -------------- | ------ | ----- | --- | -------- |
| 3            | 00000 0 11     | 3      | 0     | 0   | M        |
| 180          | 10110 1 00     | 0      | 1     | 22  | M        |
| 43           | 00101 0 11     | 3      | 0     | 5   | M        |
| 2            | 00000 0 10     | 2      | 0     | 0   | M        |
| 191          | 10111 1 11     | 3      | 1     | 23  | M        |
| 88           | 01011 0 00     | 0      | 0     | 11  | M        |
| 190          | 10111 1 10     | 2      | 1     | 23  | H        |
| 14           | 00001 1 10     | 2      | 1     | 1   | M        |
| 181          | 10110 1 01     | 1      | 1     | 22  | M        |
| 44           | 00101 1 00     | 0      | 1     | 5   | M        |
| 186          | 10111 0 10     | 2      | 0     | 23  | M        |
| 253          | 11111 1 01     | 1      | 1     | 31  | M        |
miss rate: 11 / 12 = 0.9167<br>
cycles: 25 * 11 + 5 * 12 = 335 cycles<br>

So, C2 is the best.

## 5.2.4 [15] <§5.3> 
There are many different design parameters that are important to a cache’s overall performance. Below are listed parameters for different direct-mapped cache designs.<br>
Cache Data Size:  32 KiB<br>
Cache Block Size:  2 words<br>
Cache Access Time:  1 cycle<br> 
Calculate the total number of bits required for the cache listed above, assuming a 32-bit address. Given that total size, find the total size of the closest direct-mapped cache with 16-word blocks of equal size or greater. Explain why the second cache, despite its larger data size, might provide slower performance than the first cache. 

**A:** 
32 KiB / 4 / 2 = 4096(2^12) blocks<br>
So, the tag bits are 32 - (12 + 1(block size) + 2(byte offset)) = 17<br>
total size: 32KiB + 4096 * (17(tag) + 1(valid)) / 8B = 41KiB<br>
<br>
Assume blocks number is **x**, then (16 * 32(data size per block) + (32 - log(x) -4 - 2)(tag) + 1(valid))x / 8 >= 41984<br>
Consider that in direct-mapped cache, the block number must be the power of 2, so x >= **1024**<br>
With larger block data size, hit time and miss penalty will increase, so it might provide slower performance than the first cache. 

## 5.2.5 [20] <§§5.3, 5.4> 
Generate a series of read requests that have a lower miss rate on a 2 KiB 2-way set associative cache than the cache listed above. Identify one possible solution that would make the cache listed have an equal or lower miss rate than the 2 KiB cache. Discuss the advantages and disadvantages of such a solution. 

**A:**
Assume that the block size equal to the above one. Then the groups number is: 2 KiB / 4 / (2 * 2) = 128(2^7)<br>
So, the offset bits are 1 + 2 = 3, the index bits are 7, the tag bits are 32 - 8 - 3 = 21<br>
Consider a read requests like this:
```
Byte Address:
32768, 0, 32768, 0, 32768, 0, 32768, 0, 32768, 0, 32768, 0
```
in the cache listed above:
| Byte Address | Binary Address       | Offset | Index | Tag | Hit/Miss | Note                                |
| ------------ | -------------------- | ------ | ----- | --- | -------- | ----------------------------------- |
| 32768        | 1 0000_0000_0000 000 | 0      | 0     | 1   | M        | place mem[32768] in block-0         |
| 0            | 0 0000_0000_0000 000 | 0      | 0     | 0   | M        | miss, repalce block-0 by mem[0]     |
| 32768        | 1 0000_0000_0000 000 | 0      | 0     | 1   | M        | miss, replace block-0 by mem[32768] |
| 0            | 0 0000_0000_0000 000 | 0      | 0     | 0   | M        | miss, repalce block-0 by mem[0]     |
| 32768        | 1 0000_0000_0000 000 | 0      | 0     | 1   | M        | miss, replace block-0 by mem[32768] |
| 0            | 0 0000_0000_0000 000 | 0      | 0     | 0   | M        | miss, repalce block-0 by mem[0]     |
| 32768        | 1 0000_0000_0000 000 | 0      | 0     | 1   | M        | miss, replace block-0 by mem[32768] |
| 0            | 0 0000_0000_0000 000 | 0      | 0     | 0   | M        | miss, repalce block-0 by mem[0]     |
| 32768        | 1 0000_0000_0000 000 | 0      | 0     | 1   | M        | miss, replace block-0 by mem[32768] |
| 0            | 0 0000_0000_0000 000 | 0      | 0     | 0   | M        | miss, repalce block-0 by mem[0]     |
| 32768        | 1 0000_0000_0000 000 | 0      | 0     | 1   | M        | miss, replace block-0 by mem[32768] |
| 0            | 0 0000_0000_0000 000 | 0      | 0     | 0   | M        | miss, repalce block-0 by mem[0]     |
the miss ratio is 12 / 12 = 1<br>
in the 2-way set associative cache:
| Byte Address | Binary Address      | Offset | Index | Tag | Hit/Miss | Note                                   |
| ------------ | ------------------- | ------ | ----- | --- | -------- | -------------------------------------- |
| 32768        | 100000 000_0000 000 | 0      | 0     | 32  | M        | place mem[32768] in <group-0, block-0> |
| 0            | 000000 000_0000 000 | 0      | 0     | 0   | M        | place mem[0] in <group-0, block-1>     |
| 32768        | 100000 000_0000 000 | 0      | 0     | 32  | H        | hit <group-0, block-0>                 |
| 0            | 000000 000_0000 000 | 0      | 0     | 0   | H        | hit <group-0, block-1>                 |
| 32768        | 100000 000_0000 000 | 0      | 0     | 32  | H        | hit <group-0, block-0>                 |
| 0            | 000000 000_0000 000 | 0      | 0     | 0   | H        | hit <group-0, block-1>                 |
| 32768        | 100000 000_0000 000 | 0      | 0     | 32  | H        | hit <group-0, block-0>                 |
| 0            | 000000 000_0000 000 | 0      | 0     | 0   | H        | hit <group-0, block-1>                 |
| 32768        | 100000 000_0000 000 | 0      | 0     | 32  | H        | hit <group-0, block-0>                 |
| 0            | 000000 000_0000 000 | 0      | 0     | 0   | H        | hit <group-0, block-1>                 |
| 32768        | 100000 000_0000 000 | 0      | 0     | 32  | H        | hit <group-0, block-0>                 |
| 0            | 000000 000_0000 000 | 0      | 0     | 0   | H        | hit <group-0, block-1>                 |
the miss ratio is 2 / 12 = 0.1667<br>
We can extend the direct-mapped cache to the fully associative cache, thus, in the situation above, 32768 and 0 will be both storred without confliction. But fully associative cache need much more hit time than 2-way associative cache, which may cause worse performance.

## 5.2.6 [15] <§5.3> 
The formula shown in Section 5.3 shows the typical method to index a direct-mapped cache, specifically (Block address) modulo (Number of blocks in the cache). Assuming a 32-bit address and 1024 blocks in the cache, consider a different indexing function, specifically (Block address[31:27] XOR Block address[26:22]). Is it possible to use this to index a direct-mapped cache? If so, explain why and discuss any changes that might need to be made to the cache. If it is not possible, explain why.

**A:** The index bits should be 10(2^10), but XOR operation make the index bits only 5. Due to that, there are 2^10 - 2^5 = 992 blocks are wasted and tag bits is 25 now, 5 more than before.(tag bits was 32 - 10 - 2 = 20)

# 5.3 
For a direct-mapped cache design with a 32-bit address, the following bits of the address are used to access the cache.
| Tag   | Index | Offset |
| ----- | ----- | ------ |
| 31–10 | 9–5   | 4–0    |

## 5.3.1 [5] <§5.3> 
What is the cache block size (in words)? 

**A:** 2^(4 - 0 + 1 - 2) = 8 words

## 5.3.2 [5] <§5.3> 
How many entries does the cache have? 

**A:** 2^(9 - 5 + 1) = 32 blocks

## 5.3.3 [5] <§5.3> 
What is the ratio between total bits required for such a cache implementation over the data storage bits? Starting from power on, the following byte-addressed cache references are recorded.

**A:**
total bits: 32(blocks) * ((8 * 32)(block size) + (31 - 10 + 1)(tag) + 1(valid)) = 8928<br>
data storage bits: 32(blocks) * (8 * 32)(block size) = 8192<br>
ratio: 8928 / 8192 = 1.09

## 5.3.4 [10] <§5.3> 
Address：
```
0 4 16 132 232 160 1024 30 140 3100 180 2180
```
How many blocks are replaced? 

**A:**
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss | Note               |
| ------------ | -------------- | ------ | ----- | --- | -------- | ------------------ |
| 0            | 00 00000 00000 | 0      | 0     | 0   | M        |                    |
| 4            | 00 00000 00100 | 4      | 0     | 0   | H        |                    |
| 16           | 00 00000 10000 | 16     | 0     | 0   | H        |                    |
| 132          | 00 00100 00100 | 4      | 4     | 0   | M        |                    |
| 232          | 00 00111 01000 | 8      | 7     | 0   | M        |                    |
| 160          | 00 00101 00000 | 0      | 5     | 0   | M        |                    |
| 1024         | 01 00000 00000 | 0      | 0     | 1   | M        | # 0-block replaced |
| 30           | 00 00000 11110 | 30     | 0     | 0   | M        | # 0-block replaced |
| 140          | 00 00100 01100 | 12     | 4     | 0   | H        |                    |
| 3100         | 11 00000 11100 | 28     | 0     | 3   | M        | # 0-block replaced |
| 180          | 00 00101 10100 | 20     | 5     | 0   | H        |                    |
| 2180         | 10 00100 00100 | 4      | 4     | 2   | M        | # 4-block replaced |

## 5.3.5 [10] <§5.3> 
What is the hit ratio? 

**A:** 4 / 12 = 0.3333

## 5.3.6 [20] <§5.3> 
List the final state of the cache, with each valid entry represented as a record of <index, tag, data>.

**A:**
| Index | Tag | Data           |
| ----- | --- | -------------- |
| 0     | 3   | mem[3103:3072] |
| 4     | 2   | mem[2211:2180] |
| 5     | 0   | mem[191:160]   |
| 7     | 0   | mem[263:232]   |

# 5.7 
This exercise examines the impact of different cache designs, specifically comparing associative caches to the direct-mapped caches from Section 5.4. For these exercises, refer to the address stream shown in Exercise 5.2. 
```
3, 180, 43, 2, 191, 88, 190, 14, 181, 44, 186, 253 
```

## 5.7.1 [10] <§5.4> 
Using the sequence of references from Exercise 5.2, show the final cache contents for a three-way set associative cache with two-word blocks and a total size of 24 words. Use LRU replacement. For each reference identify the index bits, the tag bits, the block offset bits, and if it is a hit or a miss. 

**A:**
Due to the given word address, there is no byte offset, so the offset bits is 1<br>
The groups number is 24 / 2 / 3 = 4(2^2)， so the index bits is 2<br>
The rest of address is tag.<br>
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss |
| ------------ | -------------- | ------ | ----- | --- | -------- |
| 3            | 00000 01 1     | 1      | 1     | 0   | M        |
| 180          | 10110 10 0     | 0      | 2     | 22  | M        |
| 43           | 00101 01 1     | 1      | 1     | 5   | M        |
| 2            | 00000 01 0     | 0      | 1     | 0   | H        |
| 191          | 10111 11 1     | 1      | 3     | 23  | M        |
| 88           | 01011 00 0     | 0      | 0     | 11  | M        |
| 190          | 10111 11 0     | 0      | 3     | 23  | H        |
| 14           | 00001 11 0     | 0      | 3     | 1   | M        |
| 181          | 10110 10 1     | 1      | 2     | 22  | H        |
| 44           | 00101 10 0     | 0      | 2     | 5   | M        |
| 186          | 10111 01 0     | 0      | 1     | 23  | M        |
| 253          | 11111 10 1     | 1      | 2     | 31  | M        |
The final content:(word address)
| Index | Tag | Data     |
| ----- | --- | -------- |
| 0     | 11  | mem[88]  |
| 1     | 0   | mem[2]   |
| 1     | 5   | mem[42]  |
| 1     | 23  | mem[186] |
| 2     | 22  | mem[180] |
| 2     | 5   | mem[44]  |
| 2     | 31  | mem[252] |
| 3     | 23  | mem[190] |
| 3     | 1   | mem[14]  |

## 5.7.2 [10] <§5.4> 
Using the references from Exercise 5.2, show the final cache contents for a fully associative cache with one-word blocks and a total size of 8 words. Use LRU replacement. For each reference identify the index bits, the tag bits, and if it is a hit or a miss.

**A:**
The offset bits is 0(2^0).<br>
With fully associative cache, the index bits is 0(2^0), and totally 8 ways.<br>
So all address is tag.<br>
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss | Content(the rightest, the last)         |
| ------------ | -------------- | ------ | ----- | --- | -------- | --------------------------------------- |
| 3            | 0000_0011      | NaN    | NaN   | 3   | M        | **3**                                   |
| 180          | 1011_0100      | NaN    | NaN   | 180 | M        | 3,**180**                               |
| 43           | 0010_1011      | NaN    | NaN   | 43  | M        | 3,180,**43**                            |
| 2            | 0000_0010      | NaN    | NaN   | 2   | M        | 3,180,43,**2**                          |
| 191          | 1011_1111      | NaN    | NaN   | 191 | M        | 3,180,43,2,**191**                      |
| 88           | 0101_1000      | NaN    | NaN   | 88  | M        | 3,180,43,2,191,**88**                   |
| 190          | 1011_1110      | NaN    | NaN   | 190 | M        | 3,180,43,2,191,88,**190**               |
| 14           | 0000_1110      | NaN    | NaN   | 14  | M        | 3,180,43,2,191,88,190,**14**            |
| 181          | 1011_0101      | NaN    | NaN   | 181 | M        | ~~3,~~ 180,43,2,191,88,190,14,**181**   |
| 44           | 0010_1100      | NaN    | NaN   | 44  | M        | ~~180,~~ 43,2,191,88,190,14,181,**44**  |
| 186          | 1011_1010      | NaN    | NaN   | 186 | M        | ~~43,~~ 2,191,88,190,14,181,44,**186**  |
| 253          | 1111_1101      | NaN    | NaN   | 253 | M        | ~~2,~~ 191,88,190,14,181,44,186,**253** |
With LRU, the final content is the last 8 data, the final content:(word address)
| Index | Tag | Data     |
| ----- | --- | -------- |
| NaN   | 191 | mem[191] |
| NaN   | 88  | mem[88]  |
| NaN   | 190 | mem[190] |
| NaN   | 14  | mem[14]  |
| NaN   | 181 | mem[181] |
| NaN   | 44  | mem[44]  |
| NaN   | 186 | mem[186] |
| NaN   | 253 | mem[253] |

## 5.7.3 [15] <§5.4> 
Using the references from Exercise 5.2, what is the miss rate for a fully associative cache with two-word blocks and a total size of 8 words, using LRU replacement? What is the miss rate using MRU (most recently used) replacement? Finally what is the best possible miss rate for this cache, given any replacement policy? 

**A:**
LRU:<br>
Fully associative cache with two-word blocks and a total size of 8 words:<br>
The offset bits is 1(2^1).<br>
The index bits is 0(2^0), and totally 4 ways.<br>
The rest of address is tag.
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss | Content(the rightest, the last) |
| ------------ | -------------- | ------ | ----- | --- | -------- | ------------------------------- |
| 3            | 0000_001 1     | 1      | NaN   | 1   | M        | **1**                           |
| 180          | 1011_010 0     | 0      | NaN   | 90  | M        | 1,**90**                        |
| 43           | 0010_101 1     | 1      | NaN   | 21  | M        | 1,90,**21**                     |
| 2            | 0000_001 0     | 0      | NaN   | 1   | H        | 90,21,**1**                     |
| 191          | 1011_111 1     | 1      | NaN   | 95  | M        | 90,21,1,**95**                  |
| 88           | 0101_100 0     | 0      | NaN   | 44  | M        | ~~90,~~ 21,1,95,**44**          |
| 190          | 1011_111 0     | 0      | NaN   | 95  | H        | 21,1,44,**95**                  |
| 14           | 0000_111 0     | 0      | NaN   | 7   | M        | ~~21,~~ 1,44,95,**7**           |
| 181          | 1011_010 1     | 1      | NaN   | 90  | M        | ~~1,~~ 44,95,7,**90**           |
| 44           | 0010_110 0     | 0      | NaN   | 22  | M        | ~~44,~~ 95,7,90,**22**          |
| 186          | 1011_101 0     | 0      | NaN   | 93  | M        | ~~95,~~ 7,90,22,**93**          |
| 253          | 1111_110 1     | 1      | NaN   | 126 | M        | ~~7,~~ 90,22,93,**126**         |
The miss rate is 10 / 12 = 0.8333<br>
MRU:<br>
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss | Content(the rightest, the last) |
| ------------ | -------------- | ------ | ----- | --- | -------- | ------------------------------- |
| 3            | 0000_001 1     | 1      | NaN   | 1   | M        | **1**                           |
| 180          | 1011_010 0     | 0      | NaN   | 90  | M        | 1,**90**                        |
| 43           | 0010_101 1     | 1      | NaN   | 21  | M        | 1,90,**21**                     |
| 2            | 0000_001 0     | 0      | NaN   | 1   | H        | 90,21,**1**                     |
| 191          | 1011_111 1     | 1      | NaN   | 95  | M        | 90,21,1,**95**                  |
| 88           | 0101_100 0     | 0      | NaN   | 44  | M        | 90,21,1,~~95,~~**44**           |
| 190          | 1011_111 0     | 0      | NaN   | 95  | M        | 90,21,1,~~44,~~**95**           |
| 14           | 0000_111 0     | 0      | NaN   | 7   | M        | 90,21,1,~~95,~~**7**            |
| 181          | 1011_010 1     | 1      | NaN   | 90  | H        | 21,1,7,**90**                   |
| 44           | 0010_110 0     | 0      | NaN   | 22  | M        | 21,1,7,~~90,~~**22**            |
| 186          | 1011_101 0     | 0      | NaN   | 93  | M        | 21,1,7,~~22,~~**93**            |
| 253          | 1111_110 1     | 1      | NaN   | 126 | M        | 21,1,7,~~93,~~**126**           |
The miss rate is 10 / 12 = 0.8333<br>
We can take MRH(Most Recently Hit) and MRU strategy both, then:
| Word Address | Binary Address | Offset | Index | Tag | Hit/Miss | Content(the rightest, the last) |
| ------------ | -------------- | ------ | ----- | --- | -------- | ------------------------------- |
| 3            | 0000_001 1     | 1      | NaN   | 1   | M        | **1**                           |
| 180          | 1011_010 0     | 0      | NaN   | 90  | M        | 1,**90**                        |
| 43           | 0010_101 1     | 1      | NaN   | 21  | M        | 1,90,**21**                     |
| 2            | 0000_001 0     | 0      | NaN   | 1   | H        | 90,21,**1**                     |
| 191          | 1011_111 1     | 1      | NaN   | 95  | M        | 90,21,1,**95**                  |
| 88           | 0101_100 0     | 0      | NaN   | 44  | M        | 90,21,~~1,~~ 95,**44**          |
| 190          | 1011_111 0     | 0      | NaN   | 95  | H        | 90,21,44,**95**                 |
| 14           | 0000_111 0     | 0      | NaN   | 7   | M        | 90,21,44,~~95,~~**7**           |
| 181          | 1011_010 1     | 1      | NaN   | 90  | H        | 21,44,7,**90**                  |
| 44           | 0010_110 0     | 0      | NaN   | 22  | M        | 21,44,7,~~90,~~**22**           |
| 186          | 1011_101 0     | 0      | NaN   | 93  | M        | 21,44,7,~~22,~~**93**           |
| 253          | 1111_110 1     | 1      | NaN   | 126 | M        | 21,44,7,~~93,~~**126**          |
The hit ratio is 3 / 12 = 0.25, and there are only 3 pairs of tags which are correspondent, so it is the best hit ratio.

## 5.7.4 [10] <§5.4> 
Multilevel caching is an important technique to overcome the limited amount of space that a fi rst level cache can provide while still maintaining its speed. Consider a processor with the following parameters:
| Base CPI, No Memory Stalls | Processor Speed | Main Memory Access Time | First Level Cache MissRate per Instruction | Second Level Cache, Direct-Mapped Speed | Global Miss Rate with Second Level Cache, Direct-Mapped | Second Level Cache, Eight-Way Set Associative Speed | Global Miss Rate with Second Level Cache, Eight-Way Set Associative |
| -------------------------- | --------------- | ----------------------- | ------------------------------------------ | --------------------------------------- | ------------------------------------------------------- | --------------------------------------------------- | ------------------------------------------------------------------- |
| 1.5                        | 2 GHz           | 100 ns                  | 7%                                         | 12 cycles                               | 3.5%                                                    | 28 cycles                                           | 1.5%                                                                |
Calculate the CPI for the processor in the table using: 1) only a first level cache, 2) a second level direct-mapped cache, and 3) a second level eight-way set associative cache. How do these numbers change if main memory access time is doubled? If it is cut in half? 

**A:**
The origin memory access time is: 100 ns / (1 / 2 GHz) = 200 cycles, so:
| Memory Access Time | Lv1 Cache             | Lv2 Dirrect-Mapped Cache           | Lv2 8-way Set Associative Cache   |
| ------------------ | --------------------- | ---------------------------------- | --------------------------------- |
| origin             | 1.5 + 7% * 200 = 15.5 | 1.5 + 7% * 12 + 3.5% * 200 = 9.34  | 1.5 + 7% * 28 + 1.5% * 200 = 6.46 |
| doubled            | 1.5 + 7% * 400 = 29.5 | 1.5 + 7% * 12 + 3.5% * 400 = 16.34 | 1.5 + 7% * 28 + 1.5% * 400 = 9.46 |
| half               | 1.5 + 7% * 100 = 8.5  | 1.5 + 7% * 12 + 3.5% * 100 = 5.84  | 1.5 + 7% * 28 + 1.5% * 100 = 4.96 |

# 5.11 
As described in Section 5.7, virtual memory uses a page table to track the mapping of virtual addresses to physical addresses. Th is exercise shows how this table must be updated as addresses are accessed. Th e following data constitutes a stream of virtual addresses as seen on a system. Assume 4 KiB pages, a 4-entry fully associative TLB, and true LRU replacement. If pages must be brought in from disk, increment the next largest page number.
```
4669, 2227, 13916, 34587, 48870, 12608, 49225 
```
TLB:
| Valid | Tag | Physical Page Number |
| ----- | --- | -------------------- |
| 1     | 11  | 12                   |
| 1     | 7   | 4                    |
| 1     | 3   | 6                    |
| 0     | 4   | 9                    |
Page table:
| Valid | Physical Page or in Disk |
| ----- | ------------------------ |
| 1     | 5                        |
| 0     | Disk                     |
| 0     | Disk                     |
| 1     | 6                        |
| 1     | 9                        |
| 1     | 11                       |
| 0     | Disk                     |
| 1     | 4                        |
| 0     | Disk                     |
| 0     | Disk                     |
| 1     | 3                        |
| 1     | 12                       |

## 5.11.1 [10] <§5.7> 
Given the address stream shown, and the initial TLB and page table states provided above, show the fi nal state of the system. Also list for each reference if it is a hit in the TLB, a hit in the page table, or a page fault. 

**A:**
| Address | Virtual Page | TLB H/M            | Valid             | Tag | Physical Page |
| ------- | ------------ | ------------------ | ----------------- | --- | ------------- |
| 4669    | 1            | TLB miss PT hit PF | 1                 | 11  | 12            |
|         |              |                    | 1                 | 7   | 4             |
|         |              |                    | 1                 | 3   | 6             |
|         |              |                    | 1 (last access 0) | 1   | 13            |
| 2227    | 0            | TLB miss PT hit    | 1 (last access 1) | 0   | 5             |
|         |              |                    | 1                 | 7   | 4             |
|         |              |                    | 1                 | 3   | 6             |
|         |              |                    | 1 (last access 0) | 1   | 13            |
| 13916   | 3            | TLB hit            | 1 (last access 1) | 0   | 5             |
|         |              |                    | 1                 | 7   | 4             |
|         |              |                    | 1 (last access 2) | 3   | 6             |
|         |              |                    | 1 (last access 0) | 1   | 13            |
| 34587   | 8            | TLB miss PT hit PF | 1 (last access 1) | 0   | 5             |
|         |              |                    | 1 (last access 3) | 8   | 14            |
|         |              |                    | 1 (last access 2) | 3   | 6             |
|         |              |                    | 1 (last access 0) | 1   | 13            |
| 48870   | 11           | TLB miss PT hit    | 1 (last access 1) | 0   | 5             |
|         |              |                    | 1 (last access 3) | 8   | 14            |
|         |              |                    | 1 (last access 2) | 3   | 6             |
|         |              |                    | 1 (last access 4) | 11  | 12            |
| 12608   | 3            | TLB hit            | 1 (last access 1) | 0   | 5             |
|         |              |                    | 1 (last access 3) | 8   | 14            |
|         |              |                    | 1 (last access 5) | 3   | 6             |
|         |              |                    | 1 (last access 4) | 11  | 12            |
| 49225   | 12           | TLB miss PT miss   | 1 (last access 6) | 12  | 15            |
|         |              |                    | 1 (last access 3) | 8   | 14            |
|         |              |                    | 1 (last access 5) | 3   | 6             |
|         |              |                    | 1 (last access 4) | 11  | 12            |

## 5.11.2 [15] <§5.7> 
Repeat 5.11.1, but this time use 16 KiB pages instead of 4 KiB pages. What would be some of the advantages of having a larger page size? What are some of the disadvantages? 

**A:**
| Address | Virtual Page | TLB H/M             | Valid                 | Tag    | Physical Page |
| ------- | ------------ | ------------------- | --------------------- | ------ | ------------- |
| 4669    | **0**        | **TLB miss PT hit** | 1                     | 11     | 12            |
|         |              |                     | 1                     | 7      | 4             |
|         |              |                     | 1                     | 3      | 6             |
|         |              |                     | 1 (last access 0)     | **0**  | **5**         |
| 2227    | 0            | **TLB hit**         | **1**                 | **11** | **12**        |
|         |              |                     | 1                     | 7      | 4             |
|         |              |                     | 1                     | 3      | 6             |
|         |              |                     | **1 (last access 1)** | **0**  | **5**         |
| 13916   | **0**        | TLB hit             | **1**                 | **11** | **12**        |
|         |              |                     | 1                     | 7      | 4             |
|         |              |                     | **1**                 | 3      | 6             |
|         |              |                     | **1 (last access 2)** | **0**  | **5**         |
| 34587   | **2**        | TLB miss PT hit PF  | **1 (last access 3)** | **2**  | **13**        |
|         |              |                     | **1**                 | **7**  | **4**         |
|         |              |                     | **1**                 | 3      | 6             |
|         |              |                     | **1 (last access 2)** | **0**  | **5**         |
| 48870   | **2**        | **TLB hit**         | **1 (last access 4)** | **2**  | **13**        |
|         |              |                     | **1**                 | **7**  | **4**         |
|         |              |                     | **1**                 | 3      | 6             |
|         |              |                     | **1 (last access 2)** | **0**  | **5**         |
| 12608   | **0**        | TLB hit             | 1 (last access **4**) | **2**  | **13**        |
|         |              |                     | **1**                 | **7**  | **4**         |
|         |              |                     | **1**                 | 3      | 6             |
|         |              |                     | **1 (last access 5)** | **0**  | **5**         |
| 49225   | **3**        | **TLB hit**         | **1 (last access 4)** | **2**  | **13**        |
|         |              |                     | **1**                 | **7**  | **4**         |
|         |              |                     | **1 (last access 6)** | 3      | 6             |
|         |              |                     | **1 (last access 5)** | **0**  | **5**         |

## 5.11.3 [15] <§§5.4, 5.7> 
Show the final contents of the TLB if it is 2-way set associative. Also show the contents of the TLB if it is direct mapped. Discuss the importance of having a TLB to high performance. How would virtual memory accesses be handled if there were no TLB? 

**A:**
When in the 2-way set associative:
| Address | Virtual Page | Tag | Index | TLB H/M             | Valid                 | Tag   | Physical Page | Index |
| ------- | ------------ | --- | ----- | ------------------- | --------------------- | ----- | ------------- | ----- |
| 4669    | 1            | 0   | 1     | TLB miss PT hit PF  | 1                     | 11    | 12            | 0     |
|         |              |     |       |                     | 1                     | 7     | 4             | 1     |
|         |              |     |       |                     | 1                     | 3     | 6             | 0     |
|         |              |     |       |                     | 1 (last access 0)     | **0** | 13            | 1     |
| 2227    | 0            | 0   | 0     | TLB miss PT hit     | 1 (last access 1)     | 0     | 5             | 0     |
|         |              |     |       |                     | 1                     | 7     | 4             | 1     |
|         |              |     |       |                     | 1                     | 3     | 6             | 0     |
|         |              |     |       |                     | 1 (last access 0)     | **0** | 13            | 1     |
| 13916   | 3            | 1   | 1     | **TLB miss PT hit** | 1 (last access 1)     | 0     | 5             | 0     |
|         |              |     |       |                     | **1 (last access 2)** | **1** | **6**         | 1     |
|         |              |     |       |                     | **1**                 | 3     | 6             | 0     |
|         |              |     |       |                     | 1 (last access 0)     | 1     | 13            | 1     |
| 34587   | 8            | 4   | 0     | TLB miss PT hit PF  | 1 (last access 1)     | 0     | 5             | 0     |
|         |              |     |       |                     | **1 (last access 2)** | **1** | **6**         | 1     |
|         |              |     |       |                     | **1 (last access 3)** | **4** | **14**        | 0     |
|         |              |     |       |                     | 1 (last access 0)     | 1     | 13            | 1     |
| 48870   | 11           | 5   | 1     | TLB miss PT hit     | 1 (last access 1)     | 0     | 5             | 0     |
|         |              |     |       |                     | **1 (last access 2)** | **1** | **6**         | 1     |
|         |              |     |       |                     | **1 (last access 3)** | **4** | **14**        | 0     |
|         |              |     |       |                     | 1 (last access 4)     | **5** | 12            | 1     |
| 12608   | 3            | 1   | 1     | TLB hit             | 1 (last access 1)     | 0     | 5             | 0     |
|         |              |     |       |                     | **1 (last access 5)** | **1** | **6**         | 1     |
|         |              |     |       |                     | **1 (last access 3)** | **4** | **14**        | 0     |
|         |              |     |       |                     | 1 (last access 4)     | **5** | 12            | 1     |
| 49225   | 12           | 0   | 0     | TLB miss PT miss    | 1 (last access 6)     | **6** | 15            | 0     |
|         |              |     |       |                     | **1 (last access 5)** | **1** | **6**         | 1     |
|         |              |     |       |                     | **1 (last access 3)** | **4** | **14**        | 0     |
|         |              |     |       |                     | 1 (last access 4)     | **5** | 12            | 1     |
When in dirrect mapped:
| Address | Virtual Page | Tag   | Index | TLB H/M             | Valid | Tag   | Physical Page | Index |
| ------- | ------------ | ----- | ----- | ------------------- | ----- | ----- | ------------- | ----- |
| 4669    | 1            | 0     | 1     | TLB miss PT hit PF  | 1     | 11    | 12            | 0     |
|         |              |       |       |                     | 1     | **0** | **13**        | 1     |
|         |              |       |       |                     | 1     | 3     | 6             | 2     |
|         |              |       |       |                     | **0** | **4** | **9**         | 3     |
| 2227    | 0            | 0     | 0     | TLB miss PT hit     | 1     | 0     | 5             | 0     |
|         |              |       |       |                     | 1     | **0** | **13**        | 1     |
|         |              |       |       |                     | 1     | 3     | 6             | 2     |
|         |              |       |       |                     | **0** | **4** | **9**         | 3     |
| 13916   | 3            | **0** | **3** | **TLB miss PT hit** | 1     | 0     | 5             | 0     |
|         |              |       |       |                     | 1     | **0** | **13**        | 1     |
|         |              |       |       |                     | 1     | 3     | 6             | 2     |
|         |              |       |       |                     | 1     | **0** | **6**         | 3     |
| 34587   | 8            | **2** | 0     | TLB miss PT hit PF  | 1     | **2** | **14**        | 0     |
|         |              |       |       |                     | 1     | 0     | 13            | 1     |
|         |              |       |       |                     | 1     | **3** | **6**         | 2     |
|         |              |       |       |                     | 1     | **0** | **6**         | 3     |
| 48870   | 11           | **2** | **3** | TLB miss PT hit     | 1     | **2** | **14**        | 0     |
|         |              |       |       |                     | 1     | **0** | **13**        | 1     |
|         |              |       |       |                     | 1     | **3** | **6**         | 2     |
|         |              |       |       |                     | 1     | **2** | **12**        | 3     |
| 12608   | 3            | **0** | **3** | **TLB miss PT hit** | 1     | **2** | **14**        | 0     |
|         |              |       |       |                     | 1     | **0** | **13**        | 1     |
|         |              |       |       |                     | 1     | **3** | **6**         | 2     |
|         |              |       |       |                     | 1     | **0** | **6**         | 3     |
| 49225   | 12           | **3** | 0     | TLB miss PT miss    | 1     | **3** | 15            | 0     |
|         |              |       |       |                     | 1     | **0** | **13**        | 1     |
|         |              |       |       |                     | 1     | **3** | **6**         | 2     |
|         |              |       |       |                     | 1     | **0** | **6**         | 3     |

## 5.11.4 [5] <§5.7> 
There are several parameters that impact the overall size of the page table. Listed below are key page table parameters.
| Virtual Address Size | Page Size | Page Table Entry Size |
| -------------------- | --------- | --------------------- |
| 32 bits              | 8 KiB     | 4 bytes               |
Given the parameters shown above, calculate the total page table size for a system running 5 applications that utilize half of the memory available. 

**A:** Due to that the system only utilize half of the memory available, and 8 KiB = 8192(2^13) B, so the tag bits is 32 - 13 = 19. And consider that each application has a page table, so there are 5*(2^(19 - 1 + 2)) = 5 MB

## 5.11.5 [10] <§5.7> 
Given the parameters shown above, calculate the total page table size for a system running 5 applications that utilize half of the memory available, given a two level page table approach with 256 entries. Assume each entry of the main page table is 6 bytes. Calculate the minimum and maximum amount of memory required. 

**A:** Considering that in the two level page table approach, the 2^19 page table entries are divided into 256 segments are allocated on demand. Each of the second-level tables contain 2^(19 - 8) = 2048 entries, requiring 2048 * 4 = 8 KiB each and covering 2048 * 8 KiB * 16 MB of the virtual address space.
Assume that half memory refers to 2 ^ 31 bytes, the minimum amount of memory required for the secondary table is 5 * (2^(31 - 24)) * 8 KiB = 5 MB. The first-level tables would require an additional 5 * 128 * 6 B = 3840 B. The maximum number will be 256 segments per application if all segments are activated. This would require 5 * 256 * 8 KiB = 10 MB for the second-level tables and 7680 bytes for the first-level tables.

## 5.11.6 [10] <§5.7> 
A cache designer wants to increase the size of a 4 KiB virtually indexed, physically tagged cache. Given the page size shown above, is it possible to make a 16 KiB direct-mapped cache, assuming 2 words per block? How would the designer increase the data size of the cache?

**A:** It needs to make the cache 2-way associative to increase its size to 16 KB.

# 5.12 
In this exercise, we will examine space/time optimizations for page tables. Th e following list provides parameters of a virtual memory system.
| Virtual Address (bits) | Physical DRAM Installed | Page Size | PTE Size (byte) |
| ---------------------- | ----------------------- | --------- | --------------- |
| 43                     | 16 GiB                  | 4 KiB     | 4               |

## 5.12.1 [10] <§5.7> 
For a single-level page table, how many page table entries (PTEs) are needed? How much physical memory is needed for storing the page table? 

**A:** 2^(43 - 12(Page Size) + 2(PTE Size)) = 8(2^33) GB

## 5.12.2 [10] <§5.7> 
Using a multilevel page table can reduce the physical memory consumption of page tables, by only keeping active PTEs in physical memory. How many levels of page tables will be needed in this case? And how many memory references are needed for address translation if missing in TLB? 

**A:** In this case, there are only 2 levels in need. When in a multilevel page table, if TLB get missing, it will access each level table to get the PTE. So in this case, it needs 2 times.

## 5.12.3 [15] <§5.7> 
An inverted page table can be used to further optimize space and time. How many PTEs are needed to store the page table? Assuming a hash table implementation, what are the common case and worst case numbers of memory references needed for servicing a TLB miss? 

**A:** PTE = Hash-table-size + Collison-cost. When a TLB miss, in the common case, it only compare to the tag in hash table once, in the worst case, it needs to compare all items with the same tags in hash table.

## 5.12.4 [5] <§5.7> 
The following table shows the contents of a 4-entry TLB.
| Entry-ID | Valid | VA Page | Modiﬁed | Protection | PA Page |
| -------- | ----- | ------- | ------- | ---------- | ------- |
| 1        | 1     | 140     | 1       | RW         | 30      |
| 2        | 0     | 40      | 0       | RX         | 34      |
| 3        | 1     | 200     | 1       | RO         | 32      |
| 4        | 1     | 280     | 0       | RW         | 31      |
Under what scenarios would entry 2’s valid bit be set to zero? 

**A:** When the page is in the disk.

## 5.12.5 [5] <§5.7> 
What happens when an instruction writes to VA page 30? When would a soft ware managed TLB be faster than a hardware managed TLB? 

**A:** It will occur a TLB miss. Consider that get the TLB entries cost a lot of time, so when the software can prefetch TLB entries, the TLB managed by the software is faster.

## 5.12.6 [5] <§5.7> 
What happens when an instruction writes to VA page 200?

**A:** It will failed, because the target page is read-only that means it cannot be written.

# 5.13 
In this exercise, we will examine how replacement policies impact miss rate. Assume a 2-way set associative cache with 4 blocks. To solve the problems in this exercise, you may fi nd it helpful to draw a table like the one below, as demonstrated for the address sequence “0, 1, 2, 3, 4.”

| Address of Memory Block Accessed | Hit or Miss | Evicted Block | Set 0  | Set 0  | Set 1  | Set 1  |
| -------------------------------- | ----------- | ------------- | ------ | ------ | ------ | ------ |
| 0                                | Miss        |               | Mem[0] |        |        |        |
| 1                                | Miss        |               | Mem[0] |        | Mem[1] |        |
| 2                                | Miss        |               | Mem[0] | Mem[2] | Mem[1] |        |
| 3                                | Miss        |               | Mem[0] | Mem[2] | Mem[1] | Mem[3] |
| 4                                | Miss        | 0             | Mem[4] | Mem[2] | Mem[1] | Mem[3] |
| …                                |             |               |        |        |        |        |
Consider the following address sequence:  0, 2, 4, 8, 10, 12, 14, 16, 0 

## 5.13.1 [5] <§§5.4, 5.8> 
Assuming an LRU replacement policy, how many hits does this address sequence exhibit? 

**A:** 
| Address of Memory Block Accessed | Hit or Miss | Evicted Block | Set 0   | Set 0   | Set 1 | Set 1 |
| -------------------------------- | ----------- | ------------- | ------- | ------- | ----- | ----- |
| 0                                | Miss        |               | Mem[0]  |         |       |       |
| 2                                | Miss        |               | Mem[0]  | Mem[2]  |       |       |
| 4                                | Miss        | 0             | Mem[4]  | Mem[2]  |       |       |
| 8                                | Miss        | 1             | Mem[4]  | Mem[8]  |       |       |
| 10                               | Miss        | 0             | Mem[10] | Mem[8]  |       |       |
| 12                               | Miss        | 1             | Mem[10] | Mem[12] |       |       |
| 14                               | Miss        | 0             | Mem[14] | Mem[12] |       |       |
| 16                               | Miss        | 1             | Mem[14] | Mem[16] |       |       |
| 0                                | Miss        | 0             | Mem[0]  | Mem[16] |       |       |
Thus, 0 hit.

## 5.13.2 [5] <§§5.4, 5.8> 
Assuming an MRU (most recently used) replacement policy, how many hits does this address sequence exhibit? 

**A:** 
| Address of Memory Block Accessed | Hit or Miss | Evicted Block | Set 0  | Set 0   | Set 1 | Set 1 |
| -------------------------------- | ----------- | ------------- | ------ | ------- | ----- | ----- |
| 0                                | Miss        |               | Mem[0] |         |       |       |
| 2                                | Miss        |               | Mem[0] | Mem[2]  |       |       |
| 4                                | Miss        | 1             | Mem[0] | Mem[4]  |       |       |
| 8                                | Miss        | 1             | Mem[0] | Mem[8]  |       |       |
| 10                               | Miss        | 1             | Mem[0] | Mem[10] |       |       |
| 12                               | Miss        | 1             | Mem[0] | Mem[12] |       |       |
| 14                               | Miss        | 1             | Mem[0] | Mem[14] |       |       |
| 16                               | Miss        | 1             | Mem[0] | Mem[16] |       |       |
| 0                                | Hit         |               | Mem[0] | Mem[16] |       |       |
Thus, 1 hit.

## 5.13.3 [5] <§§5.4, 5.8> 
Simulate a random replacement policy by fl ipping a coin. For example, “heads” means to evict the fi rst block in a set and “tails” means to evict the second block in a set. How many hits does this address sequence exhibit? 

**A:** Only address 0 occure twice, so there is at most 1 hit, at least 0 hit.

## 5.13.4 [10] <§§5.4, 5.8> 
Which address should be evicted at each replacement to maximize the number of hits? How many hits does this address sequence exhibit if you follow this “optimal” policy? 

**A:** According to 5.13.2, take MRU stategy, it has 1 hit.

## 5.13.5 [10] <§§5.4, 5.8> 
Describe why it is difficult to implement a cache replacement policy that is optimal for all address sequences. 

**A:** Because there are so many possiblity of the future address sequence, which cache cannot predict. The policy may work well now, but much more worse in the future.

## 5.13.6 [10] <§§5.4, 5.8> 
Assume you could make a decision upon each memory reference whether or not you want the requested address to be cached. What impact could this have on miss rate?

**A:** Just same as above problems, you can only make decision according to current situation, so you may manage well at present but get a worse miss rate in the future.