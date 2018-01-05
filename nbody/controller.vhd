library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ld_controller is
  generic(
    ADDRESS_W:          integer := 8;
    -- 64 bit x coordinate
	 -- 64 bit y coordinate
	 DATA_W:             integer := 128
    );

  port(
		clk, reset:		in std_logic;
		ready:			in std_logic;
		
		wr_en:			in std_logic;
		w_addr:     	in unsigned(ADDRESS_W - 1 downto 0);
		w_data:        in unsigned(DATA_W - 1 downto 0);
		
		ld_a:				out unsigned(DATA_W - 1 downto 0);
		ld_b:				out unsigned(DATA_W - 1 downto 0);
		start:			out std_logic
    );
end ld_controller;


architecture arch of ld_controller is
	constant CNT_MAX:	integer := 2**ADDRESS_W - 1;
	
	type reg_file_type is array ((2**ADDRESS_W) - 1 downto 0) of
		unsigned(DATA_W-1 downto 0);
	signal array_reg:     reg_file_type;
	 
	signal cnt_a_reg, cnt_b_reg:		unsigned(ADDRESS_W - 1 downto 0);
	signal cnt_a_next, cnt_b_next:	unsigned(ADDRESS_W - 1 downto 0);
	signal start_next, start_reg:		std_logic;
begin

  process(clk, reset)
  begin
    if (reset = '0') then
      array_reg 	<= (others => (others => '0'));
		cnt_a_reg	<= (others => '0');
		cnt_b_reg	<= (others => '0');
		start_reg 	<= '0';
    elsif (clk'event and clk='1') then
		cnt_a_reg <= cnt_a_next;
		cnt_b_reg <= cnt_b_next;
		start_reg <= start_next;
		
      if (wr_en = '1') then
        array_reg(to_integer(unsigned(w_addr))) <= w_data;
      end if;
		
	 end if;
  end process;

  process(array_reg, cnt_a_reg, cnt_b_reg)
  begin
	cnt_a_next	<= cnt_a_reg;
	cnt_b_next 	<= cnt_b_reg;
	start_next  <= '1';
	
	if (cnt_b_reg = CNT_MAX) then
		if (cnt_a_reg = CNT_MAX - 1) then
			-- start over
			if (ready = '1') then
				cnt_a_next <= (others => '0');
				cnt_b_next <= (1 => '1' , others => '0');
			else
				start_next <= '0';
			end if;			
		else
			cnt_a_next <= cnt_a_reg + to_unsigned(1, cnt_a_reg'length);
			cnt_b_next <= cnt_a_reg + to_unsigned(2, cnt_a_reg'length);
		end if;
	else
		cnt_b_next <= cnt_b_reg + 1;
	end if;
  end process;
  
  	ld_a <= array_reg(to_integer(cnt_a_reg));
	ld_b <= array_reg(to_integer(cnt_b_reg));
	start <= start_reg;
end arch;

