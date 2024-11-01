`timescale 1ps/1ps
module bcd_to_7seg_tb();
    reg [3:0] BCD;      
    wire [6:0] Seg;      

    bcd_to_7seg dut (
        .BCD(BCD),
        .Seg(Seg)
    );

    initial begin
        $monitor("BCD = %b, Seg = %b", BCD, Seg);
        BCD = 4'b0000; #10
        BCD = 4'b0001; #10
        BCD = 4'b0010; #10
        BCD = 4'b0011; #10
        BCD = 4'b0100; #10
        BCD = 4'b0101; #10
        BCD = 4'b0110; #10
        BCD = 4'b0111; #10
        BCD = 4'b1000; #10
        BCD = 4'b1001; #10
        BCD = 4'b1010; #10
        BCD = 4'b1011; #10
        BCD = 4'b1100; #10
        BCD = 4'b1101; #10
        BCD = 4'b1110; #10
        BCD = 4'b1111; #10
        #10 $finish;  
    end

endmodule
