----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/26/2026 10:53:23 AM
-- Design Name: 
-- Module Name: lab1_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab1_top is
    Port ( --push button
           BTNU : in std_logic;
           BTNC : in std_logic;
           BTND : in std_logic;
           --switches on board
           SW : in std_logic_vector (15 downto 0);
           --seg7 display signal
           SEG7_CATH : out std_logic_vector (7 downto 0);
           AN : out std_logic_vector (7 downto 0);
           --leds
           LED : out std_logic_vector (15 downto 0));
end lab1_top;

architecture Behavioral of lab1_top is

    signal disp1_data: std_logic_vector(3 downto 0);
    signal and_btn : std_logic;
    
begin
    enc1 : entity work.seg7_hex port map(digit=>disp1_data,seg7=>seg7_cath);
    and_btn <= BTNU or BTNC or BTND;
    disp1_data <= "0000" when BTNC = '1' else SW(3 downto 0);
    AN <= not SW(11 downto 4) when and_btn = '0' else 
          "00001111" when BTNU = '1' else
          "11110000" when BTND = '1' else
          "00000000";
    LED <= SW(15 downto 0);
end Behavioral;
