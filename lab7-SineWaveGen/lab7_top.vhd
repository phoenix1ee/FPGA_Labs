
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the top level entity

entity lab7_top is
    Port ( 
           clock100mhz : in std_logic;
           BTNC : in std_logic;

           --switch input
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           --cathod_led
           SEG7_CATH1 : out std_logic_vector (7 downto 0);
           AN1 : out std_logic_vector (7 downto 0);
           LED : out std_logic_vector(15 downto 0);
           --audio on off
           AUD_SD : out std_logic;
           --audio pwm
           AUD_PWM: out std_logic
           );

end lab7_top;

architecture Behavioral of lab7_top is
    signal reset: std_logic;
    signal upper_dec_digits: STD_LOGIC_VECTOR (15 downto 0);
    signal lower_dec_digits: STD_LOGIC_VECTOR (15 downto 0);
    signal phase: STD_LOGIC_VECTOR (7 downto 0);
    signal sine_valid: std_logic;
    signal sine_raw: STD_LOGIC_VECTOR (15 downto 0);
    signal inverted_sine_raw: STD_LOGIC_VECTOR (15 downto 0);
    signal sine_shifted: STD_LOGIC_VECTOR (15 downto 0);
    signal volume: unsigned (15 downto 0);
    signal frequency: unsigned (15 downto 0);
    signal sample_gen_pulse: std_logic;
    constant pwm_resol: integer:=10;
    signal pwm_out_to_audio: std_logic;

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

    reset<=BTNC;

-- frequency control and display
    freq_ctl: entity work.frequency_control port map(clk=>clock100mhz,
                                                    rst=>reset,
                                                    freq_in=>SW(2 downto 0),
                                                    freq_disp=>frequency,
                                                    pulseOut=>sample_gen_pulse);
-- phase accumulator
    phase_accu: entity work.phase_accumulator port map(clk=>clock100mhz,
                                                        rst=>reset,
                                                        pulse=>sample_gen_pulse,
                                                        phase_count=>phase);
--    sine LUT
    sine_lut_dds1 : sine_lut_dds port map(  aclk=>clock100mhz,
                                            s_axis_phase_tvalid=>'1',
                                            s_axis_phase_tdata =>phase,
                                            m_axis_data_tvalid=>sine_valid,
                                            m_axis_data_tdata=>sine_raw);
-- invert MSB
    inverted_sine_raw<=not sine_raw(15) & sine_raw(14 downto 0);

-- volumne shifter and output value to display
    vol_ctl: entity work.vol_level_shifter port map(sine_in=>inverted_sine_raw,
                                                    vol_in=>SW(5 downto 3),
                                                    sine_out=>sine_shifted,
                                                    vol_disp=>volume);

-- PWM generator
    pwm_gen: entity work.PWM_generator generic map(pwm_resolution=>pwm_resol) 
                                        port map(clk=>clock100mhz,
                                                rst=>reset,
                                                duty_cycle=>sine_shifted(15 downto (15-pwm_resol+1)) ,
                                                pwm_out=>pwm_out_to_audio);

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
-- audio pwm
    AUD_PWM<=pwm_out_to_audio;
    --assign led status
    LED <= SW(15 downto 0);

end Behavioral;
