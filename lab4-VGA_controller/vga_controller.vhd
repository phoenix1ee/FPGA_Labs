----------------------------------------------------------------------------------
-- Company: 
-- Engineer: S Lee
-- 
-- Create Date: 06/24/2026
-- Design Name: 
-- Module Name: vga_controller - Behavioral
-- Project Name: lab4

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

-- this is the entity of the vga_controller

entity vga_controller is
    Port ( clk : in std_logic;
           rst : in std_logic;
           width_in: in unsigned (10 downto 0);
           height_in: in unsigned (10 downto 0);
           pulse_25Mhz_in: in std_logic;
           rgb_in: in std_logic_vector (11 downto 0);
           
           h_sync_out : out std_logic;
           v_sync_out : out std_logic;
           red_out: out std_logic_vector(3 downto 0);
           green_out: out std_logic_vector(3 downto 0);
           blue_out: out std_logic_vector(3 downto 0);
           h_count: out unsigned (10 downto 0);
           v_count: out unsigned (10 downto 0));
           
end vga_controller;

architecture Behavioral of vga_controller is
    signal rgb_h : std_logic;
    signal rgb_v : std_logic;
    signal rgb_enable: std_logic;
    signal h_to_v: std_logic;
begin
    --horizontal sync entity
    h_sync_en : entity work.h_sync_controller port map(clock=>clk,reset=>rst,width=>width_in,pulse_25Mhz=>pulse_25Mhz_in,
                                                        h_sync=>h_sync_out,rgb=>rgb_h,h_count=>h_count,pulse_to_v=>h_to_v);
    --vertical sync entity
    v_sync_en : entity work.v_sync_controller port map(clock=>clk,reset=>rst,height=>height_in,pulse=>h_to_v,
                                                        v_sync=>v_sync_out,v_count=>v_count,rgb=>rgb_v);
    rgb_enable<=rgb_h and rgb_v;
    --rgb signal control entity
    disp_enble_c: entity work.disp_enable_controller port map(clock=>clk,reset=>rst,sel=>rgb_enable, pulse_25Mhz=>pulse_25Mhz_in,rgb=>rgb_in,red=>red_out,green=>green_out,blue=>blue_out);
    
end Behavioral;
