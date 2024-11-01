`timescale 1ps/1ps
module SR_FF_Sync_tb();
    reg s;
    reg r;
    reg clk;
    reg reset;
    wire Q;

    SR_FF_Sync dut (
        .s(s),
        .r(r),
        .clk(clk),
        .reset(reset),
        .Q(Q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        $monitor("reset=%b, S=%b, R=%b, clk=%b, Q=%b", reset, s, r, clk, Q);
        reset = 0; s = 0; r = 0; #10; 
        reset = 1; #10; 
        reset = 0; #10; 
        s = 0; r = 0; #10; 
        s = 1; r = 0; #10; 
        s = 0; r = 1; #10; 
        s = 1; r = 1; #10; 
        reset = 1; #10; 
        reset = 0; #10;  
        $finish; 
    end
endmodule
