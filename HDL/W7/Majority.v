module majority_4bit (
    input  [3:0] A,
    output reg Y
);

always @(*) begin
    if (A[0] + A[1] + A[2] + A[3] >= 3)
        Y = 1;
    else
        Y = 0;
end

endmodule
