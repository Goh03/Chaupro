module Half_Adder (
    x,y,c,s
);

input x,y;
output c,s;

xor xor_1(s,x,y);
and and_1(c,x,y);

endmodule