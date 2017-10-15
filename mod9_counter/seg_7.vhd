library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seg_7 is
  port (
    bin_val:    in unsigned(3 downto 0);
    dp:         in std_logic;
    symbol:     out std_logic_vector(7 downto 0)
    );
end seg_7;

architecture arch of seg_7 is
begin
  with bin_val select
    symbol(6 downto 0) <=
    "1000000" when "0000",
    "1111001" when "0001",
    "0100100" when "0010",
    "0110000" when "0011",
    "0011001" when "0100",
    "0010010" when "0101",
    "0000010" when "0110",
    "1111000" when "0111",
    "0000000" when "1000",
    "0010000" when "1001",
    "0001110" when others;

  symbol(7) <= dp;
end arch;
