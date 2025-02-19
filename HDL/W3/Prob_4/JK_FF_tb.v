`timescale 1ps/1ps
module JK_FF_tb();
reg J, K, clk,rst,Q;
wire Qn;

JK_FF dut (.J(J), .K(K), .clk(clk), .rst(rst), .Q(Q), .Qn(Qn));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("J = %b, K = %b, Q = %b", J, K, Q);
    rst = 1;
    #10 rst = 0;
    Q = 1;
    J = 0; K = 0; #10;
    J = 0; K = 1; #10;
    J = 1; K = 0; #10;
    J = 1; K = 1; #10;
    J = 0; K = 0; #10;
    $finish;
end

endmodule