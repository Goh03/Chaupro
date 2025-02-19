`timescale 1ps/1ps
module Two_bit_comparator_tb();
    reg A1, A0;
    reg B1, B0;
    wire A_gt_B;
    wire A_lt_B;
    wire A_eq_B;

    Two_bit_comparator dut (
        .A1(A1), .A0(A0),
        .B1(B1), .B0(B0),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B),
        .A_eq_B(A_eq_B)
    );

    initial begin
        $display("A1 A0 | B1 B0 | A gt B | A lt B | A == B");
        $display("----------------------------------------");
        $monitor(" %b  %b  |  %b  %b  |   %b   |   %b   |   %b", A1, A0, B1, B0, A_gt_B, A_lt_B, A_eq_B);
        A1 = 0; A0 = 0; B1 = 0; B0 = 0; #10;
        A1 = 0; A0 = 0; B1 = 0; B0 = 1; #10;
        A1 = 0; A0 = 1; B1 = 0; B0 = 0; #10;
        A1 = 0; A0 = 1; B1 = 0; B0 = 1; #10;
        A1 = 1; A0 = 0; B1 = 0; B0 = 1; #10;
        A1 = 1; A0 = 1; B1 = 1; B0 = 0; #10;
        A1 = 1; A0 = 1; B1 = 1; B0 = 1; #10;
        $finish;
    end

endmodule
