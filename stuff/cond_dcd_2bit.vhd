library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cond_dcd_2bit is
    Port ( 
		en : in  STD_LOGIC;
      a : in  STD_LOGIC_VECTOR (1 downto 0);
      y : out  STD_LOGIC_VECTOR (3 downto 0)
		);
end cond_dcd_2bit;

architecture cond_arch of cond_dcd_2bit is
begin
	y <= "0000" when (en='0') else
		  "0001" when (a = "00") else
		  "0010" when (a = "01") else
		  "0100" when (a = "10") else
		  "1000";

end cond_arch;

