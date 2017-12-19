library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_st2 is
	port(
		clk:				in std_logic;
		reset:			in std_logic;
		en_in:			in std_logic;
		
		diff_x:			in signed(15 downto 0);
		diff_y:			in signed(15 downto 0);
		

		r:					out signed(31 downto 0);
--		diff_x_sq:		out signed(15 downto 0);
--		diff_y_sq:		out signed(15 downto 0);
		en_out:			out std_logic
	);
end pipe_st2;

architecture arch of pipe_st2 is
signal r_reg, r_next:				signed(31 downto 0);
signal en_out_reg, en_out_next: 	std_logic;
begin

process(clk, reset)
begin
if reset = '0' then
r_reg 			<= (others => '0');
en_out_reg 	<= '0';
elsif (clk'event and clk='1') then
	r_reg 		<= r_next;
	en_out_reg 	<= en_out_next;
end if;
end process;

-- Next state logic

process(en_in, diff_x, diff_y)
begin
	if en_in = '1' then
		r_next 			<= diff_x * diff_x + diff_y * diff_y;	
		en_out_next 	<= '1';
	else
		r_next 			<= (others => '0');
		en_out_next 	<= '0';
	end if;
end process;

r			<= r_reg;
en_out 	<= en_out_reg;

end arch;
