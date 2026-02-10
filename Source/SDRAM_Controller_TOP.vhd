/**************************************************************
 Author: Twister10000 (Mika)
 
 Ensure that all constants and generics are adjusted for the SDRAM chip!
 PLS CHECK also the sdram_cmd_pkg for adjustments
**************************************************************/

-- Library Clause(s)
-- Use Clause(s) 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.sdram_cmd_pkg.all;

entity SDRAM_Controller_TOP is
	generic
	(
	
		-- Simulation Generic
		
		USE_PLL						:	boolean := true;
		
		-- these value is needed to calculate time periods [MHz]
		
		CLK_FREQ					:	real 		:= 100.0;
		
		
		-- 32-bit controller interface
		
		DATA_WIDTH				: natural := 	32;
		ADDR_WIDTH				:	natural	:= 	25; -- 25/24 Bank, 23-10 Row Address, 9-0 Column
		
		-- SDRAM Interface
		SDRAM_ADDR_WIDTH	:	natural := 	13;
		SDRAM_DATA_WIDTH	:	natural	:= 	16;
		SDRAM_COL_WIDTH		:	natural	:=	10;
		SDRAM_ROW_WIDTH		:	natural	:=	13;
		SDRAM_BANK_WIDTH	:	natural := 	2;
		
		
    -- The delay in clock cycles, between the start of a read command and the
    -- availability of the output data.
    CAS_LATENCY 			: natural := 2; -- 2=below 133MHz, 3=above 133MHz
		
		-- The number of 16-bit words to be bursted during a read/write.
    BURST_LENGTH 			: natural := 2; -- 1 | 2 | 4 | 8 
		
		-- Amount of Refresh needed during Startup-Phase
		REF_AMOUNT_INIT		:	natural	:=	8;					
		
    -- timing values (in nanoseconds)
    --
    -- These values can be adjusted to match the exact timing of your SDRAM
    -- chip (refer to the datasheet).
    T_DESL 						: real		 	:= 200000.0; 	-- startup delay
    T_MRD  						: real		 	:= 12.0; 			-- mode register cycle time
    T_RC   						: real		 	:= 60.0; 			-- row cycle time
    T_RCD  						: real		 	:= 18.0; 			-- RAS to CAS delay
    T_RP   						: real		 	:= 18.0; 			-- precharge to activate delay
    T_WR   						: real		 	:= 12.0; 			-- write recovery time
    T_REFI 						: real			:= 7812.5	  	-- average refresh interval 8192Zyklen allen 64ms 64m/8192 = 7812.5ns

		
	);


	port
	(
		-- I/O for Interfacing with Controller:
		-- Input ports
		-- reset
		reset : in std_logic := '0';

		-- clock
		clk 	: in std_logic;

		-- address bus
		addr 	: in std_logic_vector(ADDR_WIDTH-1 downto 0)	:=	(others	=>	'0');

		-- input data bus
		data 	: in std_logic_vector(DATA_WIDTH-1 downto 0)	:=	(others	=>	'0');

		-- When the write enable signal is asserted, a write operation will be performed.
		we 		: in std_logic;

		-- When the request signal is asserted, an operation will be performed.
		req 	: in std_logic;

		-- Output ports
    -- The acknowledge signal is asserted by the SDRAM controller when
    -- a request has been accepted.
    ack 	: out std_logic;

    -- The valid signal is asserted when there is a valid word on the output
    -- data bus.
    valid : out std_logic;

    -- output data bus
    q 		: out std_logic_vector(DATA_WIDTH-1 downto 0)								:=	(others	=>	'0');
		
		-- I/O for interfacing with SDRAM-Chip

		--Inout ports
    sdram_dq    : inout std_logic_vector(SDRAM_DATA_WIDTH-1 downto 0)	:=	(others	=>	'Z');
		-- Output ports
		sdram_a     : out std_logic_vector(SDRAM_ADDR_WIDTH-1 downto 0)		:=	(others	=>	'0');
    sdram_ba    : out std_logic_vector(SDRAM_BANK_WIDTH-1 downto 0)		:=	(others	=>	'0');
    sdram_cke   : out std_logic;
    sdram_cs_n  : out std_logic;
    sdram_ras_n : out std_logic;
    sdram_cas_n : out std_logic;
    sdram_we_n  : out std_logic;
    sdram_dqml  : out std_logic	:=	'1'; 	-- SDRAM_LDQM
    sdram_dqmh  : out std_logic	:=	'1'		-- SDRAM_HDQM
	);
