`timescale 1ps/1ps
module Full_Adder_4_Bit_tb ();

    reg [3:0] a, b;
    reg cin;
    wire [3:0] s;
    wire cout;

    Full_Adder_4_Bit dut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    initial begin
        $display("A\tB\tCin\tS\tCout");
        $monitor("%b\t%b\t%b\t%b\t%b", a, b, cin, s, cout);
    end

    initial begin
        a = 4'b1010; b = 4'b0101; cin = 0; #10;
        a = 4'b1111; b = 4'b0001; cin = 0; #10;
        a = 4'b0001; b = 4'b0001; cin = 0; #10;
        a = 4'b1001; b = 4'b0110; cin = 1; #10;
        a = 4'b0011; b = 4'b1100; cin = 1; #10;

        $stop;
    end
endmodule