`timescale 1ps/1ps
module CRA_tb ();
reg [3:0] x,y;
reg c_in;
wire [3:0] s;
wire c_out;
CRA dut(
    .x(x),
    .y(y),
    .c_in(c_in),
    .s(s),
    .c_out(c_out)
);

initial begin
    $monitor("x = %b, y = %b, c_in = %b, s = %b, c_out = %b", x,y,c_in,s,c_out);

    //Case 1
    x = 4'b0001;
    y = 4'b0011;
    c_in = 0;
    #10;

    //Case 2
    x = 4'b0101;
    y = 4'b0011;
    c_in = 0;
    #10;

    //Case 1
    x = 4'b1111;
    y = 4'b1111;
    c_in = 0;
    #10;
    $finish;    
end
endmodule