--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief 96 b Track Finding (TF) word to 64 b MGT word conversion. 
--! @author glein
--! @date 2019-12-23
--! @version v.1.0
--! @details
--! Convert 96 b word to 1.5 * 64 b words.
--! Option 1 - FIFO as distributed memory:   448 LUTs, 424 FFs, 0 BRAMs, Latency = 7 clk1 cylcles + 2 clk2 cylcles
--! Option 2 - FIFO as BRAM (built-in FIFO): 128 LUTs, 206 FFs, 2 BRAMs, Latency = 8 clk1 cylcles + 2 clk2 cylcles
--! See the Track Finding (TF) word definition: https://twiki.cern.ch/twiki/bin/viewauth/CMS/HybridDataFormat
--=============================================================================

--! Standard library
library ieee;
--! Standard package
use ieee.std_logic_1164.all;
--! Signed/unsigned calculations
use ieee.numeric_std.all;
--! Math real only for precompliled ports
use ieee.math_real.all;

--! Xilinx library
library unisim;
Library xpm;
--! Xilinx package
use unisim.vcomponents.all;
use xpm.vcomponents.all;

--! User package


--! @brief Top entity with a FPGA-independent interface.
entity conv96bto64bFIFO is
  generic (
    USE_BRAM : boolean := false --! Use BRAM as FIFO instead of distributed memory (defaut distr. mem.)
    );
  port(
    clk1   : in  std_logic;  --! Clock 1
    rst1   : in  std_logic;  --! Reset 1
    clk2        : in  std_logic; --! Clock 2
    rst2_s      : out std_logic; --! OUT: Syncronized reset with clk2
    TF_96b : in  std_logic_vector(96-1 downto 0); --! 96 b TF word
    MGT_64b     : out std_logic_vector(64-1 downto 0); --! 64 b MGT word
    MGT_64b_vld : out std_logic; --! 64 b MGT word valid
    MGT_64b_rdy : in  std_logic; --! 64 b MGT word valid
    full        : out std_logic; --! FIFO full; Not synchronized with other outputs
    empty       : out std_logic; --! FIFO empty; Not synchronized with other outputs
    wr_rst_busy : out std_logic; --! Indicates that the write domain is in reset state; Only in impl. using built-in FIFO
    rd_rst_busy : out std_logic ); --! Indicates that the read domain is in reset state; Only in impl. using built-in FIFO
end entity conv96bto64bFIFO;

--! @brief Converter
architecture struct of conv96bto64bFIFO is
  -- ########################### Types ###########################

  -- ########################### Constant Definitions ###########################

  -- ########################### Signal ###########################
  signal sv_TF_96b_d0   : std_logic_vector(96-1 downto 0); --! 96 b TF word
  signal sl_rd_en_d0    : std_logic; --! Read enable
  signal sl_rd_en_d1    : std_logic; --! Read enable delayed
  signal sl_empty_d0    : std_logic; --! Empty
  signal sl_empty_d1    : std_logic; --! Empty delayed
  signal sl_empty_d2    : std_logic; --! Empty delayed
  signal sl_valid_d0    : std_logic; --! Valid
  signal sl_valid_d1    : std_logic; --! Valid delayed
  signal sl_rst2_s      : std_logic; --! Reset
  signal sv_cnt         : std_logic_vector(1 downto 0) := (others => '0'); --! Counter
  signal sv_cnt_tmp     : std_logic_vector(1 downto 0) := (others => '0'); --! Counter temp.
  signal sv_MGT_64b     : std_logic_vector(64-1 downto 0); --! 64 b MGT word
  signal sv_MGT_64b_tmp : std_logic_vector(64-1 downto 0); --! Temp. 64 b MGT word
  signal sl_MGT_64b_vld : std_logic; --! Valid
  
