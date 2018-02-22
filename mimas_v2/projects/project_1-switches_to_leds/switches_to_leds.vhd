library ieee;
use ieee.std_logic_1164.all;

entity Switches_To_LEDs is
  port (
    i_Switch : in  std_logic_vector(5 downto 0);
    o_LED    : out std_logic_vector(5 downto 0));
end entity Switches_To_LEDs;

architecture RTL of Switches_To_LEDs is
begin

  o_LED <= not i_Switch;

end architecture RTL;
