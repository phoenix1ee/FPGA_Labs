----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/24/2026
-- Design Name: 
-- Module Name: rgb_controller - Behavioral
-- Project Name: lab4

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the entity of the rgb_controller inside VGA module, that receive a selection signal and output the correct rgb signal or 0.

entity disp_enable_controller is
    Port ( clock : in std_logic;
           reset : in std_logic;
           sel: in std_logic;
           pulse_25Mhz: in std_logic;
           rgb: in std_logic_vector (11 downto 0);
           red: out std_logic_vector(3 downto 0);
           green: out std_logic_vector(3 downto 0);
           blue: out std_logic_vector(3 downto 0));
end disp_enable_controller;

architecture Behavioral of disp_enable_controller is
   
begin
    
    process(clock,reset)
    begin
        if (reset = '1') then
            red <= "0000";
            green <= "0000";
            blue <= "0000";
        elsif (rising_edge(clock)) then
            if (pulse_25Mhz = '1') then
                if (sel='1') then
                    red<=rgb(11 downto 8);
                    green<=rgb(7 downto 4);
                    blue<=rgb(3 downto 0);
                else
                    red<="0000";
                    green<="0000";
                    blue<="0000";
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
