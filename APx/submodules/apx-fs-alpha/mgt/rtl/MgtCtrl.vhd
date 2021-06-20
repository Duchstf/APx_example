library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.MgtPkg.all;
use work.MgtRegMap.all;
use work.PrjSpecPkg.all;

library unisim;
use unisim.vcomponents.all;

entity MgtCtrl is
  generic (
    TPD_G : time := 1 ns;

    AXI_CLK_FREQ_G : real := 10.0E+6;  -- Reference Clock frequency, units of Hz

    REFCLK_0_CFG_G : tRefClkCfgArr;
    REFCLK_1_CFG_G : tRefClkCfgArr;
    QPLL_CFG_G     : tQpllCfgArr;
    MGT_CFG_G      : tMgtCfgArr;

    REFCLK_PAIR_IDX_BTM_G : integer := 0;
    REFCLK_PAIR_IDX_TOP_G : integer := 1;

    QPLL_IDX_BTM_G : integer := 0;
    QPLL_IDX_TOP_G : integer := 1;

    MGT_IDX_BTM_G : integer := 0;
    MGT_IDX_TOP_G : integer := 11;

    AXIL_BASE_ADDR_G : slv(31 downto 0) := x"00000000"

    );
  port (

    -- AXI-Lite Bus
    axiClk         : in  sl;
    axiRst         : in  sl;
    axiReadMaster  : in  AxiLiteReadMasterType;
    axiReadSlave   : out AxiLiteReadSlaveType;
    axiWriteMaster : in  AxiLiteWriteMasterType;
    axiWriteSlave  : out AxiLiteWriteSlaveType;

    -- Refclks
    mgtRefClk0P : in slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');
    mgtRefClk0N : in slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');
    mgtRefClk1P : in slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');
    mgtRefClk1N : in slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');

    -- Mgt Rx/Tx pins
    MgtRxN : in  slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    MgtRxP : in  slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    MgtTxN : out slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    MgtTxP : out slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');

    -- Mgt Rx/Tx Clk/Data
    mgtRxUsrClk  : out slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G)           := (others => '0');
    mgtRxDataArr : out tMgtRxDataArr(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => MgtRxData_Null_C);
    mgtTxUsrClk  : out slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G)           := (others => '0');
    mgtTxDataArr : in  tMgtTxDataArr(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => MgtTxData_Null_C);

    -- Mgt Rx/Tx Misc
    mgtTxExtRst      : in  slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    mgtRxExtRst      : in  slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    mgtRxGearboxSlip : in  slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    mgtRxInitDone    : out slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    mgtTxInitDone    : out slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0')
    );
end MgtCtrl;

