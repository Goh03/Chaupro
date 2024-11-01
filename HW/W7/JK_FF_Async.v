module JK_FF_Async (
    input J,
    input K,
    input clk,
    input reset,
    output reg Q
);

always @(posedge clk or posedge reset) begin
    if (reset) 
        Q <= 1'b0;          
    else begin
        case ({J, K})
            2'b00: 
                Q <= Q;      
            2'b01: 
                Q <= 1'b0;   
            2'b10: 
                Q <= 1'b1;   
            2'b11: 
                Q <= ~Q;   
            default: 
                Q <= Q;      
        endcase
    end
end

endmodule
