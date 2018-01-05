library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity vel_controller is
  generic(
    ADDRESS_W:          integer := 8;
    -- 64 bit x velocity
	 -- 64 bit y velocity
	 DATA_W:             integer := 128
    );

  port(
		clk, reset:		in std_logic;
		en_in:			in std_logic;
		
		delta_vx:		in unsigned(63 downto 0);
		delta_vy:		in unsigned(63 downto 0);
		
		restart:			out std_logic
    );
end vel_controller;


architecture arch of vel_controller is
	constant CNT_MAX:	integer := 2**ADDRESS_W - 1;
	
	type reg_file_type is array ((2**ADDRESS_W) - 1 downto 0) of
		unsigned(DATA_W-1 downto 0);
	signal array_reg:     reg_file_type;
	 
	signal cnt_a_reg, cnt_b_reg:			unsigned(ADDRESS_W - 1 downto 0);
	signal cnt_a_next, cnt_b_next:		unsigned(ADDRESS_W - 1 downto 0);
	signal restart_reg, restart_next:	std_logic;
	
	signal wr_en:			std_logic;
	signal w_data1:      unsigned(DATA_W - 1 downto 0);
	signal w_data2:      unsigned(DATA_W - 1 downto 0);
begin

	process(clk, reset)
	begin
	if (reset = '0') then
      array_reg 	<= (others => (others => '0'));
		cnt_a_reg	<= (others => '0');
		cnt_b_reg	<= (others => '0');
		restart_reg <= '0';
    elsif (clk'event and clk='1') then
		cnt_a_reg 	<= cnt_a_next;
		cnt_b_reg 	<= cnt_b_next;
		restart_reg <= restart_next;
	 end if;
	end process;
	
	process(array_reg, cnt_a_reg, cnt_b_reg, wr_en)
	begin
	cnt_a_next	 <= cnt_a_reg;
	cnt_b_next 	 <= cnt_b_reg;
	restart_next <= '0';
	
	if (wr_en = '1') then
		array_reg(to_integer(cnt_a_reg)) <= w_data1;
		array_reg(to_integer(cnt_b_reg)) <= w_data2;
		
		if (cnt_b_reg = CNT_MAX) then
			if (cnt_a_reg = CNT_MAX - 1) then
				-- start over
					cnt_a_next   <= (others => '0');
					cnt_b_next   <= (1 => '1' , others => '0');
					restart_next <= '1';
			else
				cnt_a_next <= cnt_a_reg + to_unsigned(1, cnt_a_reg'length);
				cnt_b_next <= cnt_a_reg + to_unsigned(2, cnt_a_reg'length);
			end if;
		else
			cnt_b_next <= cnt_b_reg + 1;
		end if;
   end if;
  end process;

  	vel_x_a : work.fp_add
		port map(clk, reset, en_in,
			delta_vx, 
			array_reg(to_integer(cnt_a_reg))(127 downto 64),
			w_data1(127 downto 64),
			wr_en);
			
  	vel_y_a : work.fp_add
		port map(
			clk, reset, en_in, 
			delta_vy,
			array_reg(to_integer(cnt_a_reg))(63 downto 0),
			w_data1(63 downto 0),
			open);
	
	vel_x_b : work.fp_add
		port map(
			clk, reset, en_in, 
			not delta_vx(63) & delta_vx(62 downto 0),
			array_reg(to_integer(cnt_b_reg))(127 downto 64),
			w_data2(127 downto 64),
			open);

	vel_y_b : work.fp_add
		port map(
			clk, reset, en_in,
			not delta_vy(63) & delta_vy(62 downto 0), 
			array_reg(to_integer(cnt_b_reg))(63 downto 0),
			w_data1(63 downto 0), 
			open);
			
	restart <= restart_reg;
end arch;

