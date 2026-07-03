----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/24/2026
-- Design Name: 
-- Module Name: h_sync_controller - Behavioral
-- Project Name: lab4

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the entity of the horizontal sync_controller inside VGA module, that receive 25Mhz pulse and output horizontal sync and rgb control signal

entity h_sync_controller is
    Port ( clock : in std_logic;
           reset : in std_logic;
           width: in unsigned (10 downto 0);
           pulse_25Mhz: in std_logic;
           h_sync : out std_logic;
           rgb : out std_logic;
           h_count: out unsigned (10 downto 0);
           pulse_to_v: out std_logic);
           
end h_sync_controller;

architecture Behavioral of h_sync_controller is
    --48
    signal backporch : unsigned(10 downto 0):="00000110000";
    --16
    signal frontporch : unsigned(10 downto 0):="00000010000";
    --96
    signal h_sync_width : unsigned(10 downto 0):="00001100000";
    signal count_sig : unsigned(10 downto 0):=(others=>'0');
    signal clear:std_logic;
begin
    
    process(clock,reset)
    begin
        if(reset = '1') then
            count_sig <= (others=>'0');
        elsif(rising_edge(clock)) then
            if (clear = '1') then
                count_sig <= (others=>'0');
            elsif (pulse_25Mhz = '1') then
                count_sig <= count_sig+1;
            end if;
        end if;
    end process;
    --clear counter when finish 1 row, 640+16+96+48-1-->0 to 799
    clear<='1' when count_sig=width+frontporch+h_sync_width+backporch-1 else '0';
    --output 1 pulse to v_sync control for each line
    pulse_to_v<=clear;
    --output rgb when counter is inside 640 pixel region
    rgb<='1' when count_sig<width else '0';
    --output h_sync signal during the sync region
    h_sync <= '0' when count_sig>=width+frontporch and count_sig<width+frontporch+h_sync_width else '1';
    h_count<=count_sig;
end Behavioral;
