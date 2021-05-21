## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
	
	
# Switches
set_property PACKAGE_PIN V17 [get_ports {start}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {start}]

#Buttons
set_property PACKAGE_PIN W19 [get_ports button_l]						
	set_property IOSTANDARD LVCMOS33 [get_ports button_l]
set_property PACKAGE_PIN T17 [get_ports button_r]						
	set_property IOSTANDARD LVCMOS33 [get_ports button_r]
set_property PACKAGE_PIN T18 [get_ports button_t]						
        set_property IOSTANDARD LVCMOS33 [get_ports button_t]
set_property PACKAGE_PIN U18 [get_ports start_ball]  	 	 	 	 	 
        set_property IOSTANDARD LVCMOS33 [get_ports start_ball] 




#VGA Connector
set_property PACKAGE_PIN G19 [get_ports {rgb[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[2]}]
set_property PACKAGE_PIN H19 [get_ports {rgb[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[2]}]
set_property PACKAGE_PIN J19 [get_ports {rgb[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[2]}]
set_property PACKAGE_PIN N19 [get_ports {rgb[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[2]}]
	
set_property PACKAGE_PIN N18 [get_ports {rgb[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[0]}]
set_property PACKAGE_PIN L18 [get_ports {rgb[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[0]}]
set_property PACKAGE_PIN K18 [get_ports {rgb[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[0]}]
set_property PACKAGE_PIN J18 [get_ports {rgb[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[0]}]
	
set_property PACKAGE_PIN J17 [get_ports {rgb[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[1]}]
set_property PACKAGE_PIN H17 [get_ports {rgb[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[1]}]
set_property PACKAGE_PIN G17 [get_ports {rgb[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[1]}]
set_property PACKAGE_PIN D17 [get_ports {rgb[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {rgb[1]}]
	
set_property PACKAGE_PIN P19 [get_ports {horizontal_sync}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {horizontal_sync}]
set_property PACKAGE_PIN R19 [get_ports {vertical_sync}]						
	set_property IOSTANDARD LVCMOS33 [get_ports {vertical_sync}]


##7 segment display
     set_property PACKAGE_PIN W7 [get_ports {seg[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
      
      set_property PACKAGE_PIN U2 [get_ports {an[0]}]                    
          set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
      set_property PACKAGE_PIN U4 [get_ports {an[1]}]                    
          set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
      set_property PACKAGE_PIN V4 [get_ports {an[2]}]                    
          set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
      set_property PACKAGE_PIN W4 [get_ports {an[3]}]                    
          set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]  
          
          ##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {JA[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[0]}]
