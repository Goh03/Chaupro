module Ripple_Carry_Counter (
    clk,rst,q
);
    input clk,rst;
    output [3:0]q;
    wire [3:0] Qn;

    T_FF tff1 (
        .T(1'b1),           
        .clk(clk),
        .rst(rst),
        .Q(q[0]),
        .Qn(Qn[0])
    );

    T_FF tff2 (
        .T(q[0]),         
        .clk(clk),
        .rst(rst),
        .Q(q[1]),
        .Qn(Qn[1])
    );

    T_FF tff3 (
        .T(q[1]),          
        .clk(clk),
        .rst(rst),
        .Q(q[2]),
        .Qn(Qn[2])
    );

    T_FF tff4 (
        .T(q[2]),          
        .clk(clk),
        .rst(rst),
        .Q(q[3]),
        .Qn(Qn[3])
    );

endmodule