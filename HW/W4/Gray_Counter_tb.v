`timescale 1ps/1ps
module Gray_Counter_4bit_tb();
    reg clk;
    reg rst;
    wire [3:0] gray;

    Gray_Counter_4bit dut (
        .clk(clk),
        .rst(rst),
        .gray(gray)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        $monitor("Reset: %b, Gray Code: %b", rst, gray);
        rst = 1;
        #10;
        rst = 0;
        #100;
        $display("Time: % dns, Reset: %b, Gray Code: %b", $time, rst, gray);
        $finish;
    end
endmodule
