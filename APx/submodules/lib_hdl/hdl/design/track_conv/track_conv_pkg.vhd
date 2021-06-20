--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief Package for the according file
--! @author glein
--! @date 2019-06-18
--! @version v.1.0
--! @details
--! Constants, types, functions, ... 
--=============================================================================

--! Standard library
library ieee;
--! Standard package
use ieee.std_logic_1164.all;

--! @brief Package.
package track_conv_pkg is

  -- ########################### Constants ###########################
  constant c_PT_WIDTH : integer := 15;  --! Track parameter bit width; extra charge bit
  constant c_PHI_WIDTH : integer := 12; --! Track parameter bit width
  constant c_ETA_WIDTH : integer := 16; --! Track parameter bit width
  constant c_Z0_WIDTH : integer := 12;  --! Track parameter bit width
  constant c_D0_WIDTH : integer := 13;  --! Track parameter bit width
  constant c_CHI2_WIDTH : integer := 4;          --! Track quality parameter bit width
  constant c_BEND_CHI2_WIDTH : integer := 3;     --! Track quality parameter bit width
  constant c_HIT_MASK_WIDTH : integer := 7;      --! Track quality parameter bit width
  constant c_MVA_WIDTH : integer := 3;           --! Track quality parameter bit width
  constant c_MVA_SPECIALIZED_WIDTH : integer := 6; --! Track quality parameter bit width
  constant c_RESERVE_WIDTH : integer := 5; --! Reserve bit width
  constant c_TRACK_WORD_WIDTH : integer := c_RESERVE_WIDTH+c_MVA_SPECIALIZED_WIDTH+c_MVA_WIDTH+c_HIT_MASK_WIDTH+c_BEND_CHI2_WIDTH+c_CHI2_WIDTH+
                                           c_D0_WIDTH+c_Z0_WIDTH+c_ETA_WIDTH+c_PHI_WIDTH+c_PT_WIDTH; --! Track word bit width

  -- ########################### Types ###########################
  type t_track_word_record is record --! Track word type definition
    reserve         : std_logic_vector(c_RESERVE_WIDTH-1 downto 0);
    mva_specialized : std_logic_vector(c_MVA_SPECIALIZED_WIDTH-1 downto 0);
    mva             : std_logic_vector(c_MVA_WIDTH-1 downto 0);
    hit_mask        : std_logic_vector(c_HIT_MASK_WIDTH-1 downto 0);
    bend_chi2       : std_logic_vector(c_BEND_CHI2_WIDTH-1 downto 0);
    chi2            : std_logic_vector(c_CHI2_WIDTH-1 downto 0);
    d0              : std_logic_vector(c_D0_WIDTH-1 downto 0);
    z0              : std_logic_vector(c_Z0_WIDTH-1 downto 0);
    eta             : std_logic_vector(c_ETA_WIDTH-1 downto 0);
    phi             : std_logic_vector(c_PHI_WIDTH-1 downto 0);
    pt              : std_logic_vector(c_PT_WIDTH-1 downto 0);
  end record t_track_word_record;  
  subtype t_track_word_sv is std_logic_vector(c_TRACK_WORD_WIDTH-1 downto 0);

  -- ########################### Functions ###########################
  function TWsv2TWrecord (sv_track_word : std_logic_vector(c_TRACK_WORD_WIDTH downto 0)) return t_track_word_record; -- Track word std_logic_vector to track word record
  function TWrecord2TWsv (track_word_record : t_track_word_record) return std_logic_vector; -- Track word record to track word std_logic_vector

end package track_conv_pkg;


package body track_conv_pkg is

  -- ########################### Functions ###########################
  function TWsv2TWrecord (sv_track_word : std_logic_vector(c_TRACK_WORD_WIDTH downto 0)) return t_track_word_record is
  variable track_word_record : t_track_word_record;
  begin
    track_word_record.reserve         := sv_track_word(c_TRACK_WORD_WIDTH-1 
                                            downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH);
    track_word_record.mva_specialized := sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH 
                                            downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH);
    track_word_record.mva             := sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH 
                                            downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH);
    track_word_record.hit_mask        := sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH 
                                            downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH);
    track_word_record.bend_chi2       := sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH 
                                            downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH);
    track_word_record.chi2            := sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH 
                                            downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH-c_CHI2_WIDTH);
    track_word_record.d0              := sv_track_word(c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH+c_D0_WIDTH downto c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH);
    track_word_record.z0              := sv_track_word(c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH            downto c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH);
    track_word_record.eta             := sv_track_word(c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH                       downto c_PT_WIDTH+c_PHI_WIDTH);
    track_word_record.phi             := sv_track_word(c_PT_WIDTH-1+c_PHI_WIDTH                                   downto c_PT_WIDTH);
    track_word_record.pt              := sv_track_word(c_PT_WIDTH-1                                               downto 0);

    return track_word_record;
  end function TWsv2TWrecord;

  function TWrecord2TWsv (track_word_record : t_track_word_record) return std_logic_vector is
  variable sv_track_word : std_logic_vector;
  begin
    sv_track_word(c_TRACK_WORD_WIDTH-1 
       downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH) := track_word_record.reserve;
    sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH 
       downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH) := track_word_record.mva_specialized;
    sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH 
       downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH) := track_word_record.mva;
    sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH 
       downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH) := track_word_record.hit_mask;
    sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH 
       downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH) := track_word_record.bend_chi2;
    sv_track_word(c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH 
       downto c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH-c_CHI2_WIDTH) := track_word_record.chi2;
    sv_track_word(c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH+c_D0_WIDTH downto c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH) := track_word_record.d0;
    sv_track_word(c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH            downto c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH) := track_word_record.z0;
    sv_track_word(c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH                       downto c_PT_WIDTH+c_PHI_WIDTH) := track_word_record.eta;
    sv_track_word(c_PT_WIDTH-1+c_PHI_WIDTH                                   downto c_PT_WIDTH) := track_word_record.phi;
    sv_track_word(c_PT_WIDTH-1                                               downto 0) := track_word_record.pt;

    return sv_track_word;
  end function TWrecord2TWsv;

end package body track_conv_pkg;
