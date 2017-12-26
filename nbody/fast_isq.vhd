library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- pipelined fast inverse-square-root algorithm
entity fast_isq is
	port(
		clk:			in std_logic;
		reset:		in std_logic;
		
		input:		in unsigned(63 downto 0);
		en_in:		in std_logic;
		
		
		en_out:		out std_logic;
		output:		out unsigned(63 downto 0)
	);
end fast_isq;


architecture arch of fast_isq is
	-- floating point representation of 1.5F
	constant TH_F : 	bit_vector(63 downto 0) := "0011111111111000000000000000000000000000000000000000000000000000";
	-- floating point representation of 0.5F
	constant OH_F:		bit_vector(63 downto 0) := "0011111111111000000000000000000000000000000000000000000000000000";
	-- 64 bit magic number
	constant MN_F: 	integer := 16#5fe6eb50c7b537a9#;
	
	signal tmp:			unsigned(63 downto 0);
begin
	
	tmp <= (MN_F - ('0' & input(63 downto 1))); -- i  = MAGIC_NR - ( i >> 1 );
	
	

end arch;