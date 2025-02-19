module JK_FF (
    input J, K, clk, rst, Q,
    output reg Qn
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Qn <= 1;
    end else begin
        if (J && K) begin
            Qn <= ~Q;
        end else if (J) begin
            Qn <= 1;
        end else if (K) begin
            Qn <= 0;
	    end else begin
            Qn <= Q;
        end
    end
end

endmodule