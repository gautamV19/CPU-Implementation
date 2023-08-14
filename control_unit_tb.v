`timescale 1ns/1ns

module control_unit_tb;
    reg [2:0] opcode;
    reg [2:0] r1;
    reg [2:0] r2;
    reg [2:0] r3;
    wire [11:0] op1, op2, result;
    reg clk;
    
    register_file re2(r1, r2, r3, 12'b0, 1'b0, clk, op1, op2);
    alu u3(.op(opcode), .op1(op1), .op2(op2), .out(result));
    register_file re3(r1, r2, r3, result, 1'b1, clk, op1, op2);

    initial begin 
        clk = 1'b0;
        forever #20 clk = ~clk ;
    end
    initial begin
        $dumpfile ("control_unit_tb.vcd");
        $dumpvars (0, control_unit_tb);
        opcode = 3'b001; r1=3'b000; r2=3'b001; r3=3'b010; #20; //Addition
        opcode = 3'b010; r1=3'b000; r2=3'b001; r3=3'b011; #20; //Addition
        opcode = 3'b011; r1=3'b000; r2=3'b001; r3=3'b100; #20; //Addition
        opcode = 3'b100; r1=3'b000; r2=3'b001; r3=3'b100; #20; //Addition
        opcode = 3'b101; r1=3'b101; r2=3'b110; r3=3'b111; #20; //Addition
        opcode = 3'b110; r1=3'b101; r2=3'b110; r3=3'b111; #20; //Addition
        opcode = 3'b111; r1=3'b000; r2=3'b001; r3=3'b010; #20; //Addition

        #10 $display ("Test Completed");
        $finish;
    end
    always
        #19 $display("%b\tr%d\tr%d\tr%d", opcode, r1, r2, r3);
  
endmodule 