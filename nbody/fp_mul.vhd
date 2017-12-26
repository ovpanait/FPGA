library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_mul is 
	port(
		clk:		in std_logic;
		reset:	in std_logic;
		
		a:			in unsigned(63 downto 0);
		b:			in unsigned(63 downto 0);
		
		result:	out unsigned(63 downto 0);
		en_out:	out std_logic
	);
end fp_mul;

architecture arch of fp_mul is
-- inputs
signal a_sig, b_sig:					std_logic;
signal a_exp, b_exp:					unsigned(10 downto 0);
signal a_man, b_man:					unsigned(51 downto 0);

-- temp
signal tmp_sig: 						std_logic;
signal tmp_exp:						unsigned(10 downto 0);
signal tmp_man:						unsigned(105 downto 0);

signal res_sig:						std_logic;
signal res_exp:						unsigned(10 downto 0);
signal res_man:						unsigned(51 downto 0);

-- fsmd
signal result_reg, result_next:	unsigned(63 downto 0);
signal en_out_reg, en_out_next:	std_logic;

begin
	-- input
	-- sign bits
	a_sig <= a(63);
	b_sig <= b(63);
	
	-- exponents
	a_exp <= a(62 downto 52);
	b_exp <= b(62 downto 52);
	
	-- mantissa
	a_man <= a(51 downto 0);
	b_man <= b(51 downto 0);
	
	process(clk, reset)
	begin
		if (reset = '0') then
			result_reg <= (others => '0');
			en_out_reg <= '0';
		elsif (clk'event and clk = '1') then
			result_reg <= result_next;
			en_out_reg <= en_out_next;
		end if;
	end process;
	
	--next-state-logic
	res_sig <= result_next(63);
	res_exp <= result_next(62 downto 52);
	res_man <= result_next(51 downto 0);
	
	tmp_sig <= a_sig xor b_sig;
	tmp_exp <= (a_exp + b_exp); -- subtract decimal 1023
	tmp_man <= unsigned(('1' & a_man) * ('1' & b_man));	
	
	res_sig <= tmp_sig;
	
	res_exp <= (tmp_exp - "011111110") when tmp_man(105) = '1' else -- result needs to be re-normalized
					(tmp_exp - "01111111"); -- result is already normalized
					
	res_man <= tmp_man(104 downto 53) when tmp_man(105) = '1' else
					tmp_man(103 downto 52);
	
	result <= result_reg;

end arch;