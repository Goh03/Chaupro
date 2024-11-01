`timescale 1ps / 1ps
module T_FF_Async_tb();
    reg T;               
    reg clk;             
    reg reset;           
    wire Q;              

    T_FF_Async dut (
        .T(T),
        .clk(clk),
        .reset(reset),
        .Q(Q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $monitor("T = %b, reset = %b, Q = %b", T, reset, Q);
        T = 0; 
        reset = 0; #10;
        reset = 1; #10;
        reset = 0; #10;
        T = 1; #10;
        T = 0; #10;
        T = 1; #10;  
        reset = 1; #10;        
        $finish;  
    end
endmodule
