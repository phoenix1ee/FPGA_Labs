----------------------------------------------------------------------------------
-- Module Name: SPI_control - Behavioral
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SPI_control is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse_5Mhz : in STD_LOGIC;
           CLK_5Mhz: in STD_LOGIC;
           --port to/from Command Control
           start : in STD_LOGIC;
           command : in STD_LOGIC_VECTOR (23 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
           status_out: out STD_LOGIC_VECTOR (1 downto 0);
           
           --port to/from accelerometer chip
           SCLK : out STD_LOGIC;
           CS : out STD_LOGIC;
           MOSI : out STD_LOGIC;
           MISO : in STD_LOGIC);
end SPI_control;

architecture Behavioral of SPI_control is
    type SPI_states is (idle, ready_cs_low, send_instru, send_data, receive_data,output_data);
    signal curstate,next_state : SPI_states;
    signal instru_addr_bit : integer range 0 to 16:= 0;
    signal data_bit : integer range 0 to 8:= 0;
    --complete command for reference and checking
    signal command_internal : std_logic_vector(23 downto 0):=(others=>'0');
    --command for feeding MOSI
    signal command_buffer : std_logic_vector(23 downto 0):=(others=>'0');
    
    signal have_command:std_logic;

    --signal pulse_5Mhz:STD_LOGIC;
    --signal count_5Mhz: unsigned(4 downto 0);
    
    signal status_temp : std_logic_vector (1 downto 0);
    signal data_temp:std_logic_vector(7 downto 0):=(others=>'0');
    signal data_received:std_logic_vector(7 downto 0):=(others=>'0');
    
    --signal CLK_5Mhz: STD_LOGIC;
    signal SCLK1: STD_LOGIC;
    signal CS1 :  STD_LOGIC;
    signal MOSI1 :  STD_LOGIC;
    signal MISO1 :  STD_LOGIC;
    
begin
--    --count for generating 5mhz pulse
--    count_5Mhz<="10011";
--    --generate 5Mhz clock, 50% active load
--    clk5 : entity work.slow_clock_gen port map(clk=>clk,rst=>rst,max_count(26 downto 5)=>"0000000000000000000000",
--                                            max_count(4 downto 0)=>count_5Mhz,clk_out=>CLK_5Mhz);
--    --pulse gen of 5Mhz
--    pulse5 : entity work.pulse_gen port map(clk=>clk,rst=>rst,
--                                            max_count(26 downto 5)=>"0000000000000000000000",
--                                            max_count(4 downto 0)=>count_5Mhz,pulseOut=>pulse_5Mhz);

    --process for state transition
    state_logic: process(curstate,have_command,command_internal,instru_addr_bit,data_bit)
    begin
        next_state<= curstate;
        case curstate is 
        when idle=>
            if have_command='1' then
                next_state<= ready_cs_low;
            end if;
        when ready_cs_low=>
            next_state<= send_instru;
        when send_instru=>
            if instru_addr_bit=16 then
                if command_internal(23 downto 16) = x"0A" then
                    next_state<=send_data;
                else
                    next_state<=receive_data;
                end if;
            else
                next_state<=send_instru;
            end if;
        when send_data=>
            if data_bit=8 then
                next_state<= output_data;
            else
                next_state<=send_data;
            end if;
        when receive_data=>
            if data_bit=8 then
                next_state<= output_data;
            else
                next_state<=receive_data;
            end if;
        when output_data=>
            next_state<=idle;
        end case;
    end process state_logic;

    -- state update follow 5Mhz pulse
    state_logic_proc:process(clk, rst)
    begin
        if(rst = '1') then
            curstate<=idle;
        elsif (rising_edge(clk)) then
            if pulse_5Mhz ='1' then
                curstate <= next_state;
            end if;
        end if;
    end process state_logic_proc;
    
    --combinational to assign 5Mhz clock to SCLK1 depends on CS
    SCLK1<=CLK_5Mhz when CS1 = '0' else '0';

    -- communication with ADXL accelerometer, follow 5Mhz pulse
    spi_bus_logic: process(clk,rst)
    begin
        if(rst = '1') then
            CS1 <='1';
            instru_addr_bit<=0;
            data_bit<=0;
            command_buffer<=(others=>'0');
        elsif(rising_edge(clk)) then
            if pulse_5Mhz = '1' then
        
                case next_state is 
                when idle=>
                    CS1 <='1';
                    MOSI1<='0';
                    instru_addr_bit<=0;
                    data_bit<=0;
                    data_received<=(others=>'0');
                when ready_cs_low=>
                    --CS1 <='0';
                    command_buffer<=command_internal; 
                when send_instru=>
                    CS1 <='0';
                    MOSI1<=command_buffer(23);
                    command_buffer<=std_logic_vector(shift_left(unsigned(command_buffer),1));
                    instru_addr_bit<=instru_addr_bit+1;
                when send_data=>
                    MOSI1<=command_buffer(23);
                    command_buffer<=std_logic_vector(shift_left(unsigned(command_buffer),1));
                    data_bit<=data_bit+1;
                when receive_data=>
                    MOSI1<='0';
                    --if curstate=receive_data then
                        data_received(0)<=MISO1;
                        data_received(7 downto 1)<=data_received(6 downto 0);
                        data_bit<=data_bit+1;
                    --end if;
                when output_data=>
                    CS1 <='1';
                    MOSI1<='0';
                    instru_addr_bit<=0;
                    data_bit<=0;
                end case;
        
            end if;
        
        end if;
    end process spi_bus_logic;
    ---------------------------------------------------------------
    --output to command control process, follow 100mhz clock
    output_logic: process(clk, rst)
    begin
        if(rst = '1') then
            data_temp <= (others=>'0');
            status_temp<=(others=>'0');
            have_command<='0';
            command_internal<=(others=>'0');
        elsif(rising_edge(clk)) then
            if pulse_5Mhz = '1' then
        
                if start='1' then
                    if command(23 downto 16)=x"0A" or command(23 downto 16)=x"0B" then
                        have_command<='1';
                        command_internal<=command;
                    end if;
                end if;
                case next_state is 
                when output_data=>
                    status_temp<="10";
                    data_temp <= data_received;
                    have_command<='0';
                    command_internal<=(others=>'0');
                when idle=>
                    status_temp<="00";
                    data_temp <= (others=>'0');
                when others=>
                    status_temp<="01";
                    data_temp <= (others=>'0');
                end case;
            end if;
        end if;
    end process output_logic;
    
    data_out<=data_temp;
    status_out<=status_temp;
    SCLK <=SCLK1;
    CS <=CS1;
    MOSI <= MOSI1;
    MISO1<=MISO;
end Behavioral;
