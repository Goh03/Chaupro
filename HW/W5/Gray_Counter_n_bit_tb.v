`timescale 1ps/1ps
module Gray_Counter_n_bit_tb();
    parameter N = 4;
    reg clk;
    reg reset;
    wire [N-1:0] gray_out;

    Gray_Counter #(.N(N)) uut (
        .clk(clk),
        .reset(reset),
        .gray_out(gray_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
        
        $monitor("Time: %0dns, Reset: %b, Gray Code: %b", $time, reset, gray_out);

        reset = 1;
        #10;
        reset = 0;
        #100;
        $stop;
    end

endmodule
