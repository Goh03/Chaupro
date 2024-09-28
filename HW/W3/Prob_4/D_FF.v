module D_FF (
    D,clk,rst,Q
);

input D,clk,rst;
output Q;

reg Q;

always @(posedge clk or posedge rst) begin
    if (rst)
        Q <= 0;
    else if (clk)
        Q <= D;
end

endmodule