`timescale 1ns/1ns

module alu(input [2:0]op, input [11:0]op1, input [11:0]op2, output [11:0]out);
    wire [11:0]out0, out1, out2, out3, out4, out5, out6, out7;
    wire [11:0] outf;

    buf b0[11:0](out0[11:0], 1'b0);

    cla16 c1(op1[7:0], op2[7:0], 1'b0, out1[7:0]);
    buf b1[11:8](out1[11:8], 1'b0);

    cla16 c2(op1[7:0], op2[7:0], 1'b1, out2[7:0]);
    buf b2[11:8](out2[11:8], 1'b0);

    wire of;
    wire [15:0]m;
    unsmul m1 (.a(op1[7:0]), .b(op2[7:0]), .pdt(m), .of(of));
    buf b3[7:0](out3[7:0], m[7:0]);
    buf b4[11:8](out3[11:8], 1'b0);

    signmul m2 (.a(op1[7:0]), .b(op2[7:0]), .pdt(m), .of(of));
    buf b5[7:0](out4[7:0], m[7:0]);
    buf b6[11:8](out4[11:8], 1'b0);

    fadd f1(.x(op1), .y(op2), .z(out5));

    fmul f2(.x(op1), .y(op2), .z(out6), .overflow(of));

    comp comp1 (.x1(op1[7:0]), .y1(op2[7:0]), .z1(out7));
    
    mux8_1 mux8_1_1(out0[0],out1[0],out2[0],out3[0],out4[0],out5[0],out6[0],out7[0],op[2],op[1],op[0],outf[0]);
    mux8_1 mux8_1_2(out0[1],out1[1],out2[1],out3[1],out4[1],out5[1],out6[1],out7[1],op[2],op[1],op[0],outf[1]);
    mux8_1 mux8_1_3(out0[2],out1[2],out2[2],out3[2],out4[2],out5[2],out6[2],out7[2],op[2],op[1],op[0],outf[2]);
    mux8_1 mux8_1_4(out0[3],out1[3],out2[3],out3[3],out4[3],out5[3],out6[3],out7[3],op[2],op[1],op[0],outf[3]);
    mux8_1 mux8_1_5(out0[4],out1[4],out2[4],out3[4],out4[4],out5[4],out6[4],out7[4],op[2],op[1],op[0],outf[4]);
    mux8_1 mux8_1_6(out0[5],out1[5],out2[5],out3[5],out4[5],out5[5],out6[5],out7[5],op[2],op[1],op[0],outf[5]);
    mux8_1 mux8_1_7(out0[6],out1[6],out2[6],out3[6],out4[6],out5[6],out6[6],out7[6],op[2],op[1],op[0],outf[6]);
    mux8_1 mux8_1_8(out0[7],out1[7],out2[7],out3[7],out4[7],out5[7],out6[7],out7[7],op[2],op[1],op[0],outf[7]);
    mux8_1 mux8_1_9(out0[8],out1[8],out2[8],out3[8],out4[8],out5[8],out6[8],out7[8],op[2],op[1],op[0],outf[8]);
    mux8_1 mux8_1_10(out0[9],out1[9],out2[9],out3[9],out4[9],out5[9],out6[9],out7[9],op[2],op[1],op[0],outf[9]);
    mux8_1 mux8_1_11(out0[10],out1[10],out2[10],out3[10],out4[10],out5[10],out6[10],out7[10],op[2],op[1],op[0],outf[10]);
    mux8_1 mux8_1_12(out0[11],out1[11],out2[11],out3[11],out4[11],out5[11],out6[11],out7[11],op[2],op[1],op[0],outf[11]);

    buf b7[11:0](out[11:0],outf[11:0]);

endmodule