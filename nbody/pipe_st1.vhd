library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_st1 is
	port(
		clk:		in std_logic;
		reset:	in std_logic;
		en_in:	in std_logic;
		
		rx_a:		in signed(10 downto 0) ;
		rx_b:		in signed(10 downto 0) ;
		ry_a:		in signed(10 downto 0) ;
		ry_b:		in signed(10 downto 0) ;
		
		diff_x:			out signed(10 downto 0);
		diff_y:			out signed(10 downto 0);
		en_out:			out std_logic
	);
end pipe_st1;

architecture arch of pipe_st1 is
signal diffx_reg, diffx_next:		signed(10 downto 0);
signal diffy_reg, diffy_next:		signed(10 downto 0);
signal en_out_reg, en_out_next:	std_logic;
begin

process(clk, reset)
begin
if reset = '0' then
	diffx_reg <= (others => '0');
	diffx_reg <= (others => '0');
	en_out_reg <= '0';
elsif (clk'event and clk='1') then
	diffx_reg  <= diffx_next;
	diffy_reg  <= diffy_next;
	en_out_reg <= en_out_next;
end if;
end process;

-- Next state logic

process(en_in, rx_a, rx_b, ry_a, ry_b, diffx_reg, diffy_reg)
begin
	if en_in = '1' then
		diffx_next 	<= rx_b - rx_a;
		diffy_next 	<= ry_b - ry_a;
		en_out_next <= '1';
	else
		diffx_next	<= (others => '0');
		diffy_next  <= (others => '0');
		en_out_next <= '0';
	end if;
end process;

diff_x <= diffx_reg;
diff_y <= diffy_reg;
en_out <= en_out_reg;

end arch;
