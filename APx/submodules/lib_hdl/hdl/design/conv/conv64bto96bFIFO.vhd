--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief 64 b MGT word to 96 b Track Finding (TF) word conversion. 
--! @author glein
--! @date 2019-10-18
--! @version v.1.0
--! @details
--! Convert 1.5 * 64 b words to a 96 b word.
--! ~172 LUTs, ~523 FFs, Latency 9 clk2 cylcles
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
use work.AxiStreamPkg.all; --! From surf/axi/axi-stream submodule

--! @brief Top entity with a FPGA-independent interface.
entity conv64bto96bFIFO is
  generic (
    GEN_TKEEP : boolean := false --! Generate/assign the tKeep in the AXI stream (defaut off)
    );
  port(
    clk1            : in  std_logic;  --! Clock 1
    rst1            : in  std_logic;  --! Reset 1
    clk2             : in  std_logic; --! Clock 2
    rst2_s           : out std_logic; --! OUT: Syncronized reset with clk2
    axiStreamIn_64b : in AxiStreamMasterType; --! 64 b MGT word
    full            : out std_logic;          --! FIFO full
    axiStreamOut_96b : out AxiStreamMasterType; --! 96 b TF word
    rd_en            : in  std_logic;           --! Read enable
    empty            : out std_logic );         --! FIFO empty
end entity conv64bto96bFIFO;

--! @brief Converter
architecture struct of conv64bto96bFIFO is
  -- ########################### Input description ###########################
    --type AxiStreamMasterType is record
    --   tValid : sl;                                           -- Qualifies the entire payload word as valid
    --   tData  : slv(AXI_STREAM_MAX_TDATA_WIDTH_C-1 downto 0); -- 64 b out of 512 b used: Payload
    --   tStrb  : slv(AXI_STREAM_MAX_TKEEP_WIDTH_C-1 downto 0); -- not used
    --   tKeep  : slv(AXI_STREAM_MAX_TKEEP_WIDTH_C-1 downto 0); -- 8 b out of 64 b used: Qualifies individual payload bytes with valid flag
    --   tLast  : sl;                                           -- Signals end of frame
    --   tDest  : slv(7 downto 0);                              -- not used
    --   tId    : slv(7 downto 0);                              -- not used
    --   tUser  : slv(AXI_STREAM_MAX_TDATA_WIDTH_C-1 downto 0); -- 8 b out of 512 b used:
        -- tUser(0): SOF Signals start of frame
        -- tUser(1): FFO Signals first frame of orbit
        -- tUser(2): CHKSM_ERR Frame checksum error
        -- tUser(3): LINK_LOCK 64b66b link lock
        -- tUser(4): FFO_LOCK First Frame of Orbit lock
        -- tUser(7:5): RSV_FLAGS Reserved for additional flags
  --end record AxiStreamMasterType;                             -- = 82 b @ clk1

  -- ########################### Output description ###########################
    --type AxiStreamMasterType is record
    --   tValid : sl;                                           -- Qualifies the entire payload word as valid
    --   tData  : slv(AXI_STREAM_MAX_TDATA_WIDTH_C-1 downto 0); -- 96 b out of 512 b used: Payload
    --   tStrb  : slv(AXI_STREAM_MAX_TKEEP_WIDTH_C-1 downto 0); -- not used
    --   tKeep  : slv(AXI_STREAM_MAX_TKEEP_WIDTH_C-1 downto 0); -- 12 b out of 64 b used: Qualifies individual payload bytes with valid flag
    --   tLast  : sl;                                           -- Signals end of frame
    --   tDest  : slv(7 downto 0);                              -- not used
    --   tId    : slv(7 downto 0);                              -- not used
    --   tUser  : slv(AXI_STREAM_MAX_TDATA_WIDTH_C-1 downto 0); -- 8 b out of 512 b used:
        -- tUser(0): SOF Signals start of frame
        -- tUser(1): FFO Signals first frame of orbit
        -- tUser(2): CHKSM_ERR Frame checksum error
        -- tUser(3): LINK_LOCK 64b66b link lock
        -- tUser(4): FFO_LOCK First Frame of Orbit lock
        -- tUser(7:5): RSV_FLAGS Reserved for additional flags
  --end record AxiStreamMasterType;                             -- = 118 b @ clk2

  -- ########################### Types ###########################

  -- ########################### Constant Definitions ###########################
  constant c_comb_word_width : integer   := 118;  --! Width

  -- ########################### Signal ###########################
  signal sv_64bword_c         : std_logic_vector(1 downto 0) := (others => '0'); --! 64 b word counter
  signal sr_axiStream_96b     : AxiStreamMasterType; --! Temp 96 b
  signal sr_axiStreamOut_96b  : AxiStreamMasterType; --! Temp 96 b
  signal sv_Out_word_clk1     : std_logic_vector(c_comb_word_width-1 downto 0) := (others => '0'); --! slv for CDC
  signal sv_Out_word_clk2     : std_logic_vector(c_comb_word_width-1 downto 0) := (others => '0'); --! slv for CDC

