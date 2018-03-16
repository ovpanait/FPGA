-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

          SIGNAL op1 :  std_logic_vector(1 downto 0);
          SIGNAL op2 :  std_logic_vector(1 downto 0);
          SIGNAL res : 	std_logic;

  BEGIN

  -- Component Instantiation
          uut: entity work.ge_2bit PORT MAP(
                  A => op1,
                  B => op2,
						output => res
          );


  --  Test Bench Statements
     tb : PROCESS
     BEGIN
			op1 <= "00";
			op2 <= "00";
        wait for 20 ns;

			op2 <= "01";
        wait for 20 ns;
		  
			op2 <= "10";
        wait for 20 ns;
		  
		  op2 <= "11";
        wait for 20 ns;
		  
		  op1 <= "01";
		  op2 <= "00";
        wait for 20 ns;
		  
		  op2 <= "01";
        wait for 20 ns;
		  
			op2 <= "10";
        wait for 20 ns;
		  
		  op2 <= "11";
        wait for 20 ns;
		  
		  op1 <= "10";
		  op2 <= "00";
		  wait for 20ns;
		  
		  op2 <= "01";
        wait for 20 ns;
		  
			op2 <= "10";
        wait for 20 ns;
		  
		  op2 <= "11";
        wait for 20 ns;
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
