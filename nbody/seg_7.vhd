library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seg_7 is
  port (
    bin_val:    in unsigned(3 downto 0);
    en:         in std_logic;
    dp:         in std_logic;
    symbol:     out std_logic_vector(7 downto 0)
    );
end seg_7;

architecture arch of seg_7 is
begin

  process(en, bin_val, dp)
  begin

    if (en = '1') then
      symbol(7) <= dp;
    else
      symbol(7) <= '1';
    end if;

    -- segment enabled
    case en is
      when '1' =>
        case bin_val is
          when "0000" =>
            symbol(6 downto 0) <= "1000000";
          when "0001" =>
            symbol(6 downto 0) <= "1111001";
          when "0010" =>
            symbol(6 downto 0) <= "0100100";
          when "0011" =>
            symbol(6 downto 0) <= "0110000";
          when "0100" =>
            symbol(6 downto 0) <= "0011001";
          when "0101" =>
            symbol(6 downto 0) <= "0010010";
          when "0110" =>
            symbol(6 downto 0) <= "0000010";
          when "0111" =>
            symbol(6 downto 0) <= "1111000";
          when "1000" =>
            symbol(6 downto 0) <= "0000000";
          when "1001" =>
            symbol(6 downto 0) <= "0010000";
          -- upper and lower squares
          when "1010" =>
            symbol(6 downto 0) <= "0011100";
          when "1011" =>
            symbol(6 downto 0) <= "0100011";
          --
          when others =>
            symbol(6 downto 0) <= "0001111";
        end case;
      when others =>
        symbol(6 downto 0) <= "1111111";
    end case;
  end process;

end arch;
