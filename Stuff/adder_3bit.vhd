library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder_4bit is
	generic(N: integer := 4);
    port( 
		a, b : in  std_logic_vector (N-1 downto 0);
      sum : out  std_logic_vector (N-1 downto 0);
      carry : out  std_logic);
end adder_4bit;

architecture hard_arch of adder_3bit is
	signal a_ext, b_ext, sum_ext : unsigned(N downto 0);
begin
	a_ext <= unsigned('0' & a);
	b_ext <= unsigned('0' & b);
	sum_ext <= a_ext + b_ext;
	sum <= std_logic_vector(sum_ext(N-1 downto 0));
	carry <= sum_ext(N);
end hard_arch;

