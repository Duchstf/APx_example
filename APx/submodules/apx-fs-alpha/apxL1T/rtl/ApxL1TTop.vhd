library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.AxiStreamPkg.all;

use work.MgtPkg.all;
use work.ApxL1TPkg.all;

use work.tcdsPkg.all;
use work.PrjSpecPkg.all;

entity ApxL1TTop is
  generic (
    TPD_G            : time             := 1 ns;
    AXI_CLK_FREQ_G   : real             := 10.0E+6;  -- Reference Clock frequency, units of Hz
    AXIL_BASE_ADDR_G : slv(31 downto 0) := x"00000000";

    REFCLK_0_CFG_G : tRefClkCfgArr;
    REFCLK_1_CFG_G : tRefClkCfgArr;
    QPLL_CFG_G     : tQpllCfgArr;
    MGT_CFG_G      : tMgtCfgArr;
    APX_L1T_CFG_G  : tApxL1TCfgArr
    );
  port (
    tcdsCmds : in tTcdsCmds;

    -- AXI-Lite Bus
    axiClk         : in  sl;
    axiRst         : in  sl;
    axiReadMaster  : in  AxiLiteReadMasterType;
    axiReadSlave   : out AxiLiteReadSlaveType;
    axiWriteMaster : in  AxiLiteWriteMasterType;
    axiWriteSlave  : out AxiLiteWriteSlaveType;

    -- Refclks
    mgtRefClk0P : in slv(0 to REFCLK_CNT_C-1) := (others => '0');
    mgtRefClk0N : in slv(0 to REFCLK_CNT_C-1) := (others => '0');
    mgtRefClk1P : in slv(0 to REFCLK_CNT_C-1) := (others => '0');
    mgtRefClk1N : in slv(0 to REFCLK_CNT_C-1) := (others => '0');

    -- Mgt Rx/Tx pins
    MgtRxN : in  slv(0 to MGT_CNT_C-1) := (others => '0');
    MgtRxP : in  slv(0 to MGT_CNT_C-1) := (others => '0');
    MgtTxN : out slv(0 to MGT_CNT_C-1) := (others => '0');
    MgtTxP : out slv(0 to MGT_CNT_C-1) := (others => '0');

    -- AXI-Stream In/Out Ports
    axiStreamClk : in  sl;
    axiStreamIn  : in  AxiStreamMasterArray(0 to L1T_OUT_STREAM_CNT_C-1);
    axiStreamOut : out AxiStreamMasterArray(0 to L1T_IN_STREAM_CNT_C-1)
    );
end ApxL1TTop;

architecture rtl of ApxL1TTop is

-----

  constant ADDR_BIT_CNT_C     : integer := 19;
  constant NUM_AXIL_MASTERS_C : natural := SECTOR_CNT_C;

-- todo : optimize!
  constant XBAR_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXIL_MASTERS_C-1 downto 0) := genAxiLiteConfig(NUM_AXIL_MASTERS_C, AXIL_BASE_ADDR_G, ADDR_BIT_CNT_C+3, ADDR_BIT_CNT_C);

  signal locAxiWriteMasters : AxiLiteWriteMasterArray(NUM_AXIL_MASTERS_C-1 downto 0) := (others => AXI_LITE_WRITE_MASTER_INIT_C);
  signal locAxiWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);
  signal locAxiReadMasters  : AxiLiteReadMasterArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_READ_MASTER_INIT_C);
  signal locAxiReadSlaves   : AxiLiteReadSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)   := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);

  signal tcdsCmdsArr : tTcdsCmdsArr(SECTOR_CNT_C-1 downto 0);

