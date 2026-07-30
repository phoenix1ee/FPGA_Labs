----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: vol_level_shifter
-- Project Name: lab7

-- this is the entity to process volume level shift and the display value of volume
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;


entity vol_level_shifter is
    Port (  sine_in: in std_logic_vector(15 downto 0);
            vol_in: in std_logic_vector(2 downto 0);
            sine_out: out std_logic_vector(15 downto 0);
            vol_disp: out unsigned (15 downto 0)
           );
end vol_level_shifter;

architecture Behavioral of vol_level_shifter is
    signal disp: unsigned (15 downto 0);
begin
    -- right shift sine
    sine_out<=std_logic_vector(UNSIGNED(sine_in) srl TO_INTEGER(unsigned(not vol_in)));

    with vol_in select
            disp <=
             TO_UNSIGNED(0,16) when "000" ,            --0%
             TO_UNSIGNED(14,16) when "001" ,            --14%
             TO_UNSIGNED(29,16) when "010" ,            --29%
             TO_UNSIGNED(43,16) when "011" ,            --43%
             TO_UNSIGNED(57,16) when "100" ,            --57%
             TO_UNSIGNED(71,16) when "101" ,            --71%
             TO_UNSIGNED(86,16) when "110" ,            --86%
             TO_UNSIGNED(100,16) when "111" ,            --100%
             TO_UNSIGNED(0,16) when others; 
    vol_disp<=disp;
    
end Behavioral;
