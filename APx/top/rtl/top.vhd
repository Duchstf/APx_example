library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.AxiStreamPkg.all;

use work.i2cPkg.all;

use work.MgtPkg.all;
use work.tcdsPkg.all;
use work.PrjSpecPkg.all;

entity top is
  generic (
    AURORA_LANES : integer := 2;
    TPD_G        : time    := 1 ns;
    BUILD_INFO_G : BuildInfoType;
    XIL_DEVICE_G : string  := "ULTRASCALE"
    );
  port (
    I2C_C2C_scl_io : inout std_logic;
    I2C_C2C_sda_io : inout std_logic;

    mgtRefClk0P : in slv(0 to REFCLK_CNT_C-1);
    mgtRefClk0N : in slv(0 to REFCLK_CNT_C-1);

    mgtRefClk1P : in slv(0 to REFCLK_CNT_C-1);
    mgtRefClk1N : in slv(0 to REFCLK_CNT_C-1);

    MgtRxN : in  slv(0 to MGT_CNT_C-1) := (others => '0');
    MgtRxP : in  slv(0 to MGT_CNT_C-1) := (others => '0');
    MgtTxN : out slv(0 to MGT_CNT_C-1) := (others => '0');
    MgtTxP : out slv(0 to MGT_CNT_C-1) := (others => '0');

    FP_LED           : out slv(2 downto 0);
    board_LED        : out slv(1 downto 0);
    clk_300_clk_n    : in  std_logic;
    clk_300_clk_p    : in  std_logic;
    gt_c2c_rx_rxn    : in  slv (AURORA_LANES-1 to 0);
    gt_c2c_rx_rxp    : in  slv (AURORA_LANES-1 to 0);
    gt_c2c_tx_txn    : out slv (AURORA_LANES-1 to 0);
    gt_c2c_tx_txp    : out slv (AURORA_LANES-1 to 0);
    refclk_c2c_clk_n : in  std_logic;
    refclk_c2c_clk_p : in  std_logic
    );
end top;

architecture rtl of top is

  signal clk_100  : sl;
  signal clk_80   : sl;
  signal clk_algo : sl;

  signal clk_333 : sl;

  constant C_heartbeat_cnt_max : integer := 100000000;
  signal heartbeat_cnt         : integer range 0 to C_heartbeat_cnt_max;
  signal fp_led_cnt            : integer range 0 to 7;
  signal bled                  : sl      := '0';

  signal axi_lite_clk    : std_logic;
  signal axi_lite_resetn : std_logic_vector (0 to 0);
  signal axi_lite_reset  : std_logic;

  constant AXI_CLK_FREQUENCY_G : real := 10.00E+6;

  constant NUM_AXI_MASTERS_C : natural := 5;

  constant VERSION_INDEX_C   : natural := 0;
  constant TCDS_INDEX_C      : natural := 1;
  constant ALGO_CTRL_INDEX_C : natural := 2;
  constant SYS_MON_INDEX_C   : natural := 3;
  constant APX_L1T_INDEX_C   : natural := 4;

  constant APX_L1T_BASE_ADDR_C : slv(31 downto 0) := x"7000_0000";

  -- constant AXI_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXI_MASTERS_C-1 downto 0) := genAxiLiteConfig(NUM_AXI_MASTERS_C, x"0000_0000", 20, 16);
  constant AXI_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXI_MASTERS_C-1 downto 0) := (
    VERSION_INDEX_C   => (
      baseAddr        => x"7200_0000",
      addrBits        => 16,
      connectivity    => x"FFFF"),
    TCDS_INDEX_C      => (
      baseAddr        => x"7400_0000",
      addrBits        => 16,
      connectivity    => x"FFFF"),
    SYS_MON_INDEX_C   => (
      baseAddr        => x"7500_0000",
      addrBits        => 16,
      connectivity    => x"FFFF"),
    ALGO_CTRL_INDEX_C => (
      baseAddr        => x"7600_0000",
      addrBits        => 16,
      connectivity    => x"FFFF"),
    APX_L1T_INDEX_C   => (
      baseAddr        => APX_L1T_BASE_ADDR_C,
      addrBits        => 22,
      connectivity    => x"FFFF"));

  signal mAxilWriteMasters : AxiLiteWriteMasterArray(NUM_AXI_MASTERS_C-1 downto 0);
  signal mAxilWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXI_MASTERS_C-1 downto 0) := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);
  signal mAxilReadMasters  : AxiLiteReadMasterArray(NUM_AXI_MASTERS_C-1 downto 0);
  signal mAxilReadSlaves   : AxiLiteReadSlaveArray(NUM_AXI_MASTERS_C-1 downto 0)  := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);

  signal mAxilWriteMaster : AxiLiteWriteMasterType;
  signal mAxilWriteSlave  : AxiLiteWriteSlaveType;
  signal mAxilReadMaster  : AxiLiteReadMasterType;
  signal mAxilReadSlave   : AxiLiteReadSlaveType;

  signal axiStreamAlgoIn  : AxiStreamMasterArray(0 to L1T_IN_STREAM_CNT_C -1);
  signal axiStreamAlgoOut : AxiStreamMasterArray(0 to L1T_OUT_STREAM_CNT_C -1);

  signal algoClk   : sl;
  signal algoRst   : sl;
  signal algoStart : sl;
  signal algoDone  : sl;
  signal algoIdle  : sl;
  signal algoReady : sl;

  signal tcdsClks  : slv(2 downto 0);
  signal fsClk40   : sl;
  signal fsClkMain : sl;
  signal fsClkDiv2 : sl;
  signal tcdsCmds  : tTcdsCmds;

