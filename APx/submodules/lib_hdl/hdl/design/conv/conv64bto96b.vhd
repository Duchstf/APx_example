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
--! 66 LUTs, 105 FFs
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
entity conv64bto96b is
  port(
    clk1             : in  std_logic; --! Clock 1
    rst1_s           : in  std_logic; --! Reset 1 sync.
    clk2             : in  std_logic; --! Clock 2
    rst2_as          : in  std_logic; --! Reset 2 async.
    rst2_s           : out std_logic; --! OUT: Syncronized reset with 2 clk
    axiStreamIn_64b  : in  AxiStreamMasterType;   --! 64 b MGT word
    axiStreamOut_96b : out AxiStreamMasterType ); --! 96 b TF word
end entity conv64bto96b;

--! @brief Converter
architecture struct of conv64bto96b is
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
  --end record AxiStreamMasterType;                             -- = 118 b @ clk2 = clk1 * 64 / 96

  -- ########################### Types ###########################

  -- ########################### Constant Definitions ###########################
  constant c_comb_word_width : integer   := 118;  --! width

  -- ########################### Signal ###########################
  signal sl_rst2_s            : std_logic; --! Temp. syncronized reset with 2 clk
  signal sv_64bword_c         : std_logic_vector(1 downto 0) := (others => '0'); --! 64 b word counter
  signal sr_axiStream_96b     : AxiStreamMasterType; --! Temp 96 b
  signal sr_axiStreamOut_96b  : AxiStreamMasterType; --! Temp 96 b
  signal sv_Out_word_clk1     : std_logic_vector(c_comb_word_width downto 0) := (others => '0'); --! slv for CDC + 1 b qualifier
  signal sv_Out_word_clk1_d1  : std_logic_vector(c_comb_word_width downto 0) := (others => '0'); --! slv for CDC + 1 b qualifier; delayed
  signal sv_Out_word_clk2     : std_logic_vector(c_comb_word_width-1 downto 0) := (others => '0'); --! slv for CDC
  signal sv_Out_word_clk2_1d  : std_logic_vector(c_comb_word_width-1 downto 0) := (others => '0'); --! slv for CDC; neg. delay