begin
  -- ########################### Assertion ###########################

  -- ########################### Instantiation ###########################
  gen_USE_DISTR_MEM : if (USE_BRAM=false) generate -- Option 1 (default)
    i_fifo_dist_96bx117 : entity work.fifo_dist_96bx117 -- 117 x 96 b tracks (25 Gbps / 96 b * 450 ns)
    port map (
      rst    => rst1,
      wr_clk => clk1,
      rd_clk   => clk2,
      din    => TF_96b,
      wr_en  => TF_96b(95), -- Valid
      rd_en    => sl_rd_en_d0,
      dout     => sv_TF_96b_d0,
      full     => full,
      empty    => sl_empty_d0,
      valid    => sl_valid_d0   );--,
  end generate;
  gen_USE_BRAM : if USE_BRAM generate -- Option 2
    i_fifo_builtin_96bx512 : entity work.fifo_builtin_96bx512 -- 512 is min depth of built-in FIFO
    port map (
      srst   => rst1,
      wr_clk => clk1,
      rd_clk   => clk2,
      din    => TF_96b,
      wr_en  => TF_96b(95), -- Valid
      rd_en    => sl_rd_en_d0,
      dout     => sv_TF_96b_d0,
      full     => full,
      empty    => sl_empty_d0,
      valid    => sl_valid_d0,
      wr_rst_busy => wr_rst_busy,
      rd_rst_busy => rd_rst_busy  );
  end generate;

  i_xpm_cdc_async_rst : xpm_cdc_async_rst generic map ( -- Clock Domain Crossing (CDC) for reset
  DEST_SYNC_FF => 2, -- DECIMAL; range: 2-10
  INIT_SYNC_FF => 1, -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
  RST_ACTIVE_HIGH => 1 ) -- DECIMAL; 0=active low reset, 1=active high reset
  port map (
  dest_arst => sl_rst2_s, -- 1-bit output: src_arst asynchronous reset signal synchronized to destination clock domain. This output is registered. NOTE: Signal asserts asynchronously
                          -- but deasserts synchronously to dest_clk. Width of the reset signal is at least (DEST_SYNC_FF*dest_clk) period.
  dest_clk => clk2,   -- 1-bit input: Destination clock.
  src_arst => rst1 ); -- 1-bit input: Source asynchronous reset signal.

  -- ########################### Port Map ##########################
  empty  <= sl_empty_d0;
  rst2_s <= sl_rst2_s;
  
  -- ########################### Processes ###########################
  --! @brief Converter
  p_conv : process(clk2)
  variable vu_cnt : unsigned(1 downto 0) := (others => '0'); --! 64 b word counter
  begin
    if rising_edge(clk2) then
      if sl_rst2_s = '1' then -- synchronous reset (high active)
        vu_cnt := (others => '0');
        sv_cnt <= (others => '0');
        sv_MGT_64b_tmp <= (others => '0');
        MGT_64b_vld    <= '0';
        sl_MGT_64b_vld <= '0';
        sl_rd_en_d0    <= '0';
        sl_rd_en_d1    <= '0';
        sl_valid_d1    <= '0';
        sl_empty_d1    <= '0';
        sl_empty_d2    <= '0';
      else -- Counter
        if ((sl_valid_d0='1' or sl_valid_d1='1') and MGT_64b_rdy='1' and sl_empty_d2='0') then
          if vu_cnt >= 2 then
            vu_cnt := (others => '0');
          else
            vu_cnt := vu_cnt + 1;
          end if;
          sv_cnt   <= std_logic_vector(vu_cnt);
        end if;
        -- Registers
        sl_rd_en_d1       <= sl_rd_en_d0;
        MGT_64b     <= sv_MGT_64b;
        if (MGT_64b_rdy='1' and (sv_cnt=sv_cnt_tmp)) then
          MGT_64b_vld <= '0';
        else
          MGT_64b_vld <= sl_MGT_64b_vld;
        end if;
        sv_cnt_tmp  <= sv_cnt;
        sl_valid_d1 <= sl_valid_d0;
        sl_empty_d1 <= sl_empty_d0;
        sl_empty_d2 <= sl_empty_d1;
      end if;
      -- Read enable and control 
      sl_rd_en_d0  <= '0'; -- Default assigment
      if (MGT_64b_rdy='1' and sl_empty_d0='0') then
        if (sl_rd_en_d0='0' or sl_rd_en_d1='0') then -- Only read 2 out of 3
          sl_rd_en_d0 <= '1';
        end if;
      end if;
      -- Convert 96 b to 64 b
      --MGT_64b_vld <= '0'; -- Default assigment
      if ((sl_valid_d0='1' or sl_valid_d1='1') and MGT_64b_rdy='1' and sl_empty_d2='0') then
        case (sv_cnt) is
          when "00" =>
            sv_MGT_64b  <= sv_TF_96b_d0(63 downto 0);
            sl_MGT_64b_vld <= '1';
            sv_MGT_64b_tmp(31 downto 0) <= sv_TF_96b_d0(95 downto 64);
          when "01" =>
            sv_MGT_64b     <= sv_TF_96b_d0(31 downto 0) & sv_MGT_64b_tmp(31 downto 0);
            sl_MGT_64b_vld    <= '1';
            sv_MGT_64b_tmp <= sv_TF_96b_d0(95 downto 32);
          when "10" =>
            sv_MGT_64b  <= sv_MGT_64b_tmp(63 downto 0);
            sl_MGT_64b_vld <= '1';
          when others =>
            sv_MGT_64b_tmp  <= (others => '0');
        end case;
      end if;
    end if;
  end process p_conv;

end struct;
