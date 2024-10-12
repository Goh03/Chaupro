`timescale 1ps/1ps
module Gray_Counter_n_bit_tb();
    parameter N = 4;
    reg clk;
    reg reset;
    wire [N-1:0] gray_code;

    Gray_Counter_n_bit #(N) dut (
        .clk(clk),
        .reset(reset),
        .gray_code(gray_code)
    );

    initial begin
        clk = 0;
        reset = 1;
        #5 reset = 0;
        #160 $stop;
    end

    always #5 clk = ~clk;

    initial begin
        $monitor("Time = %0d, Reset = %b, Gray Code = %b", $time, reset, gray_code);
    end

endmodule
