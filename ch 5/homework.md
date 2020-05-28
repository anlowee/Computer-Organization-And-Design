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

Locality is affected by both the reference order and data layout. The same computation can also be written below in Matlab, which diff ers from C by storing matrix elements within the same column contiguously in memory.
```
for I=1:8  
    for J=1:8000    
        A(I,J)=B(I,0)+A(J,I);  
    end 
end
```

## 5.1.4 [10] <§5.1> 
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
You are asked to optimize a cache design for the given references. Th ere are three direct-mapped cache designs possible, all with a total of 8 words of data: C1 has 1-word blocks, C2 has 2-word blocks, and C3 has 4-word blocks. In terms of miss rate, which cache design is the best? If the miss stall time is 25 cycles, and C1 has an access time of 2 cycles, C2 takes 3 cycles, and C3 takes 5 cycles, which is the best cache design? There are many different design parameters that are important to a cache’s overall performance. Below are listed parameters for diff erent direct-mapped cache designs. Cache Data Size:  32 KiB Cache Block Size:  2 words Cache Access Time:  1 cycle 

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
Calculate the total number of bits required for the cache listed above, assuming a 32-bit address. Given that total size, find the total size of the closest direct-mapped cache with 16-word blocks of equal size or greater. Explain why the second cache, despite its larger data size, might provide slower performance than the first cache. 

**A:**

## 5.2.5 [20] <§§5.3, 5.4> 
Generate a series of read requests that have a lower miss rate on a 2 KiB 2-way set associative cache than the cache listed above. Identify one possible solution that would make the cache listed have an equal or lower miss rate than the 2 KiB cache. Discuss the advantages and disadvantages of such a solution. 

**A:**

## 5.2.6 [15] <§5.3> 
The formula shown in Section 5.3 shows the typical method to index a direct-mapped cache, specifi cally (Block address) modulo (Number of blocks in the cache). Assuming a 32-bit address and 1024 blocks in the cache, consider a diff erent 
indexing function, specifi cally (Block address[31:27] XOR Block address[26:22]). Is it possible to use this to index a direct-mapped cache? If so, explain why and discuss any changes that might need to be made to the cache. If it is not possible, explain why.

**A:**

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

Address：
```
0 4 16 132 232 160 1024 30 140 3100 180 2180
```

## 5.3.4 [10] <§5.3> 
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

**A:** 3 / 12 = 0.25

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
This exercise examines the impact of diff erent cache designs, specifi cally comparing associative caches to the direct-mapped caches from Section 5.4. For these exercises, refer to the address stream shown in Exercise 5.2. 

## 5.7.1 [10] <§5.4> 
Using the sequence of references from Exercise 5.2, show the fi nal cache contents for a three-way set associative cache with two-word blocks and a total size of 24 words. Use LRU replacement. For each reference identify the index bits, the tag bits, the block off set bits, and if it is a hit or a miss. 

**A:**

## 5.7.2 [10] <§5.4> 
Using the references from Exercise 5.2, show the fi nal cache contents for a fully associative cache with one-word blocks and a total size of 8 words. Use LRU replacement. For each reference identify the index bits, the tag bits, and if it is a hit or a miss.

**A:**

## 5.7.3 [15] <§5.4> 
Using the references from Exercise 5.2, what is the miss rate for a fully associative cache with two-word blocks and a total size of 8 words, using LRU replacement? What is the miss rate using MRU (most recently used) replacement? Finally what is the best possible miss rate for this cache, given any replacement policy? 

**A:**

Multilevel caching is an important technique to overcome the limited amount of space that a fi rst level cache can provide while still maintaining its speed. Consider a processor with the following parameters:
| Base CPI, No Memory Stalls | Processor Speed | Main Memory Access Time | First Level Cache MissRate per Instruction | Second Level Cache, Direct-Mapped Speed | Global Miss Rate with Second Level Cache, Direct-Mapped | Second Level Cache, Eight-Way Set Associative Speed | Global Miss Rate with Second Level Cache, Eight-Way Set Associative |
| -------------------------- | --------------- | ----------------------- | ------------------------------------------ | --------------------------------------- | ------------------------------------------------------- | --------------------------------------------------- | ------------------------------------------------------------------- |
| 1.5                        | 2 GHz           | 100 ns                  | 7%                                         | 12 cycles                               | 3.5%                                                    | 28 cycles                                           | 1.5%                                                                |

## 5.7.4 [10] <§5.4> 
Calculate the CPI for the processor in the table using: 1) only a fi rst level cache, 2) a second level direct-mapped cache, and 3) a second level eight-way set associative cache. How do these numbers change if main memory access time is doubled? If it is cut in half? 

**A:**

