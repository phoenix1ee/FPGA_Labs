----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/04/2026
-- Design Name: 
-- Module Name: seg7_controller - Behavioral
-- Project Name: lab3

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seg7_controller is
    Port ( clock : in std_logic;
           reset : in std_logic;
           char: in std_logic_vector (31 downto 0);
           seg7_cath : out std_logic_vector (7 downto 0);
           AN : out std_logic_vector (7 downto 0));
end seg7_controller;

architecture Behavioral of seg7_controller is
    signal MaxCounter1 : unsigned(16 downto 0);
    signal Pulse1KHz : std_logic;
    signal slow3bit: std_logic_vector(2 downto 0);
    signal disp1_data: std_logic_vector(3 downto 0);
begin
    pulsegen : entity work.pulse_gen port map(clk=>clock,rst=>reset,max_count(26 downto 17)=>"0000000000",max_count(16 downto 0)=>MaxCounter1,pulseOut=>Pulse1Khz);
    MaxCounter1<="11000011010100000";
    enc1 : entity work.seg7_hex port map(digit=>disp1_data,seg7=>seg7_cath);
    anode_cntl: entity work.counter port map(clk=>clock, pulse=>Pulse1KHz,rst=>reset,std_logic_vector(count)=>slow3bit);
    with slow3bit select
            AN <=
             "11111110" when "000" ,
             "11111101" when "001" ,
             "11111011" when "010" ,
             "11110111" when "011" ,
             "11101111" when "100" ,
             "11011111" when "101" ,
             "10111111" when "110" ,
             "01111111" when "111" ,
             "11111111" when others;
    with slow3bit select
            disp1_data <=
             char(3 downto 0) when "000" ,
             char(7 downto 4) when "001" ,
             char(11 downto 8) when "010" ,
             char(15 downto 12) when "011" ,
             char(19 downto 16) when "100" ,
             char(23 downto 20) when "101" ,
             char(27 downto 24) when "110" ,
             char(31 downto 28) when "111" ,
             "0000" when others; 
end Behavioral;
