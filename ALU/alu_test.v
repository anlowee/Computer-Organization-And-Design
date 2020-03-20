`timescale 1ns/1ps
module alu_test;
    reg[31:0] a, b;
    reg[2:0] opcode;
    wire[2:0] d;
    wire[31:0] c;

    parameter sla = 3'b000,
        sra = 3'b001,
        add = 3'b010,
        sub = 3'b011,
        mul = 3'b100,
        andd = 3'b101,
        ord = 3'b110,
        notd = 3'b111;
    
    alu testalu(a, b, opcode, c, d);

    initial
    begin
        #10 a = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
            opcode = notd;
        
        #10 $finish;
    end


endmodule
