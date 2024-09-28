module JK_FF (J, K, CLK, rst, Q);
input J, K, CLK, rst;
output Q;

wire Q_not, J_not, K_not, D1, D2;

nand latch1 (Q_not, Q, rst);
nand latch2 (Q, Q_not, D1);

not gate1 (J_not, J);
not gate2 (K_not, K);
and gate3 (D1, J, K_not);
and gate4 (D2, J_not, K);
or gate5 (D1, D1, D2);

and gate6 (Q, Q_not, CLK);

endmodule