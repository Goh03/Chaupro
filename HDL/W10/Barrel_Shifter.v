module barrel_shifter_stage 
(
    input wire [7:0] a,             
    input wire [2:0] amt,           
    output wire [7:0] y            
);

// Signal declaration
wire [7:0] s0, s1;

// Body
// Stage 0: Shift by 0 or 1 bit
assign s0 = amt[0] ? {a[0], a[7:1]} : a;

// Stage 1: Shift by 0 or 2 bits
assign s1 = amt[1] ? {s0[1:0], s0[7:2]} : s0;

// Stage 2: Shift by 0 or 4 bits
assign y = amt[2] ? {s1[3:0], s1[7:4]} : s1;

endmodule
