library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.AxiStreamPkg.all;

use work.MgtPkg.all;
use work.tcdsPkg.all;
use work.ApxL1TPkg.all;

entity ApxL1TSector is
  generic (
    TPD_G : time := 1 ns;

    AXI_CLK_FREQ_G : real := 10.0E+6;

    REFCLK_0_CFG_G : tRefClkCfgArr;
    REFCLK_1_CFG_G : tRefClkCfgArr;
    QPLL_CFG_G     : tQpllCfgArr;
    MGT_CFG_G      : tMgtCfgArr;
    APX_L1T_CFG_G  : tApxL1TCfgArr;

    REFCLK_PAIR_IDX_BTM_G : integer;
    REFCLK_PAIR_IDX_TOP_G : integer;

    QPLL_IDX_BTM_G : integer;
    QPLL_IDX_TOP_G : integer;

    MGT_IDX_BTM_G : integer;
    MGT_IDX_TOP_G : integer;

    APX_L1T_IDX_BTM_G : integer;
    APX_L1T_IDX_TOP_G : integer;

    AXIL_BASE_ADDR_G : slv(31 downto 0) := x"00000000"
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
    mgtRefClk0P : in slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');
    mgtRefClk0N : in slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');
    mgtRefClk1P : in slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');
    mgtRefClk1N : in slv(REFCLK_PAIR_IDX_BTM_G to + REFCLK_PAIR_IDX_TOP_G) := (others => '0');

    -- Mgt Rx/Tx pins
    MgtRxN : in  slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    MgtRxP : in  slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    MgtTxN : out slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');
    MgtTxP : out slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G) := (others => '0');

    -- AXI-Stream In/Out Ports
    axiStreamClk : in  sl;
    axiStreamIn  : in  AxiStreamMasterArray(APX_L1T_IDX_BTM_G to APX_L1T_IDX_TOP_G);
    axiStreamOut : out AxiStreamMasterArray(APX_L1T_IDX_BTM_G to APX_L1T_IDX_TOP_G)
    );
end ApxL1TSector;

