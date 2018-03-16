library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib is
  port(
    clk, reset:         in std_logic;
    input:              in std_logic_vector(3 downto 0);
    start:              in std_logic;

    ready:              out std_logic;
    result:             out std_logic_vector(8 downto 0)
    );
end fib;

architecture arch of fib is
  type state_type is (idle, op, done);

  signal state_reg, state_next: state_type;
  signal n_reg, n_next:         unsigned(3 downto 0);
  signal t0_reg, t0_next:       unsigned(8 downto 0);
  signal t1_reg, t1_next:       unsigned(8 downto 0);
begin

  process(clk, reset)
  begin
    if reset = '0' then
      state_reg         <= idle;
      t0_reg            <= (others => '0');
      t1_reg            <= (others => '0');
      n_reg             <= (others => '0');
    elsif (clk'event and clk = '1') then
      state_reg         <= state_next;
      t0_reg            <= t0_next;
      t1_reg            <= t1_next;
      n_reg             <= n_next;
    end if;
  end process;

  process(state_reg, t0_reg, t1_reg, n_reg, start, input, n_next)
  begin
    ready               <= '0';
    state_next          <= state_reg;
    t0_next             <= t0_reg;
    t1_next             <= t1_reg;
    n_next              <= n_reg;

    -- fsmd next-state logic
    case state_reg is
      when idle =>
        ready <= '1';
        if start = '0' then
          t0_next       <= (others => '0');
          t1_next       <= (0 => '1', others => '0');
          n_next        <= unsigned(input);
          state_next    <= op;
        end if;
      when op =>
        if n_reg = 0 then
          t1_next       <= (others => '0');
          state_next    <= done;
        elsif n_reg = 1 then
          state_next    <= done;
        else
          t1_next       <= t1_reg + t0_reg;
          t0_next       <= t1_reg;
          n_next        <= n_reg - 1;
        end if;
      when done =>
        state_next      <= idle;
    end case;
  end process;

  result                <= std_logic_vector(t1_reg);
end arch;
