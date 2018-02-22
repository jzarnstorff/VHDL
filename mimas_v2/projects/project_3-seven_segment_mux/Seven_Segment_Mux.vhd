library ieee;
use ieee.std_logic_1164.all;

entity Seven_Segment_Mux is
    port(
        i_Clk : in std_logic;
        i_Binary_Num : in std_logic_vector(11 downto 0);
        o_Seven_Segment : out std_logic_vector(7 downto 0);
        o_Seven_Segment_Enable : out std_logic_vector(2 downto 0));
end Seven_Segment_Mux;


architecture RTL of Seven_Segment_Mux is

    -- Define Signals used as wires to other signals
    signal w_Clk_Div : std_logic := '0';
    signal w_Segment : std_logic_vector(6 downto 0);
    signal w_Digit   : std_logic_vector(3 downto 0);

    -- Define registers
    signal r_Enable  : std_logic_vector(2 downto 0) := B"110";

begin

    -- Scale down 100MHz clock frequency
    ClockDivider_Inst : entity work.Clock_Divider
    generic map( Q => 18 )
    port map (
        i_Clk => i_Clk,
        o_Clk_Div => w_Clk_Div);

    -- Shift enable bit with scaled down clock
    process (w_Clk_Div)
    begin
        if rising_edge(w_Clk_Div) then
            r_Enable <= r_Enable(1 downto 0) & r_Enable(2);
        end if;
    end process;

    -- Multiplex seven segment displays to display each digit
    process (w_Clk_Div)
    begin
        if rising_edge(w_Clk_Div) then
            case r_Enable is
                when B"110" => w_Digit <= i_Binary_Num(3 downto 0);
                when B"101" => w_Digit <= i_Binary_Num(7 downto 4);
                when B"011" => w_Digit <= i_Binary_Num(11 downto 8);
                when others => null;
            end case;
        end if;
    end process;

    SevenSeg_Inst : entity work.Binary_To_7Segment
    port map (
        i_Clk => i_Clk,
        i_Binary_Num => w_Digit,
        o_Segment => w_Segment);

    o_Seven_Segment(7 downto 1) <= not w_Segment;
    o_Seven_Segment(0 downto 0) <= "1"; --Not using decimal point
    o_Seven_Segment_Enable <= r_Enable;

end architecture RTL;
