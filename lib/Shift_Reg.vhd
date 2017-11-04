library ieee;
use ieee.std_logic_1164.all;
 
entity shift_reg is
  port (
    i_Clk       : in  std_logic;
    i_Switch    : in  std_logic;
    o_Shift_Reg : out std_logic_vector(3 downto 0));
end entity shift_reg;
     
architecture Behavioral of shift_reg is

  signal r_Shift : std_logic_vector(3 downto 0);

begin

  p_Shift_Register : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      r_Shift(2 downto 0) <= r_Shift(3 downto 1);
      r_Shift(3) <= i_Switch;
    end if;
  end process p_Shift_Register;

  o_Shift_Reg <= r_Shift;

end architecture Behavioral;
