----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: phase_accu
-- Project Name: lab7

-- this is the phase accumulator to output phase to sine lut dds
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

entity phase_accumulator is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : in STD_LOGIC;
           phase_count : out STD_LOGIC_VECTOR (7 downto 0));
end phase_accumulator;

architecture Behavioral of phase_accumulator is
    signal count: unsigned (7 downto 0):=(others=>'0');
begin
    process(clk,rst)
    begin
        if(rst = '1') then
            count <= (others=>'0');
        elsif(rising_edge(clk)) then
            if (pulse = '1') then
                count <= count+1;
            end if;
        end if;
    end process;
    phase_count<=std_logic_vector(count);

end Behavioral;
