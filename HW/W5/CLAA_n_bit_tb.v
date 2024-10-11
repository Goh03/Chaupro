`timescale 1ps/1ps
module Carry_Look_Ahead_Adder_n_bit_tb();
    parameter N = 4;
    reg [N-1:0] a, b;
    reg cin;
    wire [N-1:0] sum;
    wire cout;

    Carry_Look_Ahead_Adder_n_bit #(.N(N)) uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $display("A\t\tB\t\tCin\tSum\t\tCout");
        $monitor("%b\t%b\t%b\t%b\t%b", a, b, cin, sum, cout);
        a = 4'b0001; b = 4'b0010; cin = 0; #10;
        a = 4'b0101; b = 4'b0011; cin = 1; #10;
        a = 4'b1111; b = 4'b0001; cin = 0; #10;
        a = 4'b1001; b = 4'b0110; cin = 1; #10;
        a = 4'b1010; b = 4'b0101; cin = 0; #10;

        $stop;
    end

endmodule
