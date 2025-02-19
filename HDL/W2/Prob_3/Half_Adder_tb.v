`timescale 1ps/1ps
module Half_Adder_tb ();

reg x,y;
wire c,s;
integer i;

Half_Adder dut(
    .x(x),
    .y(y),
    .c(c),
    .s(s)
);

initial begin
    //x = 0; y = 0;
    for( i=0;i<4;i=i+1)
        begin
            {x,y} = i;
            #10 $display("%b %b | %b %b",x,y,c,s);
        end
    $finish;
end

endmodule