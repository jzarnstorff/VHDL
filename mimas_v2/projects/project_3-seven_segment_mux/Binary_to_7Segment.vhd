library ieee;
use ieee.std_logic_1164.all;
 
entity Binary_To_7Segment is
  port (
    i_Clk        : in  std_logic;
    i_Binary_Num : in  std_logic_vector(3 downto 0);
    o_Segment    : out std_logic_vector(6 downto 0));
end entity Binary_To_7Segment;
   
architecture RTL of Binary_To_7Segment is
   
  signal r_Hex_Encoding : std_logic_vector(7 downto 0) := (others => '0');
       
begin
     
  -- Purpose: Creates a case statement for all possible input binary numbers.
  -- Drives r_Hex_Encoding appropriately for each input combination.
  process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      case i_Binary_Num is
        when X"0" => r_Hex_Encoding <= X"7E";
        when X"1" => r_Hex_Encoding <= X"30";
        when X"2" => r_Hex_Encoding <= X"6D";
        when X"3" => r_Hex_Encoding <= X"79";
        when X"4" => r_Hex_Encoding <= X"33";          
        when X"5" => r_Hex_Encoding <= X"5B";
        when X"6" => r_Hex_Encoding <= X"5F";
        when X"7" => r_Hex_Encoding <= X"70";
        when X"8" => r_Hex_Encoding <= X"7F";
        when X"9" => r_Hex_Encoding <= X"7B";
        when X"A" => r_Hex_Encoding <= X"77";
        when X"B" => r_Hex_Encoding <= X"1F";
        when X"C" => r_Hex_Encoding <= X"4E";
        when X"D" => r_Hex_Encoding <= X"3D";
        when X"E" => r_Hex_Encoding <= X"4F";
        when others => r_Hex_Encoding <= X"47";
      end case;
    end if;
  end process;
      
  -- r_Hex_Encoding(7) is unused
  o_Segment <= r_Hex_Encoding(6 downto 0);
  
end architecture RTL;
