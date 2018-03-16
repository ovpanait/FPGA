-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 
            signal en : std_logic;
				signal sel : std_logic_vector(2 downto 0);       
				signal  decoded: std_logic_vector(7 downto 0);
  BEGIN

  -- Component Instantiation
          uut: entity work.dcd_3bit(Behavioral) PORT MAP(
                  en  => en,
                  input => sel,
						output => decoded
          );


  --  Test Bench Statements
     tb : PROCESS
     BEGIN

		en <= '0';
		sel <= "XXX";
		wait for 10 ns;

		en <= '1';
		sel <= "001";
		wait for 10 ns;
		
      sel <= "010";
		wait for 10 ns;
		
		sel <= "011";
		wait for 10 ns;

		sel <= "100";
		wait for 10 ns;
		
		sel <= "101";
		wait for 10 ns;
		
		sel <= "110";
		wait for 10 ns;
		
		sel <= "111";
		wait for 10 ns;
		
      wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
