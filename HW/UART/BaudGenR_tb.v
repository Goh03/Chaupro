// Testbench for BaudGenR module

`timescale 1ns/1ns

module BaudGenR_tb;

    // Inputs
    reg reset_n;
    reg clock;
    reg [1:0] baud_rate;

    // Outputs
    wire baud_clk;

    // Instantiate the Unit Under Test (UUT)
    BaudGenR dut (
        .reset_n(reset_n),
        .clock(clock),
        .baud_rate(baud_rate),
        .baud_clk(baud_clk)
    );

    // Clock generation (50MHz -> Period = 20ns)
    initial begin
        clock = 0;
        forever #10 clock = ~clock; // Toggle clock every 10ns
    end

    initial begin
            reset_n = 1'b0;
        #100  reset_n = 1'b1;
    end

    //  Test
    integer i = 0;
    initial 
    begin
        //  Testing for all the rates available
        for (i = 0; i < 4; i = i +1) 
        begin
            baud_rate = i;
            //  enough time for about 4 cycles for each baud rate
            #(150000/(i+1));
        end
    end

    //  Stop
    initial begin
        #310000 $stop;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | reset_n=%b | clock=%b | baud_rate=%b | baud_clk=%b", 
                 $time, reset_n, clock, baud_rate, baud_clk);
    end

endmodule
