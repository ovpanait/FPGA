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
		  
		  -- debug and init
		  -- uart transmitter
		  data_stream_in:   	  in unsigned(7 downto 0); -- byte to transmit
		  data_stream_in_stb:  in std_logic; -- start transmitting
		  data_stream_in_ack:  out std_logic; -- byte sent
		  
		  -- uart receiver
		  data_stream_out:	  out unsigned(7 downto 0); --received data
		  data_stream_out_stb: out std_logic -- byte received
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
        data_stream_in      => data_stream_in,
        data_stream_in_stb  => data_stream_in_stb,
        data_stream_in_ack  => data_stream_in_ack,
        data_stream_out     => data_stream_out,
        data_stream_out_stb => data_stream_out_stb,
        tx                  => tx,
        rx                  => rx
    );

--   clock_125ms: entity work.freq_div
--    port map (clk => clock, out_clk => send_clk);
end rtl;
