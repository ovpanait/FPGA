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

signal mul_res:	unsigned(63 downto 0);
signal en_out5:	std_logic;

signal uns_out:	unsigned(63 downto 0);
signal en_out6:	std_logic;

signal add_out:	unsigned(63 downto 0);
signal test_sig2: unsigned(63 downto 0) := "0011111111111000000000000000000000000000000000000000000000000000"; -- 1.5F
signal test_sig1:	unsigned(63 downto 0) := "1011111100101010001101101110001011101011000111000100001100101101"; -- 123
signal test_sig3: unsigned(63 downto 0) := "0011111111100000000000000000000000000000000000000000000000000000"; -- 0.5
signal test_sig4:	unsigned(63 downto 0) := "0011111110100011100001110101000011000111101101010011011110101001"; 
signal en_out7:	std_logic;

-- fast inv square root - stage 1
signal x:				unsigned(63 downto 0);	
signal in_half:		unsigned(63 downto 0);

-- fast inv square root - stage 2
signal x_sq:			unsigned(63 downto 0);
signal x_half_x:		unsigned(63 downto 0);
signal x_1_5:			unsigned(63 downto 0);

-- fast inv square root - stage 3
signal en_out8:			std_logic;
signal x_sqMx_half_x:	unsigned(63 downto 0);
signal x_1_5b:			unsigned(63 downto 0);
	
-- fast inv square root - stage 4 
signal en_out9:	std_logic;
signal fisr_res:	unsigned(63 downto 0);

-- debug
signal tmp_dbg:	unsigned(7 downto 0);
begin

	-- 1 stage - calculate 
	pipe_stage1: work.pipe_st1
		port map(clk => clk, reset => reset, en_in => '1', rx_a => "00000000011", rx_b => "00000000000", 
		ry_a => "00000000000", ry_b => "00000000000", diff_x => diff_x, diff_y => diff_y, en_out=> en_out1);
	
	-- 1 stage - calculate r
	pipe_stage2: work.pipe_st2
		port map(clk => clk, reset => reset, en_in => en_out1, diff_x => diff_x, diff_y => diff_y, r => r,
		en_out  => en_out2); 
	
	-- 1-stage - calculate r^3
	r_cube: work.r_cube
		port map(clk => clk, reset => reset, en_in => en_out2, r_in => r, r_3 => r_3, en_out => en_out3);
	
	r_cube_fp: work.unsigned_to_fp
		port map(clk => clk, reset => reset, en_in => en_out3, input => r_3, output => r_3_fp,
		en_out => en_out4);
	
	fpmu_test: work.fpmu
		port map(clk => clk, reset => reset, en_in => en_out4, a => test_sig4, b => test_sig4, result => mul_res,
		en_out => en_out5);

	-- 4-stage pipelined fst inverse squared root
	fast_isq1: work.fast_isq_st1
		port map(clk => clk, reset => reset, en_in => en_out5, input => r_3_fp, x => x, in_half => in_half,
		en_out => en_out6);
	
	fast_isq2: work.fast_isq_st2
		port map(clk => clk, reset => reset, en_in => en_out6, x => x, in_half => in_half, x_sq => x_sq, 
		x_half_x => x_half_x, x_1_5 => x_1_5, en_out => en_out7);
	
	fast_isq3: work.fast_isq_st3
		port map(clk => clk, reset => reset, en_in => en_out7, x_sq => x_sq, x_half_x => x_half_x, x_1_5 => x_1_5, 
		x_sqMx_half_x => x_sqMx_half_x, x_1_5_b => x_1_5b, en_out => en_out8);
	
	fast_isq4: work.fast_isq_st4
		port map(clk => clk, reset => reset, en_in => en_out8, x_1_5 => x_1_5b, x_sqMx_half_x => x_sqMx_half_x, 
		result => fisr_res, en_out => en_out9);
		
--	fp_add: work.fp_add
--		port map(clk => clk, reset => reset, en_in => en_out4, a => test_sig2, b => test_sig1, result => add_out, en_out => en_out5);
		
--	fp_to_u64:	work.ftou
--		port map(clk => clk, reset => reset, en_in => en_out5, input => mul_res, output => uns_out, debug => tmp_dbg, en_out => en_out6);
		
--	debug <= std_logic_vector(fisr_res(63 downto 56));
--	debug <= std_logic_vector(fisr_res(55 downto 48));
--	debug <= std_logic_vector(fisr_res(47 downto 40));
--	debug <= std_logic_vector(fisr_res(39 downto 32));
--	debug <= std_logic_vector(fisr_res(31 downto 24));
--	debug <= std_logic_vector(fisr_res(23 downto 16));
--	debug <= std_logic_vector(fisr_res(15 downto 8));
	debug <= std_logic_vector(fisr_res(7 downto 0));
--	debug <= std_logic_vector(tmp_dbg);
		
end arch;