module prob1 (
    F,a,b,c,d
);

input a,b,c,d;
output F;

wire b1,d1,a1,a2;

not not_b (b1,b);
not not_d (d1,d);
and and_a1 (a1,b1,d1);
and and_a2 (a2,b1,c);
or or_o1 (F,a1,a2,a);

endmodule