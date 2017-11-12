library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity re_det is
  port(
    clk, reset:        in std_logic;
    input:      in std_logic;
    output:     out std_logic
    )
end re_det;

architecture arch of re_det is
  type state_type is (zero, edge, one);
  signal state, state_next:     state_type;
begin

  -- state register
  process(clk, reset)
  begin
    if (reset = '1') then
      output <= zero;
    elsif (clk'event and clk = '1') then
      state <= state_next;
    end if;
  end process;
      
  -- next-state logic
  process(state, input)
  begin
    state_next <= state;
    tick <= 0;

    case state is
      when zero =>
        if (input = '1') then
          state_next <= edge;
        end if;
      when edge =>
        if (input = '0') then
          state_next <= zero;
        elsif (input = '1') then
          state_next = one;
        end if;
      when one =>
        if (input = '0') then
          state_next <= zero;
        end if;
    end case;
    
end arch;
      
