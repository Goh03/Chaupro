`timescale 1ps/1ps
module Half_Adder_tb ();

reg x,y,c_in;
wire c_out,s;
integer i;

Full_Adder dut(
    .x(x),
    .y(y),
    .c_in(c_in),
    .c_out(c_out),
    .s(s)
);

initial begin
    for(i=0;i<8;i=i+1)
        begin
            {x,y,c_in} = i;
            #10 $display("%b %b %b | %b %b",x,y,c_in,c_out,s);
        end
    $finish;
end

endmodule