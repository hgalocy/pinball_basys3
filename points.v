`timescale 1ns / 1ps

module points( input clk,
               input score,
               input rst,
               output reg [3:0] ones,
               output reg [3:0] tens,
               output reg [3:0] hundreds,
               output reg [3:0] thous);
    
always @(posedge score or posedge rst) begin 
    if (rst == 1) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thous <= 0;
    end
    else begin
        //increment ones          
        if (thous >= 9 && hundreds >= 9 && tens >= 9 && ones >= 9) begin
            ones <= 0;
            tens <= 0;
            hundreds <= 0;
            thous <= 0;
        end
        else if (ones < 9) begin
            ones <= ones + 1;
        end
        else begin
            ones <= 0;
            //increment tens
            if (tens < 9) begin
                tens <= tens + 1;
            end
            else begin
                tens <= 0;
                //increment hundreds
                if (hundreds < 9) begin
                    hundreds <= hundreds + 1;
                end
                else begin
                    hundreds <= 0;
                    //increment thous
                    thous <= thous + 1;
                end
            end
        end
    end
end

endmodule
