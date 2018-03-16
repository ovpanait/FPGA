-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

	signal test_in0, test_in1 : std_logic;
	signal test_out : std_logic;
  BEGIN

  -- Component Instantiation
          uut: entity work.comparator_1bit(Behavioral)
			 PORT MAP(
                  i0 => test_in0,
                  i1 => test_in1,
						eq => test_out
          );


  --  Test Bench Statements
     tb : PROCESS
     BEGIN

			test_in0 <= '0';
			test_in1 <= '0';
        wait for 100 ns; -- wait until global set/reset completes
		  
		  test_in0 <= '0';
			test_in1 <= '1';
        wait for 100 ns;
		  
		  test_in0 <= '1';
			test_in1 <= '0';
        wait for 100 ns;
		  
		  test_in0 <= '1';
			test_in1 <= '1';
        wait for 100 ns;
     END PROCESS tb;
  --  End Test Bench 

  END;
