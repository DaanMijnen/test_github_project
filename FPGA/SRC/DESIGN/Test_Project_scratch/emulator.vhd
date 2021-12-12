----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2021 20:51:26
-- Design Name: 
-- Module Name: encoder - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all; 


entity encoder is
   Port (
					rst: in std_logic; 
					clk: in std_logic; 
					o_A: out std_logic; 
					o_B: out std_logic
	 );
end encoder;

architecture rtl of encoder is

	
	constant max_count: std_logic_vector(1 downto 0) := "11"; 
	signal counter: std_logic_vector(1 downto 0); 
	signal r_a: std_logic; 
	signal r_b: std_logic; 

begin

	p_drive_a_b: process(rst, clk)
	begin 
		if (rst <=  '1') then
			r_a <= '0'; 
			r_b <= '0'; 
		
		elsif(rising_edge(clk)) then 
			if(counter > max_count) then 
				counter <= (others => '0');
			else 
				r_b <= counter(1); 
				r_a <= counter(0) xor counter(1); 
				counter <= std_logic_vector(unsigned(counter + 1));
			end if; 
		end if; 
	
	end process; 
	
	o_A <= r_a; 
	o_B <= r_b; 

end rtl;
