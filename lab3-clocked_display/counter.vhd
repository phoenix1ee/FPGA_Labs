----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/04/2026
-- Design Name: 
-- Module Name: counter - Behavioral
-- Project Name: lab3

----------------------------------------------------------------------------------

--counter for setting which anode to be on

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    Port ( clk : in std_logic ;
           pulse: in std_logic;
           rst: in std_logic ;
           count: out unsigned(2 downto 0));
end counter;

architecture Behavioral of counter is
    signal count_sig : unsigned(2 downto 0);
begin
    process(clk,rst)
    begin
        if(rst = '1') then
            count_sig <= (others=>'0');
        elsif(rising_edge(clk)) then
            if(pulse = '1') then
                count_sig <= count_sig+1;
            end if;
        end if;
    end process;
    count<=count_sig;
end Behavioral;
