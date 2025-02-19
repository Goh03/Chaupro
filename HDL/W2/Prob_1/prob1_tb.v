`timescale 1ps/1ps
module prob1_tb ();

reg a,b,c,d;
wire F;
integer i;

prob1 dut(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .F(F)
);

initial begin
    //a = 0; b = 0; c = 0; d = 0;
    for( i=0;i<16;i=i+1)
        begin
            {a,b,c,d} = i;
            #10 $display("%b %b %b %b | %b",a,b,c,d,F);
        end
    $finish;
end
endmodule