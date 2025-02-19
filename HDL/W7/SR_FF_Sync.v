module SR_FF_Sync (
    input s,
    input r,
    input clk,
    input reset,
    output reg Q
);

always @(posedge clk) begin
    if (reset) 
        Q <= 1'b0;          
    else begin
        case ({s, r})
            2'b00: 
                Q <= Q;      
            2'b01: 
                Q <= 1'b0;   
            2'b10: 
                Q <= 1'b1;   
            2'b11: 
                Q <= 1'bx;   
            default: 
                Q <= Q;      
        endcase
    end
end

endmodule