begin

  U_bd_wrapper : entity work.bd_wrapper
    port map(
      clk100           => clk_100,
      clk80            => clk_80,
      refclk_c2c_clk_n => refclk_c2c_clk_n,
      refclk_c2c_clk_p => refclk_c2c_clk_p,
      clk_300_clk_n    => clk_300_clk_n,
      clk_300_clk_p    => clk_300_clk_p,
      gt_c2c_rx_rxn    => gt_c2c_rx_rxn,
      gt_c2c_rx_rxp    => gt_c2c_rx_rxp,
      gt_c2c_tx_txn    => gt_c2c_tx_txn,
      gt_c2c_tx_txp    => gt_c2c_tx_txp,

      I2C_C2C_scl_io => I2C_C2C_scl_io,
      I2C_C2C_sda_io => I2C_C2C_sda_io,

      mAxiClk          => axi_lite_clk,
      mAxiRst          => axi_lite_reset,
      mAxilWriteMaster => mAxilWriteMaster,
      mAxilWriteSlave  => mAxilWriteSlave,
      mAxilReadMaster  => mAxilReadMaster,
      mAxilReadSlave   => mAxilReadSlave
      );

  process(clk_100) is
  begin
    if (rising_edge(clk_100)) then
      if (heartbeat_cnt = C_heartbeat_cnt_max-1) then
        heartbeat_cnt <= 0;
        bled          <= not bled;
        fp_led_cnt    <= fp_led_cnt + 1;
      else
        heartbeat_cnt <= heartbeat_cnt + 1;

      end if;
    end if;
  end process;

  fp_led       <= std_logic_vector(to_unsigned(fp_led_cnt, 3));
  board_led(0) <= bled;
  board_led(1) <= bled;