begin

  genTcdsCmdFanut : for i in 0 to SECTOR_CNT_C-1 generate
    tcdsCmdsArr(i) <= tcdsCmds when rising_edge(axiStreamClk);
  end generate;

  --------------------------
  -- AXI-Lite: Crossbar Core
  --------------------------
  U_XBAR : entity work.AxiLiteCrossbar
    generic map (
      TPD_G              => TPD_G,
      NUM_SLAVE_SLOTS_G  => 1,
      NUM_MASTER_SLOTS_G => NUM_AXIL_MASTERS_C,
      MASTERS_CONFIG_G   => XBAR_CONFIG_C)
    port map (
      axiClk              => axiClk,
      axiClkRst           => axiRst,
      sAxiWriteMasters(0) => axiWriteMaster,
      sAxiWriteSlaves(0)  => axiWriteSlave,
      sAxiReadMasters(0)  => axiReadMaster,
      sAxiReadSlaves(0)   => axiReadSlave,
      mAxiWriteMasters    => locAxiWriteMasters,
      mAxiWriteSlaves     => locAxiWriteSlaves,
      mAxiReadMasters     => locAxiReadMasters,
      mAxiReadSlaves      => locAxiReadSlaves);

  gen_sector : for i in 0 to SECTOR_CNT_C-1 generate
    U_ApxL1TSector : entity work.ApxL1TSector
      generic map (
        REFCLK_0_CFG_G => REFCLK_0_CFG_G,
        REFCLK_1_CFG_G => REFCLK_1_CFG_G,
        QPLL_CFG_G     => QPLL_CFG_G,
        MGT_CFG_G      => MGT_CFG_G,
        APX_L1T_CFG_G  => APX_L1T_CFG_G,

        REFCLK_PAIR_IDX_BTM_G => sectorMinIdx(i, REFCLK_0_CFG_G),
        REFCLK_PAIR_IDX_TOP_G => sectorMaxIdx(i, REFCLK_0_CFG_G),

        QPLL_IDX_BTM_G => sectorMinIdx(i, QPLL_CFG_G),
        QPLL_IDX_TOP_G => sectorMaxIdx(i, QPLL_CFG_G),

        MGT_IDX_BTM_G => sectorMinIdx(i, MGT_CFG_G),
        MGT_IDX_TOP_G => sectorMaxIdx(i, MGT_CFG_G),

        APX_L1T_IDX_BTM_G => sectorMinIdx(i, APX_L1T_CFG_G),
        APX_L1T_IDX_TOP_G => sectorMaxIdx(i, APX_L1T_CFG_G),

        AXIL_BASE_ADDR_G => XBAR_CONFIG_C(i).baseAddr
        )
      port map(

        tcdsCmds => tcdsCmdsArr(i),

        -- AXI-Lite Bus
        axiClk         => axiClk,
        axiRst         => axiRst,
        axiReadMaster  => locAxiReadMasters(i),
        axiReadSlave   => locAxiReadSlaves(i),
        axiWriteMaster => locAxiWriteMasters(i),
        axiWriteSlave  => locAxiWriteSlaves(i),

        MgtRxN => MgtRxN(sectorMinIdx(i, MGT_CFG_G) to sectorMaxIdx(i, MGT_CFG_G)),
        MgtRxP => MgtRxP(sectorMinIdx(i, MGT_CFG_G) to sectorMaxIdx(i, MGT_CFG_G)),
        MgtTxN => MgtTxN(sectorMinIdx(i, MGT_CFG_G) to sectorMaxIdx(i, MGT_CFG_G)),
        MgtTxP => MgtTxP(sectorMinIdx(i, MGT_CFG_G) to sectorMaxIdx(i, MGT_CFG_G)),

        mgtRefClk0N => mgtRefClk0N(sectorMinIdx(i, REFCLK_0_CFG_G) to sectorMaxIdx(i, REFCLK_0_CFG_G)),
        mgtRefClk0P => mgtRefClk0P(sectorMinIdx(i, REFCLK_0_CFG_G) to sectorMaxIdx(i, REFCLK_0_CFG_G)),
        mgtRefClk1N => mgtRefClk1N(sectorMinIdx(i, REFCLK_0_CFG_G) to sectorMaxIdx(i, REFCLK_0_CFG_G)),
        mgtRefClk1P => mgtRefClk1P(sectorMinIdx(i, REFCLK_0_CFG_G) to sectorMaxIdx(i, REFCLK_0_CFG_G)),

        axiStreamClk => axiStreamClk,
        axiStreamIn  => axiStreamIn(sectorMinIdx(i, MGT_CFG_G) to sectorMaxIdx(i, MGT_CFG_G)),
        axiStreamOut => axiStreamOut(sectorMinIdx(i, MGT_CFG_G) to sectorMaxIdx(i, MGT_CFG_G))
        );
  end generate;

end rtl;
