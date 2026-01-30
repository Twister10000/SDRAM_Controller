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
		
		DATA_WIDTH				: natural := 16;
		ADDR_WIDTH				:	natural	:= 12;
		
		-- SDRAM Interface
		SDRAM_ADDR_WIDTH	:	natural := 13;
		SDRAM_DATA_WIDTH	:	natural	:= 16;
		SDRAM_BANK_WIDTH	:	natural := 2;
		
		
    -- The delay in clock cycles, between the start of a read command and the
    -- availability of the output data.
    CAS_LATENCY 			: natural := 2; -- 2=below 133MHz, 3=above 133MHz
		
		-- The number of 16-bit words to be bursted during a read/write.
    BURST_LENGTH 			: natural := 2;
		
		
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
    T_REFI 						: real			:= 7812.5  		-- average refresh interval 8192Zyklen allen 64ms 64m/8192 = 7812.5ns		
		
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
    sdram_dq    : inout std_logic_vector(SDRAM_DATA_WIDTH-1 downto 0)	:=	(others	=>	'0');
		-- Output ports
		sdram_a     : out std_logic_vector(SDRAM_ADDR_WIDTH-1 downto 0)		:=	(others	=>	'0');
    sdram_ba    : out std_logic_vector(SDRAM_BANK_WIDTH-1 downto 0)		:=	(others	=>	'0');
    sdram_cke   : out std_logic;
    sdram_cs_n  : out std_logic;
    sdram_ras_n : out std_logic;
    sdram_cas_n : out std_logic;
    sdram_we_n  : out std_logic;
    sdram_dqml  : out std_logic; 	-- SDRAM_LDQM
    sdram_dqmh  : out std_logic		-- SDRAM_HDQM
	);
end SDRAM_Controller_TOP;

architecture BEH_SDRAM_Controller_TOP of SDRAM_Controller_TOP is
	
	-- FSM Declarations
	type sdram_fsm_type is (init, mode, reading, writing, active, idle, refresh);
	
	signal current_sdram_state				: sdram_fsm_type	:= 	init;
	signal next_sdram_state						:	sdram_fsm_type	:=	init;
	attribute	syn_encoding	: string;
	
	attribute	syn_encoding	of	sdram_fsm_type : type is	"safe";
	
	-- constant declarations
	-- CMD from COMMAND TRUTH Table
--	constant	CMD_DESELECT							:	std_logic_vector(3	downto	0)	:=	"1000";
--	constant	CMD_NOP										:	std_logic_vector(3	downto	0)	:=	"0111";
--	constant	CMD_BRST_STOP							:	std_logic_vector(3	downto	0)	:=	"0110";
--	constant	CMD_READ									:	std_logic_vector(3	downto	0)	:=	"0101";
--	constant	CMD_WRITE									:	std_logic_vector(3	downto	0)	:=	"0100";
--	constant	CMD_BANK_ACTIVATE					:	std_logic_vector(3	downto	0)	:=	"0011";
--	constant	CMD_LOAD_MODE							:	std_logic_vector(3	downto	0)	:=	"0000";
--	constant	CMD_AUTO_REFRESH					:	std_logic_vector(3	downto	0)	:=	"0001";
--	constant	CMD_PRECAHRGE							:	std_logic_vector(3	downto	0)	:=	"0010";
					
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
	constant	WRITE_WAIT				:	natural	:=	CAS_LATENCY+natural(ceil((T_RP+T_WR)/CLK_PERIOD));
	
	-- the number of clock cycles befor REFRESH CMD is needed to prevent data loss!
	constant	REFRESH_CYCLE			:	natural	:=	natural(floor(T_REFI/CLK_PERIOD)); -- Alle 781 Zyklen Refresh CMD
	
	
	-- signal declarations 
	signal 	sdram_clk				: std_logic := 	'0';
	signal	refresh_needed	:	std_logic	:=	'0';
	
	signal	cmd					:	std_logic_vector(3	downto	0)	:=	CMD_NOP_CONST;
	signal	next_cmd		:	std_logic_vector(3	downto	0)	:=	CMD_NOP_CONST;
	
	signal	wait_cnt					:	integer	range 0 to 50e3	:= 	0;
	signal	refresh_cnt				:	integer	range 0 to 50e3	:=	0;

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
					cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
					
					case current_sdram_state is
						
						when init			=>
							-- ToDo init Beh
						
							if	wait_cnt	= INIT_WAIT-1	then
							
								cmd_precharge_all(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n, sdram_a);
								
							elsif	wait_cnt	=	(INIT_WAIT+PRECHARGE_WAIT+8*REFRESH_WAIT)-1	then
							
								next_sdram_state	<= mode;
								cmd_load_mode_reg(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n, sdram_a);
								sdram_a		<= 	MODE_REGISTER_ADRESS;
								sdram_ba	<=	MODE_REGISTER_BANK;
								
							elsif	wait_cnt	>= (INIT_WAIT+PRECHARGE_WAIT)-1 and next_sdram_state /= mode	then
							
								cmd_auto_refresh(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
							
							elsif	wait_cnt	>=	(INIT_WAIT+PRECHARGE_WAIT+8*REFRESH_WAIT)-1 and next_sdram_state = mode	then
								
								cmd_load_mode_reg(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n, sdram_a);
								sdram_a		<= 	MODE_REGISTER_ADRESS;
								sdram_ba	<=	MODE_REGISTER_BANK;		
								
							end if;
						
						when mode			=>
							
							sdram_a		<= 	MODE_REGISTER_ADRESS;
							sdram_ba	<=	MODE_REGISTER_BANK;
							
							if wait_cnt	>= LOAD_MODE_WAIT-1	then
								cmd_nop(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
								next_sdram_state	<=	idle;
							end if;
						
						when idle 		=>
							-- ToDo Idle Beh
							if refresh_needed	=	'1'	then
								next_sdram_state	<=	refresh;
								cmd_auto_refresh(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n);
							end if;
						
						when writing	=>
							-- ToDo writing Beh
							
						when reading	=>
							-- ToDo reading Beh
							
						when refresh	=>
							-- ToDo refresh Beh
							if wait_cnt	>= REFRESH_WAIT-1 then
								
								next_sdram_state	<=	idle;
								
							end if;
							
						
						when active		=>
							-- ToDo active Beh
							
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
		
end BEH_SDRAM_Controller_TOP;
