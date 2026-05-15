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
set SYS_CLK	{ \PLL:PLL1|altpll_component|auto_generated|pll1|clk[0]}
set SDRAM_CLK	{ \PLL:PLL1|altpll_component|auto_generated|pll1|clk[1]}

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
#Output Data Hold Time 2.5ns
set_input_delay  -clock $SDRAM_CLK -min 2.8 [get_ports {sdram_dq[*]}]
#Output HIGH Impedance Time	5.4ns 
set_input_delay -clock $SDRAM_CLK -max  5.7 [get_ports {sdram_dq[*]}]

#Controller Interface no timing requirments
set_input_delay -clock $SYS_CLK -min 0 [get_ports {reset addr* data* we req}]

set_input_delay -clock $SYS_CLK -max  0 [get_ports {reset addr* data* we req}]

						  
#**************************************************************
# Set Output Delay
#**************************************************************

# Input Data Setup Time(2) 1.5ns 
set_output_delay -clock $SDRAM_CLK -max  2.5 [get_ports {sdram_dq[*]}]
# Input Data Hold Time 0.8ns !negative because hold Time
set_output_delay -clock $SDRAM_CLK -min -1.0 [get_ports {sdram_dq[*]}] -add_delay



# Address Setup Time(2) 1.5ns & Command Setup Time (CS, RAS, CAS, WE, DQM) 1.5ns
set_output_delay -clock $SDRAM_CLK -max 2.5 [get_ports {sdram_a* sdram_ba* sdram_ba sdram_cke sdram_cs_n sdram_ras_n sdram_cas_n sdram_we_n sdram_dqml sdram_dqmh}]
# Address Hold Time & Command Hold Time (CS, RAS, CAS, WE, DQM) 0.8ns !negative because hold Time
set_output_delay -clock $SDRAM_CLK -min -1.0 [get_ports {sdram_a* sdram_ba* sdram_ba sdram_cke sdram_cs_n sdram_ras_n sdram_cas_n sdram_we_n sdram_dqml sdram_dqmh}] -add_delay

#Controller Interface no timing requirments
set_output_delay -clock $SYS_CLK -min 0 [get_ports { ack valid q*}]

set_output_delay -clock $SYS_CLK -max  0 [get_ports { ack valid q*}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************
set_multicycle_path -setup -end -from $SDRAM_CLK -to $SYS_CLK 1


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



