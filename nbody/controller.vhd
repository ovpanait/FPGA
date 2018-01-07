library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ld_controller is
  generic(
    ADDRESS_W:          integer := 8;
    -- 64 bit x coordinate
	 -- 64 bit y coordinate
	 DATA_W:             integer := 128
    );

  port(
		clk, reset:		in std_logic;
		ready:			in std_logic;

		-- velocity controller
		add_en:			in std_logic;
		up_addr:			in unsigned(ADDRESS_W - 1 downto 0);
		vx:				in unsigned(63 downto 0);
		vy:				in unsigned(63 downto 0);
		
		-- particle loader controller
		ld_a:				out unsigned(DATA_W - 1 downto 0);
		ld_b:				out unsigned(DATA_W - 1 downto 0);
		start:			out std_logic;
		
		-- uart-debugging
		-- uart transmitter
		uart_out:   	  	out unsigned(7 downto 0); -- byte to transmit
		uart_out_start: 	out std_logic; -- start transmitting
		uart_out_done:  	in std_logic; -- byte sent

		-- uart receiver
		uart_in_data: 		in unsigned(7 downto 0); -- byte received
		uart_in_flag:	  	in std_logic--received data	
    );
end ld_controller;


architecture arch of ld_controller is
	constant CNT_MAX:	integer := 2**ADDRESS_W - 1;
	
	-- register file
	type reg_file_type is array ((2**ADDRESS_W) - 1 downto 0) of
		unsigned(DATA_W-1 downto 0);
	signal array_reg:     reg_file_type;
	
	signal wr_en:			 							std_logic;
	signal w_data:        							unsigned(DATA_W - 1 downto 0);
	
	-- state machine
	type state_type is (init, operation, debug);
	signal state_reg, state_next: 	state_type;	
	
	-- operation state
	signal cnt_a_reg, cnt_b_reg:					unsigned(ADDRESS_W - 1 downto 0);
	signal cnt_a_next, cnt_b_next:				unsigned(ADDRESS_W - 1 downto 0);
	signal start_next, start_reg:					std_logic;
	
	-- debug and init
	signal db_cnt_reg, db_cnt_next:				unsigned(ADDRESS_W downto 0);
	signal byte_cnt_reg, byte_cnt_next:			unsigned(3 downto 0);
	signal in_data_reg , in_data_next:			unsigned(DATA_W - 1 downto 0);
	signal init_wr_en_reg, init_wr_en_next:	std_logic;
	
	signal uart_out_reg, uart_out_next:			unsigned(7 downto 0);
	signal uart_out_start_reg, uart_out_start_next: std_logic;
