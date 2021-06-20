library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;

use work.tcdsPkg.all;

entity tcdsCtrl is
  generic (
    TPD_G                  : time                  := 1 ns;
    SIMULATION_G           : boolean               := false;
    MGT_DEC_INCLUDE_G      : boolean               := false;
    AXI_CLK_FREQ_G         : real                  := 10.0E+6;
    NUM_FS_CLOCKS_G        : natural range 1 to 6  := 5;
    FS_TO_LHC_CLK_FACTOR_G : natural range 1 to 12 := 8);
  port (

    refclk_n : in std_logic := '0';
    refclk_p : in std_logic := '0';

    oscClk40 : in sl := '0';
    oscClk80 : in sl := '0';

    fsClkMain : out sl;
    fsClkDiv2 : out sl;
    fsClk40   : out sl;
    fsClk240  : out sl;
    fsClk120  : out sl;
    
    tcdsCmds : out tTcdsCmds;

    -- AXI-Lite Bus
    axiClk         : in  sl                     := '0';
    axiClkRst      : in  sl                     := '0';
    axiReadMaster  : in  AxiLiteReadMasterType  := AXI_LITE_READ_MASTER_INIT_C;
    axiReadSlave   : out AxiLiteReadSlaveType;
    axiWriteMaster : in  AxiLiteWriteMasterType := AXI_LITE_WRITE_MASTER_INIT_C;
    axiWriteSlave  : out AxiLiteWriteSlaveType);
end tcdsCtrl;

architecture rtl of tcdsCtrl is

  component fifoMgtDec
    port (
      wr_clk : in  std_logic;
      rd_clk : in  std_logic;
      din    : in  std_logic_vector(7 downto 0);
      wr_en  : in  std_logic;
      rd_en  : in  std_logic;
      dout   : out std_logic_vector(7 downto 0);
      full   : out std_logic;
      empty  : out std_logic
      );
  end component;

  type RegType is record
    clkMgrRst       : sl;
    mgtMasterRst    : sl;
    mgtTxRst        : sl;
    mgtRxRst        : sl;
    mgtTxPrbsSel    : slv(3 downto 0);
    mgtRxPrbsSel    : slv(3 downto 0);
    mgtDecErrCntRst : sl;
    clkSel          : sl;
    axiReadSlave    : AxiLiteReadSlaveType;
    axiWriteSlave   : AxiLiteWriteSlaveType;
  end record RegType;

  constant REG_INIT_C : RegType := (
    clkMgrRst       => '0',
    mgtMasterRst    => '0',
    mgtRxRst        => '0',
    mgtTxRst        => '0',
    mgtTxPrbsSel    => (others => '0'),
    mgtRxPrbsSel    => (others => '0'),
    mgtDecErrCntRst => '0',
    clkSel          => '0',
    axiReadSlave    => AXI_LITE_READ_SLAVE_INIT_C,
    axiWriteSlave   => AXI_LITE_WRITE_SLAVE_INIT_C);

  signal r   : RegType := REG_INIT_C;
  signal rin : RegType;

  signal clkMgrRst                      : sl := '0';
  signal clkMgrLocked, clkMgrLockedSync : sl := '0';
  signal fsClks                         : slv(NUM_FS_CLOCKS_G-1 downto 0);

  signal subBxFreeRunCnt : integer range 0 to 65535 := 0;

  signal bc0FreeRun : sl := '0';

  signal fsClkMainFreqUpdated : sl;
  signal fsClkMainFreq        : slv(31 downto 0);
  signal fsClkMainFreqLatched : slv(31 downto 0);

  signal mgtClkFreqUpdated : sl;
  signal mgtClkFreq        : slv(31 downto 0);
  signal mgtClkFreqLatched : slv(31 downto 0);

  signal mgtMasterRst : sl;
  signal mgtTxRst     : sl;
  signal mgtRxRst     : sl;
  signal mgtRxUsrClk  : sl;
  signal mgtTxUsrClk  : sl;

  signal mgtTxDoneOut : std_logic;
  signal mgtRxDoneOut : std_logic;

  signal mgtRxPrbsSel : std_logic_vector(3 downto 0);
  signal mgtTxPrbsSel : std_logic_vector(3 downto 0);

  signal clk80  : sl;
  signal clkSel : sl;

  signal mgtDecErr                            : sl;
  signal mgtDecErrCntRst, mgtDecErrCntRstSync : sl;
  signal mgtDecErrCnt                         : slv(31 downto 0);

  signal mgtBc0, mgtBc0Sync, mgtBc0Edge                : sl;
  signal mgtL1A, mgtL1ASync, mgtL1AEdge                : sl;
  signal mgtResync, mgtResyncSync, mgtResyncEdge       : sl;
  signal mgtStart, mgtStartSync, mgtStartEdge          : sl;
  signal mgtStop, mgtStopSync, mgtStopEdge             : sl;
  signal mgtEC0, mgtEC0Sync, mgtEC0Edge                : sl;
  signal mgtTestSync, mgtTestSyncSync, mgtTestSyncEdge : sl;

  signal fifoMgtDecIn  : slv(7 downto 0);
  signal fifoMgtDecOut : slv(7 downto 0);

  signal bc0Cnt : slv(15 downto 0);

