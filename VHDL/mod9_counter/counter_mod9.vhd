library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_mod9 is
  port (
    clk:        in std_logic;
    display:    out std_logic_vector(7 downto 0)
  );
end counter_mod9;

architecture arch of counter_mod9 is
  signal reset: std_logic;
  signal out_clk: std_logic;
  signal d:     unsigned(3 downto 0) := "0000";
  signal q:     unsigned(3 downto 0);
begin

  reset <= '0';

  -- instantiate 1Hz clock
  div_1Hz: entity work.div_1Hz
		port map(clk => clk, out_clk => out_clk);
		
  -- instantiate 4 bit register
  reg: entity work.reg
    generic map(N => 4)
    port map(clk => out_clk, reset => reset, d => d, q => q);

  -- instantiate seven segment display
  sseg_disp1: entity work.seg_7
    port map(bin_val => q, dp => '1', symbol => display);

  -- next state logic
  d <= (others => '0') when q = "1001" else
       q + 1;
  
end arch;
