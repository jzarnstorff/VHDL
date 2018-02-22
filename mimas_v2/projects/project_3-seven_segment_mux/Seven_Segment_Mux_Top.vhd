library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Seven_Segment_Mux_Top is
    port(
        i_CLK_100MHz : in std_logic;
        o_Seven_Segment : out std_logic_vector(7 downto 0);
        o_Seven_Segment_Enable : out std_logic_vector(2 downto 0));
end Seven_Segment_Mux_Top;

architecture RTL of Seven_Segment_Mux_Top is

    constant c_1HZ_COUNT : integer := 100000000;
    signal r_Count : std_logic_vector(11 downto 0);
    signal r_Count_1Hz : integer range 0 to c_1HZ_COUNT := 0;

begin

    p_Count : process (i_CLK_100MHZ)
    begin
        if rising_edge(i_CLK_100MHZ) then
            if (r_Count_1Hz < c_1HZ_COUNT) then
                r_Count_1Hz <= r_Count_1Hz + 1;
            else
                r_Count <= r_Count + '1';
                r_Count_1Hz <= 0;
            end if;
        end if;
    end process p_Count;

    SevenSegMux_Inst : entity work.Seven_Segment_Mux
    port map(
        i_Clk => i_CLK_100MHz,
        i_Binary_Num => r_Count,
        o_Seven_Segment => o_Seven_Segment,
        o_Seven_Segment_Enable => o_Seven_Segment_Enable);

end architecture RTL;
