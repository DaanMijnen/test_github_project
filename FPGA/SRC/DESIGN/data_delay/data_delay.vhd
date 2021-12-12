----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2021 20:39:12
-- Design Name: 
-- Module Name: temp - rtl
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; 

entity data_delay is
	Port (
		sys_clk: in std_logic;
		i_reset: in std_logic; 
		i_data_reg: in std_logic_vector(31 downto 0); 
		o_var_data: out std_logic_vector(31 downto 0)
	);
end data_delay;

architecture rtl of data_delay is

	signal acc: std_logic; 
	signal dec: std_logic; 
	signal var_data: std_logic_vector(31 downto 0);
	signal var_data_old: std_logic_vector(31 downto 0); --holding output after first difference in i_data_reg & var_data
	
	signal flag_bit: std_logic;  --doing first step in decreasing limit
	signal flag_bit_1: std_logic;  --doing first calculations when high
	constant c_zero_vector: std_logic_vector(24 downto 0) := "0000000000000000000000000"; 

begin

	p_diff_detect: process(sys_clk, i_reset)
	begin 
	
		if(i_reset = '1') then 
		--doe iets
		elsif(rising_edge(sys_clk)) then 
				acc <= '0'; 
				dec <= '0'; 
			--accelaration
			if (i_data_reg < var_data) then 
				acc <= '1'; 
			--deceleration
			elsif (i_data_reg > var_data) then 
				dec <= '1';
			end if;
		end if;
	end process; 
	
------------------------------------------------------------------------------------------------
	
	p_acc_calc: process(sys_clk, i_reset)
	
	variable delta: std_logic_vector(31 downto 0); 
	variable factor_1: std_logic_vector(31 downto 0);
	variable factor_2: std_logic_vector(31 downto 0); 
	
	begin 
	
		if(i_reset = '1') then 
		--doe iets
		elsif(rising_edge(sys_clk)) then 
			if (acc = '1') then 
						
				if (flag_bit = '0') --for doing calculations below first time: flag_bit pre defined value is 0 
			
					if (flag_bit_1 = '0') --for remember output value at first difference detection 
			
						var_data_old <= var_data; 
						delta := var_data_old - i_data_reg; 
						factor_1 := delta; 
						flag_bit_1 <= '1'; 
					
					else -- (flag_bit_1 = 1) doe onderstaande
					
					factor_1 := '0' & (factor_1(factor_1'high downto 1)); --devide factor_1 by 2
					factor_2 := factor_1;
					factor_2 := c_zero_vector(24 downto 0) & (factor_2(factor_2'high downto 24); -- devide factor_2 by 2^25 on this line 
					--rest_vector <=                put rest of devision into rest_vector
					flag_bit <= '1';
					
				elsif (flag_bit = '1') then --do below until eindwaarde stap bereikt
				
					if(var_data < (var_data_old - factor_1)) then  --zolang de eindwaarde (stap) nog niet bereikt is, doe onderstaande
					
						--new_rest_vector <= new_rest_vector + rest_vector; 
						var_data <= std_logic_vector(unsigned(var_data) - factor_2;
						
						--if (new_rest_vector > 1) then -- hoe?? 
				
							--factor_2 <= std_logic_vector(unsigned(factor_2) + 1); --devision correction
							--new_rest_vector <= std_logic_vector(unsigned(new_rest_vector) - 1); --hoe?? 
						--end if; 
					
					else -- als de eindwaarde stap wel bereikt is, doe onderstaande
				
							var_data_old <= var_data_old - factor_1; 
							flag_bit <= '0'; --do new calculations for new step
							
							
					end if; 
						
				elsif (factor_1 = 0) then 
			
					var_data <= i_data_reg; --end value reached!
					flag_bit <= '0';
					flag_bit_1 <= '0';
					--new_rest_vector set to 0; 
				end if; 
			end if;
		end if;
	end process;
	
	
------------------------------------------------------------------------------------------------
	
--	p_accelaration: process(sys_clk, i_reset)
--		begin 
--		if(i_reset = '1') then 
--		--doe iets
--		elsif(rising_edge(sys_clk)) then 
--			--if (flag_bit = 1)?
--				--if(var_data > (var_data_old - factor_1)): --zolang de eindwaarde (stap 1) nog niet bereikt is, doe onderstaande
--					var_data <= std_logic_vector(unsigned(var_data) - factor_2; 
--					
--				--else: als de eindwaarde wel bereikt is, doe onderstaande
--				
--					--flag_bit_1 = '1'; 
--			
--		end if;
--	end process;
	
	
------------------------------------------------------------------------------------------------
	
	
--	p_dev_fault_correction: process(sys_clk, i_reset)
--	begin 
	
--		if(i_reset = '1') then 
--		--doe iets
--		elsif(rising_edge(sys_clk)) then 
--			if (acc = '1') then 
--			
--			--new_rest_vector <= new_rest_vector + rest_vector; 
--			
--			--if (new_rest_vector > 1) : hoe?? 
--			
--				--factor_2 <= std_logic_vector(unsigned(factor_2) + 1); 
--				--new_rest_vector <= std_logic_vector(unsigned(new_rest_vector) - 1); --hoe?? 
--				
--			--elsif (factor_1 = 0) 
--			
--				--var_data <= i_data_reg; --end value reached!
--				--flag_bit <= '0';
--				--flag_bit_1 <= '0';
--			end if;
--		end if;
--	end process;
	
	

end rtl;
