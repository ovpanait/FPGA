library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rot_ban is
  port (
    clk:        in std_logic;
    disp1_o:    out std_logic_vector(7 downto 0);
    disp2_o:    out std_logic_vector(7 downto 0);
    disp3_o:    out std_logic_vector(7 downto 0);
    disp4_o:    out std_logic_vector(7 downto 0)
    );
end rot_ban;

architecture arch of rot_ban is
  signal disp_clk:                    std_logic;

  signal state_next, state:           unsigned (2 downto 0);
  signal en:                                          unsigned (3 downto 0);
  signal disp_i:                      unsigned(3 downto 0) := "1010";
begin

  -- instantiate 125ms clock
  clock_125ms: entity work.freq_div
    generic map (N => 6249999)
    port map (clk => clk, out_clk => disp_clk);

  -- instantiate 4 bit register
  reg: entity work.reg
    generic map (N => 3)
    port map (clk => disp_clk, reset => '0', d => state_next, q => state);

  -- instantiate 4 x seven segment displays
  disp1: entity work.seg_7
    port map(bin_val => disp_i, en => en(0), dp => '1', symbol => disp1_o);

  disp2: entity work.seg_7
    port map(bin_val => disp_i, en => en(1), dp => '1', symbol => disp2_o);

  disp3: entity work.seg_7
    port map(bin_val => disp_i, en => en(2), dp => '1', symbol => disp3_o);

  disp4: entity work.seg_7
    port map(bin_val => disp_i, en => en(3), dp => '1', symbol => disp4_o);

  -- next-state logic

  process(en, disp_i)
  begin

    case state is
      when "000" =>
        en <= "0001";
        disp_i <= "1010";
      when "001" =>
        en <= "0010";
      when "010" =>
        en <= "0100";
      when "011" =>
        en <= "1000";
      when "100" =>
        en <= "1000";
        disp_i <= "1011";
      when "101" =>
        en <= "0100";
      when "110" =>
        en <= "0010";
      when "111" =>
        en <= "0001";
      when others =>
        en <= "0000";

    end case;

  end process;

  state_next <= state + 1;

end arch;
