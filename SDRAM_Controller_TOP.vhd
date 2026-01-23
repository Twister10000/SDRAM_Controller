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
	
		-- 32-bit controller interface
		
		DATA_WIDTH				: natural := 10;
		ADDR_WIDTH				:	natural	:= 10;
		
		-- SDRAM Interface
		SDRAM_ADDR_WIDTH	:	natural := 10;
		SDRAM_DATA_WIDTH	:	natural	:= 10;
		SDRAM_BANK_WIDTH	:	natural := 10
	);


	port
	(
		-- I/O for Interfacing with Controller:
		-- Input ports
		-- reset
		reset : in std_logic := '0';

		-- clock
		clk : in std_logic;

		-- address bus
		addr : in unsigned(ADDR_WIDTH-1 downto 0);

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
		sdram_a     : out unsigned(SDRAM_ADDR_WIDTH-1 downto 0);
    sdram_ba    : out unsigned(SDRAM_BANK_WIDTH-1 downto 0);
    sdram_cke   : out std_logic;
    sdram_cs_n  : out std_logic;
    sdram_ras_n : out std_logic;
    sdram_cas_n : out std_logic;
    sdram_we_n  : out std_logic;
    sdram_dqml  : out std_logic;
    sdram_dqmh  : out std_logic
	);
end SDRAM_Controller_TOP;

architecture BEH_SDRAM_Controller_TOP of SDRAM_Controller_TOP is

	-- Declarations (optional)

begin

	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end BEH_SDRAM_Controller_TOP;
