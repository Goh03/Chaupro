module encoder (
    input [7:0] D,
    output X,Y,Z
);
    
or  or_1(X,D[4],D[5],D[6],D[7]),
    or_2(Y,D[2],D[3],D[6],D[7]),
    or_3(Z,D[1],D[3],D[5],D[7]);

endmodule