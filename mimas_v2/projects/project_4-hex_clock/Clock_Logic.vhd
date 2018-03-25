library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock_Logic is
    generic ( g_Clk_Freq : positive);
    port (
        i_Clk : in std_logic;
        i_Btn_Min : in std_logic;
        i_Btn_Hrs : in std_logic;
        o_Seconds : out std_logic_vector(5 downto 0);
        o_Minutes : out std_logic_vector(7 downto 0);
        o_Hours : out std_logic_vector(3 downto 0));
end Clock_Logic;


architecture RTL of Clock_Logic is

    type t_Clock is record
        hours : integer range 0 to 12;
        minutes : integer range 0 to 60;
        seconds : integer range 0 to 60;
    end record t_Clock;
    
    signal s_Clock : t_Clock := (12, 0, 0);
    signal r_Count : integer := 1;
    signal w_Clk_1Hz : std_logic := '0';

begin

    p_1Hz_Clock : process(i_Clk)
    begin
        if rising_edge(i_Clk) then
            r_Count <= r_Count + 1;
            if (r_Count = g_Clk_Freq/2) then
                w_Clk_1Hz <= not w_Clk_1Hz;
                r_Count <= 1;
            end if;
        end if;
    end process p_1Hz_Clock;

    p_Real_Clock : process(w_Clk_1Hz, i_Btn_Min, i_Btn_Hrs)
    begin
        if rising_edge(w_Clk_1Hz) then
            s_Clock.seconds <= s_Clock.seconds + 1;
            if (s_Clock.seconds = 59 or i_Btn_Min = '0') then
                s_Clock.seconds <= 0;
                s_Clock.minutes <= s_Clock.minutes + 1;
                if (s_Clock.minutes >= 59) then
                    s_Clock.minutes <= 0;
                    s_Clock.hours <= s_Clock.hours + 1;
                    if (s_Clock.hours >= 12) then
                        s_Clock.hours <= 1;
                    end if;
                end if;
        elsif (i_Btn_Hrs = '0') then
            s_Clock.hours <= s_Clock.hours + 1;
            s_Clock.seconds <= 0;
                if (s_Clock.hours >= 12) then
                    s_Clock.hours <= 1;
                end if;
            end if;
        end if;
    end process p_Real_Clock;

    o_Seconds <= std_logic_vector(to_unsigned(s_Clock.seconds, o_Seconds'length));
    o_Minutes <= std_logic_vector(to_unsigned(s_Clock.minutes, o_Minutes'length));
    o_Hours <= std_logic_vector(to_unsigned(s_Clock.hours, o_Hours'length));

end architecture RTL;
