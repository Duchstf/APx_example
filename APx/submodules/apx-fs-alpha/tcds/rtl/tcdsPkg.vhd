library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.StdRtlPkg.all;

package tcdsPkg is

  constant LHC_BX_CNT_C : integer := 3564;

  type tClkMgrCfg is record
    CLKFBOUT_MULT_F  : real range 1.0 to 64.0;
    CLKOUT0_DIVIDE_F : real range 1.0 to 128.0;
    CLKOUT1_DIVIDE   : integer range 1 to 128;
    CLKOUT2_DIVIDE   : integer range 1 to 128;
    CLKOUT3_DIVIDE   : integer range 1 to 128;
    CLKOUT4_DIVIDE   : integer range 1 to 128;
  end record;

  type tClkMgrCfgArr is array (integer range <>) of tClkMgrCfg;

  -- N.B.: when main FSClk (clk0) configured to operate at 280 MHz or 440 MHz (FS_TO_LHC_CLK_FACTOR_C = 7 or 11), 
  --       then auxilary clk3 (fsClk240) and clk4 (fsClk120) do not generate exact 240 MHz and 120 MHz outputs. 

  constant ClkMgrCfg : tClkMgrCfgArr(1 to 12) := (
    1  => (CLKFBOUT_MULT_F => 15.0, CLKOUT0_DIVIDE_F => 30.0, CLKOUT1_DIVIDE => 60, CLKOUT2_DIVIDE => 30, CLKOUT3_DIVIDE => 5, CLKOUT4_DIVIDE => 10),
    2  => (CLKFBOUT_MULT_F => 15.0, CLKOUT0_DIVIDE_F => 15.0, CLKOUT1_DIVIDE => 30, CLKOUT2_DIVIDE => 30, CLKOUT3_DIVIDE => 5, CLKOUT4_DIVIDE => 10),
    3  => (CLKFBOUT_MULT_F => 15.0, CLKOUT0_DIVIDE_F => 10.0, CLKOUT1_DIVIDE => 20, CLKOUT2_DIVIDE => 30, CLKOUT3_DIVIDE => 5, CLKOUT4_DIVIDE => 10),
    4  => (CLKFBOUT_MULT_F => 15.0, CLKOUT0_DIVIDE_F => 7.5, CLKOUT1_DIVIDE => 15, CLKOUT2_DIVIDE => 30, CLKOUT3_DIVIDE => 5, CLKOUT4_DIVIDE => 10),
    5  => (CLKFBOUT_MULT_F => 15.0, CLKOUT0_DIVIDE_F => 6.0, CLKOUT1_DIVIDE => 12, CLKOUT2_DIVIDE => 30, CLKOUT3_DIVIDE => 5, CLKOUT4_DIVIDE => 10),
    6  => (CLKFBOUT_MULT_F => 15.0, CLKOUT0_DIVIDE_F => 5.0, CLKOUT1_DIVIDE => 10, CLKOUT2_DIVIDE => 30, CLKOUT3_DIVIDE => 5, CLKOUT4_DIVIDE => 10),
    7  => (CLKFBOUT_MULT_F => 17.5, CLKOUT0_DIVIDE_F => 5.0, CLKOUT1_DIVIDE => 10, CLKOUT2_DIVIDE => 35, CLKOUT3_DIVIDE => 6, CLKOUT4_DIVIDE => 12),
    8  => (CLKFBOUT_MULT_F => 12.0, CLKOUT0_DIVIDE_F => 3.0, CLKOUT1_DIVIDE => 6, CLKOUT2_DIVIDE => 24, CLKOUT3_DIVIDE => 4, CLKOUT4_DIVIDE => 8),
    9  => (CLKFBOUT_MULT_F => 18.0, CLKOUT0_DIVIDE_F => 4.0, CLKOUT1_DIVIDE => 8, CLKOUT2_DIVIDE => 36, CLKOUT3_DIVIDE => 4, CLKOUT4_DIVIDE => 8),
    10 => (CLKFBOUT_MULT_F => 15.0, CLKOUT0_DIVIDE_F => 3.0, CLKOUT1_DIVIDE => 6, CLKOUT2_DIVIDE => 30, CLKOUT3_DIVIDE => 5, CLKOUT4_DIVIDE => 10),
    11 => (CLKFBOUT_MULT_F => 16.5, CLKOUT0_DIVIDE_F => 3.0, CLKOUT1_DIVIDE => 6, CLKOUT2_DIVIDE => 33, CLKOUT3_DIVIDE => 6, CLKOUT4_DIVIDE => 12),
    12 => (CLKFBOUT_MULT_F => 15.0, CLKOUT0_DIVIDE_F => 2.5, CLKOUT1_DIVIDE => 5, CLKOUT2_DIVIDE => 30, CLKOUT3_DIVIDE => 5, CLKOUT4_DIVIDE => 10));

  type tTcdsCmds is record
    bc0      : sl;
    l1a      : sl;
    resync   : sl;
    start    : sl;
    stop     : sl;
    ec0      : sl;
    testSync : sl;
  end record;

  constant tcdsCmdsInit : tTcdsCmds := (
    bc0      => '0',
    l1a      => '0',
    resync   => '0',
    start    => '0',
    stop     => '0',
    ec0      => '0',
    testSync => '0'
    );

  type tTcdsCmdsArr is array (integer range <>) of tTcdsCmds;

end package tcdsPkg;
