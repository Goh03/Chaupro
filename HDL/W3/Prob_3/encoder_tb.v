`timescale 1ps/1ps
module encoder_tb ();
    
reg [7:0] D;
wire X,Y,Z;

encoder dut(
    .D(D),
    .X(X),
    .Y(Y),
    .Z(Z)
);

initial begin
    $monitor ("D = %b | X = %b | Y = %b | Z = %b", D,X,Y,Z);
    D = 8'b00000001; #10;  
    D = 8'b00000010; #10;  
    D = 8'b00000100; #10; 
    D = 8'b00001000; #10;
    D = 8'b00010000; #10;  
    D = 8'b00100000; #10;  
    D = 8'b01000000; #10;  
    D = 8'b10000000; #10;  
    $finish;
end
endmodule