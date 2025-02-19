`timescale 1ns / 1ns
module tb_disp_mux;
    reg clk;
    reg reset;
    reg [7:0] in3, in2, in1, in0;
    wire [3:0] an;
    wire [7:0] sseg;

    disp_mux uut (
        .clk(clk),
        .reset(reset),
        .in3(in3),
        .in2(in2),
        .in1(in1),
        .in0(in0),
        .an(an),
        .sseg(sseg)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20 ns period -> 50 MHz
    end

    // Test stimulus
    initial begin       
        // Monitor signals
        $monitor("Time=%0t | an=%b | sseg=%b | q_reg=%h", $time, an, sseg, uut.q_reg);

        reset = 1;
        in3 = 8'b10000000;
        in2 = 8'b01000000;
        in1 = 8'b00100000;
        in0 = 8'b00010000;

        #20 reset = 0;

        in0 = 8'b11110000;
        in1 = 8'b11001100;
        in2 = 8'b10101010;
        in3 = 8'b10000001;

        #500 $stop;
    end
endmodule
