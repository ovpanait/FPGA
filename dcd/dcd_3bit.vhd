library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
x
entity dcd_3bit is
    Port ( en : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (2 downto 0);
           output : out  STD_LOGIC_VECTOR (7 downto 0));
end dcd_3bit;

architecture Behavioral of dcd_3bit is
	signal not_i2 : std_logic;
	signal en1, en2 :std_logic;
begin

	en1 <=  input(2) and en; -- Enable signal for the most significant 2bit dcd
	en2 <= (not input(2)) and en; -- Enable signal for the least significant 2bit dcd
	dcd1:
			entity work.dcd_2bit(Behavioral) port map(
				en => en1,
				input => input(1 downto 0),
				output => output(7 downto 4)
				);
	dcd2:
			entity work.dcd_2bit(Behavioral) port map(
					en => en2,
					input => input(1 downto 0),
					output => output(3 downto 0)
					);
end Behavioral;

