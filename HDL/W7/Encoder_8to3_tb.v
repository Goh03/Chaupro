`timescale 1ps/1ps
module encoder_8to3_tb();
    reg [7:0] Y;
    wire [2:0] A;

    encoder_8to3 dut (
        .Y(Y),
        .A(A)
    );
    
    initial begin
        $monitor("Y = %b, A = %b", Y, A);
        Y = 8'b00000000;
        #10 Y = 8'b00000001;
        #10 Y = 8'b00000010;
        #10 Y = 8'b00000100;
        #10 Y = 8'b00001000;
        #10 Y = 8'b00010000;
        #10 Y = 8'b00100000;
        #10 Y = 8'b01000000;
        #10 Y = 8'b10000000;
        #10 $finish;
    end
    
endmodule
