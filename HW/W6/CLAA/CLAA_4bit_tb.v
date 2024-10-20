`timescale 1ps/1ps
module Carry_Look_Ahead_Adder_4bit_tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] s;
    wire cout;

    Carry_Look_Ahead_Adder_4bit dut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    initial begin
        a = 4'b0000; b = 4'b0000; cin = 1'b0;
        $monitor("a = %b, b = %b, cin = %b, s = %b, cout = %b", a, b, cin, s, cout);
        #10 a = 4'b0011; b = 4'b0101; cin = 1'b0;
        #10 a = 4'b0111; b = 4'b1000; cin = 1'b1;
        #10 a = 4'b1111; b = 4'b1111; cin = 1'b0;
        #10 a = 4'b0001; b = 4'b0001; cin = 1'b1;
        #10 a = 4'b1001; b = 4'b0110; cin = 1'b0;
        #10 a = 4'b1010; b = 4'b0101; cin = 1'b1;
        #10 $finish;
    end
endmodule
