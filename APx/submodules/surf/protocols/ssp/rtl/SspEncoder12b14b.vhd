-------------------------------------------------------------------------------
-- File       : SspEncoder12b14b.vhd
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: SimpleStreamingProtocol - A simple protocol layer for inserting
-- idle and framing control characters into a raw data stream. This module
-- ties the framing core to an RTL 12b14b encoder.
-------------------------------------------------------------------------------
-- This file is part of 'SLAC Firmware Standard Library'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'SLAC Firmware Standard Library', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

use work.StdRtlPkg.all;
use work.Code12b14bPkg.all;

entity SspEncoder12b14b is

   generic (
      TPD_G          : time    := 1 ns;
      RST_POLARITY_G : sl      := '0';
      RST_ASYNC_G    : boolean := true;
      AUTO_FRAME_G   : boolean := true;
      FLOW_CTRL_EN_G : boolean := false);
   port (
      clk      : in  sl;
      rst      : in  sl := RST_POLARITY_G;
      validIn  : in  sl;
      readyIn  : out sl;
      sof      : in  sl := '0';
      eof      : in  sl := '0';
      dataIn   : in  slv(11 downto 0);
      validOut : out sl;
      readyOut : in  sl := '1';
      dataOut  : out slv(13 downto 0));

end entity SspEncoder12b14b;

architecture rtl of SspEncoder12b14b is

   signal readyOutInt : sl;
   signal framedData  : slv(11 downto 0) := (others => '0');
   signal framedDataK : slv(0 downto 0)  := (others => '0');
   signal validInt    : sl;
   signal readyInt    : sl;

begin

   SspFramer_1 : entity work.SspFramer
      generic map (
         TPD_G           => TPD_G,
         RST_POLARITY_G  => RST_POLARITY_G,
         RST_ASYNC_G     => RST_ASYNC_G,
         AUTO_FRAME_G    => AUTO_FRAME_G,
         FLOW_CTRL_EN_G  => FLOW_CTRL_EN_G,
         WORD_SIZE_G     => 12,
         K_SIZE_G        => 1,
         SSP_IDLE_CODE_G => K_120_11_C,
         SSP_IDLE_K_G    => "1",
         SSP_SOF_CODE_G  => K_120_0_C,
         SSP_SOF_K_G     => "1",
         SSP_EOF_CODE_G  => K_120_1_C,
         SSP_EOF_K_G     => "1")
      port map (
         clk      => clk,
         rst      => rst,
         validIn  => validIn,
         readyIn  => readyIn,
         sof      => sof,
         eof      => eof,
         dataIn   => dataIn,
         validOut => validInt,
         readyOut => readyInt,
         dataOut  => framedData,
         dataKOut => framedDataK);

   Encoder12b14b_1 : entity work.Encoder12b14b
      generic map (
         TPD_G          => TPD_G,
         RST_POLARITY_G => RST_POLARITY_G,
         RST_ASYNC_G    => RST_ASYNC_G,
         FLOW_CTRL_EN_G => FLOW_CTRL_EN_G)
      port map (
         clk      => clk,
         rst      => rst,
         validIn  => validInt,
         readyIn  => readyInt,
         dataIn   => framedData,
         dataKIn  => framedDataK(0),
         validOut => validOut,
         readyOut => readyOutInt,
         dataOut  => dataOut);

end architecture rtl;
