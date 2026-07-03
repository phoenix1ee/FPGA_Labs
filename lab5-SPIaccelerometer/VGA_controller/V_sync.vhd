----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/24/2026
-- Design Name: 
-- Module Name: v_sync_controller - Behavioral
-- Project Name: lab4

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the entity of the vertical sync_controller inside VGA module, that receive a pulse from horizontal sync every line and output vertical sync and rgb control signal

entity v_sync_controller is
    Port ( clock : in std_logic;
           reset : in std_logic;
           height: in unsigned (10 downto 0);
           pulse: in std_logic;
           v_sync : out std_logic;
           v_count: out unsigned (10 downto 0);
           rgb : out std_logic);
end v_sync_controller;

architecture Behavioral of v_sync_controller is
    --33
    signal backporch : unsigned(10 downto 0):="00000100001";
    --10
    signal frontporch : unsigned(10 downto 0):="00000001010";
    --2
    signal v_sync_width : unsigned(10 downto 0):="00000000010";
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
            elsif (pulse = '1') then
                count_sig <= count_sig+1;
            end if;
        end if;
    end process;
    --clear counter when finish 480 rows-->480+10+2+33-1
    clear<='1' when count_sig=height+frontporch+v_sync_width+backporch-1 else '0';
    --output rgb when counter is inside 480 pixel lines region
    rgb<='1' when count_sig<height else '0';
    --output v_sync signal during the sync region
    v_sync <= '0' when count_sig>=height+frontporch and count_sig<height+frontporch+v_sync_width else '1';
    v_count<=count_sig;
end Behavioral;
