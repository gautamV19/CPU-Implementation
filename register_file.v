`timescale 1ns/1ns


module dff (
    input d, clk, enable,
    output q
);
    reg q;

    always @(posedge clk)
        if(enable==1)
            begin
                q = d;
            end
    
endmodule

module reg_12_bit (
    input [11:0] d_in, 
    input clk, enable,
    output [11:0] q
);
    dff ff[11:0] (d_in[11:0], clk, enable, q[11:0]);

endmodule

module decoder(
    input [2:0] opcode, // 3-bit opcode input
    output [7:0] select // 8-bit select signal output
); 
    
    wire [2:0] opcode_bar; //this stores the values of the complements of the input opcode bits
    not nots[2:0] (opcode_bar[2:0], opcode[2:0]);

    and and0 (select[0], opcode_bar[2], opcode_bar[1], opcode_bar[0]); //opcode = 000 
    and and1 (select[1], opcode_bar[2], opcode_bar[1], opcode[0]); //opcode = 001
    and and2 (select[2], opcode_bar[2], opcode[1], opcode_bar[0]); //opcode = 010
    and and3 (select[3], opcode_bar[2], opcode[1], opcode[0]); //opcode = 011
    and and4 (select[4], opcode[2], opcode_bar[1], opcode_bar[0]); //opcode = 100
    and and5 (select[5], opcode[2], opcode_bar[1], opcode[0]); //opcode = 101
    and and6 (select[6], opcode[2], opcode[1], opcode_bar[0]); //opcode = 110
    and and7 (select[7], opcode[2], opcode[1], opcode[0]); //opcode = 111

endmodule

module mux_8_to_1_12bit(
    input [11:0] s0, s1, s2, s3, s4, s5, s6, s7,
    input [2:0] control,
    output [11:0] out
);

    wire [2:0] control_not;
    wire [11:0] c, c0, c1, c2, c3, c4, c5, c6, c7;
    wire [11:0] out_temp0, out_temp1, out_temp2, out_temp3, out_temp4, out_temp5, out_temp6, out_temp7;
    
    not not1[2:0] (control_not, control);
    and and1 (c[0], control_not[2], control_not[1], control_not[0]);
    and and2 (c[1], control_not[2], control_not[1], control[0]);
    and and3 (c[2], control_not[2], control[1], control_not[0]);
    and and4 (c[3], control_not[2], control[1], control[0]);
    and and5 (c[4], control[2], control_not[1], control_not[0]);
    and and6 (c[5], control[2], control_not[1], control[0]);
    and and7 (c[6], control[2], control[1], control_not[0]);
    and and8 (c[7], control[2], control[1], control[0]);

    buf buf1[11:0] (c0, c[0]);
    buf buf2[11:0] (c1, c[1]);
    buf buf3[11:0] (c2, c[2]);
    buf buf4[11:0] (c3, c[3]);
    buf buf5[11:0] (c4, c[4]);
    buf buf6[11:0] (c5, c[5]);
    buf buf7[11:0] (c6, c[6]);
    buf buf8[11:0] (c7, c[7]);

    and and9[11:0] (out_temp0, s0, c0);
    and and10[11:0] (out_temp1, s1, c1);
    and and11[11:0] (out_temp2, s2, c2);
    and and12[11:0] (out_temp3, s3, c3);
    and and13[11:0] (out_temp4, s4, c4);
    and and14[11:0] (out_temp5, s5, c5);
    and and15[11:0] (out_temp6, s6, c6);
    and and16[11:0] (out_temp7, s7, c7);

    or or1[11:0] (out, out_temp0, out_temp1, out_temp2, out_temp3, out_temp4, out_temp5, out_temp6, out_temp7);

endmodule

module register_file (
    input[2:0] read_addr1, read_addr2, write_addr,
    input [11:0] data_in,
    input write_en, clk,
    output [11:0] read_out1, read_out2
);

    wire [11:0] reg_read [7:0];
    wire [7:0] reg_write_en, temp_reg_write_en;
    wire [7:0] in_write_en;

    decoder d1 (write_addr, temp_reg_write_en);
    buf b1[7:0] (in_write_en[7:0], write_en);
    and a1[7:0] (reg_write_en, temp_reg_write_en, in_write_en);

    reg_12_bit register0 (data_in, clk, reg_write_en[0], reg_read[0]);
    reg_12_bit register1 (data_in, clk, reg_write_en[1], reg_read[1]);
    reg_12_bit register2 (data_in, clk, reg_write_en[2], reg_read[2]);
    reg_12_bit register3 (data_in, clk, reg_write_en[3], reg_read[3]);
    reg_12_bit register4 (data_in, clk, reg_write_en[4], reg_read[4]);
    reg_12_bit register5 (data_in, clk, reg_write_en[5], reg_read[5]);
    reg_12_bit register6 (data_in, clk, reg_write_en[6], reg_read[6]);
    reg_12_bit register7 (data_in, clk, reg_write_en[7], reg_read[7]);

    mux_8_to_1_12bit mux1 (reg_read[0], reg_read[1], reg_read[2], reg_read[3], reg_read[4], reg_read[5], reg_read[6], reg_read[7], read_addr1, read_out1);
    mux_8_to_1_12bit mux2 (reg_read[0], reg_read[1], reg_read[2], reg_read[3], reg_read[4], reg_read[5], reg_read[6], reg_read[7], read_addr2, read_out2);
    
endmodule