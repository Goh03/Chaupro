module CRA (
    x,y,c_in,c_out,s
);
input [3:0] x,y;
input c_in;
output [3:0] s;
output c_out;
wire c1,c2,c3;
Full_Adder fa0(
    .x(x[0]),
    .y(y[0]),
    .c_in(c_in),
    .c_out(c1),
    .s(s[0])
);
Full_Adder fa1(
    .x(x[1]),
    .y(y[1]),
    .c_in(c1),
    .c_out(c2),
    .s(s[1])
);
Full_Adder fa2(
    .x(x[2]),
    .y(y[2]),
    .c_in(c2),
    .c_out(c3),
    .s(s[2])
);
Full_Adder fa3(
    .x(x[3]),
    .y(y[3]),
    .c_in(c3),
    .c_out(c_out),
    .s(s[3])
);
endmodule