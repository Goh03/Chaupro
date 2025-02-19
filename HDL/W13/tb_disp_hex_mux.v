`timescale 1ns / 1ns
module tb_disp_hex_mux;
    reg clk, reset;
    reg [3:0] hex3, hex2, hex1, hex0;
    reg [3:0] dp_in;
    wire [3:0] an;
    wire [7:0] sseg;

    disp_hex_mux uut (
        .clk(clk),
        .reset(reset),
        .hex3(hex3),
        .hex2(hex2),
        .hex1(hex1),
        .hex0(hex0),
        .dp_in(dp_in),
        .an(an),
        .sseg(sseg)
    );

    // Clock generation (50 MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        reset = 1;
        hex3 = 4'hF;
        hex2 = 4'hA;
        hex1 = 4'h5;
        hex0 = 4'h3;
        dp_in = 4'b1111; 

        #20 reset = 0;

        #100;
        hex3 = 4'h9;
        hex2 = 4'h4;
        hex1 = 4'h1;
        hex0 = 4'h0;
        dp_in = 4'b1001; 

        #200;
        hex3 = 4'hC;
        hex2 = 4'hE;
        hex1 = 4'h7;
        hex0 = 4'h2;
        dp_in = 4'b0100; 

        #6000000 $stop;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | reset=%b | an=%b | sseg=%b", $time, reset, an, sseg);
    end

endmodule
