module Gray_Counter_n_bit #(parameter N = 4) (
    input clk,
    input reset,
    output reg [N-1:0] gray_code
);

    reg [N-1:0] binary_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            binary_counter <= 0;
            gray_code <= 0;
        end else begin
            binary_counter <= binary_counter + 1;
            gray_code <= binary_counter ^ (binary_counter >> 1);
        end
    end
endmodule
