`timescale 1ps/1ps
module Ripple_Carry_Counter_tb();
    reg clk;
    reg rst;
    wire [3:0] q;

    Ripple_Carry_Counter dut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $monitor("Reset: %b | Count: %b", rst, q);
        rst = 1;
        #10;
        rst = 0;
        #100;
        rst = 1;
        #10;
        rst = 0;
        #100;
        $finish;
    end
endmodule
