library ieee; 
use ieee.std_logic.all;

entity test is 
	port(
		A: in std_logic; 
		B: in std_logic; 
		C: in std_logic; 
		Y: out std_logic;
		X: out std_logic
		)
end entity; 

architecture rtl of test is

begin 
	
	Y <= A nand B or C; 
	O <= A and B and C; 

end architecture; 

--text to test


