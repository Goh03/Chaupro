module encoder_8to3 (
    input  [7:0] Y,   
    output reg [2:0] A  
);

always @(*) begin
    case (Y)
        8'b10000000: A = 3'b111; 
        8'b01000000: A = 3'b110; 
        8'b00100000: A = 3'b101; 
        8'b00010000: A = 3'b100; 
        8'b00001000: A = 3'b011; 
        8'b00000100: A = 3'b010; 
        8'b00000010: A = 3'b001; 
        8'b00000001: A = 3'b000; 
        default: A = 3'b000;      
    endcase
end

endmodule
