library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_transmitter is
  port (
    clk, reset:         in std_logic;
    tx_done_tick:       out std_logic;
    tx:                 out std_logic;
    );
end test_transmitter;

architecture arch of test_transmitter is
  signal s_tick:        std_logic;
begin

  brg: entity work.brg
    generic map (N => 9599)
    port map (clk => clk, out_clk => s_tick);

  uart_tx: entoty work.uart_tx
    port_map(clk => clk, reset => reset, s_tick => s_tick, din => "10101010",
             tx_done_tick => tx_done_tick, tx => tx);
  
end arch;
