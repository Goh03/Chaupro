module Ripple_Carry_Counter (
    input clk, rst,
    output [3:0] q
);
    T_FF tff0 (
        .T(1'b0),      
        .clk(clk),
        .rst(rst),
        .Q(q[0])      
    );
    T_FF tff1 (
        .T(q[0]),      
        .clk(q[0]),
        .rst(rst),
        .Q(q[1])      
    );
    T_FF tff2 (
        .T(q[1]),      
        .clk(q[1]),
        .rst(rst),
        .Q(q[2])       
    );
    T_FF tff3 (
        .T(q[2]),     
        .clk(q[2]),
        .rst(rst),
        .Q(q[3])       
    );

endmodule
