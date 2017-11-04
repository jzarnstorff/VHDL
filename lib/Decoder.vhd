library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Decoder is
  port (
    i_Switch : in  std_logic_vector(1 downto 0);
    o_LED    : out std_logic_vector(3 downto 0));
end entity Decoder;
     
architecture Behavioral of Decoder is

begin
  p_Decoder : process (i_Switch)

  variable input : integer;

  begin
    input := conv_integer(i_Switch);
    for i in 0 to 3 loop
      if(i = input) then
        o_LED(i) <= '1';
      else
        o_LED(i) <= '0';
      end if;
    end loop;
  end process p_Decoder;
end architecture Behavioral;
