----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/04/2026
-- Design Name: 
-- Module Name: pulse_gen - Behavioral - minimum 1khz
-- Project Name: 
----------------------------------------------------------------------------------

--this is the a pulse generation entity that generate the required pulse as specified by a count input

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity pulse_gen is
    Port ( clk : in std_logic ;
           rst: in std_logic ;
           max_count: in unsigned(26 downto 0);
           pulseOut : out std_logic);
end pulse_gen;

architecture Behavioral of pulse_gen is
    signal count : unsigned(26 downto 0):="000000000000000000000000000";
    signal clear : std_logic;
begin
    process(clk,rst)
    begin
        if(rst = '1') then
            count <= (others=>'0');
        elsif(rising_edge(clk)) then
            if (clear = '1') then
                count <= (others=>'0');
            else
                count <= count+1;
            end if;
        end if;
    end process;
    clear <='1' when (count=max_count) else '0';
    pulseOut<=clear;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity pulse_gen2 is
    Port ( clk : in std_logic ;
           rst: in std_logic ;
           max_count: in unsigned(26 downto 0);
           pulseOut : out std_logic);
end pulse_gen2;

architecture Behavioral of pulse_gen2 is
    signal count : unsigned(26 downto 0):="000000000000000000000000000";
    signal clear : std_logic;
begin
    process(clk,rst)
    begin
        if(rst = '1') then
            count <= (others=>'0');
        elsif(rising_edge(clk)) then
            if (clear = '1') then
                count <= (others=>'0');
            else
                count <= count+1;
            end if;
        end if;
    end process;
    clear <='1' when (count=max_count) else '0';
    pulseOut<='1' when (count="000000000000000000000001000") else '0';
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity slow_clock_gen is
    Port ( clk : in std_logic;
           rst: in std_logic;
           max_count: in unsigned(26 downto 0);
           clk_out : out std_logic);
end slow_clock_gen;

architecture Behavioral of slow_clock_gen is
    signal s_clk:std_logic:='0';
    signal max_count1: unsigned(26 downto 0);
    signal count: unsigned(26 downto 0):= (others=>'0');
    signal clear:std_logic;
begin
    --divide the input count by 2
    max_count1<=max_count srl 1;
    process(clk,rst)
    begin
        if(rst = '1') then
            count <= (others=>'0');
        elsif(rising_edge(clk)) then
            if (clear = '1') then
                s_clk <= not s_clk;
                count <= (others=>'0');
            else
                count <= count+1;
            end if;
        end if;
    end process;
    clear <='1' when (count=max_count1) else '0';
    clk_out<=s_clk;
end Behavioral;