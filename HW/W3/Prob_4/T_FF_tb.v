`timescale 1ps/1ps
module T_FF_tb ();
reg T,clk,rst,Q;
wire Qn;

T_FF dut (.T(T), .clk(clk), .rst(rst), .Q(Q), .Qn(Qn));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("T = %b, Q = %b", T, Q);
    rst = 1;
    #10 rst = 0;
    Q = 0;
    T = 0; #10;
    T = 1; #10;
    T = 1; #10;
    T = 0; #10;
    T = 1; #10;
    T = 0; #10;
    $finish;
end
endmodule