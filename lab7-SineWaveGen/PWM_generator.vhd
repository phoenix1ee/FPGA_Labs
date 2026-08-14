----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: PWM_generator
-- Project Name: lab7

-- this is the pwm signal generator for use with the mono audio output jack
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

entity PWM_generator is
    generic (pwm_resolution : integer:=10);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           duty_cycle : in STD_LOGIC_VECTOR (pwm_resolution-1 downto 0);
           pwm_out : out STD_LOGIC);
end PWM_generator;

architecture Behavioral of PWM_generator is
    signal max_count: unsigned(pwm_resolution-1 downto 0):=(others=>'1');
    signal count : unsigned(pwm_resolution-1 downto 0):=(others=>'0');
    signal clear : std_logic;
begin
    process(clk,rst)
    begin
        if(rst = '1') then
            count <= (others=>'0');
        elsif(rising_edge(clk)) then
            if clear = '1' then
                count <= (others=>'0');
            else
                count <= count+1;
            end if;
        end if;
    end process;
    clear <='1' when (count=max_count) else '0';
    pwm_out<='0' when count>=unsigned(duty_cycle) or count=max_count else '1';
    
end Behavioral;
