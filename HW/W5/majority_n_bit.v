// module majority_n_bit #(
//     parameter N = 4
// ) (
//     input [N-1:0] a,
//     output reg F
// );

//     integer i;
//     integer count;

//     always @(*) begin
//         count = 0;
//         for (i = 0; i < N; i = i + 1) begin
//             count = count + a[i];
//         end
//         F = (count > N / 2);
//     end

// endmodule

module majority_n_bit #(parameter N = 5) (
    input [N-1:0] a,
    output F
);

    wire [$clog2(N+1)-1:0] count_ones;
    wire [$clog2(N+1)-1:0] temp[N:0];
    genvar i;
    assign temp[0] = 0;

    generate    
        for (i = 0; i < N; i = i + 1) begin : count_bits
            assign temp[i+1] = temp[i] + a[i];
        end
    endgenerate
    
    assign count_ones = temp[N];
    assign F = (count_ones > (N / 2)) ? 1'b1 : 1'b0;

endmodule
