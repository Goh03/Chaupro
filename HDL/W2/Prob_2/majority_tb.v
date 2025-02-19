`timescale 1ps/1ps
module majority_tb ();

reg a,b,c;
wire F;
integer i;

majority dut(
    .a(a),
    .b(b),
    .c(c),
    .F(F)
);

initial begin
    //a = 0; b = 0; c = 0;
    for(i=0;i<8;i=i+1)
        begin
            {a,b,c} = i;
            #10 $display("%b %b %b | %b",a,b,c,F);
        end
    $finish;
end
endmodule