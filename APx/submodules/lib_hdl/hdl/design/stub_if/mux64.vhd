--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief Muxer 64.
--! @author glein
--! @date 2018-05-17
--! @version v.1.0
--! @details
--! This module shifts a generic width input by a generic number of bits to a 
--! generic width output. 
--=============================================================================

--! Standard library
library ieee;
--! Standard types
use ieee.std_logic_1164.all;
--! Signed/unsigned calculations
use ieee.numeric_std.all;
--! Math real only for precompliled ports
use ieee.math_real.all;

--! User global package
use work.global_pkg.all;
--! User package
use work.mux64_pkg.all;


entity mux64 is
  generic (g_dout_width  : integer := 64;   --! Data out width
           g_shift_width : integer := 64);  --! Shift width
  port(clock_i      : in  std_logic;    --! Clock
       reset_i      : in  std_logic;    --! Reset
       din_arr_i    : in  t_stub_array;     --! Data in stub array
       din_valid_i  : in  std_logic;    --! Valid in
       din_ready_o  : out std_logic;    --! Ready out
       dout_o       : out std_logic_vector (g_dout_width-1 downto 0);  --! Data out
       dout_valid_o : out std_logic;    --! Valid out
       dout_ready_i : in  std_logic;    --! Ready in
       shift_cnt_o  : out std_logic_vector (integer(floor(sqrt(real(c_NUMBER_OF_STUBS*c_BITS_PER_STUB/g_dout_width)))) downto 0) );  --! Counter value times g_dout_width of current selected data in 
end mux64;


architecture RTL of mux64 is
  -- ########################### Signals ###########################
  signal sv_dout           : std_logic_vector (g_dout_width-1 downto 0);  --! Data out
  signal su_shift_cnt      : unsigned (integer(floor(sqrt(real(c_NUMBER_OF_STUBS*c_BITS_PER_STUB/g_dout_width)))) downto 0);  --! Shift counter
  signal sv_shift_cnt_o    : std_logic_vector (integer(floor(sqrt(real(c_NUMBER_OF_STUBS*c_BITS_PER_STUB/g_dout_width)))) downto 0);  --! Shift counter
  signal si_stub_cnt       : integer range 0 to c_NUMBER_OF_STUBS-1;  --! Stub counter with incremets >=1
  signal si_stub_remainder : integer range 1 to c_BITS_PER_STUB;  --! Remainder of stub starting at 1!


begin

  -- ########################### Port Map ###########################
  din_ready_o <= dout_ready_i;

  -- ########################### Processes ###########################
  --! @brief Process for shifting
  process(clock_i)
  begin
    if rising_edge(clock_i) then
      if(reset_i = '1') then
        su_shift_cnt      <= (others => '0');
        dout_o            <= (others => '0');
        si_stub_cnt       <= 0;
        si_stub_remainder <= 36;
      else
        if (din_valid_i = '1' and dout_ready_i = '1') then
          if to_integer(su_shift_cnt) >= (c_NUMBER_OF_STUBS*c_BITS_PER_STUB/g_dout_width
 +4) then -- Count = max --------------------------------------
 -- todo: investigate +4
            sv_dout <= (others => '0');          -- Default assigment
            if si_stub_cnt = c_NUMBER_OF_STUBS-1 then  -- Two concatenations
              sv_dout(c_AXI_BIT_WIDTH-1 downto c_AXI_BIT_WIDTH-si_stub_remainder) <= din_arr_i(si_stub_cnt)(si_stub_remainder-1 downto 0);  -- 1. part of vector
            else                        -- Three concatenations
              sv_dout(c_AXI_BIT_WIDTH-1 downto c_AXI_BIT_WIDTH-si_stub_remainder-c_BITS_PER_STUB) <= din_arr_i(si_stub_cnt)(si_stub_remainder-1 downto 0)  -- 1. part of vector
                         & din_arr_i(si_stub_cnt+1);  -- 2. part of vector
            end if;
            si_stub_cnt       <= 0;
            si_stub_remainder <= c_BITS_PER_STUB;
            su_shift_cnt      <= (others => '0');
          else -- Regular count +1 -------------------------------------------------------------------------------------------------------------------
            if si_stub_remainder >= c_AXI_BIT_WIDTH-c_BITS_PER_STUB then  -- Two concatenations
              sv_dout <= din_arr_i(si_stub_cnt)(si_stub_remainder-1 downto 0)  -- 1. part of vector
                         & din_arr_i(si_stub_cnt+1)(c_BITS_PER_STUB-1 downto c_BITS_PER_STUB+si_stub_remainder-c_AXI_BIT_WIDTH);  -- 2. part of vector
              if (c_BITS_PER_STUB+si_stub_remainder-c_AXI_BIT_WIDTH) = 0 then
                si_stub_remainder <= c_BITS_PER_STUB;
              else
                si_stub_remainder <= (c_BITS_PER_STUB+si_stub_remainder-c_AXI_BIT_WIDTH);
              end if;
              si_stub_cnt <= si_stub_cnt+1;
            else                        -- Three concatenations
              sv_dout <= din_arr_i(si_stub_cnt)(si_stub_remainder-1 downto 0)  -- 1. part of vector
                         & din_arr_i(si_stub_cnt+1)  -- 2. part of vector
                         & din_arr_i(si_stub_cnt+2)(c_BITS_PER_STUB-1 downto (c_BITS_PER_STUB*2+si_stub_remainder-c_AXI_BIT_WIDTH));  -- 3. part of vector
              if (c_BITS_PER_STUB+si_stub_remainder-c_AXI_BIT_WIDTH) = 0 then
                si_stub_remainder <= c_BITS_PER_STUB;
              else
                si_stub_remainder <= (c_BITS_PER_STUB*2+si_stub_remainder-c_AXI_BIT_WIDTH);
              end if;
              si_stub_cnt <= si_stub_cnt+2;
            end if;
            su_shift_cnt <= su_shift_cnt+1;
          end if;
          sv_shift_cnt_o <= std_logic_vector(su_shift_cnt);
          shift_cnt_o    <= sv_shift_cnt_o;
          dout_o         <= sv_dout;
          dout_valid_o   <= '1';
        else
          dout_valid_o <= '0';
        end if;
      end if;
    end if;
  end process;

end RTL;

