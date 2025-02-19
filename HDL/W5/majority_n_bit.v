module majority_n_bit #(parameter N = 4) (
    input [N-1:0] a,
    output F
);
    reg[N-1:0] sum;
    integer i;

    always @(a) begin
        sum = 0;
        for (i = 0; i < N; i = i + 1) begin 
            sum = sum + a[i];
        end
    end 

    assign F = (sum > (N >> 1)) ? 1'b1 : 1'b0;

endmodule
