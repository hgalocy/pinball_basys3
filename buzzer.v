`timescale 1ns / 1ps

module buzzer( input clk, 
               input score,
               output wire JA);
         
    reg speaker;
    reg [30:0] counterC;
    reg [30:0] inCounter;
    reg stop;
    
    always @(posedge clk) begin
        if (counterC >= 32768) begin //the hz
            counterC <= 0;
            if (score | stop) begin
                speaker <= ~speaker; 
                if (inCounter >= 508) begin //the duration
                    inCounter <= 0;
                    stop <= 0;
                end
                else begin
                    inCounter <= inCounter + 1;
                    stop <= 1;
                end
            end
        end
        else begin
            counterC <= counterC + 1;
        end
    end
    
    //output
    assign JA = speaker; 
     
endmodule
