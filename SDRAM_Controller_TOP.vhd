library ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;
use	ieee.std_logic_unsigned.all;

entity SDRAM_Controller_TOP is
	generic
	(
		<name>	: <type>  :=	<default_value>;
		...
		<name>	: <type>  :=	<default_value>
	);


	port
	(
		-- Input ports
		<name>	: in  <type>;
		<name>	: in  <type> := <default_value>;

		-- Inout ports
		<name>	: inout <type>;

		-- Output ports
		<name>	: out <type>;
		<name>	: out <type> := <default_value>
	);
end SDRAM_Controller_TOP;

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

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
