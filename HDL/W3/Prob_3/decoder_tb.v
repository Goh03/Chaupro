`timescale 1ps/1ps
module decoder_tb ();

reg X,Y,Z;
wire [7:0] D;
integer i;

decoder dut(
    .X(X),
    .Y(Y),
    .Z(Z),
    .D(D)
);

initial begin
    $monitor ("X = %b | Y = %b | Z = %b | D = %b", X,Y,Z,D);
    for(i=0;i<8;i=i+1)
        begin
            {X,Y,Z} = i;
            #10; 
        end
    $finish;
end

endmodule