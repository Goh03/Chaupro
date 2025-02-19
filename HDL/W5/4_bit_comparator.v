module Four_bit_compartor (
    input A3, A2, A1, A0,  
    input B3, B2, B1, B0,  
    output A_gt_B,    
    output A_lt_B,       
    output A_eq_B       
);
    wire high_greater, high_less, high_equal;
    wire low_greater, low_less, low_equal;

    Two_bit_compartor high_comp (
        .A1(A3), .A0(A2),
        .B1(B3), .B0(B2),
        .A_gt_B(high_greater),
        .A_lt_B(high_less),
        .A_eq_B(high_equal)
    );

    Two_bit_compartor low_comp (
        .A1(A1), .A0(A0),
        .B1(B1), .B0(B0),
        .A_gt_B(low_greater),
        .A_lt_B(low_less),
        .A_eq_B(low_equal)
    );

    assign A_gt_B = high_greater | (high_equal & low_greater);
    assign A_lt_B = high_less | (high_equal & low_less);
    assign A_eq_B = high_equal & low_equal;

endmodule
