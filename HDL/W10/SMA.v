module sign_mag_add 
#( 
    parameter N = 4 
) 
( 
    input wire [N-1:0] a, b,   
    output reg [N-1:0] sum     
);  

    // Signal declaration
    reg [N-2:0] mag_a, mag_b,mag_sum,max, min;      
    reg sign_a, sign_b,sign_sum;             

    //body
    always @* begin  
        // Separate magnitude and sign
        mag_a = a[N-2:0];  
        mag_b = b[N-2:0];  
        sign_a = a[N-1];  
        sign_b = b[N-1];  

        // Sort according to magnitude
        if (mag_a > mag_b) begin  
            max = mag_a;  
            min = mag_b;  
            sign_sum = sign_a;  
        end else begin  
            max = mag_b;  
            min = mag_a;  
            sign_sum = sign_b;  
        end  

        // Add or subtract magnitude based on sign
        if (sign_a == sign_b)
            mag_sum = max + min;  
        else  
            mag_sum = max - min;  

        // Form the output
        sum = {sign_sum, mag_sum};  
    end  
endmodule  
