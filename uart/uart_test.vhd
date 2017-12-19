library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
    use ieee.math_real.all;

entity uart_test is
    generic (
        baud            : positive;
        clock_frequency : positive
    );
    port (  
        clock           : in std_logic;
        reset           : in std_logic;    
        rx              : in std_logic;
        tx              : out std_logic;
		  
		  debug_port		: in std_logic_vector(7 downto 0)
    );
end uart_test;

architecture rtl of uart_test is
    ---------------------------------------------------------------------------
    -- Component declarations
    ---------------------------------------------------------------------------
    component uart is
        generic (
            baud                : positive;
            clock_frequency     : positive
        );
        port (
            clock               :   in      std_logic;
            reset               :   in      std_logic;    
            data_stream_in      :   in      std_logic_vector(7 downto 0);
            data_stream_in_stb  :   in      std_logic;
            data_stream_in_ack  :   out     std_logic;
            data_stream_out     :   out     std_logic_vector(7 downto 0);
            data_stream_out_stb :   out     std_logic;
            tx                  :   out     std_logic;
            rx                  :   in      std_logic
        );
    end component uart;

	 ---------------------------------------------------------------------------
	 -- Frequency divider
	 ---------------------------------------------------------------------------
	 signal send_clk :	std_logic;
	 
    ---------------------------------------------------------------------------
    -- UART signals
    ---------------------------------------------------------------------------
    signal uart_data_in : std_logic_vector(7 downto 0);
    signal uart_data_out : std_logic_vector(7 downto 0);
    signal uart_data_in_stb : std_logic := '0';
    signal uart_data_in_ack : std_logic := '0';
    signal uart_data_out_stb : std_logic := '0';
begin
    ---------------------------------------------------------------------------
    -- UART instantiation
    ---------------------------------------------------------------------------
    uart_inst : work.uart
    generic map (
        baud                => baud,
        clock_frequency     => clock_frequency
    )
    port map    (  
        -- general
        clock               => clock,
        reset               => reset,
        data_stream_in      => uart_data_in,
        data_stream_in_stb  => uart_data_in_stb,
        data_stream_in_ack  => uart_data_in_ack,
        data_stream_out     => uart_data_out,
        data_stream_out_stb => uart_data_out_stb,
        tx                  => tx,
        rx                  => rx
    );

   clock_125ms: entity work.freq_div
    port map (clk => clock, out_clk => send_clk);

    uart_loopback : process (clock)
    begin
        if rising_edge(clock) then
            if reset = '0' then
                uart_data_in_stb        <= '0';
                uart_data_in            <= (others => '0');
            elsif (send_clk = '1') then
                uart_data_in_stb        <= '1';
                uart_data_in            <= debug_port;
			   else
                uart_data_in_stb        <= '0';					
				end if;
			end if;
    end process;
	 
	 
	 
end rtl;
