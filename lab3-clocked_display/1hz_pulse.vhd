----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/04/2026
-- Design Name: 
-- Module Name: 1hz_pulse - Behavioral
-- Project Name: lab3

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the entity to generate 1 hz pulse

entity pulse_1hz is
    Port ( clock : in std_logic;
           reset : in std_logic;
           pulse1hz : out std_logic);
end pulse_1hz;

architecture Behavioral of pulse_1hz is
    signal MaxCounter1 : unsigned(26 downto 0);
    signal slowPulse: std_logic;
begin
    pulsegen_1hz : entity work.pulse_gen port map(clk=>clock,rst=>reset,max_count=>MaxCounter1,pulseOut=>pulse1hz);
    --max count for a 1hz pulse in 100M clock = 100M-1
    MaxCounter1<="101111101011110000011111111";
end Behavioral;
