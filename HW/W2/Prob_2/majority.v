module majority(
    F,a,b,c
);

input a,b,c;
output F;

wire a1,a2,a3;

and and_a1(a1,a,b);
and and_a2(a2,b,c);
and and_a3(a3,a,c);
or or_o1(F,a1,a2,a3);

endmodule