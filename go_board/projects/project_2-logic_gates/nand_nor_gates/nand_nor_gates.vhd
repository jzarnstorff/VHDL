library ieee;
use ieee.std_logic_1164.all;

entity Nand_Nor_Gates is
  port (
    i_Switch : in  std_logic_vector(3 downto 0);
    o_LED    : out std_logic_vector(1 downto 0));
end entity Nand_Nor_Gates;

architecture Behavioral of Nand_Nor_Gates is
begin

  o_LED(0) <= i_Switch(0) nand i_Switch(1);
  o_LED(1) <= i_Switch(2) nor i_Switch(3);

end architecture Behavioral;