end SDRAM_Controller_TOP;

architecture BEH_SDRAM_Controller_TOP of SDRAM_Controller_TOP is
	
	-- FSM Declarations
	type sdram_fsm_type is (init, refresh_init, mode, reading, writing, activate, idle, refresh);
	
	signal current_sdram_state				: sdram_fsm_type	:= 	init;
	signal next_sdram_state						:	sdram_fsm_type	:=	init;
	attribute	syn_encoding	: string;
	
	attribute	syn_encoding	of	sdram_fsm_type : type is	"safe";
	
	-- ARRAY Declarations
	
	type	data_reg_array	is array	(0 to BURST_LENGTH-1)	of	std_logic_vector(SDRAM_DATA_WIDTH-1	downto	0);
	signal	write_data	:	data_reg_array	:=	(others =>	(others	=>	'0'));
	signal	read_data		:	data_reg_array	:=	(others	=>	(others	=>	'0'));
	
	
	-- MODE Register				
					
	-- the ordering of the burst				
	constant	BURST_MODE								:	std_logic	:=	'0'; -- 0=sequential, 1=interleaved
					
	-- the write burst type for 				write operations
	constant	BURST_TYPE								:	std_logic	:=	'0'; -- 0=burst, 1=single
	
	-- the mode register value to configure the memory. Adjust the values to fit your SDRAM-CHIP
	constant	MODE_REGISTER_BANK				:	std_logic_vector(SDRAM_BANK_WIDTH-1	downto	0)	:=	"00";
	
	constant 	MODE_REGISTER_ADRESS			:	std_logic_vector((SDRAM_ADDR_WIDTH-1)	downto	0) := (
	
		"000" & 
		BURST_MODE & 
		"00" &	
		std_logic_vector(to_unsigned(CAS_LATENCY, 3)) & 
		BURST_TYPE & 
		std_logic_vector(to_unsigned(natural(ceil(log2(real(BURST_LENGTH)))), 3)));
		
	-- CLK_PERIOD in [ns]
	constant	CLK_PERIOD				:	real		:=	1.0/CLK_FREQ*1000.0; 
	-- number of clock cycles to wait before init
	constant	INIT_WAIT					:	natural	:=	natural(ceil(T_DESL / CLK_PERIOD)); -- ceil rounds the number to the next greater value and returns it as REAL var.
	
	-- the number of clock cycles to wait for LOAD_MODE CMD is executed
	constant	LOAD_MODE_WAIT		:	natural	:=	natural(ceil(T_MRD/CLK_PERIOD));
	
	-- the number of clock cycles to wait for REFRESH CMD is executed
	constant	REFRESH_WAIT			:	natural	:=	natural(ceil(T_RC/CLK_PERIOD));
	
	-- the number of clock cycles to wait for ACTIVE CMD is executed
	constant	ACTIVE_WAIT				:	natural	:=	natural(ceil(T_RCD/CLK_PERIOD));
	
	-- the number of clock cycles to wait for PRECHARGE CMD is executed
	constant	PRECHARGE_WAIT		:	natural	:=	natural(ceil(T_RP/CLK_PERIOD));
	
	-- the number of clock cycles to wait for READ CMD is executed
	constant	READ_WAIT					:	natural	:=	CAS_LATENCY+BURST_LENGTH;
	
	-- the number of clock cycles to wait for WRITE CMD is executed
	constant	WRITE_WAIT				:	natural	:=	BURST_LENGTH-2+natural(ceil((T_RP+T_WR)/CLK_PERIOD));
	
	-- the number of clock cycles befor REFRESH CMD is needed to prevent data loss!
	constant	REFRESH_CYCLE			:	natural	:=	natural(floor(T_REFI/CLK_PERIOD)); -- Alle 781 Zyklen Refresh CMD
	
	
	constant NUM_REFRESH : natural := 8;

