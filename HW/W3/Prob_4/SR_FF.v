module SR_FF_Structural (S, R, clk, rst, Q);
input S, R, clk, rst;
output Q;

wire Q_not, S_not, R_not, D1, D2;

nand latch1 (Q_not, Q, rst);
nand latch2 (Q, Q_not, D1);


not gate1 (S_not, S);
not gate2 (R_not, R);
and gate3 (D1, S_not, R);
and gate4 (D2, S, R_not);
or gate5 (D1, D1, D2);

and gate6 (Q, Q_not, clk);

endmodule