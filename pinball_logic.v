`timescale 1ns / 1ps

module pinball_logic( input clk, 
                      input[9:0] x_control,
                      input start_ball, 
                      input button_l, 
                      input button_r, 
                      input shake, 
                      input[9:0] y_control, 
                      input video_on, 
                      output wire [2:0] rgb, 
                      output wire score,
                      output wire rst); 

reg pointFlag;
reg rst_reg;
//leftFlip
parameter leftFlipDown_t = 470;
wire display_leftFlip;
wire display_leftFlipDown;
wire [2:0] rgb_leftFlip;
reg leftFlipFlag = 0;

//rightFlip
parameter rightFlipDown_t = 470;
wire display_rightFlip;
wire display_rightFlipDown;
wire [2:0] rgb_rightFlip;
reg rightFlipFlag = 0;

// ball
integer ball_c_l; // the distance between the ball and left side of the screen
integer ball_c_l_next; // the distance between the ball and left side of the screen 
integer ball_c_t; // the distance between the ball and top side of the screen
integer ball_c_t_next; // the distance between the ball and top side of the screen
parameter ball_default_c_t = 300; // default value of the distance between the ball and left side of the screen
parameter ball_default_c_l = 300; // default value of the distance between the ball and left side of the screen
parameter ball_r = 6; //radius of the ball.
integer horizontal_velocity=3; // Horizontal velocity of the ball  
integer vertical_velocity=4; //Vertical velocity of the ball
wire display_ball; //to send ball to vga 
wire[2:0] rgb_ball;//color 

//left panel
wire display_lpanel; //to send panel to vga
//right panel
wire display_rpanel; //to send bing to vga
wire[2:0] rgb_panel; //color
//top Left Bing
wire display_topLeftBing; //to send bing to vga
wire[2:0] rgb_topLeftBing;
//top right Bing
wire display_topRightBing; //to send bing to vga
wire[2:0] rgb_topRightBing;
//top mid Bing
wire display_topMidBing; //to send bing to vga
wire[2:0] rgb_topMidBing;
//leftSlide
wire display_leftSlide;
wire [2:0] rgb_leftSlide;
//rightSlide
wire display_rightSlide;
wire [2:0] rgb_rightSlide;
//leftTarget
parameter leftTargetRad = 30;
parameter leftTargetX = 150;
parameter leftTargetY = 230;
wire display_leftTarget;
wire [2:0] rgb_leftTarget;
//midTarget
parameter midTargetRad = 35;
parameter midTargetX = 300;
parameter midTargetY = 160;
wire display_midTarget;
wire [2:0] rgb_midTarget;
//rightTarget
parameter rightTargetRad = 40;
parameter rightTargetX = 520;
parameter rightTargetY = 200;
wire display_rightTarget;
wire [2:0] rgb_rightTarget;
//fastTarget
parameter fastTargetRad = 20;
parameter fastTargetX = 125;
parameter fastTargetY = 80;
wire display_fastTarget;
wire [2:0] rgb_fastTarget;
// topbar
integer topbar_l; // the distance between bar and left side of screen 
integer topbar_l_next; // the distance between bar and left side of screen
parameter topbar_t = 10; // the distance between bar and top side of screen
parameter topbar_thickness = 10; // thickness of the bar
parameter topbar_w = 80; // width of the top bar
parameter topbar_v = 6; //velocity of the bar.
wire display_topbar; //to send top bar to vga
wire[2:0] rgb_topbar; //color 
reg topBarDirec = 1; //changes the direction

// refresh
integer refresh_reg; 
wire[32:0] refresh_next; 
parameter refresh_constant = 830000;  
wire refresh_rate; 

// ball animation
integer horizontal_velocity_reg; 
integer horizontal_velocity_next; 
integer vertical_velocity_reg; 

// x,y pixel cursor
integer vertical_velocity_next; 
wire[9:0] x; 
wire[8:0] y; 

// mux to display
wire[17:0] output_mux; 

// buffer
reg[2:0] rgb_reg; 

// x,y pixel cursor
wire[2:0] rgb_next; 

//PINBALL LOGIC
initial begin
    vertical_velocity_next = 0;
    vertical_velocity_reg = 0;
    horizontal_velocity_reg = 0;
    ball_c_t_next = ball_default_c_t;
    ball_c_t = ball_default_c_t;
    ball_c_l_next = ball_default_c_l;  
    ball_c_l = ball_default_c_l; 
    topbar_l_next = 260;
    topbar_l = 260;
end
assign x = x_control; 
assign y = y_control; 

// refreshing
always @(posedge clk)
   begin //: process_1
   refresh_reg <= refresh_next;   
   end

//assigning refresh logics.
assign refresh_next = refresh_reg === refresh_constant ? 0 : 
	refresh_reg + 1; 
assign refresh_rate = refresh_reg === 0 ? 1'b 1 : 
	1'b 0; 

// beginning
always @(posedge clk) begin
      horizontal_velocity_reg <= horizontal_velocity_next; //assigns horizontal velocity
      vertical_velocity_reg <= vertical_velocity_next; // assigns vertical velocity
      if (start_ball === 1'b 1)  begin // throw the ball
         rst_reg <= 1;
         if (horizontal_velocity_reg != 0 | vertical_velocity_reg != 0) begin
             ball_c_l <= ball_default_c_l; //assigns the next value of the ball's location from the left side of the screen to it's location.
             ball_c_t <= ball_default_c_t;
             horizontal_velocity_reg <= 0; //assigns horizontal velocity
             vertical_velocity_reg <= 0;
         end 
         else begin
             horizontal_velocity_reg <= 3;   
             vertical_velocity_reg <= 4; 
         end
      end
      else begin
        rst_reg <= 0;
      end
      if (shake === 1) begin
         if (horizontal_velocity_reg < 0) begin
            horizontal_velocity_reg <= horizontal_velocity;
         end
         else begin
            horizontal_velocity_reg <= -horizontal_velocity;
         end
      end
      ball_c_l <= ball_c_l_next; //assigns the next value of the ball's location from the left side of the screen to it's location.
      ball_c_t <= ball_c_t_next; //assigns the next value of the ball's location from the top side of the screen to it's location.  
      topbar_l <= topbar_l_next;   //assigns the next value of the top bars's location from the left side of the screen to it's location.
end

//flippers animation
always @(refresh_rate or button_r or button_l) begin
    if (refresh_rate === 1'b 1) begin //refresh_rate's posedge 
        if (button_l === 1'b 1) begin
            leftFlipFlag <= 1;
        end
        else begin
            leftFlipFlag <= 0;
        end
        if (button_r === 1'b 1) begin
            rightFlipFlag <= 1;
        end
        else begin
            rightFlipFlag <= 0;
        end
    end
end

// topbar animation
always @(topbar_l or refresh_rate) begin 
   topbar_l_next <= topbar_l;   //assign topbar_l to it's next value
   if (refresh_rate === 1'b 1) begin //refresh_rate's posedge   
      if(topBarDirec === 1 & topbar_l > topbar_v) begin
        topbar_l_next <= topbar_l - topbar_v;
      end
      else if (topBarDirec === 0 & topbar_l < 639 - topbar_v - topbar_w) begin
        topbar_l_next <= topbar_l + topbar_v;   // move top bar to the right
      end
      else begin
         topBarDirec <= !topBarDirec;
      end
   end
end

// ball animation
always @(refresh_rate or ball_c_l or ball_c_t or horizontal_velocity_reg or vertical_velocity_reg) begin 
   ball_c_l_next <= ball_c_l;   
   ball_c_t_next <= ball_c_t;   
   horizontal_velocity_next <= horizontal_velocity_reg;   
   vertical_velocity_next <= vertical_velocity_reg;   
   if (refresh_rate === 1'b 1) begin // posedge of refresh_rate
      if (vertical_velocity <= 0 & ball_c_l != ball_default_c_l & ball_c_t != ball_default_c_t) begin //not going up and down and not at start
        vertical_velocity <= 1;
      end
      if (horizontal_velocity <= 0 & ball_c_l != ball_default_c_l & ball_c_t != ball_default_c_t) begin //not going side to side and not at start
        horizontal_velocity <= 1;
      end
      if (ball_c_t >= leftFlipDown_t & ball_c_l < 280 & ball_c_l >= 170 & leftFlipFlag === 0) begin //ball hits leftFlipDown
        vertical_velocity_next <= -vertical_velocity;
      end
      else if (ball_c_t >= rightFlipDown_t & ball_c_l < 500 & ball_c_l > 360 & rightFlipFlag === 0) begin //ball hits rightFlipDown
        vertical_velocity_next <= -vertical_velocity;
      end
      else if (ball_c_t >= -ball_c_l + 640 & ball_c_l < 250 & ball_c_t > 390 & ball_c_t <= leftFlipDown_t & leftFlipFlag === 1) begin //ball hits leftFlip
        vertical_velocity <= 6;
        horizontal_velocity <= 2;
        vertical_velocity_next <= -vertical_velocity;
        horizontal_velocity_next <= -horizontal_velocity;
      end
      else if (ball_c_t >= ball_c_l & ball_c_t > 390 & ball_c_l > 380 & ball_c_t <= rightFlipDown_t & rightFlipFlag === 1) begin //ball hits rightFlip;
        vertical_velocity <= 6;
        horizontal_velocity <= 2;
        vertical_velocity_next <= -vertical_velocity;
        horizontal_velocity_next <= horizontal_velocity;
      end
      else if (ball_c_t >= ball_c_l + 300) begin //ball hits leftSlide
         vertical_velocity <= 4;
         horizontal_velocity <= 2;
         vertical_velocity_next <= -vertical_velocity;
         horizontal_velocity_next <= horizontal_velocity;
      end
      else if (ball_c_t >= -ball_c_l + 940) begin //ball hits rightSlide
         vertical_velocity <= 5;
         horizontal_velocity <= 1;
         vertical_velocity_next <= -vertical_velocity;
         horizontal_velocity_next <= -horizontal_velocity;
      end
      //leftTarget
      else if ((ball_c_l - leftTargetX) * (ball_c_l - leftTargetX) + (ball_c_t - leftTargetY) * (ball_c_t - leftTargetY) <= leftTargetRad*leftTargetRad) begin //ball hits leftTarget
         pointFlag <= 1;
         if (ball_c_l < leftTargetX & ball_c_t < leftTargetY) begin //ball hit top left section of leftTarget
            vertical_velocity <= 3;
            horizontal_velocity <= 4;
            vertical_velocity_next <= -vertical_velocity;
            horizontal_velocity_next <= -horizontal_velocity;
         end
         else if (ball_c_l < leftTargetX & ball_c_t >= leftTargetY) begin //ball hit bottom left section of leftTarget
            vertical_velocity <= 2;
            horizontal_velocity <= 5;
            vertical_velocity_next <= vertical_velocity;
            horizontal_velocity_next <= -horizontal_velocity;
         end
         else if (ball_c_l >= leftTargetX & ball_c_t < leftTargetY) begin //ball hit top right section leftTarget
            vertical_velocity <= 3;
            horizontal_velocity <= 4;
            vertical_velocity_next <= -vertical_velocity;
            horizontal_velocity_next <= horizontal_velocity;
         end
         else if (ball_c_l >= leftTargetX & ball_c_t >= leftTargetY) begin //ball hit bottom right section of leftTarget
            vertical_velocity <= 3;
            horizontal_velocity <= 4;
            vertical_velocity_next <= vertical_velocity;
            horizontal_velocity_next <= horizontal_velocity;
         end       
      end
      //midTarget
      else if ((ball_c_l - midTargetX) * (ball_c_l - midTargetX) + (ball_c_t - midTargetY) * (ball_c_t - midTargetY) <= midTargetRad*midTargetRad) begin //ball hits midTarget
         pointFlag <= 1;
         if (ball_c_l < midTargetX & ball_c_t < midTargetY) begin //ball hit top left section of midTarget
            vertical_velocity <= 4;
            horizontal_velocity <= 5;
            vertical_velocity_next <= -vertical_velocity;
            horizontal_velocity_next <= -horizontal_velocity;
         end
         else if (ball_c_l < midTargetX & ball_c_t >= midTargetY) begin //ball hit bottom left section of midTarget
            vertical_velocity <= 3;
            horizontal_velocity <= 2;
            vertical_velocity_next <= vertical_velocity;
            horizontal_velocity_next <= -horizontal_velocity;
         end
         else if (ball_c_l >= midTargetX & ball_c_t < midTargetY) begin //ball hit top right section midTarget
            vertical_velocity <= 4;
            horizontal_velocity <= 3;
            vertical_velocity_next <= -vertical_velocity;
            horizontal_velocity_next <= horizontal_velocity;
         end
         else if (ball_c_l >= midTargetX & ball_c_t >= midTargetY) begin //ball hit bottom right section of midTarget
            vertical_velocity <= 5;
            horizontal_velocity <= 6;
            vertical_velocity_next <= vertical_velocity;
            horizontal_velocity_next <= horizontal_velocity;
         end       
      end
      //rightTarget
      else if ((ball_c_l - rightTargetX) * (ball_c_l - rightTargetX) + (ball_c_t - rightTargetY) * (ball_c_t - rightTargetY) <= rightTargetRad*rightTargetRad) begin //ball hits midTarget
         pointFlag <= 1;
         if (ball_c_l < rightTargetX & ball_c_t < rightTargetY) begin //ball hit top left section of rightTarget
            vertical_velocity <= 3;
            horizontal_velocity <= 5;
            vertical_velocity_next <= -vertical_velocity;
            horizontal_velocity_next <= -horizontal_velocity;
         end
         else if (ball_c_l < rightTargetX & ball_c_t >= rightTargetY) begin //ball hit bottom left section of rightTarget
            vertical_velocity <= 3;
            horizontal_velocity <= 5;
            vertical_velocity_next <= vertical_velocity;
            horizontal_velocity_next <= -horizontal_velocity;
         end
         else if (ball_c_l >= rightTargetX & ball_c_t < rightTargetY) begin //ball hit top right section midTarget
            vertical_velocity <= 3;
            horizontal_velocity <= 4;
            vertical_velocity_next <= -vertical_velocity;
            horizontal_velocity_next <= horizontal_velocity;
         end
         else if (ball_c_l >= rightTargetX & ball_c_t >= rightTargetY) begin //ball hit bottom right section of midTarget
            vertical_velocity <= 5;
            horizontal_velocity <= 4;
            vertical_velocity_next <= vertical_velocity;
            horizontal_velocity_next <= horizontal_velocity;
         end       
      end
      //fastTarget
      else if ((ball_c_l - fastTargetX) * (ball_c_l - fastTargetX) + (ball_c_t - fastTargetY) * (ball_c_t - fastTargetY) <= fastTargetRad*fastTargetRad) begin //ball hits leftTarget
         pointFlag <= 1;
         if (ball_c_l < fastTargetX & ball_c_t < fastTargetY) begin //ball hit top left section of leftTarget
            vertical_velocity <= 8;
            horizontal_velocity <= 7;
            vertical_velocity_next <= -vertical_velocity;
            horizontal_velocity_next <= -horizontal_velocity;
         end
         else if (ball_c_l < fastTargetX & ball_c_t >= fastTargetY) begin //ball hit bottom left section of leftTarget
            vertical_velocity <= 3;
            horizontal_velocity <= 7;
            vertical_velocity_next <= vertical_velocity;
            horizontal_velocity_next <= -horizontal_velocity;
         end
         else if (ball_c_l >= fastTargetX & ball_c_t < fastTargetY) begin //ball hit top right section leftTarget
            vertical_velocity <= 8;
            horizontal_velocity <= 4;
            vertical_velocity_next <= -vertical_velocity;
            horizontal_velocity_next <= horizontal_velocity;
         end
         else if (ball_c_l >= fastTargetX & ball_c_t >= fastTargetY) begin //ball hit bottom right section of midTarget
            vertical_velocity <= 6;
            horizontal_velocity <= 8;
            vertical_velocity_next <= vertical_velocity;
            horizontal_velocity_next <= horizontal_velocity;
         end 
      end
      else if (ball_c_l >= topbar_l & ball_c_l <= topbar_l + topbar_w & ball_c_t >= topbar_t + 2 & ball_c_t <= topbar_t + 12 ) begin // if ball hits the top bar 
         pointFlag <= 1;
         vertical_velocity <= 5;
         horizontal_velocity <= 1;
         vertical_velocity_next <= vertical_velocity; //set the direction of vertical velocity positive  
      end
      else if (ball_c_l <= 10) begin // if the ball hits the left side of the screen
         horizontal_velocity_next <= horizontal_velocity; //set the direction of horizontal velocity positive
      end
      else if (ball_c_l >= 630 ) begin // if the ball hits the right side of the screen
         horizontal_velocity_next <= -horizontal_velocity; //set the direction of horizontal velocity negative.
      end
      else if (ball_c_t <= 10) begin //ball hits top
         vertical_velocity_next <= vertical_velocity;
      end
      else begin
        pointFlag <= 0;
      end
      ball_c_l_next <= ball_c_l + horizontal_velocity_reg; //move the ball's horizontal location   
      ball_c_t_next <= ball_c_t + vertical_velocity_reg; // move the ball's vertical location.
      if (ball_c_t >= 479 | (horizontal_velocity_reg == 0 & vertical_velocity_reg == 0)) begin 
         ball_c_l_next <= ball_default_c_l;  //reset the ball's location to its default.  
         ball_c_t_next <= ball_default_c_t;  //reset the ball's location to its default.
         horizontal_velocity_next <= 0; //stop the ball.  
         vertical_velocity_next <= 0; //stop the ball
      end
   end
end

//DRAW TO THE SCREEN
// display topbar object on the screen
assign display_topbar = x > topbar_l & x < topbar_l + topbar_w & y > topbar_t &
    y < topbar_t + topbar_thickness ? 1'b 1 : 
	1'b 0; 
assign rgb_topbar = 3'b 100; // color of top bar: red

// display ball object on the screen
assign display_ball = (x - ball_c_l) * (x - ball_c_l) + (y - ball_c_t) * (y - ball_c_t) <= ball_r * ball_r ? 
    1'b 1 : 
	1'b 0; 
assign rgb_ball = 3'b 111; //color of ball: white

//display lpanel
assign display_lpanel = x < 10 & x > 0 & y > 0 & y < 300 ? 1'b1: 1'b0;
assign rgb_panel = 3'b 010; //green

//display rpanel
assign display_rpanel = x < 640 & x > 630 & y > 0 & y < 300 ? 1'b1: 1'b0;

//display topLeftBing
assign display_topLeftBing = x > 0 & x <= 160 & y > 0 & y < 10 ? 1'b1 : 1'b0;
assign rgb_topLeftBing = 3'b010;

//display topMidBing
assign display_topMidBing = x > 160 & x <= 480 & y > 0 & y < 10 ? 1'b1 : 1'b0;
assign rgb_topMidBing = 3'b010;

//display topRightBing
assign display_topRightBing = x > 480 & x <= 640 & y > 0 & y < 10 ? 1'b1 : 1'b0;
assign rgb_topRightBing = 3'b010;

//display leftSlide
assign display_leftSlide = y >= x + 300 ? 1'b1 : 1'b0;
assign rgb_leftSlide = 3'b010;

//display rightSlide
assign display_rightSlide = y >= -x + 940 ? 1'b1 : 1'b0;
assign rgb_rightSlide = 3'b010;

//display leftTarget
assign display_leftTarget = (x - leftTargetX) * (x - leftTargetX) + (y - leftTargetY) * (y - leftTargetY) <= leftTargetRad*leftTargetRad ? 1'b 1 : 1'b 0; 
assign rgb_leftTarget = 3'b011;

//display midTarget
assign display_midTarget = (x - midTargetX) * (x - midTargetX) + (y - midTargetY) * (y - midTargetY) <= midTargetRad*midTargetRad ? 1'b 1 : 1'b 0; 
assign rgb_midTarget = 3'b011;

//display rightTarget
assign display_rightTarget = (x - rightTargetX) * (x - rightTargetX) + (y - rightTargetY) * (y - rightTargetY) <= rightTargetRad*rightTargetRad ? 1'b 1 : 1'b 0; 
assign rgb_rightTarget = 3'b011;

//display fastTarget
assign display_fastTarget = (x - fastTargetX) * (x - fastTargetX) + (y - fastTargetY) * (y - fastTargetY) <= fastTargetRad*fastTargetRad ? 1'b 1 : 1'b 0; 
assign rgb_fastTarget = 3'b101;

//display leftFlip
assign display_leftFlipDown = y === leftFlipDown_t & x < 280 & x > 170 & leftFlipFlag === 0;
assign display_leftFlip = y === -x + 640 & y > 390 & y < leftFlipDown_t & leftFlipFlag === 1;
assign rgb_leftFlip = 3'b001;

//display rightFlip
assign display_rightFlipDown = y === rightFlipDown_t & x < 470 & x > 360 & rightFlipFlag === 0;
assign display_rightFlip = y === x & y > 390 & y < rightFlipDown_t & rightFlipFlag === 1;
assign rgb_rightFlip = 3'b001;

always @(posedge clk)
   begin 
   rgb_reg <= rgb_next;   
   end

// mux
assign output_mux = {video_on, display_topbar, display_fastTarget , display_ball, display_lpanel, 
                    display_rpanel, display_topLeftBing, display_topMidBing, display_topRightBing,
                    display_leftSlide, display_rightSlide, display_leftTarget, display_midTarget,
                    display_rightTarget, display_leftFlip, display_rightFlip, display_leftFlipDown, 
                    display_rightFlipDown}; 

//assign rgb_next wrt output_mux.
assign rgb_next = output_mux === 18'b 100000000000000000 ? 3'b 000 : 
	              output_mux === 18'b 110000000000000000 ? rgb_topbar : 
	              output_mux === 18'b 110100000000000000 ? rgb_topbar : 
	              output_mux === 18'b 101000000000000000 ? rgb_fastTarget : 
                  output_mux === 18'b 101100000000000000 ? rgb_fastTarget : 
	              output_mux === 18'b 100100000000000000 ? rgb_ball : 
	              output_mux === 18'b 100010000000000000 ? rgb_panel :
	              output_mux === 18'b 100110000000000000 ? rgb_panel :
	              output_mux === 18'b 100001000000000000 ? rgb_panel :
	              output_mux === 18'b 100101000000000000 ? rgb_panel :
	              output_mux === 18'b 100000100000000000 ? rgb_topLeftBing :
	              output_mux === 18'b 100100100000000000 ? rgb_topLeftBing :
	              output_mux === 18'b 100000010000000000 ? rgb_topMidBing :
	              output_mux === 18'b 100100010000000000 ? rgb_topMidBing :
	              output_mux === 18'b 100000001000000000 ? rgb_topRightBing :
	              output_mux === 18'b 100100001000000000 ? rgb_topRightBing :
                  output_mux === 18'b 100000000100000000 ? rgb_leftSlide :
	              output_mux === 18'b 100100000100000000 ? rgb_leftSlide :
	              output_mux === 18'b 100000000010000000 ? rgb_rightSlide :
	              output_mux === 18'b 100100000010000000 ? rgb_rightSlide :
	              output_mux === 18'b 100000000001000000 ? rgb_leftTarget :
	              output_mux === 18'b 100100000001000000 ? rgb_leftTarget :
	              output_mux === 18'b 100000000000100000 ? rgb_midTarget :
	              output_mux === 18'b 100100000000100000 ? rgb_midTarget :
	              output_mux === 18'b 100000000000010000 ? rgb_rightTarget :
	              output_mux === 18'b 100100000000010000 ? rgb_rightTarget :
	              output_mux === 18'b 100000000000001000 ? rgb_leftFlip :
	              output_mux === 18'b 100100000000001000 ? rgb_leftFlip :
	              output_mux === 18'b 100000000000000100 ? rgb_rightFlip :
	              output_mux === 18'b 100100000000000100 ? rgb_rightFlip :
	              output_mux === 18'b 100000000000000010 ? rgb_leftFlip :
	              output_mux === 18'b 100100000000000010 ? rgb_leftFlip :
	              output_mux === 18'b 100000000000000001 ? rgb_rightFlip :
	              output_mux === 18'b 100100000000000001 ? rgb_rightFlip :
	              3'b 000; 
	
// output part
assign rgb = rgb_reg; 
assign score = pointFlag;
assign rst = rst_reg;

endmodule
