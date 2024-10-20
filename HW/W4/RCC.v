module Ripple_Carry_Counter (
    input clk, rst,
    output [3:0] q
);
    T_FF tff0 (
        .T(1'b1),      
        .clk(clk),
        .rst(rst),
        .Q(q[0])      
    );
    T_FF tff1 (
        .T(q[0]),      
        .clk(clk),
        .rst(rst),
        .Q(q[1])      
    );
    T_FF tff2 (
        .T(q[1]),      
        .clk(clk),
        .rst(rst),
        .Q(q[2])       
    );
    T_FF tff3 (
        .T(q[2]),     
        .clk(clk),
        .rst(rst),
        .Q(q[3])       
    );

endmodule
