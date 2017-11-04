library ieee;
use ieee.std_logic_1164.all;

entity UART_Top is
  generic (
    g_BAUD_RATE : integer := 217);  -- Clock/Desired_Baud_Rate (25,000,000 / 115,200 = 217)
  port (
    -- Main Clock (25 MHz)
    i_Clk : in std_logic;

    -- UART Data
    i_UART_RX : in  std_logic;
    o_UART_TX : out std_logic;

    -- Segment1 is upper digit, Segment2 is lower digit
    o_Segment1, o_Segment2 : out std_logic_vector(6 downto 0));
end entity UART_Top;

architecture RTL of UART_Top is

  signal w_RX_Data_Valid        : std_logic;
  signal w_RX_Byte              : std_logic_vector(7 downto 0);
  signal w_TX_Active            : std_logic;
  signal w_TX_Serial            : std_logic;
  signal w_Segment1, w_Segment2 : std_logic_vector(6 downto 0);

begin

  UART_RX_Inst : entity work.UART_RX
    generic map (
      g_CLKS_PER_BIT  => g_BAUD_RATE)
    port map (
      i_Clk           => i_Clk,
      i_RX_Serial     => i_UART_RX,
      o_RX_Data_Valid => w_RX_Data_Valid,
      o_RX_Byte       => w_RX_Byte);

  UART_TX_Inst : entity work.UART_TX
    generic map (
      g_CLKS_PER_BIT  => g_BAUD_RATE)
    port map (
      i_Clk           => i_Clk,
      i_TX_Data_Valid => w_RX_Data_Valid,
      i_TX_Byte       => w_RX_Byte,
      o_TX_Active     => w_TX_Active,
      o_TX_Serial     => w_TX_Serial,
      o_TX_Done       => open);

  -- Drive UART line high when transmitter is not active
  o_UART_TX <= w_TX_Serial when w_TX_Active = '1' else '1';

  -- Binary to 7-Segment Converter for Upper Digit
  SevenSeg1_Inst : entity work.Binary_To_7Segment
    port map (
      i_Clk        => i_Clk,
      i_Binary_Num => w_RX_Byte(7 downto 4),
      o_Segment    => w_Segment1);
                                                                                               
    o_Segment1 <= not w_Segment1;

  -- Binary to 7-Segment Converter for Lower Digit
  SevenSeg2_Inst : entity work.Binary_To_7Segment
    port map (
      i_Clk        => i_Clk,
      i_Binary_Num => w_RX_Byte(3 downto 0),
      o_Segment    => w_Segment2);
                                                                                               
    o_Segment2 <= not w_Segment2;

end architecture RTL;
