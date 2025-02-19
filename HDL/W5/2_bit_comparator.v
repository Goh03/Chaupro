module Two_bit_compartor (
    input A1, A0,  
    input B1, B0,   
    output A_gt_B,  
    output A_lt_B,  
    output A_eq_B  
);

    assign A_gt_B = (A1 & ~B1) | (A1 & A0 & ~B0) | (A0 & ~B1 & ~B0);

    assign A_lt_B = (~A1 & B1) | (~A1 & ~A0 & B0) | (~A0 & B1 & B0);

    assign A_eq_B = ((A1 ~^ B1) & (A0 ~^ B0));

endmodule
