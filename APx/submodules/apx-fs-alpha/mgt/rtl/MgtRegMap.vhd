library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.StdRtlPkg.all;

package MgtRegMap is

-- Main MGT Sector Address Map
  constant GENERAL_BASE_ADDR_C : integer := 16#00000#;
  constant REFCLK0_BASE_ADDR_C : integer := 16#00100#;
  constant REFCLK1_BASE_ADDR_C : integer := 16#00180#;
  constant QPLL_BASE_ADDR_C    : integer := 16#00200#;
  constant MGT_BASE_ADDR_C     : integer := 16#00400#;

  constant REFCLK_CH2CH_OFFSET_C : integer := 4 * 1;
  constant QPLL_CH2CH_OFFSET_C   : integer := 4 * 4;
  constant MGT_CH2CH_OFFSET_C    : integer := 4 * 32;

-- General registers
  constant MGT_SECTOR_CFG_REG_C : integer := 16#00000#;
  constant QPLL_DRP_SEL_REG_C   : integer := 16#00004#;
  constant MGT_DRP_REG_C        : integer := 16#00008#;

-- Refclk0 registers
  constant REFCLK0_FREQ_REG_C : integer := 16#00000#;

-- Refclk1 registers
  constant REFCLK1_FREQ_REG_C : integer := 16#00000#;

-- QPLL registers
  constant QPLL_RST_CTRL_REG_C : integer := 16#00000#;
  constant QPLL_STATUS_REG_C   : integer := 16#00004#;
  constant QPLL_CTRL_REG_C     : integer := 16#00008#;

-- MGT registers
  constant RX_BCFG_REG_C              : integer := 16#00000#;
  constant TX_BCFG_REG_C              : integer := 16#00004#;
  constant RX_RST_CTRL_REG_C          : integer := 16#00008#;
  constant RX_RST_STAT_REG_C          : integer := 16#0000C#;
  constant TX_RST_CTRL_REG_C          : integer := 16#00010#;
  constant TX_RST_STAT_REG_C          : integer := 16#00014#;
  constant CPLL_RST_CTRL_REG_C        : integer := 16#00018#;
  constant CPLL_LOCK_STAT_REG_C       : integer := 16#0001C#;
  constant CPLL_MAIN_CTRL_REG_C       : integer := 16#00020#;
  constant RX_MAIN_CTRL_REG_C         : integer := 16#00024#;
  constant TX_MAIN_CTRL_REG_C         : integer := 16#00028#;
  constant TX_DRV_CTRL_REG_C          : integer := 16#0002C#;
  constant LOOPBACK_REG_C             : integer := 16#00030#;
  constant RX_STAT_REG_C              : integer := 16#00034#;
  constant TX_STAT_REG_C              : integer := 16#00038#;
  constant RX_PHY_ERR_CNT_REG_C       : integer := 16#0003C#;
  constant RX_CDR_CTRL_REG_C          : integer := 16#00040#;
  constant RX_EQ_CDR_DFE_STATUS_REG_C : integer := 16#00044#;
  constant RX_LPM_CTRL_REG_C          : integer := 16#00048#;
  constant RX_DFE_AGC_CTRL_REG_C      : integer := 16#0004C#;
  constant RX_DFE_1_CTRL_REG_C        : integer := 16#00050#;
  constant RX_DFE_2_CTRL_REG_C        : integer := 16#00054#;
  constant RX_OS_CTRL_REG_C           : integer := 16#00058#;

end package MgtRegMap;

