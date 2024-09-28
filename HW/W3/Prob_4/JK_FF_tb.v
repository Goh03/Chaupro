`timescale 1ps/1ps
module JK_FF_tb();
reg J, K, clk;
wire Q;

JK_FF dut (.J(J), .K(K), .clk(clk), .rst(rst), .Q(Q));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("J = %b, K = %b, Q = %b", J, K, Q);
    J = 0; K = 0; #10;
    J = 0; K = 1; #10;
    J = 1; K = 0; #10;
    J = 1; K = 1; #10;
    J = 0; K = 0; #10;
    $finish;
end

endmodule