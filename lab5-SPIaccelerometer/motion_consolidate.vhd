

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity motion_consolidate is
    Port ( clk : in std_logic ;
           reset: in std_logic;
           pbu: in std_logic;
           pbd: in std_logic;
           pbl: in std_logic;
           pbr: in std_logic;
           rx8: in std_logic_vector(7 downto 0);
           rx9: in std_logic_vector(7 downto 0);
           max_count: in unsigned(23 downto 0);
           pulse_u_out : out std_logic;
           pulse_d_out : out std_logic;
           pulse_l_out : out std_logic;
           pulse_r_out : out std_logic);
           
end motion_consolidate;

architecture Behavioral of motion_consolidate is
    signal pulse_bu: std_logic;
    signal pulse_bd: std_logic;
    signal pulse_bl: std_logic;
    signal pulse_br: std_logic;
    
    signal v_up: unsigned (7 downto 0);
    signal v_down: unsigned (7 downto 0);
    signal v_left: unsigned (7 downto 0);
    signal v_right: unsigned (7 downto 0);
    
    signal pulse_au: std_logic;
    signal pulse_ad: std_logic;
    signal pulse_al: std_logic;
    signal pulse_ar: std_logic;

begin
    --accelerometer filter
    v_up<=(unsigned(not rx8)+ 1) when rx8(7) = '1' else (others => '0');
    v_down<=(unsigned(rx8)) when rx8(7) = '0' else (others => '0');
    v_left<=(unsigned(not rx9)) when rx9(7) = '0' else (others => '0');
    v_right<=(unsigned(not rx9)+ 1) when rx9(7) = '1' else (others => '0');
    --debounce button
    bttn_U: entity work.debounce_button port map(clk=>clk,reset=>reset,pb0=>pbu,max_count=>max_count,pulseOut=>pulse_bu);
    bttn_D: entity work.debounce_button port map(clk=>clk,reset=>reset,pb0=>pbd,max_count=>max_count,pulseOut=>pulse_bd);
    bttn_L: entity work.debounce_button port map(clk=>clk,reset=>reset,pb0=>pbl,max_count=>max_count,pulseOut=>pulse_bl);
    bttn_R: entity work.debounce_button port map(clk=>clk,reset=>reset,pb0=>pbr,max_count=>max_count,pulseOut=>pulse_br);
    --accelerometer sensing
    tilt_front: entity work.accel_control_input port map(clk=>clk,reset=>reset,value=>v_up,max_count=>max_count,pulseOut=>pulse_au);
    tilt_back: entity work.accel_control_input port map(clk=>clk,reset=>reset,value=>v_down,max_count=>max_count,pulseOut=>pulse_ad);
    tilt_left: entity work.accel_control_input port map(clk=>clk,reset=>reset,value=>v_left,max_count=>max_count,pulseOut=>pulse_al);
    tilt_right: entity work.accel_control_input port map(clk=>clk,reset=>reset,value=>v_right,max_count=>max_count,pulseOut=>pulse_ar);
    --output real control pulse
    pulse_u_out<=pulse_bu or pulse_au;
    pulse_d_out<=pulse_bd or pulse_ad;
    pulse_l_out<=pulse_bl or pulse_al;
    pulse_r_out<=pulse_br or pulse_ar;
    
end Behavioral;