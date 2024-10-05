    module Carry_Look_Ahead_Adder_4bit (
    input [3:0] a, b,
    input cin,
    output [3:0] s,
    output cout
);
    wire [3:0] g;
    wire [3:0] p;
    wire [3:0] c;

    and (g[0], a[0], b[0]);
    and (g[1], a[1], b[1]);
    and (g[2], a[2], b[2]);
    and (g[3], a[3], b[3]);

    xor (p[0], a[0], b[0]);
    xor (p[1], a[1], b[1]);
    xor (p[2], a[2], b[2]);
    xor (p[3], a[3], b[3]);

    wire w1, w2, w3, w4;

    and (w1, p[0], cin);
    or  (c[1], g[0], w1);

    and (w2, p[1], c[1]);
    or  (c[2], g[1], w2);

    and (w3, p[2], c[2]);
    or  (c[3], g[2], w3);

    and (w4, p[3], c[3]);
    or  (cout, g[3], w4);

    xor (s[0], p[0], cin);
    xor (s[1], p[1], c[1]);
    xor (s[2], p[2], c[2]);
    xor (s[3], p[3], c[3]);

endmodule

