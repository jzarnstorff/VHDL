library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Clock_Divider is
    generic( Q : integer);
    port(
        i_Clk : in std_logic;
        o_Clk_Div : out std_logic);
end Clock_Divider;


architecture Behavioral of Clock_Divider is

    signal r_Count : std_logic_vector(Q downto 0) := (others => '0');

begin

    process (i_Clk)
    begin
        if rising_edge(i_Clk) then
            r_Count <= r_Count + '1';
        end if;
    end process;

    o_Clk_Div <= r_Count(Q);

end architecture Behavioral;
