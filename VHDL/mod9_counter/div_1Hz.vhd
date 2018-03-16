library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div_1Hz is
  port(
    clk:        in std_logic;
    out_clk:    out std_logic
    );
end div_1Hz;

architecture arch of div_1Hz is
  signal tmp:           std_logic := '0';
  signal counter:       integer range 0 to 24999999 := 0;
begin
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (counter = 24999999) then
        counter <= 0;
        tmp <= NOT(tmp);
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;
  
  out_clk <= tmp;
end arch;
