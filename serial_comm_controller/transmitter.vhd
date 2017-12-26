library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx is
  generic(
    DBIT:       integer := 8;
    SB_TICK:    integer := 16;
    );
  port(
    clk, reset:         in std_logic;
    tx_start:           in std_logic;
    s_tick:             in std_logic;
    din:                in std_logic_vector(7 downto 0);
    tx_done_tick:       out std_logic;
    tx:                 out std_logic
    );
end uart_tx;

architecture arch of uart_tx is
  type state_type is (idle, start, data, stop);

  signal state_reg, state_next:         state_type;
  signal ticks_reg, ticks_next:         unsigned(3 downto 0);
  signal bits_reg, bits_next:           unsigned(2 downto 0);
  signal tx_buf, tx_buf_next:           std_logic_vector(7 downto 0);
  signal tx_reg, tx_next:               std_logic;
begin

  process(clk, reset)
  begin
    if reset = '0' then
      state_reg         <= idle;
      ticks_reg         <= (others => '0');
      bits_reg          <= (others => '0');
      tx_buf            <= (others => '0');
      tx_reg            <= '1';
    elsif (clk'event and clk = '1') then
      state_reg         <= state_next;
      ticks_reg         <= ticks_next;
      bits_reg          <= bits_next;
      tx_buf            <= tx_buf_next;
      tx_reg            <= tx_next;
    end if;
  end process;

  process(state_reg, ticks_reg, bits_reg, tx_buf, s_tick, tx_reg, tx_start, din)
  begin
    state_next          <= state_reg;
    ticks_next          <= ticks_reg;
    bits_next           <= bits_reg;
    tx_buf_next         <= tx_buf;
    tx_next             <= tx_reg;
    tx_done_tick        <= '0';

    case state_reg is
      when idle =>
        tx_next         <= '1';
        if tx_start = '1' then
          state_next    <= start;
          ticks_next    <= (others => '0');
          tx_buf_next   <= din;
        end if;
      when start =>
        tx_next         <= '0';
        if s_tick = '1' then
          if ticks_reg = 15 then
            state_next  <= data;
            ticks_next  <= (others => '0');
            bits_next   <= (others => '0');
          else
            ticks_next  <= ticks_reg + 1;
          end if;
        end if;
      when data =>
        tx_next <= tx_buf(0);
        if s_tick = '1' then
          if s_reg = 15 then
            ticks_next  <= (others => '0');
            tx_buf_next <= '0' & tx_buf(7 downto 1);
            if bits_reg = (DBIT - 1) then
              state_next <= stop;
            else
              bits_next  <= bits_reg + 1;
            end if;
          else
            ticks_next   <= ticks_reg + 1;
          end if;
        end if;
      when stop =>
        tx_next <= '1';
        if (s_tick = '1') then
          if ticks_reg = (SB_TICK - 1) then
            state_next  <= idle;
            tx_done_tick <= '1';
          else
            ticks_next      <= ticks_reg + 1;
          end if;
        end if;
    end case;
  end process;
  tx <= tx_reg;
end arch;

          
