----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/04/2026
-- Design Name: 
-- Module Name: debounce_button - Behavioral
-- Project Name: lab4
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity accel_control_input is
    Port ( clk : in std_logic ;
           reset: in std_logic;
           value: in unsigned(7 downto 0);
           max_count: in unsigned(23 downto 0);
           pulseOut : out std_logic);
end accel_control_input;

architecture Behavioral of accel_control_input is
    signal pb0: std_logic;
    signal count_sig : unsigned(23 downto 0);
    signal pb0_db : std_logic;
    signal pb0_db_q : std_logic;
begin
    pb0<='1' when value>x"30" else '0';
    process(clk,reset)
    begin
        if(reset = '1') then
            count_sig <= (others=>'0');
            pb0_db<='0';
        elsif(rising_edge(clk)) then
            if (pb0='1') then
                if (count_sig<max_count) then
                    count_sig <= count_sig+1;
                else
                    pb0_db<='1';
                end if;
            else
                count_sig <= (others=>'0');
                pb0_db<='0';
            end if;
        end if;
    end process;
    process(clk,reset)
    begin
        if(reset = '1') then
            pb0_db_q<='0';
        elsif(rising_edge(clk)) then
            pb0_db_q<=pb0_db;
        end if;
    end process;
    pulseOut<='1' when (pb0_db_q='0') and (pb0_db='1') else '0';
    
end Behavioral;