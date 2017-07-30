library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_1bit is
	port(
		i0, i1: in std_logic;
		eq: out std_logic
		);
end comparator_1bit;

architecture Behavioral of comparator_1bit is
	signal p0, p1 : std_logic;
begin
	p0 <= (not i0) and (not i1);
	p1 <= i0 and i1;
	eq <= p0 or p1;

end Behavioral;

