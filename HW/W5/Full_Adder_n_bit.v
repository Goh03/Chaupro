module Full_Adder (
    input x, y, c_in,
    output s, c_out
);
    assign s = x ^ y ^ c_in;                 
    assign c_out = (x & y) | (c_in & (x ^ y)); 
endmodule

module n_Bit_Full_Adder #(parameter N = 4) (
    input [N-1:0] a, b,
    input cin,
    output [N-1:0] s,
    output cout
);
    wire [N:0] c; 
    assign c[0] = cin; 
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : full_adder_loop
            Full_Adder fa (
                .x(a[i]),
                .y(b[i]),
                .c_in(c[i]),
                .s(s[i]),
                .c_out(c[i + 1])
            );
        end
    endgenerate
    assign cout = c[N]; 
endmodule
