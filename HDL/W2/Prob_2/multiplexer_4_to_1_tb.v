`timescale 1ps/1ps
module multiplexer_4_to_1_tb();
    reg S0, S1, A, B, C, D;    
    wire Y;            

    multiplexer_4_to_1 dut (
        .Y(Y),
        .S0(S0),
        .S1(S1),
        .A(A),
        .B(B),
        .C(C),
        .D(D)
    );

    initial begin
        $monitor("S1=%b S0=%b | A=%b B=%b C=%b D=%b | Y=%b", S1, S0, A, B, C, D, Y);
        S0 = 0; S1 = 0; A = 0; B = 0; C = 0; D = 0;
        #10 A = 1; B = 0; C = 0; D = 0; S0 = 0; S1 = 0; 
        #10 A = 0; B = 1; C = 0; D = 0; S0 = 1; S1 = 0; 
        #10 A = 0; B = 0; C = 1; D = 0; S0 = 0; S1 = 1; 
        #10 A = 0; B = 0; C = 0; D = 1; S0 = 1; S1 = 1; 
        #10 A = 1; B = 0; C = 1; D = 0; S0 = 0; S1 = 0; 
        #10 A = 1; B = 0; C = 1; D = 0; S0 = 1; S1 = 0; 
        #10 A = 1; B = 0; C = 1; D = 0; S0 = 0; S1 = 1; 
        #10 A = 1; B = 0; C = 1; D = 1; S0 = 1; S1 = 1; 
        
        #10 $finish;
    end
endmodule
