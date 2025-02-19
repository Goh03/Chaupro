`timescale 1ps/1ps
module majority_n_bit_tb ();

    reg [3:0] a; 
    wire F;

    majority_n_bit #(.N(4)) uut (
        .a(a),
        .F(F)
    );

    initial begin
        $display("A\t\t Majority");
        $monitor("%b\t\t %b", a, F);
        a = 4'b0000; #10;
        a = 4'b0001; #10; 
        a = 4'b0011; #10; 
        a = 4'b0111; #10; 
        a = 4'b1111; #10; 
        $finish; 
    end
endmodule