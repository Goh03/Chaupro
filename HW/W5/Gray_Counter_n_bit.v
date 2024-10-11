module Gray_Counter_n_bit #(
    parameter N = 4
) (
    input clk,
    input reset,
    output reg [N-1:0] gray_out
);
    reg [N-1:0] binary_count;

    always @(posedge clk or posedge reset) begin
        if (reset)
            binary_count <= 0;
        else
            binary_count <= binary_count + 1;
    end

    assign gray_out = binary_count ^ (binary_count >> 1);

endmodule
