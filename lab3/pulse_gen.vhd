----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/04/2026
-- Design Name: 
-- Module Name: pulse_gen - Behavioral - minimum 1khz
-- Project Name: lab3
----------------------------------------------------------------------------------

--this is the a pulse generation entity that generate the required pulse as specified by a count input

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity pulse_gen is
    Port ( clk : in std_logic ;
           rst: in std_logic ;
           max_count: in unsigned(26 downto 0);
           pulseOut : out std_logic);
end pulse_gen;

architecture Behavioral of pulse_gen is
    signal count : unsigned(26 downto 0);
    signal clear : std_logic;
begin
    process(clk,rst)
    begin
        if(rst = '1') then
            count <= (others=>'0');
        elsif(rising_edge(clk)) then
            if (clear = '1') then
                count <= (others=>'0');
            else
                count <= count+1;
            end if;
        end if;
    end process;
    clear <='1' when (count=max_count) else '0';
    pulseOut<=clear;
end Behavioral;
