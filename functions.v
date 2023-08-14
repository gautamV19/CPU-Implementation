`timescale 1ns/1ns


module CLA4 (
	input [3:0]op1,
	input [3:0]op2,
	input cin,

	output cout,
	output [3:0] sum
	);

	wire [4:0]c;
	wire w1, w2, w3, w4;
	wire [3:0]gen;
	wire [3:0]prop;
	
	buf  (c[0], cin);
	and  (w1, prop[0], c[0]);

	or   (c[1], w1, gen[0]);
	and  (w2, c[1], prop[1]);

	or   (c[2], gen[1], w2);
	and  (w3, c[2], prop[2]);

	or   (c[3], gen[2], w3);
	and  (w4, c[3], prop[3]);
	
	or   (c[4], gen[3], w4);
	xor  gateo2[3:0](sum[3:0], prop[3:0], c[3:0]);
	buf  (cout, c[4]);

	and gatea1[3:0](gen[3:0], op1[3:0], op2[3:0]);
	xor gateo1[3:0](prop[3:0], op1[3:0], op2[3:0]);

endmodule

module CLA16 (
	input [7:0]op1,
	input [7:0]op2,
	input cin,
	output cout,
	output [7:0] sum
	);

	wire [8:0]c;
	
    buf (c[0], cin);

	CLA4 CLA4_dut1a (.op1(op1[3:0]), .op2(op2[3:0]), .cin(c[0]), .cout(c[4]), .sum(sum[3:0]));
    CLA4 CLA4_dut1b (.op1(op1[7:4]), .op2(op2[7:4]), .cin(c[4]), .cout(c[8]), .sum(sum[7:4]));
	
	buf (cout, c[8]);
endmodule

// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 001 010 : 8-bit integer addition, 8-bit integer subtraction
module cla4(input [3:0] x,input [3:0] y,input cin,output [3:0] S,output [3:0]cout);
    wire [3:0]p,g;
    xor xor_0(p[0],x[0],y[0]);
    and and_0(g[0],x[0],y[0]);
    xor xor_1(p[1],x[1],y[1]);
    and and_1(g[1],x[1],y[1]);
    xor xor_2(p[2],x[2],y[2]);
    and and_2(g[2],x[2],y[2]);
    xor xor_3(p[3],x[3],y[3]);
    and and_3(g[3],x[3],y[3]);
    wire and_a1,and_a2,and_a3,and_a4;
    and and1(and_a1,p[0],cin);
    or or1(cout[0],and_a1,g[0]);
    and and2(and_a2,p[1],cout[0]);
    or or2(cout[1],and_a2,g[1]);
    and and3(and_a3,p[2],cout[1]);
    or or3(cout[2],and_a3,g[2]);
    and and4(and_a4,p[3],cout[2]);
    or or4(cout[3],and_a4,g[3]);
    xor xor1(S[0],p[0],cin);
    xor xor2(S[1],p[1],cout[0]);
    xor xor3(S[2],p[2],cout[1]);
    xor xor4(S[3],p[3],cout[2]);
endmodule

module cla16(input wire [7:0]x ,input wire [7:0]z, input wire control, output [7:0]s);
    wire [7:0] cout;
    wire [7:0] y;
    
    xor xor0(y[0],z[0],control);
    xor xor1(y[1],z[1],control);
    xor xor2(y[2],z[2],control);
    xor xor3(y[3],z[3],control);
    xor xor4(y[4],z[4],control);
    xor xor5(y[5],z[5],control);
    xor xor6(y[6],z[6],control);
    xor xor7(y[7],z[7],control);

    cla4 cla_uut1(x[3:0],y[3:0],control,s[3:0],cout[3:0]);
    cla4 cla_uut2(x[7:4],y[7:4],cout[3],s[7:4],cout[7:4]);
endmodule

// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 011 : 8-bit unsigned integer multiplication


module partial_products (input [7:0]a, input [7:0]b, output reg [7:0][15:0]p_prods);
integer i;

always @(a or b)
begin
    for(i=0; i<8; i=i+1)begin
        if(b[i] == 1)begin
            p_prods[i] <= a << i;
        end
        else
            //bug may be here
            p_prods[i] = 64'h00000000;
    end
end

endmodule

module csa (
	input [15:0] x,
	input [15:0] y,
	input [15:0] z,
	output [15:0] u,
	output [15:0] v);

assign u = x^y^z;
assign v[0] = 0;
assign v[15:1] = (x&y) | (y&z) | (z&x);

endmodule

module CLA16ht(
    input [3:0]p,
	input [3:0]g,
    output pi, 
	output gi
	);

    wire a,b,c;

    and pi1 (pi, p[0], p[1], p[2], p[3]);
    and a1 (a, p[3], p[2], p[1], g[0]);
    and a2 (b, p[3], p[2], g[1]);
    and a3 (c, p[3], g[2]);
    or gi1 (gi, a, b, c, g[3]);

endmodule

module CLA4h(
	input [3:0]p,
	input [3:0]g,
	input cin,
	output [3:0] sum
	);

	wire [4:0]c;
	wire w1, w2, w3, w4;

	buf  (c[0], cin);

	and  (w1, p[0], c[0]);
	or   (c[1], w1, g[0]);

	and  (w2, c[1], p[1]);
	or   (c[2], g[1], w2);

	and  (w3, c[2], p[2]);
	or   (c[3], g[2], w3);

	and  (w4, c[3], p[3]);
	xor  s1[3:0](sum[3:0], p[3:0], c[3:0]);

endmodule


module CLA16h(
	input [15:0]op1,
	input [15:0]op2,
	input signal,
	input cin,
	output [15:0] sum,
	output cout
	);

	wire [15:0]p, g;
	wire [3:0]pi, gi;
	wire [4:0] ci;
	wire w1, w2, w3,w4;
	wire [15:0] op3;

	assign op3 = signal ? (-op2) : op2;
	
	buf(ci[0], cin);

    xor p1[15:0](p[15:0], op1[15:0], op3[15:0]);
	and g1[15:0](g[15:0], op1[15:0], op3[15:0]);

	CLA16ht uut1 (p[3:0], g[3:0], pi[0], gi[0]);
	CLA16ht uut2 (p[7:4], g[7:4], pi[1], gi[1]);
	CLA16ht uut3 (p[11:8], g[11:8], pi[2], gi[2]);
	CLA16ht uut4 (p[15:12], g[15:12], pi[3], gi[3]);

	and a1 (w1, pi[0], ci[0]);
	or o1 (ci[1], w1, gi[0]);
	and a2 (w2, pi[1], ci[1]);
	or o2 (ci[2], w2, gi[1]);
	and a3 (w3, pi[2], ci[2]);
	or o3 (ci[3], w3, gi[2]);
	and a4 (w4, pi[3], ci[3]);
	or o4 (ci[4], w4, gi[3]);

	CLA4h CLA4_dut1a (.p(p[3:0]), .g(g[3:0]), .cin(ci[0]),  .sum(sum[3:0]));
    CLA4h CLA4_dut1b (.p(p[7:4]), .g(g[7:4]), .cin(ci[1]), .sum(sum[7:4]));
    CLA4h CLA4_dut1c (.p(p[11:8]), .g(g[11:8]), .cin(ci[2]), .sum(sum[11:8]));
    CLA4h CLA4_dut1d (.p(p[15:12]), .g(g[15:12]), .cin(ci[3]), .sum(sum[15:12]));
	
	buf (cout, ci[4]);
endmodule

module unsmul(
    input [7:0]a, 
    input [7:0]b, 
    output [15:0]pdt, 
    output of
    );

    wire [7:0][15:0] pp;

    partial_products i1(a, b, pp);

    // Level 1

    wire [15:0] u11, u12, v11, v12;

    csa l11(pp[0][15:0], pp[1][15:0], pp[2][15:0], u11[15:0], v11[15:0]);
    csa l12(pp[3][15:0], pp[4][15:0], pp[5][15:0], u12[15:0], v12[15:0]);

    // Level 2

    wire [15:0] u21, u22, v21, v22;

    csa l21(u11[15:0], v11[15:0], u12[15:0], u21[15:0], v21[15:0]);
    csa l22(v12[15:0], pp[6][15:0], pp[7][15:0], u22[15:0], v22[15:0]);

    // Level 3

    wire [15:0] u31, v31;

    csa l31(u21[15:0], v21[15:0], u22[15:0], u31[15:0], v31[15:0]);

    // Level 4

    wire [15:0] u41, v41;

    csa l41(u31[15:0], v31[15:0], v22[15:0], u41[15:0], v41[15:0]);

    // adding last two 16 bit 
    wire cout;
    CLA16h CLA16h_dut(u41[15:0], v41[15:0], 1'b0, 1'b0,  pdt[15:0], cout);


    assign of = pdt[8] + pdt[9] + pdt[10] + pdt[11] + pdt[12] + pdt[13] + pdt[14]+ pdt[15];
endmodule

// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 100 : 8-bit signed integer multiplication

module signmul(
    input [7:0]a, 
    input [7:0]b, 
    output [15:0]pdt, 
    output of
    );

    wire [7:0][15:0] pp;

    partial_products i1(a, b, pp);
    
    // Level 1

    wire [15:0] u11, u12, v11, v12;

    csa l11(pp[0][15:0], pp[1][15:0], pp[2][15:0], u11[15:0], v11[15:0]);
    csa l12(pp[3][15:0], pp[4][15:0], pp[5][15:0], u12[15:0], v12[15:0]);

    // Level 2

    wire [15:0] u21, u22, v21, v22;

    csa l21(u11[15:0], v11[15:0], u12[15:0], u21[15:0], v21[15:0]);
    csa l22(v12[15:0], pp[6][15:0], pp[7][15:0], u22[15:0], v22[15:0]);

    // Level 3

    wire [15:0] u31, v31;

    csa l31(u21[15:0], v21[15:0], u22[15:0], u31[15:0], v31[15:0]);

    // Level 4

    wire [15:0] u41, v41;

    csa l41(u31[15:0], v31[15:0], v22[15:0], u41[15:0], v41[15:0]);

    // adding last two 16 bit 
    wire cout;
    CLA16h CLA16h_dut(u41[15:0], v41[15:0], 1'b0, 1'b0,  pdt[15:0], cout);


    assign of = pdt[8] + pdt[9] + pdt[10] + pdt[11] + pdt[12] + pdt[13] + pdt[14]+ pdt[15];
endmodule

// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 101: 12-bit floating-point addition

module cla4_fa( input [3:0] x,input [3:0] b1,input cin1,input control,output [3:0] S,output c4);
    wire [3:0]y;
    wire cin;
    xor xo[3:0](y[3:0],b1[3:0],control);
    buf(cin,control);
    wire [3:0]p,g;
    wire [3:0] cout;
    xor xor_0(p[0],x[0],y[0]);
    and and_0(g[0],x[0],y[0]);
    xor xor_1(p[1],x[1],y[1]);
    and and_1(g[1],x[1],y[1]);
    xor xor_2(p[2],x[2],y[2]);
    and and_2(g[2],x[2],y[2]);
    xor xor_3(p[3],x[3],y[3]);
    and and_3(g[3],x[3],y[3]);
    wire and_a1,and_a2,and_a3,and_a4;
    
    and and1(and_a1,p[0],cin);
    or or1(cout[0],and_a1,g[0]);
    and and2(and_a2,p[1],cout[0]);
    or or2(cout[1],and_a2,g[1]);
    and and3(and_a3,p[2],cout[1]);
    or or3(cout[2],and_a3,g[2]);
    and and4(and_a4,p[3],cout[2]);
    or or4(cout[3],and_a4,g[3]);
    xor xor1(S[0],p[0],cin);
    xor xor2(S[1],p[1],cout[0]);
    xor xor3(S[2],p[2],cout[1]);
    xor xor4(S[3],p[3],cout[2]);
    buf(c4,cout[3]);
endmodule

module mux8_1(input  y0,y1,y2,y3,y4,y5,y6,y7,input a,input b,input c,output  out );
    wire abar,bbar,cbar;
    not(abar,a);
    not(bbar,b);
    not(cbar,c);
    wire a0,a1,a2,a3,a4,a5,a6,a7;
    and(a0,abar,bbar,cbar,y0);
    and(a1,abar,bbar,c,y1);
    and(a2,abar,b,cbar,y2);
    and(a3,abar,b,c,y3);
    and(a4,a,bbar,cbar,y4);
    and(a5,a,bbar,c,y5);
    and(a6,a,b,cbar,y6);
    and(a7,a,b,c,y7);
    or(out,a0,a1,a2,a3,a4,a5,a6,a7);
endmodule

module mux2_1(input x1,input x2,input s,output y);
    wire p1,p2,ns;
    not (ns,s);
    and (p1,ns,x1);
    and (p2,s,x2);
    or (y,p1,p2);
endmodule

module fadd(input [11:0]x ,input [11:0]y, output [11:0]z );
    wire [3:0]k;
    wire [7:0] sy;
    wire [8:0]sm;
    wire [3:0]xe,ye;
    wire [7:0]xm,ym;
    buf b1[3:0](xe[3:0],x[10:7]);
    buf b2[3:0](ye[3:0],y[10:7]);
    buf b3[6:0](xm[6:0],x[6:0]);
    buf (xm[7],1'b1);
    buf b4[6:0](ym[6:0],y[6:0]);
    buf (ym[7],1'b1);
    wire dup;
    cla4_fa cl_1(xe[3:0],ye[3:0],1'b0,1'b1,k[3:0],dup);

    wire [7:0]nsy;
    mux8_1 mm1(ym[7],1'b0 ,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0   ,k[2],k[1],k[0],sy[7]);
    mux8_1 mm2(ym[6],ym[7],1'b0,1'b0,1'b0,1'b0,1'b0,1'b0   ,k[2],k[1],k[0],sy[6]);
    mux8_1 mm3(ym[5],ym[6],ym[7],1'b0,1'b0,1'b0,1'b0,1'b0  ,k[2],k[1],k[0],sy[5]);
    mux8_1 mm4(ym[4],ym[5],ym[6],ym[7],1'b0,1'b0,1'b0,1'b0  ,k[2],k[1],k[0],sy[4]);
    mux8_1 mm5(ym[3],ym[4],ym[5],ym[6],ym[7],1'b0,1'b0,1'b0 ,k[2],k[1],k[0],sy[3]);
    mux8_1 mm6(ym[2],ym[3],ym[4],ym[5],ym[6],ym[7],1'b0,1'b0 ,k[2],k[1],k[0],sy[2]);
    mux8_1 mm7(ym[1],ym[2],ym[3],ym[4],ym[5],ym[6],ym[7],1'b0 ,k[2],k[1],k[0],sy[1]);
    mux8_1 mm8(ym[0],ym[1],ym[2],ym[3],ym[4],ym[5],ym[6],ym[7] ,k[2],k[1],k[0],sy[0]);

    mux2_1 m1(sy[0],1'b0,k[3],nsy[0]);
    mux2_1 m2(sy[1],1'b0,k[3],nsy[1]);
    mux2_1 m3(sy[2],1'b0,k[3],nsy[2]);
    mux2_1 m4(sy[3],1'b0,k[3],nsy[3]);
    mux2_1 m5(sy[4],1'b0,k[3],nsy[4]);
    mux2_1 m6(sy[5],1'b0,k[3],nsy[5]);
    mux2_1 m7(sy[6],1'b0,k[3],nsy[6]);
    mux2_1 m8(sy[7],1'b0,k[3],nsy[7]);

    // wire [8:0]sm;
    wire dup2,dup3;
    cla4_fa cl_2(nsy[3:0],xm[3:0],1'b0,1'b0,sm[3:0],dup2);
    cla4_fa cl_3(nsy[7:4],xm[7:4],dup2,1'b0,sm[7:4],dup3);
    buf(sm[8],dup3);

    mux2_1 t1(sm[0],sm[1],sm[8],z[0]);
    mux2_1 t2(sm[1],sm[2],sm[8],z[1]);
    mux2_1 t3(sm[2],sm[3],sm[8],z[2]);
    mux2_1 t4(sm[3],sm[4],sm[8],z[3]);
    mux2_1 t5(sm[4],sm[5],sm[8],z[4]);
    mux2_1 t6(sm[5],sm[6],sm[8],z[5]);
    mux2_1 t7(sm[6],sm[7],sm[8],z[6]);

    wire [3:0]xee;
    wire dup5,dup6;
    cla4_fa cl_4(xe[3:0],4'b0001,1'b0,1'b0,xee[3:0],dup5);
    mux2_1 t_1(xe[0],xee[0],sm[8],z[7]);
    mux2_1 t_2(xe[1],xee[1],sm[8],z[8]);
    mux2_1 t_3(xe[2],xee[2],sm[8],z[9]);
    mux2_1 t_4(xe[3],xee[3],sm[8],z[10]);

    buf(z[11],1'b0);
endmodule

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 110: 12-bit floating-point multiplication

module m21_4(output[3:0] out, input[3:0] x,y, input S);

    wire [3:0] T1, T2; 
    wire Sbar;

    not n1 (Sbar, S);
    and a1[3:0] (T1[3:0], x[3:0], {4{S}});
    and a2[3:0] (T2[3:0], y[3:0], {4{Sbar}});
    or o1[3:0] (out[3:0], T1[3:0], T2[3:0]);

endmodule

module m21_7(output[6:0] out, input[6:0] x,y, input S);

    wire [6:0] T1, T2; 
    wire Sbar;

    not n1 (Sbar, S);
    and a1[6:0] (T1[6:0], x[6:0], {7{S}});
    and a2[6:0] (T2[6:0], y[6:0], {7{Sbar}});
    or o1[6:0] (out[6:0], T1[6:0], T2[6:0]);

endmodule

module m21_1(output out, input x,y, input S);

    wire  T1, T2; 
    wire Sbar;

    not n1 (Sbar, S);
    and a1 (T1, x, S);
    and a2 (T2, y, Sbar);
    or o1 (out, T1, T2);

endmodule

module subtractor (
    input [4:0] a, 
    input [4:0] b, 
    output reg [4:0] diff
);

always @(*) begin
    diff = a - b;
end

endmodule

module fmul (
    input [11:0]x, 
    input [11:0]y,
    output [11:0]z,
    output overflow
);
    // Sign of Z, zs
    xor(z[11], x[11], y[11]);

    wire [7:0]xm, ym;
    wire [15:0]pm;
    wire of;

    buf buf1(xm[7], 1'b1);
    buf buf2(ym[7], 1'b1);
    buf buf3[6:0](xm[6:0], x[6:0]);
    buf buf4[6:0](ym[6:0], y[6:0]);

    // multiplying xm and ym, mantisa of Z
    unsmul w1 (.a(xm), .b(ym), .pdt(pm), .of(of));
    m21_7 m1 (.out(z[6:0]), .x(pm[14:8]), .y(pm[13:7]), .S(pm[15]));

    // calculate exponent of Z
    // lvl 1
    wire[4:0] c;
    wire[4:0] sum;
    buf (c[0], 1'b0);
    CLA4 cla1 (.op1(x[10:7]), .op2(y[10:7]), .cin(c[0]), .cout(c[4]), .sum(sum[3:0]));
    buf(sum[4], c[4]); 

    // lvl 2
    wire [4:0]bais = 5'b00111, _bais = 5'b00110;
    wire[4:0] ze1, ze2;
    subtractor s1 (.a(sum), .b(bais), .diff(ze1));
    subtractor s2 (.a(sum), .b(_bais), .diff(ze2));

    // lvl 3
    m21_4 m2(.out(z[10:7]), .x(ze2[3:0]), .y(ze1[3:0]), .S(pm[15]));

    // overflow detection
    m21_1 m3(.out(overflow), .x(ze2[4]), .y(ze1[4]), .S(pm[15]));
endmodule

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 111 : 8-bit comparison

module comp(input [7:0]x1, input [7:0]y1, output [11:0]z1);
    wire [7:0]z2;
    xor xor_1[7:0](z2[7:0],x1[7:0],y1[7:0]);
    or or1(z1[0],z2[0],z2[1],z2[2],z2[3],z2[4],z2[5],z2[6],z2[7]);
    buf b1(z1[1],z1[0]);
    buf b2(z1[2],z1[0]);
    buf b3(z1[3],z1[0]);
    buf b4(z1[4],z1[0]);
    buf b5(z1[5],z1[0]);
    buf b6(z1[6],z1[0]);
    buf b7(z1[7],z1[0]);
    buf b8(z1[8],z1[0]);
    buf b9(z1[9],z1[0]);
    buf b10(z1[10],z1[0]);
    buf b11(z1[11],z1[0]);
endmodule
  