----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/04/2026
-- Design Name: 
-- Module Name: char_shift - Behavioral
-- Project Name: lab3

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- This entity is to read the switch 0-3 value, shift the original bit 27 to 0 left and replace bit 3 to 0 with the input switch value
-- and output a 32 bit signal for segment display

entity char_shift is
    Port ( clock : in std_logic;
           reset : in std_logic;
           pulse: in std_logic;
           --switch value
           SWvalue : in std_logic_vector (3 downto 0);
           char: out std_logic_vector (31 downto 0));
end char_shift;

architecture Behavioral of char_shift is
    signal char1:std_logic_vector (31 downto 0) := (others => '0');
begin
    process(clock,reset)
    begin
        if(reset = '1') then
            char1<=(others=>'0');
        elsif(rising_edge(clock)) then
            if (pulse = '1') then
                char1 <= char1(27 downto 0) & SWvalue(3 downto 0);
            end if;
        end if;
    end process;
    char<=char1;
end Behavioral;
