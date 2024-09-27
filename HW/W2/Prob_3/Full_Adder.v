module Full_Adder (
    x,y,c_in,c_out,s
);

input x,y,c_in;
output c_out,s;

wire x1,a1,a2,a3;

xor xor_x1(x1,x,y);
xor xor_x2(s,c_in,x1);
and and_a1(a1,x,y);
and and_a2(a2,x,c_in);
and and_a3(a3,y,c_in);
or or_o1(c_out,a1,a2,a3);

endmodule