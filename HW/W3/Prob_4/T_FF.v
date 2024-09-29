module T_FF (
    T, clk, rst, Q, Qn
);
    input T, clk, rst, Q;
    output Qn;
    wire D1, D2;

    D_FF dff1 (D1, clk, rst, Q);
    xor gate1 (D2, T, Q);
    D_FF dff2 (D2, clk, rst, Qn);

endmodule
