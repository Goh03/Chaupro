//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: ParityTest.v
//  TYPE: Test fixture "Test bench".
//  DATE: 30/8/2022
//  KEYWORDS: Parity.

`timescale 1ns/1ns
module Parity_tb;

//  Regs to drive the inputs
reg       reset_n;
reg [7:0] data_in;
reg [1:0] parity_type;

//  wire to show the output
wire      parity_bit;

//  Instatniation of the design module
Parity dut(
    .data_in(data_in),
    .reset_n(reset_n),
    .parity_type(parity_type),

    .parity_bit(parity_bit)
);

//  dump
initial
begin
    $dumpfile("ParityTest.vcd");
    $dumpvars;
end

//  Monitoring the outputs and the inputs
initial begin
    $monitor($time, "   The Outputs:  Parity Bit = %b  The Inputs:   Parity Type = %b  Reset = %b  Data In = %b",
    parity_bit, parity_type[1:0], reset_n, data_in);
end

//  Resetting the system
initial
begin
    reset_n = 1'b0;
    #10 reset_n = 1'b1;
end

//  Test
initial
begin
        data_in = 8'b00010111;
    #10 data_in = 8'b00001111;
    #10 data_in = 8'b10101111;
    #10 data_in = 8'b10101001;
    #10 data_in = 8'b10101001;
    #10 data_in = 8'b10111101;
end

//  Parity Types
initial
begin
        parity_type = 2'b00;
    #10 parity_type = 2'b00;
    #10 parity_type = 2'b01;
    #10 parity_type = 2'b10;
    #10 parity_type = 2'b11;
end

endmodule