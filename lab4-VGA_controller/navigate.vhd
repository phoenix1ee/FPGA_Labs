----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/24/2026
-- Design Name: 
-- Module Name: navigate - Behavioral
-- Project Name: lab4

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the entity for providing an coordinate to navigate the red square across the checker board pattern

entity navigate is
    Port ( clock : in std_logic;
           reset : in std_logic;
           --pulse_25Mhz: in std_logic;
           max_x : in unsigned(4 downto 0);
           max_y : in unsigned(3 downto 0);
           pulse_up: in std_logic;
           pulse_down: in std_logic;
           pulse_left: in std_logic;
           pulse_right: in std_logic;
           
           x: out unsigned(4 downto 0);
           y: out unsigned(3 downto 0));
           
end navigate;

architecture Behavioral of navigate is
    --origin
    signal x_curr:unsigned(4 downto 0):="01010";
    signal y_curr:unsigned(3 downto 0):="1000";

begin
    process(clock,reset,pulse_up,pulse_down,pulse_left,pulse_right)
    begin
        if (reset = '1') then
            x_curr <= "01010";
            y_curr <= "1000";
        elsif (rising_edge(clock)) then
            --if (pulse_25Mhz = '1') then
                if (pulse_right = '1') then
                    if x_curr = max_x then
                        x_curr <= (others => '0');
                    else
                        x_curr <= x_curr + 1;
                    end if;
                elsif (pulse_left = '1') then
                    if x_curr = "00000" then
                        x_curr <= max_x;
                    else
                        x_curr <= x_curr - 1;
                    end if;
                end if;
                
                if (pulse_down = '1') then
                    if y_curr = max_y then
                        y_curr <= (others => '0');
                    else
                        y_curr <= y_curr + 1;
                    end if;
                elsif (pulse_up = '1') then
                    if y_curr = "0000" then
                        y_curr <= max_y;
                    else
                        y_curr <= y_curr - 1;
                    end if;
                end if;
            --end if;
        end if;
    end process;
    x<=x_curr;
    y<=y_curr;
end Behavioral;