signal refresh_counter   : natural range 0 to 2*NUM_REFRESH;
signal refresh_timer : natural range 0 to REFRESH_WAIT-1;
	
	-- signal declarations 
	signal 	sdram_clk					: std_logic := 	'0';
	signal	refresh_needed		:	std_logic	:=	'0';
	signal	init_done					:	std_logic	:=	'0';
	
	-- Control signals declarations
	
	signal	ready							:	std_logic	:=	'0';
	
	-- Counter declarations
	signal	wait_cnt					:	integer	range 0 to 	50e3								:= 	0;
	signal	refresh_cnt				:	integer	range 0 to 	50e3								:=	0;
	signal	refresh_init_cnt	:	integer	range	0	to	REF_AMOUNT_INIT+1		:=	0;
	signal	word_index				:	integer	range	0	to	BURST_LENGTH				:=	0;
	
	-- Registers declarations
	signal	addr_reg					:	std_logic_vector(SDRAM_BANK_WIDTH+SDRAM_COL_WIDTH+SDRAM_ROW_WIDTH-1	downto	0)	:=	(others	=>	'0');
	signal	data_reg					:	std_logic_vector(DATA_WIDTH-1	downto	0)	:=	(others	=>	'0');
	signal	q_reg							:	std_logic_vector(DATA_WIDTH-1	downto	0)	:=	(others	=>	'0');
	signal	we_reg						:	std_logic	:= '0';
	
	-- alias declarations
	alias		bank							:	std_logic_vector(SDRAM_BANK_WIDTH-1	downto	0)	is	addr_reg(SDRAM_BANK_WIDTH+SDRAM_ROW_WIDTH+SDRAM_COL_WIDTH-1	downto	SDRAM_ROW_WIDTH+SDRAM_COL_WIDTH);
	alias		row								:	std_logic_vector(SDRAM_ROW_WIDTH-1	downto	0)	is	addr_reg(SDRAM_ROW_WIDTH+SDRAM_COL_WIDTH-1	downto	SDRAM_COL_WIDTH);
	alias		column						:	std_logic_vector(SDRAM_COL_WIDTH-1	downto	0)	is	addr_reg(SDRAM_COL_WIDTH-1	downto	0);

	begin
		-- Generate Statement
		/**************************************************************
		/ Normal PLL Generation	for Final Version delete PLL!!!																									
		/**************************************************************/
	  PLL			: if USE_PLL = true generate -- wird bei der Quartus Compilation benutzt
			PLL1	:	entity work.SDRAM_PLL
        
        port map(
          
          inclk0 	=> clk,
          c0			=> sdram_clk);
					
    end generate PLL;

		/**************************************************************
		/ Simulation PLL Generation																										
		/**************************************************************/		
		Simu_PLL: if USE_PLL = false generate -- wird bei der Modelsim Simulation ausgefuehrt
          sdram_clk <= clk; -- Der Clock input wird direkt mit der globalen clk verbunden
    end generate Simu_PLL;

		-- Process Statement (optional)
		main : process(all)
		
			begin
			
				if rising_edge(sdram_clk) then
					
					current_sdram_state	<=	next_sdram_state;
					/*Default values for signal*/
					ack									<=	'0';																-- Default Value should be 0
					ready								<=	'0';																-- Default Value should be 0
					sdram_cke						<=	'1';
					--valid								<=	'0';																-- Default Value should be 0
					sdram_dqml					<=	'1';																-- Disables lower input byte buffer
					sdram_dqmh					<=	'1';																-- Disables higher input byte buffer
					sdram_a							<=	(others	=>	'0');										-- Default Value should be 0
					sdram_ba						<=	(others	=>	'0');										-- Default Value should be 0
					cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);	-- Default CMD should be NOP
					
					/*FSM for SDRAM_CONTROLLER*/
					case current_sdram_state is
						
					/*STATE: INIT*/
						when init			=>
						
							cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
						
							-- Phase 0: Start
							if wait_cnt = 0 then
								cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
						
							-- Phase 1: Precharge
							elsif wait_cnt = INIT_WAIT-1 then
								cmd_precharge_all(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n,	sdram_a);
								refresh_counter    <= 0;
								refresh_timer			 <= 0;
						
							-- Phase 2: Refresh-Sequenz
							elsif wait_cnt >= INIT_WAIT + PRECHARGE_WAIT -	1 then
						
								if	refresh_counter	=	0	then
									
									cmd_auto_refresh(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
									refresh_counter    	<= refresh_counter + 1;
									refresh_timer 			<= 0;
									
								elsif refresh_timer = REFRESH_WAIT-1 then
									
									if refresh_counter	=	NUM_REFRESH	then
										cmd_load_mode_reg(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
										sdram_a		<= 	MODE_REGISTER_ADRESS;
										sdram_ba	<=	MODE_REGISTER_BANK;
										next_sdram_state	<=	mode;
									
									else
										cmd_auto_refresh(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
										refresh_counter    	<= refresh_counter + 1;
										refresh_timer 			<= 0;
									end if;
								else
									refresh_timer <= refresh_timer + 1;
								end if;
						
							end if;
							
						/*STATE: LOAD MODE REGISTER*/
						when mode			=>
							
							sdram_a		<= 	MODE_REGISTER_ADRESS;
							sdram_ba	<=	MODE_REGISTER_BANK;
							
							if wait_cnt	>= LOAD_MODE_WAIT-1	then
								cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
								next_sdram_state	<=	idle;
								init_done					<=	'1';
								ready							<=	'1';
							end if;
							
						/*STATE: IDLE*/
						when idle 		=>
							
							ready	<=	'1';
							
							if refresh_needed	=	'1'	then
							
								next_sdram_state	<=	refresh;
								
								case next_sdram_state	is
									when refresh	=>
										cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
									when others		=>
										cmd_auto_refresh(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
								end case;	
							elsif	req	=	'1' or next_sdram_state	/= idle	then
								
								if	refresh_cnt	>= REFRESH_CYCLE-ACTIVE_WAIT-WRITE_WAIT-4 or refresh_cnt	>= REFRESH_CYCLE-ACTIVE_WAIT-READ_WAIT-4	then
									next_sdram_state	<=	refresh;
								else
								
									case	next_sdram_state	is
									
										when	activate	=>
											cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
											ready			<=	'0';
										when others		=>	
											next_sdram_state	<=	activate;
											cmd_activate(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
											sdram_ba	<= 	bank;
											sdram_a		<=	row;
											ack				<=	'1';
											ready			<=	'0';
									end case;
								end if;
							end if;
						
						/*STATE: WRITING*/
						when writing	=>
							sdram_dqml	<=	'0';
							sdram_dqmh	<=	'0';
							if wait_cnt	>= WRITE_WAIT-1	then
								ready				<=	'1';
								word_index	<=	0;
								sdram_dq	<=	(others	=>	'Z');
								if refresh_needed	=	'1' then
									next_sdram_state	<=	refresh;
									
									case next_sdram_state	is -- case for Handle the FSM-Change-delay 
										when refresh	=>
											cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
										when others		=>
											cmd_auto_refresh(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
									end case;
									
								elsif req = '1' /*or next_sdram_state	= activate */then
									
									if	refresh_cnt	>= REFRESH_CYCLE-ACTIVE_WAIT-WRITE_WAIT-6 or refresh_cnt	>= REFRESH_CYCLE-ACTIVE_WAIT-READ_WAIT-6	then
										next_sdram_state	<=	refresh;
									else
									
										case next_sdram_state	is	
											when activate	=>
												cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
												ready	<=	'0';
											when others	=>
												next_sdram_state	<=	activate;
												cmd_activate(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
												ack		<=	'1';
												ready	<=	'0';
										end case;
									end if;
								else
									next_sdram_state	<=	idle;
								end if;
								
							elsif word_index	<=	BURST_LENGTH-1	then
								word_index	<=	word_index	+	1;
								sdram_dq	<=	write_data(word_index);
							else
								ready	<=	'1';
							end if;
						
						/*STATE: READING*/	
						when reading	=>
							-- ToDo reading Beh
							sdram_dqml	<=	'0';
							sdram_dqmh	<=	'0';
							if wait_cnt	>=	CAS_LATENCY-1	then -- wait CAS_LATENCY
								
								if wait_cnt	>=	READ_WAIT-1	then
									-- Fertig Gelesen
									ready				<=	'1';
									word_index	<=	0;
									/*LOOP To OUTPUT READ DATA to Q OUTPUT*/
									for i in 0 to BURST_LENGTH-1 loop
										q((i+1)*SDRAM_DATA_WIDTH-1 downto	i*SDRAM_DATA_WIDTH)	<=	read_data(i);
									end loop;
									
									valid	<=	'1';
									sdram_dq	<=	(others	=>	'Z');
									if	refresh_needed	=	'1'	then
										next_sdram_state	<=	refresh;
										
										case next_sdram_state	is -- case for Handle the FSM-Change-delay 
											when refresh	=>
												cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
											when others		=>
												cmd_auto_refresh(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
										end case;
										
									elsif	req	=	'1' or next_sdram_state	= activate	then -- NEW Operation	should be performed
										
										case next_sdram_state	is	
											when activate	=>
												cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
												ready	<=	'0';
											when others	=>
												next_sdram_state	<=	activate;
												cmd_activate(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
												ack		<=	'1';
												ready	<=	'0';
										end case;		
									else		-- Going back to IDLE
										next_sdram_state	<= idle;
									end if;

								else
									word_index						<=	word_index	+	1; 	-- bump+ index for ARRAY
									read_data(word_index)	<=	sdram_dq;					-- write Data to OUTPUT ARRAY-REGISTER
								end if;
								
							end if;
							
						/*STATE: REFRESH*/	
						when refresh	=>
							
							if wait_cnt	>= REFRESH_WAIT-3 and init_done	=	'1' then
								
								next_sdram_state	<=	idle;
								ready	<=	'1';
							elsif	wait_cnt	>= REFRESH_WAIT-3 and next_sdram_state /= refresh_init	then
								
								refresh_init_cnt	<=	refresh_init_cnt	+	1;
								next_sdram_state	<=	refresh_init;
							
							end if;
						
						/*STATE: ACTIVATE*/	
						when activate		=>
							
							if wait_cnt	>= ACTIVE_WAIT-1 then
								
								if we_reg	=	'1' then
									
									case	next_sdram_state	is
										when writing	=>
											cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
											word_index	<=	word_index	+	1;
											sdram_dq		<=	write_data(word_index);
											sdram_dqml	<=	'0';
											sdram_dqmh	<=	'0';
										when others		=>
											
										cmd_write(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
										next_sdram_state	<=	writing;
										sdram_ba					<= 	bank;
										sdram_a						<=	"001" & column; -- Auto-Precharge A10 needs to be HIGH
										sdram_dqml				<=	'0';	-- Enables lower input byte buffer
										sdram_dqmh				<=	'0';	-- Enables higher input byte buffer
										
										word_index	<=	word_index	+	1;
										sdram_dq	<=	write_data(word_index);
									end case;	
								else
									-- Reading_Beh
									case next_sdram_state	is
										when	reading	=>
											cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
											valid	<=	'0';
											sdram_dqml				<=	'0';	-- Enables lower input byte buffer
											sdram_dqmh				<=	'0';	-- Enables higher input byte buffer
											
										when others		=>												
											cmd_read(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
											next_sdram_state	<=	reading;
											sdram_ba					<= 	bank;
											sdram_a						<=	"001" & column; -- Auto-Precharge A10 needs to be HIGH
											sdram_dqml				<=	'0';	-- Enables lower input byte buffer
											sdram_dqmh				<=	'0';	-- Enables higher input byte buffer
									end case;
									
									
								end if;
							else
								cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
							end if;
					
						/*STATE: OTHERS*/	
						when others	=> next_sdram_state <= idle;
					end case;
				end if;
		end process main; 
		
		-- process for wait_cnt
		update_wait_cnt			:	process(all)
			begin
				
				if rising_edge(sdram_clk)	then
					-- TO DO Logic for CNT Update
					if reset	= '1' then
						wait_cnt	<= 	0;
					elsif	next_sdram_state	/= current_sdram_state	then
						wait_cnt	<=	0;
					else
						wait_cnt	<= wait_cnt	+	1;
					end if;
				end if;			
	
		end process update_wait_cnt;

		-- process for refresh_cnt
		update_refresh_cnt	:	process(all)
			begin
				if rising_edge(sdram_clk)	then
					
					if reset	=	'1'	then
					
						refresh_cnt				<=	0;
						refresh_needed		<=	'0';
						
					elsif	current_sdram_state	= refresh and wait_cnt	=	0	then
					
						refresh_cnt				<=	0;
						refresh_needed		<=	'0';
						
					elsif	refresh_cnt	>= REFRESH_CYCLE - 4 then
					
						refresh_needed		<=	'1';
						
					else
					
						refresh_cnt				<=	refresh_cnt	+	1;
						
					end if;
					
				end if;
		end process	update_refresh_cnt;
		
		register_input	:	process(all)
		
			begin
			
				if rising_edge(sdram_clk)	then
				
					if ready	=	'1'	then
						for i in 0 to BURST_LENGTH-1 loop
							write_data(i) <= data((i+1)*SDRAM_DATA_WIDTH-1 downto i*SDRAM_DATA_WIDTH);
						end loop;
						addr_reg	<=	addr;
						we_reg		<=	we;
					end if;
				
				end if;
				
		end process register_input;
		
end BEH_SDRAM_Controller_TOP;