architecture rtl of MgtCtrl is

  signal mgtRefClk     : Slv2Array(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => "00");
  signal mgtRefClkBufg : Slv2Array(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => "00");

  signal mgtRefClk0Freq : Slv32Array(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => (others => '0'));
  signal mgtRefClk1Freq : Slv32Array(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => (others => '0'));

  signal mgtRefClk0FreqLatched : Slv32Array(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => (others => '0'));
  signal mgtRefClk1FreqLatched : Slv32Array(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => (others => '0'));

  signal mgtRefClk0FreqUpdated : slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');
  signal mgtRefClk1FreqUpdated : slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');

  signal qPllReset     : Slv2Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G) := (others => "00");
  signal qPllPowerDown : Slv2Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G) := (others => "00");

  signal qPllOutClk     : Slv2Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G) := (others => "00");
  signal qPllOutRefClk  : Slv2Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G) := (others => "00");
  signal qPllFbClkLost  : Slv2Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G) := (others => "11");
  signal qPllLock       : Slv2Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G) := (others => "00");
  signal qPllRefClkLost : Slv2Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G) := (others => "11");

  signal drpRdyGt, drpRdyGt_d1, drpRdyGt_d2 : sl               := '1';
  signal drpEnGt                            : sl;
  signal drpWeGt                            : sl;
  signal drpAddrGt                          : slv(15 downto 0) := (others => '0');
  signal drpDiGt                            : slv(15 downto 0);
  signal drpDoGt                            : slv(15 downto 0);

  signal drpEnGtArr                  : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G)                        := (others => '0');
  signal drpEnGtDec                  : slv(63 downto 0)                                           := (others => '0');
  signal drpRdyGtArr, drpRdyGtArr_d1 : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G)                        := (others => '0');
  signal drpDoGtArr, drpDoGtArrLat   : Slv16Array(MGT_IDX_BTM_G to MGT_IDX_TOP_G)                 := (others => (others => '0'));
  signal drpDoGtArrAggr              : SlVectorArray(15 downto 0, MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => (others => '0'));

  signal drpRdyQpll, drpRdyQpll_d1, drpRdyQpll_d2 : sl               := '1';
  signal drpEnQpll                                : sl;
  signal drpWeQpll                                : sl;
  signal drpAddrQpll                              : slv(15 downto 0) := (others => '0');
  signal drpDiQpll                                : slv(15 downto 0);
  signal drpDoQpll                                : slv(15 downto 0);

  signal drpEnQpllArr                    : slv(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G)                        := (others => '0');
  signal drpEnQpllDec                    : slv(15 downto 0)                                             := (others => '0');
  signal drpRdyQpllArr, drpRdyQpllArr_d1 : slv(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G)                        := (others => '0');
  signal drpDoQpllArr, drpDoQpllArrLat   : Slv16Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G)                 := (others => (others => '0'));
  signal drpDoQpllArrAggr                : SlVectorArray(15 downto 0, QPLL_IDX_BTM_G to QPLL_IDX_TOP_G) := (others => (others => '0'));

  --signal drpGtSel   : slv(5 downto 0) := (others => '0');
  --signal drpQpllSel : slv(3 downto 0) := (others => '0');

  signal mgtSlwCtrlArr   : tMgtSlwCtrlArr(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal mgtSlwStatusArr : tMgtSlwStatusArr(MGT_IDX_BTM_G to MGT_IDX_TOP_G);

  signal mgtRxPrbsErr : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G);


  signal mgtRxUsrClkInt  : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G)           := (others => '0');
  signal mgtRxDataArrInt : tMgtRxDataArr(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => MgtRxData_Null_C);
  signal mgtTxUsrClkInt  : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G)           := (others => '0');

  signal mgtRxPhyErrCnt : Slv24Array(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => (others => '0'));

  type RegType is record
    mgtSlwCtrlArr     : tMgtSlwCtrlArr(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
    mgtRxPhyErrCntRst : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G);

    qPllReset     : Slv2Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G);
    qPllPowerDown : Slv2Array(QPLL_IDX_BTM_G to QPLL_IDX_TOP_G);

    drpGtSel   : slv(5 downto 0);
    drpQpllSel : slv(3 downto 0);

    axiReadSlave  : AxiLiteReadSlaveType;
    axiWriteSlave : AxiLiteWriteSlaveType;
  end record RegType;

  constant REG_INIT_C : RegType := (
    mgtSlwCtrlArr     => (others => MgtSlwCtrlPowerOn_C),
    mgtRxPhyErrCntRst => (others => '0'),

    qpllReset     => (others => (others => '0')),
    qpllPowerDown => (others => (others => '0')),

    drpGtSel   => (others => '0'),
    drpQpllSel => (others => '0'),

    axiReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
    axiWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C);

  signal r   : RegType := REG_INIT_C;
  signal rin : RegType;


-----

  constant ADDR_BIT_CNT_C : integer := 17;

  constant NUM_AXIL_MASTERS_C : natural := 3;

  constant REG_FILE_INDEX_C : natural := 0;
  constant QPLL_DRP_INDEX_C : natural := 1;
  constant MGT_DRP_INDEX_C  : natural := 2;

  constant REG_FILE_BASE_ADDR_C : slv(31 downto 0) := slv(unsigned(AXIL_BASE_ADDR_G) + x"0_0000");
  constant QPLL_DRP_BASE_ADDR_C : slv(31 downto 0) := slv(unsigned(AXIL_BASE_ADDR_G) + x"2_0000");
  constant MGT_DRP_BASE_ADDR_C  : slv(31 downto 0) := slv(unsigned(AXIL_BASE_ADDR_G) + x"3_0000");

  constant XBAR_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXIL_MASTERS_C-1 downto 0) := (
    REG_FILE_INDEX_C => (
      baseAddr       => REG_FILE_BASE_ADDR_C,
      addrBits       => 17,
      connectivity   => x"FFFF"),
    QPLL_DRP_INDEX_C => (
      baseAddr       => QPLL_DRP_BASE_ADDR_C,
      addrBits       => 16,
      connectivity   => x"FFFF"),
    MGT_DRP_INDEX_C  => (
      baseAddr       => MGT_DRP_BASE_ADDR_C,
      addrBits       => 16,
      connectivity   => x"FFFF")
    );

  signal locAxiWriteMasters : AxiLiteWriteMasterArray(NUM_AXIL_MASTERS_C-1 downto 0) := (others => AXI_LITE_WRITE_MASTER_INIT_C);
  signal locAxiWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);
  signal locAxiReadMasters  : AxiLiteReadMasterArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_READ_MASTER_INIT_C);
  signal locAxiReadSlaves   : AxiLiteReadSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)   := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);

