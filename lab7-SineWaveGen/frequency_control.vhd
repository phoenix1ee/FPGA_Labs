----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: frequency_control
-- Project Name: lab7

-- this is the entity to handle frequency setting, generate sample pulse and the display value of frequency
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
-- the count for sample generation
    with freq_in select
            count <=
             TO_UNSIGNED(0,27) srl 8 when "000" ,     
             TO_UNSIGNED(200000,27) srl 8  when "001" ,        
             TO_UNSIGNED(100000,27) srl 8  when "010" ,     
             TO_UNSIGNED(66666,27) srl 8  when "011" ,       
             TO_UNSIGNED(50000,27) srl 8  when "100" ,         
             TO_UNSIGNED(40000,27) srl 8  when "101" ,    
             TO_UNSIGNED(33333,27) srl 8  when "110" ,    
             TO_UNSIGNED(28571,27) srl 8  when "111" ,   
             TO_UNSIGNED(0,27) srl 8  when others; 
    
--use the pulse gen entity
    sample_gen : entity work.pulse_gen2 port map(clk=>clk,rst=>rst,max_count=>count,pulseOut=>pulse1);
    
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
