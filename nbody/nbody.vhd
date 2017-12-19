library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nbody is
	port (
		clk:		in std_logic;
		reset: 	in std_logic;
		
		debug:	out std_logic_vector(7 downto 0)
		
		);
end nbody;
		
architecture arch of nbody is
signal en_out1:	std_logic;
signal diff_x:	   signed(15 downto 0);
signal diff_y:	   signed(15 downto 0);

signal r:			signed(31 downto 0);
signal en_out2:	std_logic;
begin

	
	pipe_stage1: work.pipe_st1
		port map(clk => clk, reset => reset, en_in => '1', rx_a => "0000000000000100", rx_b => "0000000000000001", 
		ry_a => "0000000000000100", ry_b => "0000000000000100", diff_x => diff_x, diff_y => diff_y, en_out=> en_out1);
	
	-- calculate r
	pipe_stage2: work.pipe_st2
		port map(clk => clk, reset => reset, en_in => en_out1, diff_x => diff_x, diff_y => diff_y, r => r, en_out  => en_out2); 
	
	debug <= std_logic_vector(r(7 downto 0));

end arch;