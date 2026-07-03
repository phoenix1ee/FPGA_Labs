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

-- this is the entity of the color_controller, that produce the rgb content based on the counter values from vga controller
-- checker board pattern for this lab, with a square of red

entity color_controller is
    Port ( clock : in std_logic;
           reset : in std_logic;
           pulse_25Mhz: in std_logic;
           h_count: in unsigned(10 downto 0);
           v_count: in unsigned(10 downto 0);
           x: in unsigned(4 downto 0);
           y: in unsigned(3 downto 0);
           
           red: out std_logic_vector(3 downto 0);
           green: out std_logic_vector(3 downto 0);
           blue: out std_logic_vector(3 downto 0));
end color_controller;

architecture Behavioral of color_controller is
    signal color:std_logic;
    signal target:std_logic;
begin
    color<=h_count(5) xor v_count(5);
    
    process(clock,reset)
    begin
        if (reset = '1') then
            red <= "0000";
            green <= "0000";
            blue <= "0000";
        elsif (rising_edge(clock)) then
            if (pulse_25Mhz = '1') then
                if (x=h_count(9 downto 5) and y=v_count(8 downto 5)) then
                    red<="1111";
                    green<="0000";
                    blue<="0000";
                else
                    red<="0000";
                    if (color = '1') then
                        green<="0000";
                        blue<="1111";
                    else
                        green<="1111";
                        blue<="0000";
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
