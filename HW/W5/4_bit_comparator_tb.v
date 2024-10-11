`timescale 1ps/1ps
module Four_bit_compartor_tb();
    reg A3, A2, A1, A0;  
    reg B3, B2, B1, B0;  
    wire A_gt_B;    
    wire A_lt_B;       
    wire A_eq_B;       

    Four_bit_compartor dut (
        .A3(A3), .A2(A2), .A1(A1), .A0(A0),
        .B3(B3), .B2(B2), .B1(B1), .B0(B0),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B),
        .A_eq_B(A_eq_B)
    );

    initial begin
        $display("A3 A2 A1 A0 | B3 B2 B1 B0 | A gt B | A lt B | A == B");
        $display("-----------------------------------------------");
        $monitor(" %b  %b  %b  %b  |  %b  %b  %b  %b  |   %b   |   %b   |   %b", A3, A2, A1, A0, B3, B2, B1, B0, A_gt_B, A_lt_B, A_eq_B);

        A3 = 0; A2 = 0; A1 = 0; A0 = 0; B3 = 0; B2 = 0; B1 = 0; B0 = 0; #10;
        A3 = 0; A2 = 0; A1 = 0; A0 = 1; B3 = 0; B2 = 0; B1 = 0; B0 = 1; #10;
        A3 = 0; A2 = 1; A1 = 0; A0 = 1; B3 = 0; B2 = 1; B1 = 0; B0 = 0; #10;
        A3 = 1; A2 = 0; A1 = 1; A0 = 1; B3 = 0; B2 = 1; B1 = 1; B0 = 1; #10;
        A3 = 1; A2 = 1; A1 = 1; A0 = 1; B3 = 1; B2 = 1; B1 = 1; B0 = 0; #10;
        A3 = 1; A2 = 1; A1 = 1; A0 = 1; B3 = 1; B2 = 1; B1 = 1; B0 = 1; #10;
        $finish;
    end
endmodule
