module T_FF (
    T, clk, rst, Q
);
    input T, clk, rst;
    output Q;
    wire D1, D2, Q_prev;

    D_FF dff1 (D1, clk, rst, Q_prev);
    xor gate1 (D2, T, Q_prev);
    D_FF dff2 (D2, clk, rst, Q);

endmodule
