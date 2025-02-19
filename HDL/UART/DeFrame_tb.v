// Testbench for DeFrame module

`timescale 1ns/1ns

module DeFrame_tb;

    // Inputs
    reg reset_n;
    reg recieved_flag;
    reg [10:0] data_parll;

    // Outputs
    wire parity_bit;
    wire start_bit;
    wire stop_bit;
    wire done_flag;
    wire [7:0] raw_data;

    // Instantiate the Unit Under Test (UUT)
    DeFrame dut (
        .reset_n(reset_n),
        .recieved_flag(recieved_flag),
        .data_parll(data_parll),
        .parity_bit(parity_bit),
        .start_bit(start_bit),
        .stop_bit(stop_bit),
        .done_flag(done_flag),
        .raw_data(raw_data)
    );

    // Testbench process
    initial begin
        // Initialize signals
        reset_n = 0;
        recieved_flag = 0;
        data_parll = 11'b11111111111;

        // Apply reset
        #10 reset_n = 1;

        // Test case 1: Valid frame input
        #10 recieved_flag = 1; data_parll = 11'b111101010110; // Start bit: 0, Data: 8'b10101010, Parity: 1, Stop bit: 1
        #10 recieved_flag = 0;

        // Test case 2: Another valid frame input
        #10 recieved_flag = 1; data_parll = 11'b11011111100; // Start bit: 0, Data: 8'b01111000, Parity: 0, Stop bit: 1
        #10 recieved_flag = 0;

        // Test case 3: Reset during operation
        #10 reset_n = 0;
        #10 reset_n = 1;

        // Test case 4: Idle condition
        #10 recieved_flag = 0; data_parll = 11'b11011111100;

        // Hold simulation for observation
        #10 $stop;
    end

    // Monitor output signals
    initial begin
        $monitor("Time=%0t | reset_n=%b | recieved_flag=%b | data_parll=%b | start_bit=%b | raw_data=%b | parity_bit=%b | stop_bit=%b | done_flag=%b",
                 $time, reset_n, recieved_flag, data_parll, start_bit, raw_data, parity_bit, stop_bit, done_flag);
    end

endmodule
