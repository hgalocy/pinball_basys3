`timescale 1ns / 1ps
//obtained from https://github.com/CynicalApe/BASYS3-PONG/blob/master/sources/new/vga.sv
//his source is translated from VHDL

module vga_sync( input clk,  
                 input start, 
                 output wire [9:0] y_control, 
                 output wire [9:0] x_control, 
                 output wire horizontal_scan, 
                 output wire vertical_scan, 
                 output wire video_on );
   
   
   
   parameter HR = 640; //left to right
   parameter HFP = 16; 
   parameter HBP = 48; 
   parameter HT = 96;
   parameter VR = 480; //top to bottom
   parameter VFP = 10; 
   parameter VBP = 33; 

reg[9:0] counter_h; 
reg[9:0] counter_h_next; 
reg[9:0] counter_v; 

// mod 2 counter
reg[9:0] counter_v_next; 
reg counter_mod2; 

// State signals
reg counter_mod2_next; 
reg horizontal_end; 

// Output Signals(buffer)
reg vertical_end; 
reg horizontal_scanning_buffer; 
reg horizontal_scanning_buffer_next; 
reg vertical_scanning_buffer; 

// pixel cunter
reg vertical_scanning_buffer_next; 
reg[9:0] x_counter; 
reg[9:0] x_counter_next; 
reg[9:0] y_counter; 

// video_on_of
reg[9:0] y_counter_next; 
wire video; 

// clk register

initial
begin: process_0
   vertical_scanning_buffer_next = 1'b 0;   
   vertical_scanning_buffer = 1'b 0;   
   horizontal_scanning_buffer_next = 1'b 0;   
   horizontal_scanning_buffer = 1'b 0;   
   vertical_end = 1'b 0;   
   horizontal_end = 1'b 0;   
   counter_mod2_next = 1'b 0;   
   counter_mod2 = 1'b 0;   
end


always @(posedge clk)
begin : process_1
      if (start === 1'b 1)
         begin
         counter_h <= counter_h_next;   
         counter_v <= counter_v_next;   
         x_counter <= x_counter_next;   
         y_counter <= y_counter_next;   
         horizontal_scanning_buffer <= horizontal_scanning_buffer_next;   
         vertical_scanning_buffer <= vertical_scanning_buffer_next;   
         counter_mod2 <= counter_mod2_next;   
      end
end

	//video on/off
	assign video = counter_v >= VBP & counter_v < VBP + 
          VR & counter_h >= HBP & counter_h < 
          HBP + HR ? 1'b 1 : 
        1'b 0; 
    
    always @( counter_mod2 ) 
    counter_mod2_next = ~counter_mod2; 
    
    // end of Horizontal scanning     
    
    always @( counter_h ) 
    horizontal_end = counter_h === 799 ? 1'b 1 : 
        1'b 0; 
    
    //  end of Vertical scanning   
    
    always @( counter_v ) 
    vertical_end = counter_v === 523 ? 1'b 1 : 
        1'b 0; 
    
    //  Horizontal Counter    
    always @(counter_h or counter_mod2 or horizontal_end)
       begin : process_2
       counter_h_next <= counter_h;   
       if (counter_mod2 === 1'b 1)
          begin
          if (horizontal_end === 1'b 1)
             begin
             counter_h_next <= 0;   
             end
          else
             begin
             counter_h_next <= counter_h + 1;   
             end
          end
       end

always @(counter_v or counter_mod2 or horizontal_end or vertical_end)
   begin : process_3
   counter_v_next <= counter_v;   
   if (counter_mod2 === 1'b 1 & horizontal_end === 1'b 1)
      begin
      if (vertical_end === 1'b 1)
         begin
         counter_v_next <= 0;   
         end
      else
         begin
         counter_v_next <= counter_v + 1;   
         end
      end
   end


always @(x_counter or counter_mod2 or horizontal_end or video)
   begin : process_4
   x_counter_next <= x_counter;   
   if (video === 1'b 1)
      begin
      if (counter_mod2 === 1'b 1)
         begin
         if (x_counter === 639)
            begin
            x_counter_next <= 0;   
            end
         else
            begin
            x_counter_next <= x_counter + 1;   
            end
         end
      end
   else
      begin
      x_counter_next <= 0;   
      end
   end

always @(y_counter or counter_mod2 or horizontal_end or counter_v)
   begin : process_5
   y_counter_next <= y_counter;   
   if (counter_mod2 === 1'b 1 & horizontal_end === 1'b 1)
      begin
      if (counter_v > 32 & counter_v < 512)
         begin
         y_counter_next <= y_counter + 1;   
         end
      else
         begin
         y_counter_next <= 0;   
         end
      end
   end

// buffer
// (HBP+HR+HFP)
always @( counter_h ) 
horizontal_scanning_buffer_next = counter_h < 704 ? 1'b 1 : 
	1'b 0; 

// (VBP+VR+VFP)
always @( counter_v ) 
vertical_scanning_buffer_next = counter_v < 523 ? 1'b 1 : 
	1'b 0; 
 
// outputs
assign y_control = y_counter; 
assign x_control = x_counter; 
assign horizontal_scan = horizontal_scanning_buffer; 
assign vertical_scan = vertical_scanning_buffer; 
assign video_on = video; 

endmodule
