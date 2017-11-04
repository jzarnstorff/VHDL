library ieee;
use ieee.std_logic_1164.all;

entity And_Or_Gates is
  port(
    i_Switch : in  std_logic_vector(3 downto 0);
    o_LED    : out std_logic_vector(1 downto 0));
end entity And_Or_Gates;

architecture Behavioral of And_Or_Gates is
begin

  o_LED(0) <= i_Switch(0) and i_Switch(1);
  o_LED(1) <= i_Switch(2) or i_Switch(3);

end architecture Behavioral;
