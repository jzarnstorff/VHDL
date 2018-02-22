library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity Binary_LED is
  port (
    i_CLK_100MHZ : in  std_logic;
    o_LED        : out std_logic_vector(7 downto 0));
end Binary_LED;


architecture RTL of Binary_LED is

    constant c_1HZ_COUNT : integer := 100000000;

    signal r_Count_1Hz : integer range 0 to c_1HZ_COUNT := 0;
    signal r_LED : std_logic_vector(7 downto 0) := (others => '0');

begin

    p_Count : process (i_CLK_100MHZ)
    begin
        if rising_edge(i_CLK_100MHZ) then
            if (r_Count_1Hz < c_1HZ_COUNT) then
                r_Count_1Hz <= r_Count_1Hz + 1;
            else
                r_LED <= r_LED + '1';
                r_Count_1Hz <= 0;
            end if;
        end if;
    end process p_Count;

    o_LED <= r_LED;

end RTL;
