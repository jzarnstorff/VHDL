library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_RX is
  generic (
    g_CLKS_PER_BIT : integer);
  port (
    i_Clk           : in  std_logic;
    i_RX_Serial     : in  std_logic;
    o_RX_Data_Valid : out std_logic;
    o_RX_Byte       : out std_logic_vector(7 downto 0));
end UART_RX;

architecture RTL of UART_RX is

  type t_SM_Main is (s_Idle, s_RX_Start_Bit, s_RX_Data_Bits,
                     s_RX_Stop_Bit, s_Cleanup);

  signal r_SM_Main       : t_SM_Main := s_Idle;

  signal r_Clk_Count     : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal r_Bit_Index     : integer range 0 to 7 := 0;
  signal r_RX_Byte       : std_logic_vector(7 downto 0) := (others => '0');
  signal r_RX_Data_Valid : std_logic := '0';

begin

  -- Control RX state machine
  p_UART_RX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
    
      case r_SM_Main is
        
        when s_Idle =>
          r_RX_Data_Valid <= '0';
          r_Clk_Count     <= 0;
          r_Bit_Index     <= 0;

          if i_RX_Serial = '0' then  -- Start bit dectected
            r_SM_Main <= s_RX_Start_Bit;
          else
            r_SM_Main <= s_Idle;
          end if;

        -- Check middle of start bit to make sure it's still low
        when s_RX_Start_Bit =>
          if r_Clk_Count = (g_CLKS_PER_BIT-1)/2 then
            if i_RX_Serial = '0' then
              r_Clk_Count <= 0;  -- reset counter since we found the middle
              r_SM_Main   <= s_RX_Data_Bits;
            else
              r_SM_Main <= s_Idle;
            end if;
          else
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Start_Bit;
          end if;

        -- Wait g_CLKS_PER_BITS-1 clock cycles to sample serial data
        when s_RX_Data_Bits =>
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Data_Bits;
          else
            r_Clk_Count <= 0;
            r_RX_Byte(r_Bit_Index) <= i_RX_Serial;

            -- Check if we have received all data bits
            if r_Bit_Index < 7 then
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= s_RX_Data_Bits;
            else
              r_Bit_Index <= 0;
              r_SM_Main   <= s_RX_Stop_Bit;
            end if;
          end if;

        -- Recieve Stop bit. Stop bit = 1
        when s_RX_Stop_Bit =>
          -- Wait g_CLKS_PER_BITS-1 clock cycles for Stop bit to finish
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_RX_Stop_Bit;
          else
            r_RX_Data_Valid <= '1';
            r_Clk_Count     <= 0;
            r_SM_Main       <= s_Cleanup;
          end if;

        -- Stay here 1 clock
        when s_Cleanup =>
          r_SM_Main <= s_Idle;
          r_RX_Data_Valid <= '0';

        when others =>
          r_SM_Main <= s_Idle;

      end case;
    end if;
  end process p_UART_RX;

  o_RX_Data_Valid <= r_RX_Data_Valid;
  o_RX_Byte       <= r_RX_Byte;

end RTL;
