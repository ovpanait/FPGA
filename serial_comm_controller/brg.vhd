library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- divide 50MHz onboard clock (20ns period)
entity freq_div is
  -- default value of half a second
  generic (
    N:          integer := 24999999
    );

  port(
    clk:        in std_logic;
    out_clk:    out std_logic
    );
end freq_div;

architecture arch of freq_div is
  signal tmp:           std_logic := '0';
  signal counter:       integer range 0 to N := 0;
begin
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (counter = N) then
        counter <= 0;
        tmp <= NOT(tmp);
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;
    out_clk <= tmp;
end arch;