begin

  gen_refclk_buf : for i in REFCLK_PAIR_IDX_BTM_G to REFCLK_PAIR_IDX_TOP_G generate
    gen_refclk0 : if (REFCLK_0_CFG_G(i).enabled = true) generate
      U_MgtRefClkBuf : entity work.MgtRefClkBuf
        port map(
          mgtRefClkP    => mgtRefClk0P(i),
          mgtRefClkN    => mgtRefClk0N(i),
          mgtRefClk     => mgtRefClk(i)(0),
          mgtRefClkBufg => mgtRefClkBufg(i)(0)
          );
      U_SyncClockFreq_RefClk0 : entity work.SyncClockFreq
        generic map(
          REF_CLK_FREQ_G => AXI_CLK_FREQ_G,  -- Reference Clock frequency, units of Hz
          REFRESH_RATE_G => 1.0E+3,     -- Refresh rate, units of Hz
          COMMON_CLK_G   => true,  -- Set to true if (locClk = refClk) to save resources else false
          CNT_WIDTH_G    => 32)         -- Counters' width
        port map (
          -- Frequency Measurement and Monitoring Outputs (locClk domain)
          freqOut     => mgtRefClk0Freq(i),  -- units of Hz
          freqUpdated => mgtRefClk0FreqUpdated(i),
          -- Clocks
          clkIn       => mgtRefClkBufg(i)(0),  -- Input clock to measure
          locClk      => axiClk,        -- System clock
          refClk      => axiClk);       -- Stable Reference Clock
      mgtRefClk0FreqLatched(i) <= mgtRefClk0Freq(i) when (rising_edge(axiClk) and mgtRefClk0FreqUpdated(i) = '1');

    end generate;

    gen_refclk1 : if (REFCLK_1_CFG_G(i).enabled = true) generate
      U_MgtRefClkBuf : entity work.MgtRefClkBuf
        port map(
          mgtRefClkP    => mgtRefClk1P(i),
          mgtRefClkN    => mgtRefClk1N(i),
          mgtRefClk     => mgtRefClk(i)(1),
          mgtRefClkBufg => mgtRefClkBufg(i)(1)
          );

      U_SyncClockFreq_RefClk1 : entity work.SyncClockFreq
        generic map(
          REF_CLK_FREQ_G => AXI_CLK_FREQ_G,  -- Reference Clock frequency, units of Hz
          REFRESH_RATE_G => 1.0E+3,     -- Refresh rate, units of Hz
          COMMON_CLK_G   => true,  -- Set to true if (locClk = refClk) to save resources else false
          CNT_WIDTH_G    => 32)         -- Counters' width
        port map (
          -- Frequency Measurement and Monitoring Outputs (locClk domain)
          freqOut     => mgtRefClk1Freq(i),  -- units of Hz
          freqUpdated => mgtRefClk1FreqUpdated(i),
          -- Clocks
          clkIn       => mgtRefClkBufg(i)(1),  -- Input clock to measure
          locClk      => axiClk,        -- System clock
          refClk      => axiClk);       -- Stable Reference Clock

      mgtRefClk1FreqLatched(i) <= mgtRefClk1Freq(i) when (rising_edge(axiClk) and mgtRefClk1FreqUpdated(i) = '1'); end generate;
  end generate;

  gen_qpll : for i in QPLL_IDX_BTM_G to QPLL_IDX_TOP_G generate
    gen_qpllen : if (QPLL_CFG_G(i).enabled = true) generate

      drpEnQpllArr(i) <= drpEnQpll and drpEnQpllDec(i-QPLL_IDX_BTM_G);

      U_MgtQpll25g : entity work.MgtQpll25g
        port map(
          drpClk  => axiClk,
          drpEn   => drpEnQpllArr(i),
          drpWe   => drpWeQpll,
          drpRdy  => drpRdyQpllArr(i),
          drpAddr => drpAddrQpll,
          drpDi   => drpDiQpll,
          drpDo   => drpDoQpllArr(i),

          qPllRefClk        => mgtRefClk(QPLL_CFG_G(i).refclk0),  -- todo
          qPllLockDetClk(0) => axiClk,
          qPllLockDetClk(1) => axiClk,
          qPllReset         => qPllReset(i),

          qPllOutClk     => qPllOutClk(i),
          qPllOutRefClk  => qPllOutRefClk(i),
          qPllFbClkLost  => qPllFbClkLost(i),
          qPllLock       => qPllLock(i),
          qPllRefClkLost => qPllRefClkLost(i));
    end generate;
  end generate;

  gen_mgt : for i in MGT_IDX_BTM_G to MGT_IDX_TOP_G generate
    gen_mgt_en : if (MGT_CFG_G(i).kind /= mgt_none) generate

      mgtRxUsrClk(i)  <= mgtRxUsrClkInt(i);
      mgtRxDataArr(i) <= mgtRxDataArrInt(i);
      mgtTxUsrClk(i)  <= mgtTxUsrClkInt(i);

      --process (mgtRxUsrClkInt(i)) is
      --begin
      --  if rising_edge(mgtRxUsrClkInt(i)) then
      --    if (r.mgtRxPhyErrCntRst(i) = '1') then
      --      mgtRxPhyErrCnt(i) <= (others => '0');
      --    elsif (mgtRxPhyErrCnt(i) = x"FFFFFF") then
      --      mgtRxPhyErrCnt(i) <= x"FFFFFF";
      --    elsif(mgtRxDataArrInt(i).header = "00" or mgtRxDataArrInt(i).header = "11") then
      --      mgtRxPhyErrCnt(i) <= std_logic_vector(unsigned(mgtRxPhyErrCnt(i))+1);
      --    end if;
      --  end if;
      --end process;

      drpEnGtArr(i) <= drpEnGt and drpEnGtDec(i-MGT_IDX_BTM_G);

      U_MgtWrapper : entity work.MgtWrapper
        generic map (
          MGT_IDX_G => i,
          MGT_CFG_G => MGT_CFG_G
          )
        port map(
          clk_freerun => axiClk,
          MgtRxN      => MgtRxN(i),
          MgtRxP      => MgtRxP(i),
          MgtTxN      => MgtTxN(i),
          MgtTxP      => MgtTxP(i),

          mgtTxUsrClk => mgtTxUsrClkInt(i),
          mgtTxData   => mgtTxDataArr(i),
          mgtRxData   => mgtRxDataArrInt(i),
          mgtRxUsrClk => mgtRxUsrClkInt(i),

          mgtRxPrbsErr     => mgtRxPrbsErr(i),
          mgtRxGearboxSlip => mgtRxGearboxSlip(i),

          mgtSlwCtrl   => mgtSlwCtrlArr(i),
          mgtSlwStatus => mgtSlwStatusArr(i),

          qpllClk    => qPllOutClk(i/4),
          qpllRefClk => qPllOutRefClk(i/4),
          qpllLock   => qPllLock(i/4),

          drpAddr => drpAddrGt(9 downto 0),
          drpClk  => AxiClk,
          drpDi   => drpDiGt,
          drpEn   => drpEnGtArr(i),
          drpRst  => axiRst,
          drpWe   => drpWeGt,
          drpDo   => drpDoGtArr(i),
          drpRdy  => drpRdyGtArr(i)
          );
    end generate;
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

  U_AxiLiteToDrpGt : entity work.AxiLiteToDrp
    generic map (
      TPD_G            => TPD_G,
      COMMON_CLK_G     => true,
      EN_ARBITRATION_G => false,
      TIMEOUT_G        => 32,
      ADDR_WIDTH_G     => 10,
      DATA_WIDTH_G     => 16)
    port map (
      -- AXI-Lite Port
      axilClk         => axiClk,
      axilRst         => axiRst,
      axilReadMaster  => locAxiReadMasters(MGT_DRP_INDEX_C),
      axilReadSlave   => locAxiReadSlaves(MGT_DRP_INDEX_C),
      axilWriteMaster => locAxiWriteMasters(MGT_DRP_INDEX_C),
      axilWriteSlave  => locAxiWriteSlaves(MGT_DRP_INDEX_C),
      -- DRP Interface
      drpClk          => axiClk,
      drpRst          => axiRst,
      drpRdy          => drpRdyGt_d2,
      drpEn           => drpEnGt,
      drpWe           => drpWeGt,
      drpAddr         => drpAddrGt(9 downto 0),
      drpDi           => drpDiGt,
      drpDo           => drpDoGt);

  U_AxiLiteToDrpQpll : entity work.AxiLiteToDrp
    generic map (
      TPD_G            => TPD_G,
      COMMON_CLK_G     => true,
      EN_ARBITRATION_G => false,
      TIMEOUT_G        => 32,
      ADDR_WIDTH_G     => 8,
      DATA_WIDTH_G     => 16)
    port map (
      -- AXI-Lite Port
      axilClk         => axiClk,
      axilRst         => axiRst,
      axilReadMaster  => locAxiReadMasters(QPLL_DRP_INDEX_C),
      axilReadSlave   => locAxiReadSlaves(QPLL_DRP_INDEX_C),
      axilWriteMaster => locAxiWriteMasters(QPLL_DRP_INDEX_C),
      axilWriteSlave  => locAxiWriteSlaves(QPLL_DRP_INDEX_C),
      -- DRP Interface
      drpClk          => axiClk,
      drpRst          => axiRst,
      drpRdy          => drpRdyQpll_d2,
      drpEn           => drpEnQpll,
      drpWe           => drpWeQpll,
      drpAddr         => drpAddrQpll(7 downto 0),
      drpDi           => drpDiQpll,
      drpDo           => drpDoQpll);

  drpRdyGtArr_d1 <= drpRdyGtArr      when rising_edge(axiClk);
  drpRdyGt       <= uOr(drpRdyGtArr) when rising_edge(axiClk);
  drpRdyGt_d1    <= drpRdyGt         when rising_edge(axiClk);
  drpRdyGt_d2    <= drpRdyGt_d1      when rising_edge(axiClk);

  drpRdyQpllArr_d1 <= drpRdyQpllArr      when rising_edge(axiClk);
  drpRdyQpll       <= uOr(drpRdyQpllArr) when rising_edge(axiClk);
  drpRdyQpll_d1    <= drpRdyQpll         when rising_edge(axiClk);
  drpRdyQpll_d2    <= drpRdyQpll_d1      when rising_edge(axiClk);

  process(axiClk) is
  begin
    if (rising_edge(axiClk)) then
      if (drpRdyGt = '1') then
        gen_DrpDoGt : for i in MGT_IDX_BTM_G to MGT_IDX_TOP_G loop
          if (drpRdyGtArr_d1(i) = '1') then
            drpDoGtArrLat(i) <= drpDoGtArr(i);
          else
            drpDoGtArrLat(i) <= (others => '0');
          end if;
        end loop;
      end if;

      if (drpRdyQpll = '1') then
        gen_DrpDoQpll : for i in QPLL_IDX_BTM_G to QPLL_IDX_TOP_G loop
          if (drpRdyQpllArr_d1(i) = '1') then
            drpDoQpllArrLat(i) <= drpDoQpllArr(i);
          else
            drpDoQpllArrLat(i) <= (others => '0');
          end if;
        end loop;
      end if;
    end if;
  end process;

  gen_DrpDoAggr : for i in 0 to 15 generate
    gen_DrpDoQpll : for j in QPLL_IDX_BTM_G to QPLL_IDX_TOP_G generate
      drpDoQpllArrAggr(i, j) <= drpDoQpllArrLat(j)(i);
    end generate;

    gen_DrpDoGt : for j in MGT_IDX_BTM_G to MGT_IDX_TOP_G generate
      drpDoGtArrAggr(i, j) <= drpDoGtArrLat(j)(i);
    end generate;
  end generate;

  process(axiClk) is
  begin
    if rising_edge(axiClk) then
      for i in 0 to 15 loop
        drpDoQpll(i) <= uOr(muxSlVectorArray(drpDoQpllArrAggr, i));
      end loop;

      for i in 0 to 15 loop
        drpDoGt(i) <= uOr(muxSlVectorArray(drpDoGtArrAggr, i));
      end loop;

    end if;
  end process;

  drpEnGtDec   <= decode(r.drpGtSel);
  drpEnQpllDec <= decode(r.drpQpllSel);

  comb : process (axiRst, locAxiReadMasters, locAxiWriteMasters, r, mgtSlwStatusArr, mgtRxPhyErrCnt, mgtRefClk0FreqLatched, mgtRefClk1FreqLatched, qPllLock, qPllFbClkLost, qPllRefClkLost) is
    variable v      : RegType;
    variable axilEp : AxiLiteEndpointType;
  begin
    -- Latch the current value
    v := r;

    v.mgtRxPhyErrCntRst := (others => '0');

    ------------------------      
    -- AXI-Lite Transactions
    ------------------------      

    -- Determine the transaction type
    axiSlaveWaitTxn(axilEp, locAxiWriteMasters(REG_FILE_INDEX_C), locAxiReadMasters(REG_FILE_INDEX_C), v.axiWriteSlave, v.axiReadSlave);

