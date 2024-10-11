module Carry_Look_Ahead_Adder_n_bit #(
    parameter N = 4
) (
    input [N-1:0] a, b,
    input cin,
    output cout,
    output [N-1:0] sum
);
    wire [N-1:0] g, p;
    wire [N:0] c;
    
    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] ^ b[i];
        end
    endgenerate

    generate
        for (i = 1; i <= N; i = i + 1) begin
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    generate
        for (i = 0; i < N; i = i + 1) begin
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

    assign cout = c[N];

endmodule
