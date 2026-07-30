----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: Hex2Decdigit
-- Project Name: lab7

-- this is the process to convert a 16 bit value to 4 decimal digit
-- support only up to 9999
-- overflow disregarded
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

entity Hex2Decdigit is
    Port ( char_in : in unsigned (15 downto 0);
           char_out : out STD_LOGIC_VECTOR (15 downto 0));
end Hex2Decdigit;

architecture Behavioral of Hex2Decdigit is
--    signal char: unsigned (15 downto 0);
    signal dec_result: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
begin
--    char<="0000010011010010";
    
    --add 3 and shift loop on the input char to convert it to deciaml digist
    process (char_in)
            variable temp:unsigned (31 downto 0);
    begin
        temp:=(others=>'0');
        --put input char into lower half
        temp(15 downto 0):=char_in;
        for i in 15 downto 0 loop
            --ones digit
            if temp(19 downto 16) >= 5 then
                temp(19 downto 16) := temp(19 downto 16) + 3;
            end if;
            --tens digit
            if temp(23 downto 20) >= 5 then
                temp(23 downto 20) := temp(23 downto 20) + 3;
            end if;
            --hundreds digit
            if temp(27 downto 24) >= 5 then
                temp(27 downto 24) := temp(27 downto 24) + 3;
            end if;
            --thousands digit
            if temp(31 downto 28) >= 5 then
                temp(31 downto 28) := temp(31 downto 28) + 3;
            end if;
        -- shift the digits
        temp:=temp(30 downto 0) & '0';
        end loop;
        dec_result<=std_logic_vector(temp(31 downto 16));
    end process;
    
    char_out<=dec_result;
end Behavioral;