-- General Register Section
    axiSlaveRegisterR(axilEp, toSlv(GENERAL_BASE_ADDR_C + MGT_SECTOR_CFG_REG_C, ADDR_BIT_CNT_C), 0, toSlv(12345, 7));
    axiSlaveRegister(axilEp, toSlv(GENERAL_BASE_ADDR_C + QPLL_DRP_SEL_REG_C, ADDR_BIT_CNT_C), 0, v.drpQpllSel);
    axiSlaveRegister(axilEp, toSlv(GENERAL_BASE_ADDR_C + MGT_DRP_REG_C, ADDR_BIT_CNT_C), 0, v.drpGtSel);

-- Refclk0 Register Section
    for i in REFCLK_PAIR_IDX_BTM_G to REFCLK_PAIR_IDX_TOP_G loop
      axiSlaveRegisterR(axilEp, toSlv(REFCLK0_BASE_ADDR_C + (i-REFCLK_PAIR_IDX_BTM_G)*REFCLK_CH2CH_OFFSET_C+REFCLK0_FREQ_REG_C, ADDR_BIT_CNT_C), 0, mgtRefClk0FreqLatched(i));
    end loop;

-- Refclk1 Register Section
    for i in REFCLK_PAIR_IDX_BTM_G to REFCLK_PAIR_IDX_TOP_G loop
      axiSlaveRegisterR(axilEp, toSlv(REFCLK1_BASE_ADDR_C + (i-REFCLK_PAIR_IDX_BTM_G)*REFCLK_CH2CH_OFFSET_C+REFCLK1_FREQ_REG_C, ADDR_BIT_CNT_C), 0, mgtRefClk1FreqLatched(i));
    end loop;

