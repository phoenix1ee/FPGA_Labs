
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the top level entity

entity lab3_top is
    Port ( clock100mhz : in std_logic;
           BTNC : in std_logic;
           --switch input
           SW : in STD_LOGIC_VECTOR (15 downto 0); 
           SEG7_CATH1 : out std_logic_vector (7 downto 0);
           AN1 : out std_logic_vector (7 downto 0);
           --led
           LED : out STD_LOGIC_VECTOR (15 downto 0));
end lab3_top;

architecture Behavioral of lab3_top is

    signal char1:std_logic_vector (31 downto 0);
    signal pulse1:std_logic;
begin
    --pulse gen of 1hz, output 1hz pulse for reading sw0-3 values and char shift
    pulse1hz : entity work.pulse_1hz port map(clock=>clock100mhz , reset=>BTNC , pulse1hz=>pulse1);
    --segment display control, take a 32 bit value and output display and anode signal
    seg7_control : entity work.seg7_controller port map(clock=>clock100mhz,reset=>BTNC,char=>char1,seg7_cath=>SEG7_CATH1,AN=>AN1);
    --read sw0-3 values and character shift and output 32 bit values for display
    char_shift:entity work.char_shift port map(clock=>clock100mhz,reset=>BTNC,pulse=>pulse1,SWvalue=>SW(3 downto 0),char=>char1);
    --assign led status
    LED <= SW(15 downto 0);
end Behavioral;
