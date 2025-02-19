`timescale 1ns/1ns

module PISO_tb;

// Test Inputs
reg           reset_n;
reg           send;
reg           baud_clk;
reg           parity_bit;
reg [1:0]     parity_type;
reg [7:0]     data_in;

// Test Outputs
wire          data_tx;
wire          active_flag;
wire          done_flag;

// Instantiate the PISO module
PISO dut (
    .reset_n(reset_n),
    .send(send),
    .baud_clk(baud_clk),
    .parity_bit(parity_bit),
    .parity_type(parity_type),
    .data_in(data_in),
    .data_tx(data_tx),
    .active_flag(active_flag),
    .done_flag(done_flag)
);

// Dump waveform data
initial begin
    $dumpfile("PISO_Test.vcd");
    $dumpvars(0, PISO_tb);
end

// Monitor inputs and outputs
initial begin
    $monitor($time, 
        " Outputs: DataTx = %b, ActiveFlag = %b, DoneFlag = %b | Inputs: Send = %b, Reset = %b, ParityType = %b, ParityBit = %b, DataIn = %b",
        data_tx, active_flag, done_flag, send, reset_n, parity_type, parity_bit, data_in);
end

//   Resetting the system
initial begin
         reset_n = 1'b0;
    #100 reset_n = 1'b1;
end

//   Set up a clock "Baudrate"
//   For example: Baud Rate of 9600
initial
begin
    baud_clk = 1'b0;
    forever
    begin
     #104166.667 baud_clk = ~baud_clk;
    end
end

//   Set up the send signal
initial begin
          send = 1'b0;
    #1000 send = 1'b1;
end 

//   Various Data In 
initial begin
    data_in = 8'b01001010;
    #8000000
    data_in = 8'b01011010;
    #2291653;
end

//   Varying the stopits, datalength, paritytype >>> 4-bits with 16 different cases with 8 ignored cases <<<
initial
begin
     //  no parity
     parity_type = 2'b00;
     parity_bit  = 1'b1;
     //   odd parity
     #2700000;
     parity_type = 2'b01;
     parity_bit  =   (^(data_in))? 1'b0 : 1'b1;
     //  even parity
     #2700000;
     parity_type = 2'b10;
     parity_bit  =   (^(data_in))? 1'b1 : 1'b0;
     //  no parity
     #2700000;
     parity_type = 2'b11;
     parity_bit  =  1'b1;
     #2700000;
end

initial begin
    #12000000 $stop;
end

endmodule