begin

  BUFGMUX_CTRL_inst : BUFGMUX_CTRL
    port map (
      O  => clk80,                      -- 1-bit output: Clock output
      I0 => oscClk80,                   -- 1-bit input: Clock input (S=0)
      I1 => mgtRxUsrClk,                -- 1-bit input: Clock input (S=1)
      S  => clkSel                      -- 1-bit input: Clock select
      );

  gen_mgt_dec : if MGT_DEC_INCLUDE_G = true generate
    U_tcds3p2MgtDec : entity work.tcds3p2MgtDec
      port map(
        refclk_n => refclk_n,
        refclk_p => refclk_p,
        mgtRxN   => '1',
        mgtRxP   => '0',
        mgtTxN   => open,
        mgtTxP   => open,

        sysclk => axiClk,

        mgtMasterRst => mgtMasterRst,
        mgtTxRst     => mgtTxRst,
        mgtRxRst     => mgtMasterRst,

        mgtRxPrbsSel => mgtRxPrbsSel,
        mgtTxPrbsSel => mgtTxPrbsSel,

        mgtDecErr => mgtDecErr,

        mgtBc0      => mgtBc0,
        mgtL1A      => mgtL1A,
        mgtResync   => mgtResync,
        mgtStart    => mgtStart,
        mgtStop     => mgtStop,
        mgtEC0      => mgtEC0,
        mgtTestSync => mgtTestSync,

        mgtTxUsrClk => mgtTxUsrClk,
        mgtRxUsrClk => mgtRxUsrClk,

        mgtTxDoneOut => mgtTxDoneOut,
        mgtRxDoneOut => mgtRxDoneOut
        );

    fifoMgtDecIn(0) <= mgtBc0;
    fifoMgtDecIn(1) <= mgtL1A;
    fifoMgtDecIn(2) <= mgtResync;
    fifoMgtDecIn(3) <= mgtStart;
    fifoMgtDecIn(4) <= mgtStop;
    fifoMgtDecIn(5) <= mgtEC0;
    fifoMgtDecIn(6) <= mgtTestSync;
    fifoMgtDecIn(7) <= '0';

    U_fifoMgtDec : fifoMgtDec
      port map (
        wr_clk => mgtRxUsrClk,
        rd_clk => fsClks(0),
        din    => fifoMgtDecIn,
        dout   => fifoMgtDecOut,
        wr_en  => '1',
        rd_en  => '1',
        full   => open,
        empty  => open
        );

    mgtBc0Sync      <= fifoMgtDecOut(0);
    mgtL1ASync      <= fifoMgtDecOut(1);
    mgtResyncSync   <= fifoMgtDecOut(2);
    mgtStartSync    <= fifoMgtDecOut(3);
    mgtStopSync     <= fifoMgtDecOut(4);
    mgtEC0Sync      <= fifoMgtDecOut(5);
    mgtTestSyncSync <= fifoMgtDecOut(6);

    U_SynchronizerEdgeBC0 : entity work.SynchronizerEdge
      generic map(
        BYPASS_SYNC_G => true)
      port map(
        clk        => fsClks(0),
        dataIn     => mgtBc0Sync,
        risingEdge => mgtBc0Edge);

    U_SynchronizerEdgeL1A : entity work.SynchronizerEdge
      generic map(
        BYPASS_SYNC_G => true)
      port map(
        clk        => fsClks(0),
        dataIn     => mgtL1ASync,
        risingEdge => mgtL1AEdge);

    U_SynchronizerResync : entity work.SynchronizerEdge
      generic map(
        BYPASS_SYNC_G => true)
      port map(
        clk        => fsClks(0),
        dataIn     => mgtResyncSync,
        risingEdge => mgtResyncEdge);

    U_SynchronizerStart : entity work.SynchronizerEdge
      generic map(
        BYPASS_SYNC_G => true)
      port map(
        clk        => fsClks(0),
        dataIn     => mgtStartSync,
        risingEdge => mgtStartEdge);

    U_SynchronizerStop : entity work.SynchronizerEdge
      generic map(
        BYPASS_SYNC_G => true)
      port map(
        clk        => fsClks(0),
        dataIn     => mgtStopSync,
        risingEdge => mgtStopEdge);

    U_SynchronizerEdgeEC0 : entity work.SynchronizerEdge
      generic map(
        BYPASS_SYNC_G => true)
      port map(
        clk        => fsClks(0),
        dataIn     => mgtEC0Sync,
        risingEdge => mgtEC0Edge);

    U_SynchronizerEdgeTestSync : entity work.SynchronizerEdge
      generic map(
        BYPASS_SYNC_G => true)
      port map(
        clk        => fsClks(0),
        dataIn     => mgtTestSyncSync,
        risingEdge => mgtTestSyncEdge);
  end generate;

  process(fsClks(0)) is
  begin
    if rising_edge(fsClks(0)) then
      subBxFreeRunCnt <= subBxFreeRunCnt + 1;
      bc0FreeRun      <= '0';
      if (subBxFreeRunCnt = FS_TO_LHC_CLK_FACTOR_G * LHC_BX_CNT_C -1) then
        bc0FreeRun      <= '1';
        subBxFreeRunCnt <= 0;
      end if;
    end if;
  end process;

  U_ClockManager : entity work.ClockManagerUltraScale
    generic map(
      SIMULATION_G       => SIMULATION_G,
      INPUT_BUFG_G       => false,
      NUM_CLOCKS_G       => NUM_FS_CLOCKS_G,
      CLKIN_PERIOD_G     => 12.5, -- 80 MHz
      DIVCLK_DIVIDE_G    => 1,
      CLKFBOUT_MULT_F_G  => ClkMgrCfg(FS_TO_LHC_CLK_FACTOR_G).CLKFBOUT_MULT_F,
      CLKOUT0_DIVIDE_F_G => ClkMgrCfg(FS_TO_LHC_CLK_FACTOR_G).CLKOUT0_DIVIDE_F,
      CLKOUT1_DIVIDE_G   => ClkMgrCfg(FS_TO_LHC_CLK_FACTOR_G).CLKOUT1_DIVIDE,
      CLKOUT2_DIVIDE_G   => ClkMgrCfg(FS_TO_LHC_CLK_FACTOR_G).CLKOUT2_DIVIDE,
      CLKOUT3_DIVIDE_G   => ClkMgrCfg(FS_TO_LHC_CLK_FACTOR_G).CLKOUT3_DIVIDE,
      CLKOUT4_DIVIDE_G   => ClkMgrCfg(FS_TO_LHC_CLK_FACTOR_G).CLKOUT4_DIVIDE
      )
    port map(
      clkIn  => clk80,
      rstIn  => clkMgrRst,
      clkOut => fsClks,
      locked => clkMgrLocked);

  fsClkMain <= fsClks(0);
  fsClkDiv2 <= fsClks(1);
  fsClk40   <= fsClks(2);
  fsClk240  <= fsClks(3);
  fsClk120  <= fsClks(4);

  U_SyncLocked : entity work.Synchronizer
    port map (
      clk     => axiClk,
      dataIn  => clkMgrLocked,
      dataOut => clkMgrLockedSync
      );

  process (fsClks(0)) is
  begin
    if (rising_edge(fsClks(0))) then
      if (clkSel = '0') then            -- internally generated 40MHz clock
        tcdsCmds.bc0      <= bc0FreeRun;
        tcdsCmds.L1A      <= '0';
        tcdsCmds.Resync   <= '0';
        tcdsCmds.Start    <= '0';
        tcdsCmds.Stop     <= '0';
        tcdsCmds.EC0      <= '0';
        tcdsCmds.TestSync <= '0';
      else                              -- TCDS recovered clocks
        tcdsCmds.bc0      <= mgtBc0Edge;
        tcdsCmds.L1A      <= mgtL1AEdge;
        tcdsCmds.Resync   <= mgtResyncEdge;
        tcdsCmds.Start    <= mgtStartEdge;
        tcdsCmds.Stop     <= mgtStopEdge;
        tcdsCmds.EC0      <= mgtEC0Edge;
        tcdsCmds.TestSync <= mgtTestSyncEdge;
      end if;
    end if;
  end process;

  process (fsClks(0)) is
  begin
    if (rising_edge(fsClks(0))) then
      if (mgtBc0Edge = '1' and clkSel = '1') then
        bc0Cnt <= (others => '0');
      else
        bc0Cnt <= std_logic_vector(unsigned(bc0Cnt)+1);
      end if;
    end if;
  end process;
