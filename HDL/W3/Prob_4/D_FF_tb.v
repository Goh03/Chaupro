`timescale 1ps/1ps
module D_FF_tb();

reg D, clk, rst;
wire Q;

D_FF dut (D, clk, rst, Q);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("D = %b, Q = %b", D, Q);
    D = 1;
    #10;
    D = 0;
    #10;
    D = 1;
    #10;

    $finish;
end

endmodule