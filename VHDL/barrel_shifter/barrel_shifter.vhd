library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity barrel_shifter is
	port (
			a: in std_logic_vector(7 downto 0);
			amt: in std_logic_vector(2 downto 0);
			y: out std_logic_vector(7 downto 0)
	);
end barrel_shifter;

architecture Behavioral of barrel_shifter is
	signal s0, s1: std_logic_vector(7 downto 0);
begin
	-- stage 0, shift by 1 or 0 bits
	s0 <= a(0) & a(7 downto 1) when amt(0)='1' else a;
	-- stage 1, shift by 2 or 0 bits
	s1 <= s0(1 downto 0) & s0(7 downto 2) when amt(1)='1' else s0;
	-- last stage, shift by 4 or 0 bits
	y <= s1(3 downto 0) & s1(7 downto 4) when amt(2)='1' else s1;
end Behavioral;