-------
  U_SyncClockFreq_RefClk0 : entity work.SyncClockFreq
    generic map(
      REF_CLK_FREQ_G => AXI_CLK_FREQ_G,  -- Reference Clock frequency, units of Hz
      REFRESH_RATE_G => 1.0E+3,         -- Refresh rate, units of Hz
      COMMON_CLK_G   => true,  -- Set to true if (locClk = refClk) to save resources else false
      CNT_WIDTH_G    => 32)             -- Counters' width
    port map (
      -- Frequency Measurement and Monitoring Outputs (locClk domain)
      freqOut     => fsClkMainFreq,     -- units of Hz
      freqUpdated => fsClkMainFreqUpdated,
      -- Clocks
      clkIn       => fsClks(0),         -- Input clock to measure
      locClk      => axiClk,            -- System clock
      refClk      => axiClk);           -- Stable Reference Clock

  fsClkMainFreqLatched <= fsClkMainFreq when (rising_edge(axiClk) and fsClkMainFreqUpdated = '1');

------

  U_SyncClockFreq_Rx : entity work.SyncClockFreq
    generic map(
      REF_CLK_FREQ_G => AXI_CLK_FREQ_G,  -- Reference Clock frequency, units of Hz
      REFRESH_RATE_G => 1.0E+3,         -- Refresh rate, units of Hz
      COMMON_CLK_G   => true,  -- Set to true if (locClk = refClk) to save resources else false
      CNT_WIDTH_G    => 32)             -- Counters' width
    port map (
      -- Frequency Measurement and Monitoring Outputs (locClk domain)
      freqOut     => mgtClkFreq,        -- units of Hz
      freqUpdated => mgtClkFreqUpdated,
      -- Clocks
      clkIn       => mgtRxUsrClk,       -- Input clock to measure
      locClk      => axiClk,            -- System clock
      refClk      => axiClk);           -- Stable Reference Clock

  mgtClkFreqLatched <= mgtClkFreq when (rising_edge(axiClk) and mgtClkFreqUpdated = '1');

  U_mgtDecErrCntRstSync : entity work.RstSync
    port map (
      clk      => mgtRxUsrClk,
      asyncRst => mgtDecErrCntRst,
      syncRst  => mgtDecErrCntRstSync);

  process (mgtRxUsrClk) is
  begin
    if rising_edge(mgtRxUsrClk) then
      if (mgtDecErrCntRstSync = '1') then
        mgtDecErrCnt <= (others => '0');
      elsif (mgtDecErr = '1' and mgtDecErrCnt /= x"FFFFFFFF") then
        mgtDecErrCnt <= std_logic_vector(unsigned(mgtDecErrCnt)+1);
      end if;
    end if;
  end process;

  comb : process (axiClkRst, axiReadMaster, axiWriteMaster, r, fsClkMainFreqLatched, mgtClkFreqLatched, clkMgrLockedSync, mgtRxDoneOut, mgtTxDoneOut, mgtDecErrCnt) is
    variable v      : RegType;
    variable axilEp : AxiLiteEndPointType;
  begin
    -- Latch the current value
    v := r;

    -- Determine the transaction type
    axiSlaveWaitTxn(axilEp, axiWriteMaster, axiReadMaster, v.axiWriteSlave, v.axiReadSlave);

    axiSlaveRegisterR(axilEp, x"0000", 0, clkMgrLockedSync);
    axiSlaveRegister(axilEp, x"0004", 0, v.clkMgrRst);
    axiSlaveRegister(axilEp, x"0008", 0, v.clkSel);

    axiSlaveRegisterR(axilEp, x"0010", 0, fsClkMainFreqLatched);
    axiSlaveRegisterR(axilEp, x"0014", 0, mgtClkFreqLatched);

    axiSlaveRegisterR(axilEp, x"0030", 0, mgtRxDoneOut);
    axiSlaveRegisterR(axilEp, x"0030", 1, mgtTxDoneOut);

    axiSlaveRegister(axilEp, x"0034", 0, v.mgtMasterRst);
    axiSlaveRegister(axilEp, x"0034", 1, v.mgtRxRst);
    axiSlaveRegister(axilEp, x"0034", 2, v.mgtTxRst);

    axiSlaveRegister(axilEp, x"0038", 0, v.mgtRxPrbsSel);
    axiSlaveRegister(axilEp, x"003c", 0, v.mgtTxPrbsSel);

    axiSlaveRegister(axilEp, x"0040", 0, v.mgtDecErrCntRst);
    axiSlaveRegisterR(axilEp, x"0044", 0, mgtDecErrCnt);

    -- Closeout the transaction
    axiSlaveDefault(axilEp, v.axiWriteSlave, v.axiReadSlave, AXI_RESP_DECERR_C);

    -- Synchronous Reset
    if (axiClkRst = '1') then
      v := REG_INIT_C;
    end if;

    -- Register the variable for next clock cycle
    rin <= v;

    -- Outputs
    axiReadSlave  <= r.axiReadSlave;
    axiWriteSlave <= r.axiWriteSlave;
    clkMgrRst     <= r.clkMgrRst;

    mgtMasterRst <= r.mgtMasterRst;
    mgtTxRst     <= r.mgtTxRst;
    mgtRxRst     <= r.mgtRxRst;
    mgtRxPrbsSel <= r.mgtRxPrbsSel;
    mgtTxPrbsSel <= r.mgtTxPrbsSel;

    clkSel          <= r.clkSel;
    mgtDecErrCntRst <= r.mgtDecErrCntRst;

  end process comb;

  seq : process (axiClk) is
  begin
    if (rising_edge(axiClk)) then
      r <= rin after TPD_G;
    end if;
  end process seq;

end architecture rtl;

