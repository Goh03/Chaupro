module T_FF (
    input T, clk, rst,
    output reg Q
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 1'b0;   
        else if (T)
            Q <= ~Q;     
    end
endmodule
