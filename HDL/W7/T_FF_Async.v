    module T_FF_Async (
        input T,           
        input clk,         
        input reset,       
        output reg Q            
    );

    always @(posedge clk or posedge reset) begin
        if (reset)             
            Q <= 1'b0;         
        else if (T)
            Q <= ~Q;           
    end

    endmodule
