`timescale 1ns / 1ps

module top( input clk,
            input start,   
            input button_l,
            input button_r,
            input button_t,
            input start_ball,  
            output wire [2:0] rgb, 
            output wire horizontal_sync,
            output wire vertical_sync,
            output wire [6:0] seg,
            output wire [3:0] an,
            output wire [0:0] JA  ); 

//signal x,y:std_logic_vector(9 downto 0);
wire[9:0] x_control;
wire[9:0] y_control;
//signal video:std_logic;
wire video_on;
//signal clk_50 :std_logic;
reg clk_50;
reg [30:0] counter50;
//flag for points
wire score;
wire rst;
//digits of score
wire [3:0] ones;
wire [3:0] tens;
wire [3:0] hundreds;
wire [3:0] thous;

always @(posedge clk) begin
    if(counter50 >= 50000000) begin
        clk_50 <= !clk_50;
    end
    else begin
        counter50 <= counter50 + 1;
    end
end

//Module for pinball logic
pinball_logic (.clk(clk_50), .x_control(x_control),.start_ball(start_ball), .button_l(button_l), 
.button_r(button_r),.shake(button_t), .y_control(y_control), .video_on(video_on), .rgb(rgb), 
.score(score), .rst(rst));

//vga synchronization module to update changing pixels and refresh the display
vga_sync (.clk(clk_50), .start(start), .y_control(y_control), .x_control(x_control), 
.horizontal_scan(horizontal_sync), .vertical_scan(vertical_sync), .video_on(video_on));

//points logic
points (.clk(clk_50), .score(score), .rst(rst), .ones(ones), .tens(tens), .hundreds(hundreds), .thous(thous));

//Module to display the scores on the 7seg display of basys3
seven_seg(.clk(clk_50), .ones(ones), .tens(tens), .hundreds(hundreds), .thous(thous), .seg(seg), .an(an));

//module to make noise when points are accumulated
buzzer (.clk(clk), .score(score), .JA(JA));

endmodule