-- QPLL Register Section
    for i in QPLL_IDX_BTM_G to QPLL_IDX_TOP_G loop
      axiSlaveRegister(axilEp, toSlv(QPLL_BASE_ADDR_C + (i-QPLL_IDX_BTM_G)*QPLL_CH2CH_OFFSET_C + QPLL_RST_CTRL_REG_C, ADDR_BIT_CNT_C), 0, v.qPllReset(i));
      axiSlaveRegister(axilEp, toSlv(QPLL_BASE_ADDR_C + (i-QPLL_IDX_BTM_G)*QPLL_CH2CH_OFFSET_C + QPLL_CTRL_REG_C, ADDR_BIT_CNT_C), 0, v.qPllPowerDown(i));
      axiSlaveRegisterR(axilEp, toSlv(QPLL_BASE_ADDR_C + (i-QPLL_IDX_BTM_G)*QPLL_CH2CH_OFFSET_C + QPLL_STATUS_REG_C, ADDR_BIT_CNT_C), 0, qPllLock(i));
      axiSlaveRegisterR(axilEp, toSlv(QPLL_BASE_ADDR_C + (i-QPLL_IDX_BTM_G)*QPLL_CH2CH_OFFSET_C + QPLL_STATUS_REG_C, ADDR_BIT_CNT_C), 2, qPllFbClkLost(i));
      axiSlaveRegisterR(axilEp, toSlv(QPLL_BASE_ADDR_C + (i-QPLL_IDX_BTM_G)*QPLL_CH2CH_OFFSET_C + QPLL_STATUS_REG_C, ADDR_BIT_CNT_C), 4, qPllRefClkLost(i));

      qpllReset(i)     <= v.qpllReset(i);
      qpllPowerDown(i) <= v.qpllPowerDown(i);
    end loop;

