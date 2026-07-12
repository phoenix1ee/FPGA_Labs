library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;
use IEEE.NUMERIC_STD.ALL;

entity command_control is
    Port (clk: in std_logic;
          rst: in std_logic;
          pulse: in std_logic;
          -- 00 idle 01 busy 10 done
          -- from 
          SPI_status: in std_logic_vector(1 downto 0);
          SPI_data: in std_logic_vector(7 downto 0);
          SPI_start: out std_logic;
          command: out std_logic_vector(23 downto 0);
          r_AD: out std_logic_vector(7 downto 0);
          r_1D: out std_logic_vector(7 downto 0);
          r_X: out std_logic_vector(7 downto 0);
          r_Y: out std_logic_vector(7 downto 0);
          r_Z: out std_logic_vector(7 downto 0));
end command_control;

architecture Behavioral of command_control is
    type SM_states is (idle, wait_wake, ready, wait_read);
    signal curstate,next_state : SM_states;
    constant idle_c: std_logic_vector(23 downto 0):=x"000000";
    signal wake_c: std_logic_vector(23 downto 0):=x"0A2D02";
    type read_command is array(4 downto 0) of std_logic_vector(23 downto 0);
    signal read_c: read_command;
    signal item : integer range 0 to 4:= 0;
    --signal next_item: integer range 0 to 4:= 0;
    signal command_out:std_logic_vector(23 downto 0):=x"000000";
    signal rAD: std_logic_vector(7 downto 0):=(others=>'0');
    signal r1D: std_logic_vector(7 downto 0):=(others=>'0');
    signal rX: std_logic_vector(7 downto 0):=(others=>'0');
    signal rY: std_logic_vector(7 downto 0):=(others=>'0');
    signal rZ: std_logic_vector(7 downto 0):=(others=>'0');
    
begin
    read_c(0)<=x"0B0000"; --AD
    read_c(1)<=x"0B0100"; --1D
    read_c(2)<=x"0B0800"; --X
    read_c(3)<=x"0B0900"; --Y
    read_c(4)<=x"0B0A00"; --Y
    
    --state_logic: process(curstate, SPI_status, enable_internal)
    state_logic: process(curstate, SPI_status)
    
    begin
        next_state<= curstate;
        case curstate is 
        when idle=>
            --if enable_internal='1' then
                if SPI_status="00" then
                    next_state<= wait_wake;
                end if;
            --end if;
        when wait_wake=>
            if SPI_status="01" then
                next_state<= wait_wake;
            elsif SPI_status="10" then
                next_state<= ready;
            end if;
        when ready=>
            if SPI_status="00" then
                next_state<= wait_read;
            end if;
        when wait_read=>
            if SPI_status="01" then
                next_state<= wait_read;
            elsif SPI_status="10" then
                next_state<= ready;
            end if;
        end case;
    end process state_logic;

    output_logic: process(clk, rst)
    begin
        if(rst = '1') then
            SPI_start <= '0';
            command_out <= idle_c;
            item <= 0;
            rAD<=(others=>'0');
            r1D<=(others=>'0');
            rX<=(others=>'0');
            rY<=(others=>'0');
            rZ<=(others=>'0');
            --next_item <= 0;
        elsif(rising_edge(clk)) then
            if pulse='1' then
                SPI_start <= '0';
                command_out <= idle_c;
                
                case next_state is 
                when wait_wake=>
                    if curstate = idle then
                        command_out<=wake_c;
                        SPI_start<='1';
                    end if;
                when ready=>
                    --output data
                    if curstate = wait_read then
                        case item is
                        when 0=>
                                rAD<=SPI_data;
                        when 1=>
                                r1D<=SPI_data;
                        when 2=>
                                rX<=SPI_data;
                        when 3=>
                                rY<=SPI_data;
                        when 4=>
                                rZ<=SPI_data;
                        end case;
                        if item = 4 then
                            item<=0;
                        else
                            item<=item+1;
                        end if;
                     end if;
                when wait_read=>
                    --feed the next command
                    if curstate = ready then
                        command_out<=read_c(item);
                        SPI_start<='1';
                    end if;
                when others=>
                    
                end case;
            end if;
        end if;
    end process output_logic;

    process(clk, rst)
    begin
        if(rst = '1') then
            curstate<= idle;
            --enable_internal<='0';
        elsif(rising_edge(clk)) then
            if pulse='1' then
                curstate <= next_state;
            end if;
        end if;
    end process;
    
    command<=command_out;
    r_AD<=rAD;
    r_1D<=r1D;
    r_X<=rX;
    r_Y<=rY;
    r_Z<=rZ;
end Behavioral;
