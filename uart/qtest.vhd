library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;

entity qtest is
port(
	 KEY:                in std_logic_vector(1 downto 0); 
    MAX10_CLK1_50:      in std_logic;
	 LEDR:               out std_logic_vector(9 downto 0);
	 GPIO:				   inout std_logic_vector(35 downto 0)
	 );
end qtest;

architecture arch of qtest is
signal debug:	std_logic_vector(7 downto 0);
begin
    uart_test: entity work.uart_test
		generic map(baud => 115200, clock_frequency => 50000000)
			port map (clock => MAX10_CLK1_50, reset => KEY(0), tx => GPIO(0), rx => GPIO(1), debug_port => debug);
	 
	 nbody: work.nbody
		port map (clk => MAX10_CLK1_50, reset => KEY(0), debug => debug);
	 
end arch;
