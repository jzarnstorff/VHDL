library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity nBit_Counter is
    generic (
        N : integer);
    port (
        i_Clk : in  std_logic;
        i_Rst : in  std_logic;
        o_Q   : out std_logic_vector(N-1 downto 0));
end entity nBit_Counter;

architecture RTL of nBit_Counter is

    signal r_Count : std_logic_vector(N-1 downto 0) := (others => '0');

    p_Count : process (i_Clk, i_Rst)
    begin
        if i_Rst = '0' then
            r_Count <= (others => '0')
        elsif rising_edge(i_Clk) then
            r_Count <= r_Count + '1';
        end if;
    end process p_Count;

    o_Q <= r_Count;
            
end architecture RTL;
