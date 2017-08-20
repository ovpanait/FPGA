library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prio_encoder is
    port ( 
		r : in  STD_LOGIC_VECTOR (4 downto 1);
      pcode : out  STD_LOGIC_VECTOR (2 downto 0));
end prio_encoder;

architecture cond_arch of prio_encoder is
begin
	pcode <= "100" when (r(4)='1') else
				"011" when (r(3)='1') else
				"010" when (r(2)='1') else
				"001" when (r(1)='1') else
				"000";
end cond_arch;

