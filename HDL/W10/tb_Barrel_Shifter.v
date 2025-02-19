`timescale 1ps / 1ps
module tb_barrel_shifter_stage();
    reg [7:0] a;
    reg [3:0] amt;
    wire [7:0] y;

    barrel_shifter_stage dut (
        .a(a),
        .amt(amt[2:0]),
        .y(y)
    );

    initial begin
        a = 8'b10101011;
        for (amt = 3'b000; amt <= 3'b111; amt = amt + 1) begin
            #10;
            $display("%t | %b |  %b  | %b", $time, a, amt, y);
        end
        $finish;
    end

endmodule
