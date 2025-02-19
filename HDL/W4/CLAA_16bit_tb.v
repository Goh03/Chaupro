`timescale 1ps/1ps
module Carry_Look_Ahead_Adder_16bit_tb;
    reg [15:0] a, b;
    reg cin;
    wire [15:0] s;
    wire cout;

    Carry_Look_Ahead_Adder_16bit dut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    initial begin
        a = 16'b0000000000000000; b = 16'b0000000000000000; cin = 1'b0;
        $monitor("a = %b, b = %b, cin = %b, s = %b, cout = %b", a, b, cin, s, cout);
        
        #10 a = 16'b0000000000000011; b = 16'b0000000000000101; cin = 1'b0;
        #10 a = 16'b0000000000000111; b = 16'b0000000000001000; cin = 1'b1;
        #10 a = 16'b0000000000001111; b = 16'b0000000000001111; cin = 1'b0;
        #10 a = 16'b0000000000000001; b = 16'b0000000000000001; cin = 1'b1;
        #10 a = 16'b0000000000001001; b = 16'b0000000000000110; cin = 1'b0;
        #10 a = 16'b0000000000101010; b = 16'b0000000000010101; cin = 1'b1;
        #10 a = 16'b1111111111111111; b = 16'b1111111111111111; cin = 1'b0;
        #10 $finish;
    end
endmodule