-- MGT Register Section
    for i in MGT_IDX_BTM_G to MGT_IDX_TOP_G loop

      axiSlaveRegisterR(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_BCFG_REG_C, ADDR_BIT_CNT_C), 0, toSlv(i, 7));
      axiSlaveRegisterR(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+TX_BCFG_REG_C, ADDR_BIT_CNT_C), 0, toSlv(i+10, 7));

      axiSlaveRegisterR(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_STAT_REG_C, ADDR_BIT_CNT_C), 0, mgtSlwStatusArr(i).txInitDone);
      axiSlaveRegisterR(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_STAT_REG_C, ADDR_BIT_CNT_C), 1, mgtSlwStatusArr(i).rxInitDone);
      axiSlaveRegisterR(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_STAT_REG_C, ADDR_BIT_CNT_C), 2, mgtSlwStatusArr(i).rxPrbsLocked);

      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_RST_CTRL_REG_C, ADDR_BIT_CNT_C), 0, v.mgtSlwCtrlArr(i).mgtMasterRst);
      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_RST_CTRL_REG_C, ADDR_BIT_CNT_C), 1, v.mgtSlwCtrlArr(i).mgtRxRst);
      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_RST_CTRL_REG_C, ADDR_BIT_CNT_C), 2, v.mgtSlwCtrlArr(i).mgtTxRst);
      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_RST_CTRL_REG_C, ADDR_BIT_CNT_C), 3, v.mgtRxPhyErrCntRst(i));

      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+LOOPBACK_REG_C, ADDR_BIT_CNT_C), 0, v.mgtSlwCtrlArr(i).loopback);

      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_MAIN_CTRL_REG_C, ADDR_BIT_CNT_C), 0, v.mgtSlwCtrlArr(i).rxPd);
      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_MAIN_CTRL_REG_C, ADDR_BIT_CNT_C), 1, v.mgtSlwCtrlArr(i).rxPolarity);
      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_MAIN_CTRL_REG_C, ADDR_BIT_CNT_C), 2, v.mgtSlwCtrlArr(i).rxPrbsSel);

      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+TX_MAIN_CTRL_REG_C, ADDR_BIT_CNT_C), 0, v.mgtSlwCtrlArr(i).txPd);
      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+TX_MAIN_CTRL_REG_C, ADDR_BIT_CNT_C), 1, v.mgtSlwCtrlArr(i).txPolarity);
      axiSlaveRegister(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+TX_MAIN_CTRL_REG_C, ADDR_BIT_CNT_C), 2, v.mgtSlwCtrlArr(i).txPrbsSel);

      axiSlaveRegisterR(axilEp, toSlv((MGT_BASE_ADDR_C+(i-MGT_IDX_BTM_G)*MGT_CH2CH_OFFSET_C)+RX_PHY_ERR_CNT_REG_C, ADDR_BIT_CNT_C), 0, mgtRxPhyErrCnt(i));

      -- todo: replace with registerd version
      mgtSlwCtrlArr(i) <= v.mgtSlwCtrlArr(i);

    end loop;

    -- Close the transaction
    axiSlaveDefault(axilEp, v.axiWriteSlave, v.axiReadSlave, AXI_RESP_DECERR_C);

    --------
    -- Reset
    --------
    if (axiRst = '1') then
      v := REG_INIT_C;
    end if;

    -- Register the variable for next clock cycle
    rin <= v;

    -- Outputs 
    locAxiReadSlaves(REG_FILE_INDEX_C)  <= r.axiReadSlave;
    locAxiWriteSlaves(REG_FILE_INDEX_C) <= r.axiWriteSlave;

  end process comb;

  seq : process (axiClk) is
  begin
    if (rising_edge(axiClk)) then
      r <= rin after TPD_G;
    end if;
  end process seq;

  gen_sigs : for i in MGT_IDX_BTM_G to MGT_IDX_TOP_G generate
    mgtRxInitDone(i) <= mgtSlwStatusArr(i).rxInitDone;
    mgtTxInitDone(i) <= mgtSlwStatusArr(i).txInitDone;
  end generate;

end rtl;
