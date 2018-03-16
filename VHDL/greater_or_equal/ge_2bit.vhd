library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ge_2bit is
    Port ( A : in  STD_LOGIC_VECTOR (1 downto 0);
           B : in  STD_LOGIC_VECTOR (1 downto 0);
           output : out  STD_LOGIC);
end ge_2bit;

architecture Behavioral of ge_2bit is

begin

output <= ((not B(1)) and (not B(0))) or
		(A(1) and (not B(1) or A(0) or (not B(0)))) or
		((not B(1)) and A(0));

end Behavioral;

