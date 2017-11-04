library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity Project_7_Segment_Top is
  generic (
    -- Input Clock is 25 MHz
    g_2HZ_COUNT : integer := 12500000);
  port (
    i_Clk : in std_logic;
    -- Segment1 is upper digit, Segment2 is lower digit
    o_Segment1, o_Segment2 : out std_logic_vector(6 downto 0));
end entity Project_7_Segment_Top;
     
architecture RTL of Project_7_Segment_Top is
     
  signal s_1Hz_Count  : integer range 0 to g_2HZ_COUNT := 0;
  signal r_Count      : std_logic_vector(7 downto 0)   := (others => '0');
  signal w_Segment1, w_Segment2 : std_logic_vector(6 downto 0);
  
begin
                         
  p_Count : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
      if (s_1Hz_Count < g_2HZ_COUNT) then
        s_1Hz_Count <= s_1Hz_Count + 1;
      else
        r_Count <= r_Count + '1';
        s_1Hz_Count <= 0;
      end if;
    end if;
  end process p_Count;
                                                                                       
  -- Instantiate Binary to 7-Segment Converter
  SevenSeg1_Inst : entity work.Binary_To_7Segment
    port map (
      i_Clk        => i_Clk,
      i_Binary_Num => r_Count(7 downto 4),
      o_Segment    => w_Segment1);
                                                                                               
    o_Segment1 <= not w_Segment1;
   
  SevenSeg2_Inst : entity work.Binary_To_7Segment
    port map (
      i_Clk        => i_Clk,
      i_Binary_Num => r_Count(3 downto 0),
      o_Segment    => w_Segment2);
                                                                                               
    o_Segment2 <= not w_Segment2;
   
end architecture RTL;
