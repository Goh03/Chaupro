`timescale 1ps/1ps
module BCD_to_7Segment_tb();
    reg [3:0] bcd;         
    wire [6:0] seg;       

    BCD_to_7Segment dut (
        .bcd(bcd),
        .seg(seg)
    );

    initial begin
        for (bcd = 0; bcd < 10; bcd = bcd + 1) begin
            #10;
            $display("BCD = %b, Segments = %b", bcd, seg);
        end
        $finish;
    end
endmodule