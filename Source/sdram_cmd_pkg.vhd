
-- Library Clause(s) (optional)
-- Use Clause(s) (optional)
library ieee;
use ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

package sdram_cmd_pkg is

	-- Type Declaration (optional)

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)
	
		-- constant declarations
		-- CMD from COMMAND TRUTH Table
		constant	CMD_DESELECT_CONST				:	std_logic_vector(3	downto	0)	:=	"1000";
		constant	CMD_NOP_CONST							:	std_logic_vector(3	downto	0)	:=	"0111";
		constant	CMD_BRST_STOP_CONST				:	std_logic_vector(3	downto	0)	:=	"0110";
		constant	CMD_READ_CONST						:	std_logic_vector(3	downto	0)	:=	"0101";
		constant	CMD_WRITE_CONST						:	std_logic_vector(3	downto	0)	:=	"0100";
		constant	CMD_BANK_ACTIVATE_CONST		:	std_logic_vector(3	downto	0)	:=	"0011";
		constant	CMD_LOAD_MODE_CONST				:	std_logic_vector(3	downto	0)	:=	"0000";
		constant	CMD_AUTO_REFRESH_CONST		:	std_logic_vector(3	downto	0)	:=	"0001";
		constant	CMD_PRECHARGE_CONST				:	std_logic_vector(3	downto	0)	:=	"0010";

	-- Procedure Declaration (optional)
	
	procedure cmd_nop (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic
	);
	
	procedure cmd_precharge_all (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	);
		
	procedure	cmd_precharge_single (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a  		: out std_logic_vector(12 downto 	0);
		signal sdram_ba			:	out	std_logic_vector(1	downto	0)
	
	);
		
	
	procedure cmd_auto_refresh (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic
	);
	
	procedure cmd_load_mode_reg (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	);
		
	procedure cmd_read (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	);
		
	procedure cmd_write (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	);
		
	procedure cmd_active (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	);
	
	-- Component Declaration (optional)

end sdram_cmd_pkg;


package body sdram_cmd_pkg  is

	-- Procedure Declaration (optional)
	
	procedure cmd_nop (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic
	) is
	begin
	
		(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n)	<= CMD_NOP_CONST;

	end procedure	cmd_nop;
	
	procedure cmd_precharge_all (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	) is
	begin

		(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n)	<= CMD_PRECHARGE_CONST;
		sdram_a(10)						<=	'1';
	end procedure	cmd_precharge_all;
		
	procedure	cmd_precharge_single (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a  		: out std_logic_vector(12 downto 0);
		signal sdram_ba			:	out	std_logic_vector(1	downto	0)
	
	)is
	begin
		(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n)	<= CMD_PRECHARGE_CONST;
		sdram_a(10)					<=	'0';
	end procedure	cmd_precharge_single;
		
	
	procedure cmd_auto_refresh (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic
	)is
	begin
		(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n)	<= CMD_AUTO_REFRESH_CONST;
	end procedure	cmd_auto_refresh;
	
	procedure cmd_load_mode_reg (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	)is
	begin
	
		(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n)	<= CMD_LOAD_MODE_CONST;
	
	end procedure	cmd_load_mode_reg;
		
	procedure cmd_read (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	)is
	begin
		(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n)	<= CMD_READ_CONST;
	end procedure	cmd_read;
		
	procedure cmd_write (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	)is
	begin
		(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n)	<= CMD_WRITE_CONST;
	end procedure	cmd_write;
		
	procedure cmd_active (
		signal sdram_cs_n   : out std_logic;
		signal sdram_ras_n  : out std_logic;
		signal sdram_cas_n  : out std_logic;
		signal sdram_we_n   : out std_logic;
		signal sdram_a		  : out std_logic_vector(12 downto 0)
	)is
	begin
		(sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n)	<= CMD_BANK_ACTIVATE_CONST;
	end procedure	cmd_active;
	
	-- Component Declaration (optional)	
	

	-- Procedure Body (optional)

end sdram_cmd_pkg;