begin
  -- ########################### Assertion ###########################

  -- ########################### Instantiation ###########################
  i_fifo_dist_118bx16 : entity work.fifo_dist_118bx16 -- FIFO as distributed RAM (LUT)
  port map (
    rst    => rst1,
    wr_clk => clk1,
    rd_clk => clk2,
    din    => sv_Out_word_clk1,
    wr_en  => sv_Out_word_clk1(0), -- Valid
    full   => full,
    dout   => sv_Out_word_clk2,
    rd_en  => rd_en,
    empty  => empty
  );
  i_xpm_cdc_async_rst : xpm_cdc_async_rst generic map ( -- Clock Domain Crossing (CDC) for reset
  DEST_SYNC_FF => 2, -- DECIMAL; range: 2-10
  INIT_SYNC_FF => 1, -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values
  RST_ACTIVE_HIGH => 1 ) -- DECIMAL; 0=active low reset, 1=active high reset
  port map (
  dest_arst => rst2_s, -- 1-bit output: src_arst asynchronous reset signal synchronized to destination clock domain. This output is registered. NOTE: Signal asserts asynchronously
                       -- but deasserts synchronously to dest_clk. Width of the reset signal is at least (DEST_SYNC_FF*dest_clk) period.
  dest_clk => clk2,   -- 1-bit input: Destination clock.
  src_arst => rst1 ); -- 1-bit input: Source asynchronous reset signal.

  -- ########################### Port Map ##########################
  
  -- ########################### Processes ###########################
  --! @brief Converter
  p_conv : process(clk1)
  variable vu_64bword_c : unsigned(1 downto 0) := (others => '0'); --! 64 b word counter
  begin
    if rising_edge(clk1) then
      if rst1 = '1' then -- synchronous reset (high active)
        vu_64bword_c := (others => '0');
        sv_64bword_c <= (others => '0');
        sr_axiStreamOut_96b <= AXI_STREAM_MASTER_INIT_C;
        sr_axiStream_96b    <= AXI_STREAM_MASTER_INIT_C;
      else -- Counter
        if (axiStreamIn_64b.tValid='1') then
          if vu_64bword_c >= 2 then
            vu_64bword_c := (others => '0');
          else
            vu_64bword_c := vu_64bword_c + 1;
          end if;
          sv_64bword_c <= std_logic_vector(vu_64bword_c);
        end if;
      end if;
      -- Convert 64b to 96 b
      sr_axiStreamOut_96b.tValid <= '0'; -- Default assigment
      if (axiStreamIn_64b.tValid='1') then
        case (sv_64bword_c) is
          when "00" =>
            sr_axiStreamOut_96b.tData(63 downto 0)  <= axiStreamIn_64b.tData(63 downto 0);
            sr_axiStreamOut_96b.tLast               <= axiStreamIn_64b.tLast;
            sr_axiStreamOut_96b.tUser               <= axiStreamIn_64b.tUser;
            if GEN_TKEEP then
              sr_axiStreamOut_96b.tKeep( 7 downto 0)  <= axiStreamIn_64b.tKeep( 7 downto 0);
            end if;
          when "01" =>
            sr_axiStreamOut_96b.tData(95 downto 64) <= axiStreamIn_64b.tData(31 downto 0);
            sr_axiStreamOut_96b.tValid              <= '1';
            sr_axiStreamOut_96b.tLast               <= axiStreamIn_64b.tLast;
            sr_axiStreamOut_96b.tUser               <= axiStreamIn_64b.tUser;
            sr_axiStream_96b.tData(31 downto 0)  <= axiStreamIn_64b.tData(63 downto 32);
            if GEN_TKEEP then
              sr_axiStreamOut_96b.tKeep(11 downto 8)  <= axiStreamIn_64b.tKeep( 3 downto 0);
              sr_axiStream_96b.tKeep( 3 downto 0)  <= axiStreamIn_64b.tKeep( 7 downto  4);
            end if;
          when "10" =>
            sr_axiStreamOut_96b.tData(95 downto 32) <= axiStreamIn_64b.tData(63 downto 0);
            sr_axiStreamOut_96b.tData(31 downto 0)  <= sr_axiStream_96b.tData(31 downto 0);
            sr_axiStreamOut_96b.tValid              <= '1';
            sr_axiStreamOut_96b.tLast               <= axiStreamIn_64b.tLast;
            sr_axiStreamOut_96b.tUser               <= axiStreamIn_64b.tUser;
            if GEN_TKEEP then
              sr_axiStreamOut_96b.tKeep(11 downto 4)  <= axiStreamIn_64b.tKeep( 7 downto 0);
              sr_axiStreamOut_96b.tKeep( 3 downto 0)  <= sr_axiStream_96b.tKeep( 3 downto 0);
            end if;
          when others =>
            sr_axiStreamOut_96b <= AXI_STREAM_MASTER_INIT_C;
            sr_axiStream_96b <= AXI_STREAM_MASTER_INIT_C;
        end case;
      end if;
      sv_Out_word_clk1 <= sr_axiStreamOut_96b.tUser(7 downto 0) & sr_axiStreamOut_96b.tLast & sr_axiStreamOut_96b.tKeep(11 downto 0) & 
                          sr_axiStreamOut_96b.tData(95 downto 0) & sr_axiStreamOut_96b.tValid;
    end if;
  end process p_conv;

  --! @brief Reassign slv to record
  p_slv2rec : process(clk2)
  begin
    if rising_edge(clk2) then
      axiStreamOut_96b.tValid             <= sv_Out_word_clk2(0);
      axiStreamOut_96b.tData(95 downto 0) <= sv_Out_word_clk2(96 downto 1);
      axiStreamOut_96b.tLast              <= sv_Out_word_clk2(109);
      axiStreamOut_96b.tUser(7 downto 0)  <= sv_Out_word_clk2(c_comb_word_width-1 downto 110);
      if GEN_TKEEP then
        axiStreamOut_96b.tKeep(11 downto 0) <= sv_Out_word_clk2(108 downto 97);
      else
        axiStreamOut_96b.tKeep(11 downto 0) <= (others => '0');
      end if;
    end if;
  end process p_slv2rec;


end struct;
