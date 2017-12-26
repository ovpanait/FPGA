library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
  generic(
    DBIT:       integer := 8;
    SB_TRICK:   integer := 16;
    );
  port(
    clk, reset: in std_logic;
    rx:         in std_logic;
    s_tick:     in std_logic;
    rx_done:    out std_logic;
    dout:       out std_logic_vector(7 downto 0);
    );
end uart_rx;

architecture arch of uart_rx is
  type state_type is (idle, start, data, stop);

  signal state_reg, state_next:       state_type;
  signal ticks_reg, ticks_next:       unsigned(3 downto 0);
  signal bits_reg, bits_next:         unsigned(2 downto 0);
  signal rx_buf, rx_buf_next:         std_logic_vector(7 downto 0);
begin

  process(clk, reset)
  begin
    if reset = '0' then
      state_reg         <= idle;
      ticks_reg         <= (others => '0');
      bits_reg          <= (others => '0');
      rx_buf            <= (others => '0');
    elsif (clk'event and clk = '1') then
      state_reg         <= state_next;
      ticks_reg         <= ticks_next;
      bits_reg          <= bits_next;
      rx_buf            <= rx_buf_next;
    end if;
  end process;

  -- next state logic and data path functional units/routing
  process(state_reg, ticks_reg, bits_reg, rx_buf, s_tick, rx)
  begin
    state_next          <= state_reg;
    ticks_next          <= ticks_reg;
    bits_next           <= bits_reg;
    rx_buf_next         <= rx_buf;
    rx_done             <= '0';

    case state_Reg is
      when idle =>
        if rx = '0' then
          ticks_next <= (others <= '0');
          state_next <= start;
        end if;
      when start =>
        if s_tick = '1' and ticks_reg = 7 then
          state_next    <= data;
          ticks_next    <= (others => '0');
          bits_next   <= (others => '0');
        else
          ticks_next = ticks_reg + 1;
        end if;
      when data =>
        if s_tick = '1' and ticks_reg = 15 then
          ticks_next    <= (others => '0');
          rx_buf_next   <= rx & rx_buf(7 downto 0);
          if bits_reg = (DBIT - 1) then
            state_next  <= stop;
          else
            bits_next   <= bits_reg + 1;
          end if;
        else
          ticks_next = ticks_reg + 1;
        end if;
      when stop =>
        if s_tick = '1' then
          if ticks_reg = (SB_TICK - 1) then
            state_next  <= idle;
            rx_done     <= '1';
          else
            ticks_next  <= ticks_reg + 1;
          end if;
        end if;
    end case;
  end process;
  dout <= rx_buf;
end arch;

    
