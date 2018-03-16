library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r_cube is
	port(
		clk:				in std_logic;
		reset:			in std_logic;
		en_in:			in std_logic;
		
		r_in:				in unsigned(20 downto 0);

		r_3:				out unsigned(63 downto 0);
--		diff_x_sq:		out signed(15 downto 0);
--		diff_y_sq:		out signed(15 downto 0);
		en_out:			out std_logic
	);
end r_cube;

architecture arch of r_cube is
signal rcube_reg, rcube_next:		unsigned(63 downto 0);
signal en_out_reg, en_out_next: 	std_logic;
begin

process(clk, reset)
begin
if reset = '0' then
rcube_reg  	<= (others => '0');
en_out_reg 	<= '0';
elsif (clk'event and clk='1') then
	rcube_reg 	<= rcube_next;
	en_out_reg 	<= en_out_next;
end if;
end process;

-- Next state logic

process(en_in, r_in)
begin
	if en_in = '1' then
		rcube_next 		<= '0' & (r_in * r_in * r_in);	
		en_out_next 	<= '1';
	else
		rcube_next		<= (others => '0');
		en_out_next 	<= '0';
	end if;
end process;

r_3		<= rcube_reg;
en_out 	<= en_out_reg;

end arch;
