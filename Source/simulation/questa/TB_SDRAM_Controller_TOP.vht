-- Copyright (C) 2025  Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Altera and sold by Altera or its authorized distributors.  Please
-- refer to the Altera Software License Subscription Agreements 
-- on the Quartus Prime software download page.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "01/26/2026 09:51:44"
                                                            
-- Vhdl Test Bench template for design  :  SDRAM_Controller_TOP
-- 
-- Simulation tool : Questa Altera FPGA (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sdram_cmd_pkg.all;                             

ENTITY SDRAM_Controller_TOP_vhd_tst IS
END SDRAM_Controller_TOP_vhd_tst;
ARCHITECTURE SDRAM_Controller_TOP_arch OF SDRAM_Controller_TOP_vhd_tst IS
-- constants
constant	clk_period	:	time :=  7.5 ns;
signal		USE_PLL			: boolean := false;                                                
-- signals                                                   
SIGNAL ack 						: STD_LOGIC	:=	'0';
SIGNAL addr 					: STD_LOGIC_VECTOR(24 DOWNTO 0)	:=	(others	=>	'0');
SIGNAL CLK 						: STD_LOGIC	:=	'0';
SIGNAL data 					: STD_LOGIC_VECTOR(31 DOWNTO 0)	:=	(others	=>	'0');
SIGNAL q 							: STD_LOGIC_VECTOR(31 DOWNTO 0)	:=	(others	=>	'0');
SIGNAL req 						: STD_LOGIC	:=	'0';
SIGNAL reset 					: STD_LOGIC	:=	'0';
SIGNAL sdram_a 				: STD_LOGIC_VECTOR(12 DOWNTO 0)	:=	(others	=>	'0');
SIGNAL sdram_ba 			: STD_LOGIC_VECTOR(1 DOWNTO 0)	:=	(others	=>	'0');
SIGNAL sdram_cas_n 		: STD_LOGIC	:=	'0';
SIGNAL sdram_cke 			: STD_LOGIC	:=	'0';
SIGNAL sdram_cs_n 		: STD_LOGIC	:=	'0';
SIGNAL sdram_dq 			: STD_LOGIC_VECTOR(15 DOWNTO 0)	:=	(others	=>	'Z');
SIGNAL sdram_dqmh 		: STD_LOGIC	:=	'0';
SIGNAL sdram_dqml 		: STD_LOGIC	:=	'0';
SIGNAL sdram_ras_n 		: STD_LOGIC	:=	'0';
SIGNAL sdram_we_n 		: STD_LOGIC	:=	'0';
SIGNAL valid 					: STD_LOGIC	:=	'0';
SIGNAL we 						: STD_LOGIC	:=	'0';
COMPONENT SDRAM_Controller_TOP
	generic	(USE_PLL : boolean := false);
	PORT (
	ack 								: OUT STD_LOGIC;
	addr 								: IN STD_LOGIC_VECTOR(11 DOWNTO 0);
	CLK 								: IN STD_LOGIC;
	data 								: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	q 									: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	req 								: IN STD_LOGIC;
	reset 							: IN STD_LOGIC;
	sdram_a 						: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
	sdram_ba 						: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	sdram_cas_n 				: OUT STD_LOGIC;
	sdram_cke 					: OUT STD_LOGIC;
	sdram_cs_n 					: OUT STD_LOGIC;
	sdram_dq 						: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	sdram_dqmh 					: OUT STD_LOGIC;
	sdram_dqml 					: OUT STD_LOGIC;
	sdram_ras_n 				: OUT STD_LOGIC;
	sdram_we_n 					: OUT STD_LOGIC;
	valid 							: OUT STD_LOGIC;
	we 									: IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : entity work.SDRAM_Controller_TOP
	GENERIC MAP (USE_PLL => USE_PLL)
	PORT MAP (
-- list connections between master ports and signals
	ack 					=> ack,
	addr 					=> addr,
	CLK 					=> CLK,
	data 					=> data,
	q 						=> q,
	req 					=> req,
	reset 				=> reset,
	sdram_a 			=> sdram_a,
	sdram_ba 			=> sdram_ba,
	sdram_cas_n 	=> sdram_cas_n,
	sdram_cke 		=> sdram_cke,
	sdram_cs_n 		=> sdram_cs_n,
	sdram_dq 			=> sdram_dq,
	sdram_dqmh 		=> sdram_dqmh,
	sdram_dqml 		=> sdram_dqml,
	sdram_ras_n 	=> sdram_ras_n,
	sdram_we_n 		=> sdram_we_n,
	valid 				=> valid,
	we 						=> we
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once
	assert (false)	report "Start" severity note;			
	wait for 100103.75 ns;
	assert (false)	report "Precharge" severity note;
	wait for (2*clk_period);
	assert (false)	report "Refresh" severity note;
	wait for (8*8*clk_period);
	assert (false)	report "Load  Mode" severity note;
	wait for (2*clk_period);
	assert (false)	report "INIT DONE- READY for DATA" severity note;
	wait for (4*clk_period);
	
	/* -- This code is used to Test if no refresh violations occur
	wait for 7 us;
	wait for 70 * clk_period;
	
			wait for 7 us;
	wait for 70 * clk_period;
	*/
	data 		<=	x"AFFE1234";
	addr		<=	std_logic_vector(to_unsigned(8388608, 25));
	req			<=	'1';
	we			<=	'1';
	
	wait until ack	=	'1'	for 0.1 ms;
	assert (false)	report "data was written to registers" severity note;
	data 		<=	(others	=>	'0');
	--addr		<=	(others	=>	'0');
	req			<=	'1';
	we			<=	'0';
	
	
	
	
	wait until  sdram_cs_n	=	'0' and  sdram_ras_n = '1' and sdram_cas_n = '0' and sdram_we_n = '0'	and sdram_a(10) = '1' for 0.1 ms;
	wait for	clk_period;
	assert (false)	report "Starting write process" severity note;
	
	wait until ack = '1' for 0.1 ms;
	wait for (2*clk_period);
	req			<=	'0';
	data 		<=	(others	=>	'0');
	addr		<=	std_logic_vector(to_unsigned(8388608, 25));
	
	assert (false)	report "DATA OUT DONE. STARTING READING PROCESS" severity note;
	
	wait for (4*clk_period);
	assert (false)	report "FIRST 16-BIT" severity note;
	sdram_dq(15 downto	0)	<=	x"1234";
	wait for clk_period;
	assert (false)	report "SECOND 16-BIT" severity note;
	sdram_dq(15 downto	0)	<=	x"AFFE";
	
		wait for clk_period;
	assert (false)	report "SECOND 16-BIT" severity note;
	sdram_dq(15 downto	0)	<=	(others	=>	'Z');
	
	
	wait until valid	=	'1'	for 0.1 ms;
	assert (false)	report "READING is DONE. DATA @ Q are valid" severity note;
	sdram_dq(15	downto	0)	<=	(others	=>	'Z');
	
WAIT;                                                       
END PROCESS init; 

Clock	:	process
begin
	clk	<= '0';
	wait for 	clk_period/2;
	clk <=	'1';
	wait for	clk_period/2;
end process Clock;                                          
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
WAIT;                                                        
END PROCESS always;                                          
END SDRAM_Controller_TOP_arch;
