`timescale 1ps/1ps
module Four_bit_compartor_tb();
    reg [3:0] A;
    reg [3:0] B;
    wire A_gt_B;
    wire A_lt_B;
    wire A_eq_B;      

    Four_bit_compartor dut (
        .A(A),
        .B(B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B),
        .A_eq_B(A_eq_B)
    );

    initial begin
        $display("A    | B    | A > B | A < B | A == B");
        $display("--------------------------------------------");
        A = 4'b0000; B = 4'b0000; #10;
        $monitor("%b | %b |   %b   |   %b   |   %b", A, B, A_gt_B, A_lt_B, A_eq_B);
        A = 4'b0001; B = 4'b0000; #10;
        A = 4'b0010; B = 4'b0011; #10;
        A = 4'b0110; B = 4'b0100; #10;
        A = 4'b1000; B = 4'b1000; #10;
        A = 4'b1010; B = 4'b1001; #10;
        A = 4'b1111; B = 4'b0000; #10;
        A = 4'b0111; B = 4'b1111; #10;
        A = 4'b0001; B = 4'b0001; #10;
        $finish;
    end
endmodule