architecture rtl of ApxL1TSector is

  constant NUM_AXIL_MASTERS_C : natural := 5;

  constant MGT_INDEX_C          : natural := 0;
  constant IRIDIS_SF_RX_INDEX_C : natural := 1;
  constant IRIDIS_SF_TX_INDEX_C : natural := 2;
  constant LINK_BUF_RX_INDEX_C  : natural := 3;
  constant LINK_BUF_TX_INDEX_C  : natural := 4;

  constant MGT_BASE_ADDR_C          : slv(31 downto 0) := slv(unsigned(AXIL_BASE_ADDR_G) + x"0_0000");
  constant IRIDIS_SF_RX_BASE_ADDR_C : slv(31 downto 0) := slv(unsigned(AXIL_BASE_ADDR_G) + x"4_0000");
  constant IRIDIS_SF_TX_BASE_ADDR_C : slv(31 downto 0) := slv(unsigned(AXIL_BASE_ADDR_G) + x"5_0000");
  constant LINK_BUF_RX_BASE_ADDR_C  : slv(31 downto 0) := slv(unsigned(AXIL_BASE_ADDR_G) + x"6_0000");
  constant LINK_BUF_TX_BASE_ADDR_C  : slv(31 downto 0) := slv(unsigned(AXIL_BASE_ADDR_G) + x"7_0000");

  constant XBAR_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXIL_MASTERS_C-1 downto 0) := (
    MGT_INDEX_C          => (
      baseAddr           => MGT_BASE_ADDR_C,
      addrBits           => 18,
      connectivity       => x"FFFF"),
    IRIDIS_SF_RX_INDEX_C => (
      baseAddr           => IRIDIS_SF_RX_BASE_ADDR_C,
      addrBits           => 16,
      connectivity       => x"FFFF"),
    IRIDIS_SF_TX_INDEX_C => (
      baseAddr           => IRIDIS_SF_TX_BASE_ADDR_C,
      addrBits           => 16,
      connectivity       => x"FFFF"),
    LINK_BUF_RX_INDEX_C  => (
      baseAddr           => LINK_BUF_RX_BASE_ADDR_C,
      addrBits           => 16,
      connectivity       => x"FFFF"),
    LINK_BUF_TX_INDEX_C  => (
      baseAddr           => LINK_BUF_TX_BASE_ADDR_C,
      addrBits           => 16,
      connectivity       => x"FFFF")
    );

  signal locAxiWriteMasters : AxiLiteWriteMasterArray(NUM_AXIL_MASTERS_C-1 downto 0) := (others => AXI_LITE_WRITE_MASTER_INIT_C);
  signal locAxiWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);
  signal locAxiReadMasters  : AxiLiteReadMasterArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_READ_MASTER_INIT_C);
  signal locAxiReadSlaves   : AxiLiteReadSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)   := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);

  signal axiStreamRxIn  : AxiStreamMasterArray(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal axiStreamRxOut : AxiStreamMasterArray(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal axiStreamTxIn  : AxiStreamMasterArray(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal axiStreamTxOut : AxiStreamMasterArray(MGT_IDX_BTM_G to MGT_IDX_TOP_G);

  signal mgtRxUsrClk      : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal mgtRxInitDone    : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal mgtRxGearboxSlip : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal mgtRxDataArr     : tMgtRxDataArr(MGT_IDX_BTM_G to MGT_IDX_TOP_G);

  signal mgtTxUsrClk   : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal mgtTxInitDone : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal mgtTxDataArr  : tMgtTxDataArr(MGT_IDX_BTM_G to MGT_IDX_TOP_G);

  -- Mgt Rx/Tx Misc
  signal mgtTxExtRst : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G);
  signal mgtRxExtRst : slv(MGT_IDX_BTM_G to MGT_IDX_TOP_G);

  signal tcdsCmdsD1 : tTcdsCmds;

  attribute max_fanout               : integer;
  attribute max_fanout of tcdsCmdsD1 : signal is 32;

begin

  tcdsCmdsD1 <= tcdsCmds when rising_edge(axiStreamClk);

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

  U_MgtCtrl : entity work.MgtCtrl
    generic map(
      TPD_G => TPD_G,

      AXI_CLK_FREQ_G => 10.0E+6,  -- Reference Clock frequency, units of Hz

      REFCLK_0_CFG_G => REFCLK_0_CFG_G,
      REFCLK_1_CFG_G => REFCLK_1_CFG_G,
      QPLL_CFG_G     => QPLL_CFG_G,
      MGT_CFG_G      => MGT_CFG_G,

      REFCLK_PAIR_IDX_BTM_G => REFCLK_PAIR_IDX_BTM_G,
      REFCLK_PAIR_IDX_TOP_G => REFCLK_PAIR_IDX_TOP_G,

      QPLL_IDX_BTM_G => QPLL_IDX_BTM_G,
      QPLL_IDX_TOP_G => QPLL_IDX_TOP_G,

      MGT_IDX_BTM_G => MGT_IDX_BTM_G,
      MGT_IDX_TOP_G => MGT_IDX_TOP_G,

      AXIL_BASE_ADDR_G => MGT_BASE_ADDR_C

      )
    port map(
      -- AXI-Lite Bus
      axiClk         => axiClk,
      axiRst         => axiRst,
      axiReadMaster  => locAxiReadMasters(MGT_INDEX_C),
      axiReadSlave   => locAxiReadSlaves(MGT_INDEX_C),
      axiWriteMaster => locAxiWriteMasters(MGT_INDEX_C),
      axiWriteSlave  => locAxiWriteSlaves(MGT_INDEX_C),

      MgtRxN => MgtRxN,
      MgtRxP => MgtRxP,
      MgtTxN => MgtTxN,
      MgtTxP => MgtTxP,

      mgtRefClk0P => mgtRefClk0P,
      mgtRefClk0N => mgtRefClk0N,
      mgtRefClk1P => mgtRefClk1P,
      mgtRefClk1N => mgtRefClk1N,

      mgtRxUsrClk  => mgtRxUsrClk,
      mgtRxDataArr => mgtRxDataArr,
      mgtTxUsrClk  => mgtTxUsrClk,
      mgtTxDataArr => mgtTxDataArr,

      mgtTxExtRst      => mgtTxExtRst,
      mgtRxExtRst      => mgtRxExtRst,
      mgtRxGearboxSlip => mgtRxGearboxSlip,
      mgtRxInitDone    => mgtRxInitDone,
      mgtTxInitDone    => mgtTxInitDone
      );

  U_IridisSfRxCtrl : entity work.IridisSfRxCtrl
    generic map(
      TPD_G         => TPD_G,
      IDX_BTM_G     => MGT_IDX_BTM_G,
      IDX_TOP_G     => MGT_IDX_TOP_G,
      MGT_CFG_G     => MGT_CFG_G
      )
    port map(
      tcdsCmds => tcdsCmdsD1,

      -- MGT interface
      mgtRxClk         => mgtRxUsrClk,
      mgtRxInitDone    => mgtRxInitDone,
      mgtRxDataArr     => mgtRxDataArr,
      mgtRxGearboxSlip => mgtRxGearboxSlip,

      -- AXI-Lite Bus
      axiClk         => axiClk,
      axiRst         => axiRst,
      axiReadMaster  => locAxiReadMasters(IRIDIS_SF_RX_INDEX_C),
      axiReadSlave   => locAxiReadSlaves(IRIDIS_SF_RX_INDEX_C),
      axiWriteMaster => locAxiWriteMasters(IRIDIS_SF_RX_INDEX_C),
      axiWriteSlave  => locAxiWriteSlaves(IRIDIS_SF_RX_INDEX_C),

      -- AXI-Stream In/Out Ports
      axiStreamClk => axiStreamClk,
      axiStreamOut => axiStreamRxIn
      );

  u_IridisSfTxCtrl : entity work.IridisSfTxCtrl
    generic map(
      TPD_G         => TPD_G,
      IDX_BTM_G     => MGT_IDX_BTM_G,
      IDX_TOP_G     => MGT_IDX_TOP_G,
      MGT_CFG_G     => MGT_CFG_G
      )
    port map(
      tcdsCmds => tcdsCmdsD1,

      mgtTxClk      => mgtTxUsrClk,
      mgtTxInitDone => mgtTxInitDone,
      mgtTxDataArr  => mgtTxDataArr,

      -- AXI-Lite Bus
      axiClk         => axiClk,
      axiRst         => axiRst,
      axiReadMaster  => locAxiReadMasters(IRIDIS_SF_TX_INDEX_C),
      axiReadSlave   => locAxiReadSlaves(IRIDIS_SF_TX_INDEX_C),
      axiWriteMaster => locAxiWriteMasters(IRIDIS_SF_TX_INDEX_C),
      axiWriteSlave  => locAxiWriteSlaves(IRIDIS_SF_TX_INDEX_C),

      -- AXI-Stream In/Out Ports
      axiStreamClk => axiStreamClk,
      axiStream    => axiStreamTxOut
      );

  U_LinkStreamBuffer72bRx : entity work.LinkStreamBufferCtrl
    generic map(
      TPD_G         => TPD_G,
      IDX_BTM_G     => MGT_IDX_BTM_G,
      IDX_TOP_G     => MGT_IDX_TOP_G,
      BUF_POS_G     => "RX",
      APX_L1T_CFG_G => APX_L1T_CFG_G
      )
    port map(
      tcdsCmds => tcdsCmdsD1,

      -- AXI-Lite Bus
      axiClk         => axiClk,
      axiRst         => axiRst,
      axiReadMaster  => locAxiReadMasters(LINK_BUF_RX_INDEX_C),
      axiReadSlave   => locAxiReadSlaves(LINK_BUF_RX_INDEX_C),
      axiWriteMaster => locAxiWriteMasters(LINK_BUF_RX_INDEX_C),
      axiWriteSlave  => locAxiWriteSlaves(LINK_BUF_RX_INDEX_C),

      -- AXI-Stream In/Out Ports
      axiStreamClk => axiStreamClk,
      axiStreamIn  => axiStreamRxIn,
      axiStreamOut => axiStreamRxOut
      );

  U_LinkStreamBuffer72bTx : entity work.LinkStreamBufferCtrl
    generic map(
      TPD_G         => TPD_G,
      IDX_BTM_G     => MGT_IDX_BTM_G,
      IDX_TOP_G     => MGT_IDX_TOP_G,
      BUF_POS_G     => "TX",
      APX_L1T_CFG_G => APX_L1T_CFG_G
      )
    port map(
      tcdsCmds => tcdsCmdsD1,

      -- AXI-Lite Bus
      axiClk         => axiClk,
      axiRst         => axiRst,
      axiReadMaster  => locAxiReadMasters(LINK_BUF_TX_INDEX_C),
      axiReadSlave   => locAxiReadSlaves(LINK_BUF_TX_INDEX_C),
      axiWriteMaster => locAxiWriteMasters(LINK_BUF_TX_INDEX_C),
      axiWriteSlave  => locAxiWriteSlaves(LINK_BUF_TX_INDEX_C),

      -- AXI-Stream In/Out Ports
      axiStreamClk => axiStreamClk,
      axiStreamIn  => axiStreamTxIn,
      axiStreamOut => axiStreamTxOut
      );

  axiStreamOut  <= axiStreamRxOut;
  axiStreamTxIn <= axiStreamIn;

end rtl;
