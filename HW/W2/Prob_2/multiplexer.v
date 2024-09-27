module multiplexer (
    Y,S,A,B
);

input S,A,B;
output Y;

wire n1,a1,a2;

not not_S(n1,S);
and and_a1(a1,n1,A);
and and_a2(a2,S,B);
or or_o1(Y,a1,a2);
    
endmodule