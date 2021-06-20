library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all; --! From surf/base/general/rtl submodule
use work.AxiStreamPkg.all; --! From surf/axi/axi-stream submodule

library xpm; --! Xilinx XMP lib (for sim)
use xpm.vcomponents.all; --! Xilinx XMP components (for sim)


entity algoTopWrapper is
  generic (
    N_INPUT_STREAMS  : integer := 54;
    N_OUTPUT_STREAMS : integer := 54
    );
  port (
    -- Algo Control/Status Signals
    algoClk   : in  sl;
    algoRst   : in  sl;
    algoStart : in  sl;
    algoDone  : out sl := '0';
    algoIdle  : out sl := '0';
    algoReady : out sl := '0';
    -- AXI-Stream In/Out Ports
    axiStreamIn  : in  AxiStreamMasterArray(0 to N_INPUT_STREAMS-1);
    axiStreamOut : out AxiStreamMasterArray(0 to N_OUTPUT_STREAMS-1)
    );
end algoTopWrapper;

architecture rtl of algoTopWrapper is
  -- ########################### Description ###########################
  -- 54 links pass through

  -- ########################### Types ###########################

  -- ########################### Constant Definitions ###########################

  -- ########################### Signals ###########################
  

begin
  -- Clocking ----------------------------------------------------------
  --i_clk_320to213 : entity work.clk_320to213 -- 320/1.5
  --   port map ( 
  --   clk_out1 => sl_Clk213,
  --   clk_in1  => algoClk
  -- );

  -- Pass through 3x18 ----------------------------------------------------------
  gen_PASS_THROUGH : for i in 0 to (N_INPUT_STREAMS-1) generate
    axiStreamOut(i) <= axiStreamIn(i);
  end generate gen_PASS_THROUGH;

  -- Test section ----------------------------------------------------------
  i_ila_18in_3out : entity work.ila_18in_3out -- ILA
    port map(
      clk => algoClk,
      probe0     => axiStreamIn(00).tData(63 downto 0), 
      probe1(0)  => axiStreamIn(00).tValid, 
      probe2     => axiStreamIn(01).tData(63 downto 0), 
      probe3(0)  => axiStreamIn(01).tValid, 
      probe4     => axiStreamIn(02).tData(63 downto 0), 
      probe5(0)  => axiStreamIn(02).tValid, 
      probe6     => axiStreamIn(03).tData(63 downto 0), 
      probe7(0)  => axiStreamIn(03).tValid, 
      probe8     => axiStreamIn(04).tData(63 downto 0), 
      probe9(0)  => axiStreamIn(04).tValid, 
      probe10    => axiStreamIn(05).tData(63 downto 0), 
      probe11(0) => axiStreamIn(05).tValid, 
      probe12    => axiStreamIn(06).tData(63 downto 0), 
      probe13(0) => axiStreamIn(06).tValid, 
      probe14    => axiStreamIn(07).tData(63 downto 0), 
      probe15(0) => axiStreamIn(07).tValid, 
      probe16    => axiStreamIn(08).tData(63 downto 0), 
      probe17(0) => axiStreamIn(08).tValid, 
      probe18    => axiStreamIn(09).tData(63 downto 0), 
      probe19(0) => axiStreamIn(09).tValid, 
      probe20    => axiStreamIn(10).tData(63 downto 0), 
      probe21(0) => axiStreamIn(10).tValid, 
      probe22    => axiStreamIn(11).tData(63 downto 0), 
      probe23(0) => axiStreamIn(11).tValid, 
      probe24    => axiStreamIn(12).tData(63 downto 0), 
      probe25(0) => axiStreamIn(12).tValid, 
      probe26    => axiStreamIn(13).tData(63 downto 0), 
      probe27(0) => axiStreamIn(13).tValid, 
      probe28    => axiStreamIn(14).tData(63 downto 0), 
      probe29(0) => axiStreamIn(14).tValid, 
      probe30    => axiStreamIn(15).tData(63 downto 0), 
      probe31(0) => axiStreamIn(15).tValid, 
      probe32    => axiStreamIn(16).tData(63 downto 0), 
      probe33(0) => axiStreamIn(16).tValid, 
      probe34    => axiStreamIn(17).tData(63 downto 0), 
      probe35(0) => axiStreamIn(17).tValid, 
      probe36    => axiStreamIn(00).tData(63 downto 0), -- Repeat inputs because of simple pass through
      probe37(0) => axiStreamIn(00).tValid,             -- Repeat inputs because of simple pass through
      probe38    => axiStreamIn(01).tData(63 downto 0), -- Repeat inputs because of simple pass through
      probe39(0) => axiStreamIn(01).tValid,             -- Repeat inputs because of simple pass through
      probe40    => axiStreamIn(02).tData(63 downto 0), -- Repeat inputs because of simple pass through
      probe41(0) => axiStreamIn(02).tValid,             -- Repeat inputs because of simple pass through
      probe42(0) => algoRst );

end rtl;
