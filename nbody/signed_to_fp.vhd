library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity unsigned_to_fp is
	port(
		clk:			in std_logic;
		reset:		in std_logic;
		en_in:		in std_logic;
		
		input:		in unsigned(63 downto 0);
		
		output:		out unsigned(63 downto 0);
		en_out:		out std_logic
--		debug:		out unsigned(7 downto 0)
		
	);
end unsigned_to_fp;


architecture arch of unsigned_to_fp is
signal output_reg, output_next:	unsigned(63 downto 0);
signal en_out_reg, en_out_next:	std_logic;

--signal o_sig:			std_logic;
--signal o_exp:			unsigned(10 downto 0);
--ssignal o_man:			unsigned(51 downto 0);
begin
	
	process(clk, reset)
	begin
		if reset = '0' then
			output_reg <= (others => '0');
			en_out_reg <= '0';
		elsif clk'event and clk = '1' then
			output_reg <= output_next;
			en_out_reg <= en_out_next;
		end if;
	end process;

	-- next-state logic
	process(input, en_in)
	variable in_tmp: 			unsigned(63 downto 0);
	variable index_tmp:		unsigned(10 downto 0);
	begin
		if (en_in = '1') then
			
			in_tmp    := input;
			index_tmp := "01111111111";
			
			if in_tmp = to_unsigned(0, in_tmp'length) then
				output_next <= (others => '0');
			else
				for I in 63 downto 0  loop
					if in_tmp(63) = '1' then
						index_tmp := (index_tmp + to_unsigned(I, index_tmp'length));
					--	debug <= to_unsigned(I - 1, debug'length);
						exit;
					else
						in_tmp := (in_tmp(62 downto 0) & '0'); -- shift 1 bit left
					end if;
				end loop;
				
				output_next(63) <= '0'; 	-- we assume only possitive input numbers
				output_next(62 downto 52) <= index_tmp;
				output_next(51 downto 0) <= in_tmp(62 downto 11); 
				en_out_next <= '1';
			end if;
		else
			output_next(63)					<= '0';
			output_next(62 downto 52) 		<= (others => '0');
			output_next(51 downto 0)		<= (others => '0');
			en_out_next <= '0';
		end if;
	end process;
	
	
	output <= output_reg;
	en_out <= en_out_reg;

end arch;