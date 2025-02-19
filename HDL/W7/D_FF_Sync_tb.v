`timescale 1ps/1ps
module D_FF_Sync_tb();
    reg D;               
    reg clk;             
    reg reset;           
    wire Q;              
    
    D_FF_Sync dut (
        .D(D),
        .clk(clk),
        .reset(reset),
        .Q(Q)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        $monitor("D = %b, reset = %b, Q = %b", D, reset, Q);
        D = 0; 
        reset = 0; #10;
        reset = 1; #10;
        reset = 0; #10;
        D = 1; #10;
        D = 0; #10;
        D = 1; #10;  
        reset = 1; #10;        
        $finish;  
    end
endmodule
