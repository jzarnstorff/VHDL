library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Clock_Logic is
    generic ( g_Clk_Freq : positive);
    port (
        i_Clk : in std_logic;
        o_Seconds : out std_logic_vector(5 downto 0);
        o_Minutes : out std_logic_vector(7 downto 0);
        o_Hours   : out std_logic_vector(3 downto 0));
end Clock_Logic;


architecture RTL of Clock_Logic is

    signal hrs : integer range 0 to 12 := 1;
    signal sec, min : integer range 0 to 60 := 0;
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

    process(w_Clk_1Hz)
    begin
        if rising_edge(w_Clk_1Hz) then
            sec <= sec + 1;
            if (sec = 59) then
                sec <= 0;
                min <= min + 1;
            end if;
            if (min = 59) then
                min <= 0;
                hrs <= hrs + 1;
            end if;
            if (hrs > 12) then
                hrs <= 1;
            end if;
        end if;
    end process;

    o_Seconds <= std_logic_vector(to_unsigned(sec, o_Seconds'length));
    o_Minutes <= std_logic_vector(to_unsigned(min, o_Minutes'length));
    o_Hours <= std_logic_vector(to_unsigned(hrs, o_Hours'length));

end architecture RTL;
