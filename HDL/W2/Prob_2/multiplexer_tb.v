`timescale 1ps/1ps
module multiplexer_tb ();
    
reg S,A,B;
wire Y;
integer i;

multiplexer dut(
    .S(S),
    .A(A),
    .B(B),
    .Y(Y)
);

initial begin
    //S = 0; A = 0; B = 0;
    for(i=0;i<8;i=i+1)
        begin
            {S,A,B} = i;
            #10 $display("%b %b %b | %b",S,A,B,Y);
        end
    $finish;
end
endmodule