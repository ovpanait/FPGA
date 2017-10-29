library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity reg_file is
  generic(
    ADDRESS_W:          integer := 8;
    DATA_W:             integer := 2;
    );

  port(
    clk, reset:         in std_logic;
    wr_en:              in std_logic;
    w_addr, r_addr:     in std_logic_vector(ADDRESS_W - 1);
    w_data:             in std_logic_vector(DATA_W - 1);
    r_data:             out std_logic_vector(DATA_W -1);
    );
end reg_file;


architecture arch of reg_file is
  type reg_file_type is array (2**ADDRESS_W downto 0) of
    std_logic_vector(DATA_W-1 downto 0);

  signal array_reg:     reg_file_type;
begin

  process(clk, reset)
  begin
    if (reset = '1') then
      array_reg <= (others => (others => '0'));
    elsif (clk'event and clk='1') then
      if (wr_en = '1') then
        array_reg(to_integer(unsigned(w_addr))) <= w_data;
      end if;
    end if;
  end process;

  r_data <= array_reg(to_integer(unsigned(r_addr)));
       
end arch;

