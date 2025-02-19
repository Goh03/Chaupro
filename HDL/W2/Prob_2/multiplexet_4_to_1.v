module multiplexer_4_to_1 (
    Y,S0,S1,A,B,C,D
);
    input S0,S1,A,B,C,D;
    output Y;

    wire Y1,Y2;
    multiplexer mux1 (Y1,S0,A,B);
    multiplexer mux2 (Y2,S0,C,D);
    multiplexer mux3 (Y,S1,Y1,Y2);

endmodule