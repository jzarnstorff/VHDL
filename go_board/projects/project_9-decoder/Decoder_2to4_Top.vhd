library ieee;
use ieee.std_logic_1164.all;

entity Decoder_Top is
  port (
    i_Clk    : in std_logic;
    i_Switch : in std_logic_vector(3 downto 0);
    o_LED    : out std_logic_vector(3 downto 0));
end entity Decoder_Top;

architecture RTL of Decoder_Top is

  signal w_Switch : std_logic_vector(1 downto 0);
  signal w_LED    : std_logic_vector(3 downto 0);

begin

  Debounce_Switch1 : entity work.Debounce_Switch
  port map (
    i_Clk => i_Clk,
    i_Switch => i_Switch(0),
    o_Switch => w_Switch(0));

  Debounce_Switch2 : entity work.Debounce_Switch
  port map (
    i_Clk => i_Clk,
    i_Switch => i_Switch(1),
    o_Switch => w_Switch(1));

  Decode : entity work.Decoder
  port map (
    i_Switch => w_Switch,
    o_LED => w_LED);

  o_LED <= w_LED;

end architecture RTL;
