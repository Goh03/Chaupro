module decoder (
    input X,Y,Z,
    output [7:0] D
);
    wire n1,n2,n3;

    not not_x(n1,X),
        not_y(n2,Y),
        not_z(n3,Z);
    
    and a1(D[0],n1,n2,n3),
        a2(D[1],n1,n2,Z),
        a3(D[2],n1,Y,n3),
        a4(D[3],n1,Y,Z),
        a5(D[4],X,n2,n3),
        a6(D[5],X,n2,Z),
        a7(D[6],X,Y,n3),
        a9(D[7],X,Y,Z);

endmodule