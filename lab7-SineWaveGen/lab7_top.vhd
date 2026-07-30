
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the top level entity

entity lab7_top is
--    Port ( 
--           clock100mhz : in std_logic;
--           BTNC : in std_logic;

--           --switch input
--           SW : in STD_LOGIC_VECTOR (15 downto 0);
--           --cathod_led
--           SEG7_CATH1 : out std_logic_vector (7 downto 0);
--           AN1 : out std_logic_vector (7 downto 0);
--           LED : out std_logic_vector(15 downto 0);
--           --audio on off
--           AUD_SD : out std_logic
--           );

end lab7_top;

architecture Behavioral of lab7_top is
    signal reset: std_logic;
    signal upper_dec_digits: STD_LOGIC_VECTOR (15 downto 0);
    signal lower_dec_digits: STD_LOGIC_VECTOR (15 downto 0);
    signal phase: STD_LOGIC_VECTOR (7 downto 0);
    signal sine_raw: STD_LOGIC_VECTOR (15 downto 0);
    signal sine_shifted: STD_LOGIC_VECTOR (15 downto 0);
    signal volume: unsigned (15 downto 0);
    signal frequency: unsigned (15 downto 0);
    signal sample_gen_pulse: std_logic;
    
    --------------------------------------------
         signal  clock100mhz :  std_logic;
        signal   BTNC :  std_logic;

           --switch input
       signal    SW :  STD_LOGIC_VECTOR (15 downto 0);
           --cathod_led
       signal    SEG7_CATH1 : std_logic_vector (7 downto 0);
       signal    AN1 :  std_logic_vector (7 downto 0);
       signal    LED :  std_logic_vector(15 downto 0);
           --audio on off
        signal   AUD_SD : std_logic;
    --------------------------------------------
--    sine LUT
    component sine_lut_dds
      PORT (
            aclk : IN STD_LOGIC;
            s_axis_phase_tvalid : IN STD_LOGIC;
            s_axis_phase_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            m_axis_data_tvalid : OUT STD_LOGIC;
            m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
            );
    end component;
begin
    --------------------------------------------
    SW<="0000000000011111";
    BTNC<='0';
    gen_clk: process
    begin
        clock100mhz<= '1';
        wait for 5 ns;
        clock100mhz<= '0';
        wait for 5 ns;
    end process gen_clk;
    --------------------------------------------
    reset<=BTNC;
    --count for 25Mhz pulse
--    max_count1<="000000000000000000000000011";

-- frequency control and display
    freq_ctl: entity work.frequency_control port map(clk=>clock100mhz,
                                                    rst=>reset,
                                                    freq_in=>SW(2 downto 0),
                                                    freq_disp=>frequency,
                                                    pulseOut=>sample_gen_pulse);
-- volumne shifter and output value to display
    vol_ctl: entity work.vol_level_shifter port map(sine_in=>sine_raw,
                                                    vol_in=>SW(5 downto 3),
                                                    sine_out=>sine_shifted,
                                                    vol_disp=>volume);
--    sine LUT
    sine_lut_dds1 : sine_lut_dds port map(  aclk=>clock100mhz,
                                            s_axis_phase_tvalid=>'1',
                                            s_axis_phase_tdata =>phase,
                                            m_axis_data_tdata=>sine_raw);

-- volumne decimal value convert
    vol_dec_dis: entity work.Hex2Decdigit port map( char_in=>volume,
                                                    char_out=>upper_dec_digits);
-- freq decimal value convert
    freq_dec_dis: entity work.Hex2Decdigit port map( char_in=>frequency,
                                                    char_out=>lower_dec_digits);

--    segment display control, take a 32 bit value and output display and anode signal
    seg7_control : entity work.seg7_controller port map(clock=>clock100mhz,reset=>reset,
                                                        char(31 downto 16)=>upper_dec_digits,
                                                        char(15 downto 0)=>lower_dec_digits,
                                                        seg7_cath=>SEG7_CATH1,AN=>AN1);

-- audio on off
    AUD_SD<=SW(15);

    --assign led status
    LED <= SW(15 downto 0);

end Behavioral;