begin
  -- ########################### Assertion ###########################

  -- ########################### Instantiation ###########################

  -- ########################### Port Map ##########################
  
  -- ########################### Processes ###########################
  --! @brief Converter
  p_conv : process(clk1)
  variable vu_64bword_c : unsigned(1 downto 0) := (others => '0'); --! 64 b word counter
  begin
    if rising_edge(clk1) then
      if rst1_s = '1' then -- synchronous reset (high active)
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
            sr_axiStreamOut_96b.tKeep( 7 downto 0)  <= axiStreamIn_64b.tKeep( 7 downto 0);
            sr_axiStreamOut_96b.tLast               <= axiStreamIn_64b.tLast;
            sr_axiStreamOut_96b.tUser               <= axiStreamIn_64b.tUser;
          when "01" =>
            sr_axiStreamOut_96b.tData(95 downto 64) <= axiStreamIn_64b.tData(31 downto 0);
            sr_axiStreamOut_96b.tValid              <= '1';
            sr_axiStreamOut_96b.tKeep(11 downto 8)  <= axiStreamIn_64b.tKeep( 3 downto 0);
            sr_axiStreamOut_96b.tLast               <= axiStreamIn_64b.tLast;
            sr_axiStreamOut_96b.tUser               <= axiStreamIn_64b.tUser;
            sr_axiStream_96b.tData(31 downto 0)  <= axiStreamIn_64b.tData(63 downto 32);
            sr_axiStream_96b.tKeep( 3 downto 0)  <= axiStreamIn_64b.tKeep( 7 downto  4);
          when "10" =>
            sr_axiStreamOut_96b.tData(95 downto 32) <= axiStreamIn_64b.tData(63 downto 0);
            sr_axiStreamOut_96b.tData(31 downto 0)  <= sr_axiStream_96b.tData(31 downto 0);
            sr_axiStreamOut_96b.tValid              <= '1';
            sr_axiStreamOut_96b.tKeep(11 downto 4)  <= axiStreamIn_64b.tKeep( 7 downto 0);
            sr_axiStreamOut_96b.tKeep( 3 downto 0)  <= sr_axiStream_96b.tKeep( 3 downto 0);
            sr_axiStreamOut_96b.tLast               <= axiStreamIn_64b.tLast;
            sr_axiStreamOut_96b.tUser               <= axiStreamIn_64b.tUser;
          when others =>
            sr_axiStreamOut_96b <= AXI_STREAM_MASTER_INIT_C;
            sr_axiStream_96b <= AXI_STREAM_MASTER_INIT_C;
        end case;
      end if;
      sv_Out_word_clk1 <= sv_64bword_c(0) & -- Assign record to slv for CDC and add qualifier (MSb)
                          sr_axiStreamOut_96b.tUser(7 downto 0) & sr_axiStreamOut_96b.tLast & sr_axiStreamOut_96b.tKeep(11 downto 0) & 
                          sr_axiStreamOut_96b.tData(95 downto 0) & sr_axiStreamOut_96b.tValid;
      sv_Out_word_clk1_d1 <= sv_Out_word_clk1;
    end if;
  end process p_conv;

  --! @brief Clock Domain Crossing (CDC)
  p_cdc : process(rst2_as, clk2)
  begin
    if rst2_as = '1' then
      sv_Out_word_clk2    <= (others => '0');
      sv_Out_word_clk2_1d <= (others => '0');
      sl_rst2_s <= '0';
      rst2_s <= '0';
    else
      if rising_edge(clk2) then
        if (sv_Out_word_clk1(0) = '1') then -- Check valid bit
          sv_Out_word_clk2_1d <= sv_Out_word_clk1(c_comb_word_width-1 downto 0);
        elsif (sv_Out_word_clk1_d1(0) = '1' and sv_Out_word_clk1(c_comb_word_width) /= sv_Out_word_clk1_d1(c_comb_word_width)) then -- Check valid bit and if it is the same word
          sv_Out_word_clk2_1d <= sv_Out_word_clk1_d1(c_comb_word_width-1 downto 0);
        else
          sv_Out_word_clk2_1d <= (others => '0');
        end if;
        sv_Out_word_clk2 <= sv_Out_word_clk2_1d;
        sl_rst2_s <= rst1_s;
        rst2_s    <= sl_rst2_s;
      end if;
    end if;
  end process p_cdc;

  ---- Clock Domain Crossing (CDC)
  --i_xpm_cdc_array_single : xpm_cdc_array_single
  --generic map (
  --  DEST_SYNC_FF   => 2, -- DECIMAL; range: 2-10
  --  INIT_SYNC_FF   => 1, -- DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
  --  SIM_ASSERT_CHK => 1, -- DECIMAL; 0=disable simulation messages, 1=enable simulation messages 
  --  SRC_INPUT_REG  => 0, -- DECIMAL; 0=do not register input, 1=register input
  --  WIDTH          => c_comb_word_width ) -- DECIMAL; range: 1-1024
  --port map (
  --  dest_out => sv_Out_word_clk2,   -- WIDTH-bit output: src_in synchronized to the destination clock domain. This -- output is registered.
  --  dest_clk => clk2,               -- 1-bit input: Clock signal for the destination clock domain.
  --  src_clk  => '0',                -- 1-bit input: optional; required when SRC_INPUT_REG = 1
  --  src_in   => sv_Out_word_clk1 ); -- WIDTH-bit input: Input single-bit array to be synchronized to destination clock domain. It is assumed that each bit of the array is unrelated to the others.
  --                                  -- This is reflected in the constraints applied to this macro. To transfer a binary value losslessly across the two clock domains, use the XPM_CDC_GRAY macro instead.

  --! @brief Reassign slv to record
  p_slv2rec : process(clk2)
  begin
    if rising_edge(clk2) then
      axiStreamOut_96b.tValid             <= sv_Out_word_clk2(0);
      axiStreamOut_96b.tData(95 downto 0) <= sv_Out_word_clk2(96 downto 1);
      axiStreamOut_96b.tKeep(11 downto 0) <= sv_Out_word_clk2(108 downto 97);
      axiStreamOut_96b.tLast              <= sv_Out_word_clk2(109);
      axiStreamOut_96b.tUser(7 downto 0)  <= sv_Out_word_clk2(c_comb_word_width-1 downto 110);
    end if;
  end process p_slv2rec;

end struct;
