module alu(a, b, opcode, c, d);

    output signed[31:0] c;  // calculate result
    output signed[2:0] d;  // d[0]-is zero, d[1]-is overflow, d[2]-is negtive
    input signed[31:0] a, b;  // two operator number
    input [2:0] opcode;  // operate code

    reg[31:0] c;
    reg[2:0] d;
    reg[5:0] ii; // a iterator
    reg[31:0] mul_a;  // mul number for a
    reg[31:0] mul_b;  // mul number for b
    reg[32:0] temp;
    reg[63:0] mul_temp;

    parameter sla = 3'b000,
        sra = 3'b001,
        add = 3'b010,
        sub = 3'b011,
        mul = 3'b100,
        andd = 3'b101,
        ord = 3'b110,
        notd = 3'b111;

    always @(a, b, opcode)
    begin
        case (opcode)
            sla:
                begin
                    c[0] = 1'b0;
                    for (ii = 1; ii < 32; ii = ii + 1)
                        c[ii] = a[ii - 1];
                    if (a[30:0] == 31'b0000_0000_0000_0000_0000_0000_0000_000)
                        d[0] = 1'b1;
                    else
                        d[0] = 1'b0;
                    if (a[31] == 1'b1)
                        d[2] = 1'b1;
                    else
                        d[2] = 1'b0;
                    if (a[31]^c[31])
                        d[1] = 1'b1;
                    else
                        d[1] = 1'b0;
                end
            sra:
                begin
                    c[31] = a[31];
                    for (ii = 0; ii < 31; ii = ii + 1)
                        c[ii] = a[ii + 1];
                    if (a[31:1] == 31'b0000_0000_0000_0000_0000_0000_0000_000)
                        d[0] = 1'b1;
                    else
                        d[0] = 1'b0;
                    if (a[31] == 1'b1)
                        d[2] = 1'b1;
                    else
                        d[2] = 1'b0;
                    d[1] = 1'bz;  // sra never overflow
                end
            add:
                begin
                    temp = 0;
                    temp = a[31:0] + b[31:0];
                    c = temp[31:0];
                    d[1] = (~c[31]&a[31]&b[31])|(c[31]&~a[31]&~b[31]);
                    if (c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                        d[0] = 1'b1;
                    else
                        d[0] = 1'b0;
                    if (c[31] == 1'b1)
                        d[2] = 1'b1;
                    else
                        d[2] = 1'b0;
                end
            sub:
                begin
                    temp = 0;
                    temp = a[31:0] - b[31:0];
                    c = temp[31:0];
                    d[1] = (~c[31]&a[31]&~b[31])|(c[31]&~a[31]&b[31]);
                    if (c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                        d[0] = 1'b1;
                    else
                        d[0] = 1'b0;
                    if (c[31] == 1'b1)
                        d[2] = 1'b1;
                    else 
                        d[2] = 1'b0;
                end
            mul:
                begin
                    c = 0;
                    // signed extend
                    for (ii = 0; ii < 16; ii = ii + 1)
                        mul_a[ii] = a[ii];
                    for (ii = 16; ii < 32; ii = ii + 1)
                        mul_a[ii] = a[15];
                    for (ii = 0; ii < 16; ii = ii + 1)
                        mul_b[ii] = b[ii];
                    for (ii = 16; ii < 32; ii = ii + 1)
                        mul_b[ii] = b[15];
                    // do mutiply
                    for (ii = 0; ii < 32; ii = ii + 1)
                        if (mul_b[ii])
                            c = c + (mul_a << (ii));
                    if (c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                        d[0] = 1'b1;
                    else
                        d[0] = 1'b0;
                    d[2] = mul_a[31] ^ mul_b[31];
                    d[1] = 1'bz;  // 16 bits multiply never overflow 32 bits
                end
            andd:
                begin
                    c = a&b;
                    if (c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                        d[0] = 1'b1;
                    else
                        d[0] = 1'b0;
                    d[2] = 1'bz;  // and operate is meaningless to negtive
                    d[1] = 1'bz;  // and operate never overflow
                end
            ord:
                begin
                    c = a|b;
                    if (c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                        d[0] = 1'b1;
                    else
                        d[0] = 1'b0;
                    d[2] = 1'bz;  // same as above
                    d[1] = 1'bz;
                end
            notd:
                begin
                    c= ~a;
                    if (c == 32'b0000_0000_0000_0000_0000_0000_0000_0000)
                        d[0] = 1'b1;
                    else
                        d[0] = 1'b0;
                    d[2] = 1'bz;  // same as above
                    d[1] = 1'bz;
                end
        endcase
    end

endmodule