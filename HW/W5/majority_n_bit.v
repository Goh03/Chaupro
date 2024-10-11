module majority_n_bit #(
    parameter N = 4
) (
    input [N-1:0] a,
    output reg F
);

    integer i;
    integer count;

    always @(*) begin
        count = 0;
        for (i = 0; i < N; i = i + 1) begin
            count = count + a[i];
        end
        F = (count > N / 2);
    end

endmodule
