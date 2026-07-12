----------------------------------------------------------------------------------
-- Engineer: S Lee
-- 
-- Create Date: 07/02/2026
-- Design Name: 
-- Module Name: accel_spi_rw - Behavioral
-- Project Name: lab5
-- this is the entity of the SPI interface to the board accelerometer

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;


entity accel_spi_rw is 
     Port ( clk : in STD_LOGIC; 
          reset : in STD_LOGIC; 
          --Register Values from accelerometer
          DATA_X : out STD_LOGIC_VECTOR(7 downto 0); 
          DATA_Y : out STD_LOGIC_VECTOR(7 downto 0); 
          DATA_Z : out STD_LOGIC_VECTOR(7 downto 0); 
          ID_AD : out STD_LOGIC_VECTOR(7 downto 0); 
          ID_1D : out STD_LOGIC_VECTOR(7 downto 0); 
          --SPI Signals between FPGA and accelerometer 
          CSb : out STD_LOGIC; 
          MOSI : out STD_LOGIC; 
          SCLK : out STD_LOGIC; 
          MISO : in STD_LOGIC); 
end accel_spi_rw;

architecture Behavioral of accel_spi_rw is
    signal command:std_logic_vector(23 downto 0);
    signal SPI_status1:std_logic_vector(1 downto 0);
    signal SPI_start1:std_logic;
    signal SPI_data1:std_logic_vector(7 downto 0);
    --signal pulse_5Mhz:STD_LOGIC;
    signal count_5Mhz: unsigned(4 downto 0);
    signal pulse_5Mhz:STD_LOGIC;
    signal CLK_5Mhz: STD_LOGIC;
begin

    --count for generating 5mhz pulse
    count_5Mhz<="10011";
    --generate 5Mhz clock, 50% active load
    clk5 : entity work.slow_clock_gen port map(clk=>clk,rst=>reset,max_count(26 downto 5)=>"0000000000000000000000",
                                            max_count(4 downto 0)=>count_5Mhz,clk_out=>CLK_5Mhz);
    --pulse gen of 5Mhz
    pulse5 : entity work.pulse_gen2 port map(clk=>clk,rst=>reset,
                                            max_count(26 downto 5)=>"0000000000000000000000",
                                            max_count(4 downto 0)=>count_5Mhz,pulseOut=>pulse_5Mhz);

    command_ctl: entity work.command_control port map(clk=>clk,rst=>reset,pulse=>pulse_5Mhz,
                                        SPI_status=>SPI_status1,SPI_data=>SPI_data1,SPI_start=>SPI_start1,
                                        command=>command,r_AD=>ID_AD,r_1D=>ID_1D,r_X=>DATA_X,r_Y=>DATA_Y,r_Z=>DATA_Z);

    spi_ctl: entity work.SPI_control port map(clk=>clk,rst=>reset,pulse_5Mhz=>pulse_5Mhz,CLK_5Mhz=>CLK_5Mhz,
               --port to/from Command Control
               start=>SPI_start1,
               command=>command,
               data_out=>SPI_data1,
               status_out=>SPI_status1,
               --port to and from acceleromter
               SCLK=>SCLK,
               CS=>CSb,
               MOSI=>MOSI,
               MISO=>MISO);

end Behavioral;