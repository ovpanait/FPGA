library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
  generic (
    N:          integer := 4
    );

  port (
    clk, reset: in std_logic;
    d:          in unsigned(N-1 downto 0);
    q:          out unsigned(N-1 downto 0)
    );

architecture arch of reg is
begin
  process (clk, reset)
  begin
    if (reset = '1') then
      q <= (others => '0');
    elsif (clk'event and clk = '1') then
      q <= d;
    end if;
  end process;
end arch;
