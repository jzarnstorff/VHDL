library ieee;
use ieee.std_logic_1164.all;

pntity clock is
  generic (
    g_Clock_Count : integer);
  port (
    i_Clk : in  std_logic;
    o_Clk : out std_logic);
end entity clock;

architecture RTL of clock is

  signal   s_Clock_Count : integer range 0 to g_Clock_Count := 0;
  signal   s_Clock_Slow  : std_logic := '0';

begin

  p_Clock : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      if (s_Clock_Count < g_Clock_Count) then
        s_Clock_Count <= s_Clock_Count + 1;
      else
        s_Clock_Count <= 0;
        s_Clock_Slow  <= not s_Clock_Slow;
      end if;
    end if;
  end process p_Clock;
  
  o_Clk <= s_Clock_Slow;

end architecture RTL;
