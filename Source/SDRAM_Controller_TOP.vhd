/**************************************************************
 Author: Twister10000 (Mika)
**************************************************************/

-- Library Clause(s)
-- Use Clause(s) 
library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

entity SDRAM_Controller_TOP is
	generic
	(
	
		-- Simulation Generic
		
		USE_PLL						:	boolean := true;
		
		-- 32-bit controller interface
		
		DATA_WIDTH				: natural := 16;
		ADDR_WIDTH				:	natural	:= 12;
		
		-- SDRAM Interface
		SDRAM_ADDR_WIDTH	:	natural := 12;
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
    T_DESL 						: natural := 200000; 	-- startup delay
    T_MRD  						: natural := 12; 			-- mode register cycle time
    T_RC   						: natural := 60; 			-- row cycle time
    T_RCD  						: natural := 18; 			-- RAS to CAS delay
    T_RP   						: natural := 18; 			-- precharge to activate delay
    T_WR   						: natural := 12; 			-- write recovery time
    T_REFI 						: real 		:= 7812.5  	-- average refresh interval 8192Zyklen allen 64ms 64m/8192 = 7812.5ns		
		
	);


	port
	(
		-- I/O for Interfacing with Controller:
		-- Input ports
		-- reset
		reset : in std_logic := '0';

		-- clock
		CLK : in std_logic;

		-- address bus
		addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);

		-- input data bus
		data : in std_logic_vector(DATA_WIDTH-1 downto 0);

		-- When the write enable signal is asserted, a write operation will be performed.
		we : in std_logic;

		-- When the request signal is asserted, an operation will be performed.
		req : in std_logic;

		-- Output ports
    -- The acknowledge signal is asserted by the SDRAM controller when
    -- a request has been accepted.
    ack : out std_logic;

    -- The valid signal is asserted when there is a valid word on the output
    -- data bus.
    valid : out std_logic;

    -- output data bus
    q : out std_logic_vector(DATA_WIDTH-1 downto 0);
		
		-- I/O for interfacing with SDRAM-Chip

		--Inout ports
    sdram_dq    : inout std_logic_vector(SDRAM_DATA_WIDTH-1 downto 0);
		-- Output ports
		sdram_a     : out std_logic_vector(SDRAM_ADDR_WIDTH-1 downto 0);
    sdram_ba    : out std_logic_vector(SDRAM_BANK_WIDTH-1 downto 0);
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
	type sdram_fsm_type is (init, reading, writing, active, idle, refresh);
	
	signal FSM_SDRAM				: sdram_fsm_type	:= init;
	attribute	syn_encoding	: string;
	
	attribute	syn_encoding	of	sdram_fsm_type : type is	"safe";
	
	-- constant declarations
	-- CMD from COMMAND TRUTH Table
	constant	CMD_DESELECT			:	std_logic_vector(3	downto	0)	:=	"1000";
	constant	CMD_NOP						:	std_logic_vector(3	downto	0)	:=	"0111";
	constant	CMD_BRST_STOP			:	std_logic_vector(3	downto	0)	:=	"0110";
	constant	CMD_READ					:	std_logic_vector(3	downto	0)	:=	"0101";
	constant	CMD_WRITE					:	std_logic_vector(3	downto	0)	:=	"0100";
	constant	CMD_BANK_ACTIVATE	:	std_logic_vector(3	downto	0)	:=	"0011";
	constant	CMD_LOAD_MODE			:	std_logic_vector(3	downto	0)	:=	"0000";
	constant	CMD_AUTO_REFRESH	:	std_logic_vector(3	downto	0)	:=	"0001";
	constant	CMD_PRECAHRGE			:	std_logic_vector(3	downto	0)	:=	"0010";
	
	-- signal declarations 
	signal 	SDRAM_CLK	: std_logic := '0';

begin
		-- Generate Statement
		/**************************************************************
		/ Normal PLL Generation	for Final Version delete PLL!!!																									
		/**************************************************************/
	  PLL			: if USE_PLL = true generate -- wird bei der Quartus Compilation benutzt
			PLL1	:	entity work.SDRAM_PLL
        
        port map(
          
          inclk0 	=> CLK,
          c0			=> SDRAM_CLK);
					
    end generate PLL;

		/**************************************************************
		/ Simulation PLL Generation																										
		/**************************************************************/		
		Simu_PLL: if USE_PLL = false generate -- wird bei der Modelsim Simulation ausgefÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¼hrt
          SDRAM_CLK <= CLK; -- Der Clock input wird direkt mit dem globalen
    end generate Simu_PLL;

		-- Process Statement (optional)
		main : process(all)
		
			begin
			
				if rising_edge(SDRAM_CLK) then
					
					valid	<=	not valid;
					
					case fsm_SDRAM is
						
						when idle 		=>
							-- ToDo Idle Beh
						
						when writing	=>
							-- ToDo writing Beh
							
						when reading	=>
							-- ToDo reading Beh
							
						when refresh	=>
							-- ToDo refresh Beh
							
						when others	=> fsm_SDRAM <= idle;
					end case;
					
				end if;
		end process main; 

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)


end BEH_SDRAM_Controller_TOP;
