-- Create Date: 05/26/2026 10:53:23 AM
-- Design Name: 
-- Module Name: lab2_top - Behavioral


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

entity lab2_top is
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
end lab2_top;

architecture Behavioral of lab2_top is

    signal disp1_data: std_logic_vector(3 downto 0);
    signal and_btn : std_logic;
    
begin
    --create the component of the display
    enc1 : entity work.seg7_hex port map(digit=>disp1_data,seg7=>seg7_cath);
    --signal of whether any button is pressed
    and_btn <= BTNU or BTNC or BTND;
    --assign 0 or value of sw0-3 to display
    cathode : process(BTNC,SW)
    begin
        case BTNC is
            when '1' =>
                disp1_data <= "0000";
            when others =>
                disp1_data <= SW(3 downto 0);
        end case;   
    end process cathode;
    --assign which 7segment to display
          
    anode : process(BTNU,BTND,SW)
    begin
        if (BTNC='1') then
            AN <= "00000000";
        elsif (BTNU='1') then
            AN <= "00001111";
        elsif (BTND='1') then
            AN <= "11110000";
        else
            AN <= not SW(11 downto 4);
        end if;
    end process anode;
    --assign led status
    LED <= SW(15 downto 0);
end Behavioral;