begin

  process(clk, reset)
  begin
    if (reset = '0') then
		-- state machine
		state_reg 	<= init;
		
		-- register file
      array_reg 	<= (others => (others => '0'));
		
		-- operation
		cnt_a_reg	<= (others => '0');
		cnt_b_reg	<= (others => '0');
		start_reg 	<= '0';
		
		-- debug and init
		db_cnt_reg 			<= (others => '0');
		byte_cnt_reg 		<= (others => '0'); 
		in_data_reg			<= (others => '0');
		init_wr_en_reg 	<= '0';
		uart_out_reg		<= (others => '0');
		uart_out_start_reg <= '0';
    elsif (clk'event and clk='1') then
		state_reg <= state_next;
		
		cnt_a_reg <= cnt_a_next;
		cnt_b_reg <= cnt_b_next;
		start_reg <= start_next;
		
      if (wr_en = '1') then
        array_reg(to_integer(unsigned(up_addr))) <= w_data;
      elsif (init_wr_en_reg = '1') then
        array_reg(to_integer(db_cnt_reg)) <= in_data_reg;
      end if;
		
		-- debug and init
		db_cnt_reg 		<= db_cnt_next;
		byte_cnt_reg 	<= byte_cnt_next; 
		in_data_reg		<= in_data_next;
		init_wr_en_reg	<= init_wr_en_next;
		uart_out_reg	<= uart_out_next;
		uart_out_start_reg <= uart_out_start_next;
	 end if;
  end process;

  process(array_reg, cnt_a_reg, cnt_b_reg, ready, uart_in_flag, uart_in_data, state_reg,
				db_cnt_reg, byte_cnt_reg, uart_out_done)
  begin
  -- state machine
  	state_next 	<= state_reg;
	
	-- operation
	cnt_a_next	<= cnt_a_reg;
	cnt_b_next 	<= cnt_b_reg;
	
	-- debug and init
	db_cnt_next 		<= db_cnt_reg;
	byte_cnt_next 		<= byte_cnt_reg;
	in_data_next 		<= (others => '0');
	init_wr_en_next 	<= '0';
	uart_out_next 		<= (others => '0');
	uart_out_start_next <= '0';
	
	case state_reg is
		-- initialize the register file with particles' positions
		when init =>
			start_next <= '0';
			
			if (uart_in_flag = '1') then
				if (db_cnt_reg = CNT_MAX) then
					--state_next 		<= operation;
					state_next <= debug;
					db_cnt_next 	<= (others => '0');
					byte_cnt_next 	<= (others => '0');
				else
					if (byte_cnt_reg = 15) then
						db_cnt_next 	<= db_cnt_reg + 1;
						byte_cnt_next 	<= (others => '0');
					else
						byte_cnt_next <= byte_cnt_reg + 1;
					end if;
				end if;
				
				init_wr_en_next 	<= '1';	
				in_data_next 		<= array_reg(to_integer(db_cnt_reg))(DATA_W - 9 downto 0) & unsigned(uart_in_data);
			end if;
		-- normal operation
		when operation =>
			start_next  <= '1';
			
			if (cnt_b_reg = CNT_MAX) then
				if (cnt_a_reg = CNT_MAX - 1) then
					-- start over
					if (ready = '1') then
						cnt_a_next <= (others => '0');
						cnt_b_next <= (1 => '1' , others => '0');
						
						state_next <= debug;
						db_cnt_next 	<= (others => '0');
						byte_cnt_next 	<= (others => '0');
					else
						start_next <= '0';
					end if;			
				else
					cnt_a_next <= cnt_a_reg + to_unsigned(1, cnt_a_reg'length);
					cnt_b_next <= cnt_a_reg + to_unsigned(2, cnt_a_reg'length);
				end if;
			else
				cnt_b_next <= cnt_b_reg + 1;
			end if;
		
		when debug =>
			start_next <= '0';
			-- TODO // create registers for uart_out, uart_out_start
			if (uart_out_done = '1') then
				if (db_cnt_reg = CNT_MAX) then
					state_next 		<= operation;
					db_cnt_next 	<= (others => '0');
					byte_cnt_next 	<= (others => '0');
				else
					if (byte_cnt_reg = 15) then
						db_cnt_next 	<= db_cnt_reg + 1;
						byte_cnt_next 	<= (others => '0');
					else
						byte_cnt_next <= byte_cnt_reg + 1;
					end if;
				end if;
				
				case to_integer(byte_cnt_reg) is
					when 0 => 
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(DATA_W - 1 downto 120);
					when 1 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(119 downto 112);
					when 2 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(111 downto 104);
					when 3 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(103 downto 96);
					when 4 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(95 downto 88);
					when 5 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(87 downto 80);
					when 6 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(79 downto 72);
					when 7 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(71 downto 64);
					when 8 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(63 downto 56);
					when 9 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(55 downto 48);
					when 10 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(47 downto 40);
					when 11 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(39 downto 32);
					when 12 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(31 downto 24);
					when 13 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(23 downto 16);
					when 14 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(15 downto 8);
					when 15 =>
						uart_out_next <= array_reg(to_integer(db_cnt_reg))(7 downto 0);
					when others =>
						uart_out_next <= (others => '0');
					end case;
					
					uart_out_start_next <= '1';
			end if;
		when others => 
			state_next <= init;
	end case;
  end process;
  
  	ld_a <= array_reg(to_integer(cnt_a_reg));
	ld_b <= array_reg(to_integer(cnt_b_reg));

	-- update particle positions
	upd_posx : work.fp_add
	port map(
		clk, reset, add_en,
		array_reg(to_integer(up_addr))(DATA_W - 1 downto 64), 
		vx,
		w_data(127 downto 64), 
		wr_en);
	
	upd_posy : work.fp_add
		port map(
			clk, reset, add_en,
			array_reg(to_integer(up_addr))(63 downto 0), 
			vy,
			w_data(63 downto 0), 
			open);
	
	start  			<= start_reg;
	uart_out 		<= uart_out_reg;
	uart_out_start <= uart_out_start_reg;
end arch;

