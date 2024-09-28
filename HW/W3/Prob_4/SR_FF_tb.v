`timescale 1ps/1ps
module SR_FF_tb ();
    
reg S, R, clk, rst;
wire Q;

SR_FF dut (
    .S(S),
    .R(R),
    .clk(clk),
    .rst(rst),
    .Q(Q)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $monitor("S = %b, R = %b, Q = %b", S, R, Q);
    S = 0; R = 0; #10;
    S = 1; R = 0; #10;
    S = 0; R = 1; #10;
    S = 1; R = 1; #10;
    S = 0; R = 0; #10;
    $finish;
end

endmodule