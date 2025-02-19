module Gray_Counter_4bit (
    input clk,
    input rst,
    output [3:0] gray
);
    reg [3:0] binary;

    always @(posedge clk or posedge rst) begin
        if (rst)
            binary <= 4'b0000;
        else
            binary <= binary + 1;
    end

    // assign gray[3] = binary[3];
    // assign gray[2] = binary[3] ^ binary[2];
    // assign gray[1] = binary[2] ^ binary[1];
    // assign gray[0] = binary[1] ^ binary[0];

    assign gray = binary ^ (binary >> 1);

endmodule
