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
signal diff_x:	   signed(10 downto 0);
signal diff_y:	   signed(10 downto 0);

signal r:			unsigned(20 downto 0);
signal en_out2:	std_logic;

signal r_3:			unsigned(63 downto 0);
signal en_out3:	std_logic;

signal r_3_fp:		unsigned(63 downto 0);
signal en_out4:	std_logic;
begin

	-- 1 stage pipeline - calculate 
	pipe_stage1: work.pipe_st1
		port map(clk => clk, reset => reset, en_in => '1', rx_a => "01100100000", rx_b => "00000000000", 
		ry_a => "01001011000", ry_b => "00000000000", diff_x => diff_x, diff_y => diff_y, en_out=> en_out1);
	
	-- 1 stage pipeline - calculate r
	pipe_stage2: work.pipe_st2
		port map(clk => clk, reset => reset, en_in => en_out1, diff_x => diff_x, diff_y => diff_y, r => r, en_out  => en_out2); 
	
	-- 1-stage pipeline - calculate r^3
	r_cube: work.r_cube
		port map(clk => clk, reset => reset, en_in => en_out2, r_in => r, r_3 => r_3, en_out => en_out3);
	
	r_cube_fp: work.unsigned_to_fp
		port map(clk => clk, reset => reset, en_in => en_out3, input => r_3, output => r_3_fp, en_out => en_out4);
		
--	debug <= std_logic_vector(r_3_fp(63 downto 56));
	debug <= std_logic_vector(r_3_fp(55 downto 48));
--	debug <= std_logic_vector(r_3_fp(47 downto 40));
--	debug <= std_logic_vector(r_3_fp(39 downto 32));
	
end arch;