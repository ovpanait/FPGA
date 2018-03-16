library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_gen is
  port(
    clk, reset:         in std_logic;
    hsync, vsync:       out std_logic;
    rgb:                out std_logic_vector(11 downto 0)
    );
end pixel_gen;

architecture arch of pixel_gen is
  constant STRIPE_H:    integer := 60;

  signal rgb_reg:               std_logic_vector(11 downto 0);
  signal video_on:              std_logic;
  signal pixel_x, pixel_y:      unsigned(9 downto 0);
begin
  -- instantiate VGA sync circuit
  vga_sync_unit: entity work.vga_sync
    port map(clk => clk, reset => reset, hsync => hsync,
             vsync => vsync, video_on => video_on, p_tick => open, pixel_x => pixel_x, pixel_y => pixel_y);

  -- reg buffer
  process (clk, reset)
  begin
    if reset = '0' then
      rgb_reg <= (others => '0');
    elsif (clk'event and clk='1') then
      if pixel_y <= STRIPE_H then
        rgb_reg <= "111100000001";
      elsif pixel_y <= STRIPE_H * 2 then
        rgb_reg <= "001010101010";
      elsif pixel_y <= STRIPE_H * 3 then
        rgb_reg <= "000000000100";
      elsif pixel_y <= STRIPE_H * 4 then
        rgb_reg <= "000000001000";
      elsif pixel_y <= STRIPE_H * 5 then
        rgb_reg <= "001100010000";
      elsif pixel_y <= STRIPE_H * 6 then
        rgb_reg <= "110100010010";
      elsif pixel_y <= STRIPE_H * 7 then
        rgb_reg <= "111111111111";
      elsif pixel_y <= STRIPE_H * 8 then
        rgb_reg <= "000011001001";
    end if;
	 end if;
  end process;

  rgb <= rgb_reg when video_on = '1' else (others => '0');

end arch;
