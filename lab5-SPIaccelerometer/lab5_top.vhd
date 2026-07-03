
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the top level entity

entity lab4_top is
    Port ( clock100mhz : in std_logic;
           reset : in std_logic;
           BTNU : in std_logic;
           BTND : in std_logic;
           BTNL : in std_logic;
           BTNR : in std_logic;
           --cathod_led
           SEG7_CATH1 : out std_logic_vector (7 downto 0);
           AN1 : out std_logic_vector (7 downto 0);
           --vga
           VGA_R : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_HS : out std_logic;
           VGA_VS : out std_logic);
end lab4_top;

architecture Behavioral of lab4_top is

    signal clk_25mhz:std_logic;
    signal rgb_from_vga:std_logic_vector(11 downto 0);
    signal w: unsigned (10 downto 0);
    signal h: unsigned (10 downto 0);
    signal rgb_to_vga:std_logic_vector(11 downto 0);
    signal h_sync:std_logic;
    signal v_sync:std_logic;
    signal max_count1:unsigned(26 downto 0);
    signal h_count1:unsigned (10 downto 0);
    signal v_count1:unsigned (10 downto 0);
    signal max_x:unsigned (4 downto 0);
    signal max_y:unsigned (3 downto 0);
    signal x:unsigned (4 downto 0);
    signal y:unsigned (3 downto 0);
    signal debounce_latency: unsigned (23 downto 0);
    signal pulse_u: std_logic;
    signal pulse_d: std_logic;
    signal pulse_l: std_logic;
    signal pulse_r: std_logic;

begin
    --640 width
    w<="01010000000";
    --480 height
    h<="00111100000";
    --count for 25Mhz pulse
    max_count1<="000000000000000000000000011";
    --0-19 no. of horizontal square
    max_x<="10011";
    --0-14 no. of vertical square
    max_y<="1110";
    --0.1s
    debounce_latency<="100110001001011010000000";
    --0.9s
    --debounce_latency<="100010010101010001000000";
    --0.8s
    --debounce_latency<="011110100001001000000000";

    --25Mhz pulse
    pulse25 : entity work.pulse_gen port map(clk=>clock100mhz,rst=>reset,max_count=>max_count1,pulseOut=>clk_25mhz);
    --vga signal controller
    vga_ctl: entity work.vga_controller port map(clk =>clock100mhz,
                                                rst =>reset,
                                                width_in=>w,
                                                height_in=>h,
                                                pulse_25Mhz_in=>clk_25mhz,
                                                rgb_in=>rgb_to_vga,
                                                
                                                h_sync_out =>h_sync,
                                                v_sync_out =>v_sync,
                                                red_out=>rgb_from_vga(11 downto 8),
                                                green_out=>rgb_from_vga(7 downto 4),
                                                blue_out=>rgb_from_vga(3 downto 0),
                                                h_count=>h_count1,
                                                v_count=>v_count1);
    --color controller
    color_ctl: entity work.color_controller port map(clock=>clock100mhz,reset=>reset,pulse_25Mhz=>clk_25mhz,h_count=>h_count1,v_count=>v_count1,x=>x,y=>y,
                                                     red=>rgb_to_vga(11 downto 8),
                                                     green=>rgb_to_vga(7 downto 4),
                                                     blue=>rgb_to_vga(3 downto 0));
    --debounce button
    bttn_U: entity work.debounce_button port map(clk=>clock100mhz,reset=>reset,pb0=>BTNU,max_count=>debounce_latency,pulseOut=>pulse_u);
    bttn_D: entity work.debounce_button port map(clk=>clock100mhz,reset=>reset,pb0=>BTND,max_count=>debounce_latency,pulseOut=>pulse_d);
    bttn_L: entity work.debounce_button port map(clk=>clock100mhz,reset=>reset,pb0=>BTNL,max_count=>debounce_latency,pulseOut=>pulse_l);
    bttn_R: entity work.debounce_button port map(clk=>clock100mhz,reset=>reset,pb0=>BTNR,max_count=>debounce_latency,pulseOut=>pulse_r);
    --naviagate control
    navigate_ctl: entity work.navigate port map(clock=>clock100mhz,reset=>reset,max_x=>max_x,max_y=>max_y,
                                                pulse_up=>pulse_u,pulse_down=>pulse_d,pulse_right=>pulse_r,pulse_left=>pulse_l,
                                                x=>x,y=>y);
    --output signal
    VGA_R<=rgb_from_vga(11 downto 8);
    VGA_G<=rgb_from_vga(7 downto 4);
    VGA_B<=rgb_from_vga(3 downto 0);
    VGA_HS<=h_sync;
    VGA_VS<=v_sync;
    
    --segment display control, take a 32 bit value and output display and anode signal
    seg7_control : entity work.seg7_controller port map(clock=>clock100mhz,reset=>reset,
                                                        char(31 downto 16)=>"0000000000000000",
                                                        char(15 downto 13)=>"000",
                                                        char(12 downto 8)=>std_logic_vector(x),
                                                        char(7 downto 4)=>"0000",
                                                        char(3 downto 0)=>std_logic_vector(y),
                                                        seg7_cath=>SEG7_CATH1,AN=>AN1);



end Behavioral;
