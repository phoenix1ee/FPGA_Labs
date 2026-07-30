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


entity frequency_control is
    Port ( clk : in std_logic;
           rst : in std_logic;
           freq_in: in std_logic_vector (2 downto 0);
           freq_disp : out unsigned (15 downto 0);
           pulseOut: out std_logic
           );
end frequency_control;

architecture Behavioral of frequency_control is
    signal count : unsigned(26 downto 0);
    signal freq: unsigned (15 downto 0);
    signal pulse1:std_logic;
begin
-- the display of frequency
    with freq_in select
            count <=
             TO_UNSIGNED(0,27) when "000" ,     
             TO_UNSIGNED(199999,27) when "001" ,        
             TO_UNSIGNED(99999,27) when "010" ,     
             TO_UNSIGNED(66666,27) when "011" ,       
             TO_UNSIGNED(49999,27) when "100" ,         
             TO_UNSIGNED(39999,27) when "101" ,    
             TO_UNSIGNED(33332,27) when "110" ,    
             TO_UNSIGNED(28570,27) when "111" ,   
             TO_UNSIGNED(0,27) when others; 
    
--use the pulse gen entity
    sample_gen : entity work.pulse_gen port map(clk=>clk,rst=>rst,max_count=>count,pulseOut=>pulse1);
    
-- the display of frequency
    with freq_in select
            freq <=
             TO_UNSIGNED(0,16) when "000" ,       
             TO_UNSIGNED(500,16) when "001" ,         
             TO_UNSIGNED(1000,16) when "010" ,       
             TO_UNSIGNED(1500,16) when "011" ,      
             TO_UNSIGNED(2000,16) when "100" ,        
             TO_UNSIGNED(2500,16) when "101" ,  
             TO_UNSIGNED(3000,16) when "110" ,  
             TO_UNSIGNED(3500,16) when "111" , 
             TO_UNSIGNED(0,16) when others; 
    
    freq_disp<=freq;
    pulseOut<=pulse1;
end Behavioral;
