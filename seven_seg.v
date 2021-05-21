`timescale 1ns / 1ps

module seven_seg( input clk,
                  input wire [3:0] ones,
                  input wire [3:0] tens,
                  input wire [3:0] hundreds,
                  input wire [3:0] thous,
                  output reg [6:0] seg,
                  output reg [3:0] an);

    reg [30:0] counter = 0; //flash every 5ms
    reg [30:0] counterA = 0; //switch anode   
    
    reg [3:0] disp;
    
    //counterA switches from 1 to 3 every 5ms
    always @(posedge clk) begin
         if (counter >= 100) begin
                counter = 0;
                if (counterA <= 3) begin
                    counterA = counterA + 1;
                end
                else begin
                    counterA = 0;
                end
         end
         else begin
                counter = counter + 1;
         end
    end
    
    //switch anodes
    always @(posedge clk) begin
        case (counterA)
            0: begin
               an <= 4'b1110;
               disp <= ones; 
            end
            1: begin
               an <= 4'b1101;
               disp <= tens;
            end
            2: begin
               an <= 4'b1011;
               disp <= hundreds;
            end
            3: begin
               an <= 4'b0111;
               disp <= thous;
            end
        default: an = 4'b1111;
        endcase
    end
    
    //disp digit
    always @(posedge clk) begin
        case (disp)
            0: seg = 7'b1000000;
            1: seg = 7'b1111001;
            2: seg = 7'b0100100;
            3: seg = 7'b0110000;
            4: seg = 7'b0011001;
            5: seg = 7'b0010010;
            6: seg = 7'b0000010;
            7: seg = 7'b1011000;
            8: seg = 7'b0000000;
            9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end

endmodule
