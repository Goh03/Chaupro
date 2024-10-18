module Four_bit_compartor (
    input [3:0] A,
    input [3:0] B,
    output A_gt_B,
    output A_lt_B,
    output A_eq_B
);
    wire high_greater, high_less, high_equal;
    wire low_greater, low_less, low_equal;

    Two_bit_comparator msb_comparator (
        .A1(A[3]), .A0(A[2]),
        .B1(B[3]), .B0(B[2]),
        .A_gt_B(high_greater),
        .A_lt_B(high_less),
        .A_eq_B(high_equal)
    );

    Two_bit_comparator lsb_comparator (
        .A1(A[1]), .A0(A[0]),
        .B1(B[1]), .B0(B[0]),
        .A_gt_B(low_greater),
        .A_lt_B(low_less),
        .A_eq_B(low_equal)
    );

    assign A_gt_B = high_greater | (high_equal & low_greater);
    assign A_lt_B = high_less | (high_equal & low_less);
    assign A_eq_B = high_equal & low_equal;

endmodule
