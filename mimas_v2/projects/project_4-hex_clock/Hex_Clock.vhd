library ieee;
use ieee.std_logic_1164.all;

entity Hex_Clock is
    port (
        i_CLK_100MHz : in std_logic;
        o_LED : out std_logic_vector(5 downto 0);
        o_Seven_Segment : out std_logic_vector(7 downto 0);
        o_Seven_Segment_Enable : out std_logic_vector(2 downto 0));
end Hex_Clock;

architecture RTL of Hex_Clock is

    signal w_Hours : std_logic_vector(3 downto 0);
    signal w_Minutes : std_logic_vector(7 downto 0);
    signal w_Seconds : std_logic_vector(5 downto 0);

begin

    Clock_Inst : entity work.Clock_Logic
    generic map( g_Clk_Freq => 100000000 )
    port map(
        i_Clk => i_CLK_100MHz,
        o_Seconds => w_Seconds,
        o_Minutes => w_Minutes,
        o_Hours => w_Hours);

    SevenSegMux_Inst : entity work.Seven_Segment_Mux
    port map(
        i_Clk => i_CLK_100MHz,
        i_Binary_Num => w_Hours & w_Minutes,
        o_Seven_Segment => o_Seven_Segment,
        o_Seven_Segment_Enable => o_Seven_Segment_Enable);

    o_LED <= w_Seconds;

end architecture RTL;
