library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dcd_2bit is
    Port ( 	 
				input : in  STD_LOGIC_VECTOR (1 downto 0);
				en : in STD_LOGIC;
				output : out  STD_LOGIC_VECTOR (3 downto 0)
			  );
end dcd_2bit;

architecture Behavioral of dcd_2bit is
	
begin

	output(0) <= en and (not input(1)) and (not input(0));
	output(1) <= en and input(0) and (not input(1));
	output(2) <= en and input(1) and (not input(0));
	output(3) <= en and input(1) and input(0); 
	
end Behavioral;

