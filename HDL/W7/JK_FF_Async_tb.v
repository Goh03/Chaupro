`timescale 1ps/1ps
module JK_FF_Async_tb();
    reg J;
    reg K;
    reg clk;
    reg reset;
    wire Q;

    JK_FF_Async dut (
        .J(J),
        .K(K),
        .clk(clk),
        .reset(reset),
        .Q(Q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        $monitor("reset=%b, J=%b, K=%b, clk=%b, Q=%b", reset, J, K, clk, Q);
        reset = 0; J = 0; K = 0; #10; 
        reset = 1; #10; 
        reset = 0; #10; 
        J = 1; K = 0; #10; 
        J = 0; K = 1; #10; 
        J = 1; K = 1; #10; 
        J = 0; K = 0; #10; 
        reset = 1; #10; 
        reset = 0; #10;  
        $finish; 
    end
endmodule
