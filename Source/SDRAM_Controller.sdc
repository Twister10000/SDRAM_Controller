#**************************************************************
# Author: Twister10000 (Mika)
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "50.0 MHz" [get_ports CLK]


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks -create_base_clocks
set SDRAM_PLL	{ \PLL:PLL1|altpll_component|auto_generated|pll1|clk[0]}

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************
#Output Data Hold Time 2.7ns
set_input_delay -min -clock $SDRAM_PLL 3.0 [get_ports sdram_dq*]
#Output HIGH Impedance Time	5.4ns 
set_input_delay -max -clock $SDRAM_PLL 5.9 [get_ports sdram_dq*]

#Controller Interface no timing requirments
set_input_delay -min -clock $SDRAM_PLL 0 [get_ports {reset addr* data* we req}]

set_input_delay -max -clock $SDRAM_PLL 0 [get_ports {reset addr* data* we req}]

						  
#**************************************************************
# Set Output Delay
#**************************************************************

# Input Data Hold Time 0.8ns !negative because hold Time
set_output_delay -min -clock $SDRAM_PLL -0.9 [get_ports sdram_dq*]
# Input Data Setup Time(2) 1.5ns 
set_output_delay -max -clock $SDRAM_PLL 1.6 [get_ports sdram_dq*]

# Address Hold Time & Command Hold Time (CS, RAS, CAS, WE, DQM) 0.8ns !negative because hold Time
set_output_delay -min -clock $SDRAM_PLL -0.9 [get_ports {sdram_a* sdram_ba* sdram_ba sdram_cke sdram_cs_n sdram_ras_n sdram_cas_n sdram_we_n sdram_dqml sdram_dqmh}]
# Address Setup Time(2) 1.5ns & Command Setup Time (CS, RAS, CAS, WE, DQM) 1.5ns
set_output_delay -max -clock $SDRAM_PLL 1.6 [get_ports {sdram_a* sdram_ba* sdram_ba sdram_cke sdram_cs_n sdram_ras_n sdram_cas_n sdram_we_n sdram_dqml sdram_dqmh}]

#Controller Interface no timing requirments
set_output_delay -min -clock $SDRAM_PLL 0 [get_ports {ack valid q*}]

set_output_delay -max -clock $SDRAM_PLL 0 [get_ports {ack valid q*}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



