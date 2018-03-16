library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity quartus_test is
  port(
    MAX10_CLK1_50:              in std_logic;
    KEY:                        in std_logic_vector(1 downto 0);
    SW:                         in std_logic_vector(9 downto 0);
    VGA_HS, VGA_VS:             out std_logic;
    VGA_R:                      out std_logic_vector(3 downto 0);
    VGA_G:                      out std_logic_vector(3 downto 0);
    VGA_B:                      out std_logic_vector(3 downto 0)
    );
end quartus_test;

architecture arch of quartus_test is
  signal rgb_reg:       std_logic_vector(11 downto 0);
  signal rgb:           std_logic_vector(11 downto 0);
  signal video_on:      std_logic;
  signal reset:         std_logic;
begin

  -- instantiate pixel generator
  pix_gen_unit: entity work.pixel_gen
    port map(clk => MAX10_CLK1_50, reset => KEY(0), hsync => VGA_HS, vsync => VGA_VS,
             rgb(3 downto 0) => VGA_B, rgb(7 downto 4) => VGA_G, rgb(11 downto 8) => VGA_R);

end arch;

