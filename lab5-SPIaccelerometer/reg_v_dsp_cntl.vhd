----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 07/02/2026
-- Design Name: 
-- Module Name: reg_v_disp_cntl - Behavioral
-- Project Name: lab4

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the entity of the rgb_controller inside VGA module, that receive a selection signal and output the correct rgb signal or 0.

entity reg_v_disp_cntl is
    Port ( clock : in std_logic;
           reset : in std_logic;
           sw: in std_logic_vector (1 downto 0);
           r00: in std_logic_vector(7 downto 0);
           r01: in std_logic_vector(7 downto 0);
           r08: in std_logic_vector(7 downto 0);
           r09: in std_logic_vector(7 downto 0);
           r0A: in std_logic_vector(7 downto 0);
           disp7654: out std_logic_vector(15 downto 0));
end reg_v_disp_cntl;

architecture Behavioral of reg_v_disp_cntl is
   
begin
    process(clock,reset)
    begin
        if (reset = '1') then
            disp7654<=(others=>'0');
        elsif (rising_edge(clock)) then
            if (sw = "00") then
                disp7654(15 downto 8)<=r01;
                disp7654(7 downto 0)<=r00;
            else
                disp7654(15 downto 8)<="00000000";
                if (sw = "01") then
                    disp7654(7 downto 0)<=r08;
                elsif (sw = "10") then
                    disp7654(7 downto 0)<=r09;
                elsif (sw = "11") then
                    disp7654(7 downto 0)<=r0A;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