---------------------------
  -- AXI-Lite Crossbar Module
  ---------------------------         
  U_XBAR : entity work.AxiLiteCrossbar
    generic map (
      TPD_G              => TPD_G,
      NUM_SLAVE_SLOTS_G  => 1,
      NUM_MASTER_SLOTS_G => NUM_AXI_MASTERS_C,
      MASTERS_CONFIG_G   => AXI_CONFIG_C)
    port map (
      sAxiWriteMasters(0) => mAxilWriteMaster,
      sAxiWriteSlaves(0)  => mAxilWriteSlave,
      sAxiReadMasters(0)  => mAxilReadMaster,
      sAxiReadSlaves(0)   => mAxilReadSlave,
      mAxiWriteMasters    => mAxilWriteMasters,
      mAxiWriteSlaves     => mAxilWriteSlaves,
      mAxiReadMasters     => mAxilReadMasters,
      mAxiReadSlaves      => mAxilReadSlaves,
      axiClk              => axi_lite_clk,
      axiClkRst           => axi_lite_reset);

  ---------------------------
  -- AXI-Lite: Version Module
  ---------------------------            
  U_AxiVersion : entity work.AxiVersion
    generic map (
      TPD_G           => TPD_G,
      CLK_PERIOD_G    => (1.0/AXI_CLK_FREQUENCY_G),
      BUILD_INFO_G    => BUILD_INFO_G,
      XIL_DEVICE_G    => XIL_DEVICE_G,
      EN_DEVICE_DNA_G => false)
    port map (
      axiReadMaster  => mAxilReadMasters(VERSION_INDEX_C),
      axiReadSlave   => mAxilReadSlaves(VERSION_INDEX_C),
      axiWriteMaster => mAxilWriteMasters(VERSION_INDEX_C),
      axiWriteSlave  => mAxilWriteSlaves(VERSION_INDEX_C),
      axiClk         => axi_lite_clk,
      axiRst         => axi_lite_reset);

  U_tcdsCtrl : entity work.tcdsCtrl
    generic map(
      TPD_G          => TPD_G,
      AXI_CLK_FREQ_G => AXI_CLK_FREQUENCY_G,

      FS_TO_LHC_CLK_FACTOR_G => FS_TO_LHC_CLK_FACTOR_C)
    port map(
      oscClk80  => clk_80,
      fsClk40   => fsClk40,
      fsClkMain => fsClkMain,
      fsClkDiv2 => fsClkDiv2,

      tcdsCmds => tcdsCmds,

      -- AXI-Lite Bus
      axiReadMaster  => mAxilReadMasters(TCDS_INDEX_C),
      axiReadSlave   => mAxilReadSlaves(TCDS_INDEX_C),
      axiWriteMaster => mAxilWriteMasters(TCDS_INDEX_C),
      axiWriteSlave  => mAxilWriteSlaves(TCDS_INDEX_C),
      axiClk         => axi_lite_clk,
      axiClkRst      => axi_lite_reset);

  U_algoCtrl : entity work.algoCtrl
    generic map (
      TPD_G => TPD_G)
    port map(
      algoClk   => clk_algo,
      algoRst   => algoRst,
      algoStart => algoStart,
      algoDone  => algoDone,
      algoIdle  => algoIdle,
      algoReady => algoReady,

      tcdsCmds => tcdsCmds,

      -- AXI-Lite Bus
      axiReadMaster  => mAxilReadMasters(ALGO_CTRL_INDEX_C),
      axiReadSlave   => mAxilReadSlaves(ALGO_CTRL_INDEX_C),
      axiWriteMaster => mAxilWriteMasters(ALGO_CTRL_INDEX_C),
      axiWriteSlave  => mAxilWriteSlaves(ALGO_CTRL_INDEX_C),
      axiClk         => axi_lite_clk,
      axiClkRst      => axi_lite_reset);

  clk_algo <= fsClkMain;

  --------------------------
  -- AXI-Lite: SYSMON Module
  --------------------------
  U_SysMon : entity work.SystemManagementWrapper
    generic map (
      TPD_G => TPD_G)
    port map (
      axiReadMaster  => mAxilReadMasters(SYS_MON_INDEX_C),
      axiReadSlave   => mAxilReadSlaves(SYS_MON_INDEX_C),
      axiWriteMaster => mAxilWriteMasters(SYS_MON_INDEX_C),
      axiWriteSlave  => mAxilWriteSlaves(SYS_MON_INDEX_C),
      axiClk         => axi_lite_clk,
      axiRst         => axi_lite_reset,
      vPIn           => '0',
      vNIn           => '1');

  U_ApxL1TTop : entity work.ApxL1TTop
    generic map(
      AXIL_BASE_ADDR_G => APX_L1T_BASE_ADDR_C,
      REFCLK_0_CFG_G   => RefClk0CfgImpl_C,
      REFCLK_1_CFG_G   => RefClk1CfgImpl_C,
      QPLL_CFG_G       => QpllCfgImpl_C,
      MGT_CFG_G        => MgtCfgImpl_C,
      APX_L1T_CFG_G    => apxL1TCfgArrImpl
      )
    port map(
      -- AXI-Lite Bus
      axiReadMaster  => mAxilReadMasters(APX_L1T_INDEX_C),
      axiReadSlave   => mAxilReadSlaves(APX_L1T_INDEX_C),
      axiWriteMaster => mAxilWriteMasters(APX_L1T_INDEX_C),
      axiWriteSlave  => mAxilWriteSlaves(APX_L1T_INDEX_C),
      axiClk         => axi_lite_clk,
      axiRst         => axi_lite_reset,

--    MgtRxN => (others => '1'),
--      MgtRxP => (others => '0'),
--      MgtTxN => open,
--      MgtTxP => open,

      MgtRxN => MgtRxN,
      MgtRxP => MgtRxP,
      MgtTxN => MgtTxN,
      MgtTxP => MgtTxP,

      mgtRefClk0P => mgtRefClk0P,
      mgtRefClk0N => mgtRefClk0N,
      mgtRefClk1P => mgtRefClk1P,
      mgtRefClk1N => mgtRefClk1N,

      tcdsCmds => tcdsCmds,

      -- AXI-Stream In/Out Ports
      axiStreamClk => clk_algo,
      axiStreamIn  => axiStreamAlgoOut,
      axiStreamOut => axiStreamAlgoIn
      );

  U_algoTopWrapper : entity work.algoTopWrapper
    generic map(
      N_INPUT_STREAMS  => L1T_IN_STREAM_CNT_C,
      N_OUTPUT_STREAMS => L1T_OUT_STREAM_CNT_C
      )
    port map(
      -- Algo Control/Status Signals
      algoClk   => clk_algo,
      algoRst   => algoRst,
      algoStart => algoStart,
      algoDone  => algoDone,
      algoIdle  => algoIdle,
      algoReady => algoReady,

      -- AXI-Stream In/Out Ports
      axiStreamIn  => axiStreamAlgoIn,
      axiStreamOut => axiStreamAlgoOut
      );

end architecture;
