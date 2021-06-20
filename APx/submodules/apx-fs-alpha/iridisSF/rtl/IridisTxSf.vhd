library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiStreamPkg.all;

use work.iridisPkg.all;
-- ! NB: sync fiforst to rdclk AR42571 AR21870 !

entity IridisSfTx is
  generic (
    TPD_G           : time                 := 1 ns;
    FRAME_LENGTH_G  : natural              := 6;
    CRC_LENGTH_G    : integer              := 16;  -- Valid options [16, 24, 32]
    LINK_INFO_CNT_G : integer range 0 to 7 := 4);
  port (

    -- Resync request (axis clk domain)
    resync : in sl;

    -- MGT interface
    mgtTxClk      : in  sl;
    mgtTxInitDone : in  sl;
    mgtTxHeader   : out slv(1 downto 0)  := (others => '0');
    mgtTxData     : out slv(63 downto 0) := (others => '0');
    mgtTxSequence : out slv(6 downto 0)  := (others => '0');

    -- AXI-stream/algo interface
    axisClk    : in  sl;
    axiStream  : in  AxiStreamMasterType;
    -- Misc
    fifoOvfErr : out sl;
    fifoUdfErr : out sl;
    fifoErrRst : in  sl                                     := '0';
    linkInfo   : in  Slv32Array(LINK_INFO_CNT_G-1 downto 0) := (others => x"00000000")
    );
end entity IridisSfTx;

architecture rtl of IridisSfTx is

  component fifoTx
    port (
      srst        : in  std_logic;
      wr_clk      : in  std_logic;
      rd_clk      : in  std_logic;
      din         : in  std_logic_vector(71 downto 0);
      wr_en       : in  std_logic;
      rd_en       : in  std_logic;
      dout        : out std_logic_vector(71 downto 0);
      full        : out std_logic;
      overflow    : out std_logic;
      empty       : out std_logic;
      underflow   : out std_logic;
      wr_rst_busy : out std_logic;
      rd_rst_busy : out std_logic
      );
  end component;

--------------------------------------------------------------------------------
-- Input FSM register set (axis clk domain)
  type StateTypeInFsm is (RESYNC_S, RUN_S);

  type InFsmRegType is record
    state        : StateTypeInFsm;
    wordCnt      : integer range 0 to 65535;
    fifoWrite    : sl;
    crcEn        : sl;
    crcRst       : sl;
    crcLatched   : slv(CRC_LENGTH_G-1 downto 0);
    axiStream_s1 : AxiStreamMasterType;
    axiStream_s2 : AxiStreamMasterType;
  end record;

  constant IN_FSM_REG_INIT_C : InFsmRegType := (
    state        => RESYNC_S,
    fifoWrite    => '0',
    wordCnt      => 0,
    crcEn        => '0',
    crcRst       => '0',
    crcLatched   => (others => '0'),
    axiStream_s1 => AXI_STREAM_MASTER_INIT_C,
    axiStream_s2 => AXI_STREAM_MASTER_INIT_C
    );

--------------------------------------------------------------------------------
-- Output FSM register set (mgtTxClk clk domain)

  type StateTypeOutFsm is (RESYNC_S, FIFO_RST_S, WAIT_FFO_S, RUN_S);

  type OutFsmRegType is record
    state          : StateTypeOutFsm;
    wordCnt        : integer range 0 to 65535;
    fifoRead       : sl;
    fifoRst        : sl;
    prevFFO        : sl;
    linkInfoSeq    : integer range 0 to LINK_INFO_CNT_G-1;
    txHeader       : slv(1 downto 0);
    txData         : slv(63 downto 0);
    txSequence     : integer range 0 to 33;
    txSequenceHalt : sl;
    txDataValid    : sl;
  end record;

  constant OUT_FSM_REG_INIT_C : OutFsmRegType := (
    prevFFO        => '0',
    linkInfoSeq    => 0,
    wordCnt        => 0,
    state          => RESYNC_S,
    fifoRead       => '0',
    fifoRst        => '0',
    txHeader       => "01",
    txSequence     => 0,
    txSequenceHalt => '1',
    txData         => (others => '0'),
    txDataValid    => '0'
    );

--------------------------------------------------------------------------------
-- Input FSM register set
  signal r_iFSM   : InFsmRegType := IN_FSM_REG_INIT_C;
  signal rin_iFSM : InFsmRegType;

-- Output FSM register set
  signal r_oFSM   : OutFsmRegType := OUT_FSM_REG_INIT_C;
  signal rin_oFSM : OutFsmRegType;
--------------------------------------------------------------------------------

  signal protTxData      : slv(63 downto 0);
  signal protTxHeader    : slv(1 downto 0);
  signal protTxSequence  : slv(6 downto 0);
  signal protTxDataValid : sl;

  signal mgtTxDataBitRev : slv(63 downto 0) := (others => '0');
  signal mgtTxInitDoneN  : sl;

  signal fifoWrite, fifoWrite_d1, fifoWrite_d2 : sl;
  signal fifoRead                              : sl;
  signal fifoEmpty                             : sl;
  signal fifoDataIn                            : slv(71 downto 0);
  signal fifoDataInD1                          : slv(71 downto 0);
  signal fifoDataOut                           : slv(71 downto 0);
  signal fifoUdf                               : sl;
  signal fifoOvf                               : sl;

  signal crcOut     : std_logic_vector (CRC_LENGTH_G-1 downto 0);
  signal crcLatched : std_logic_vector (CRC_LENGTH_G-1 downto 0);
  signal crcEn      : sl;
  signal crcRst     : sl;

  signal resyncRE : sl;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
begin

  mgtTxInitDoneN <= not mgtTxInitDone;

  U_SyncEdgeResync : entity work.SynchronizerEdge
    port map (
      clk        => mgtTxClk,
      dataIn     => resync,
      risingEdge => resyncRE
      );

--------------------------------------------------------------------------------
-- Build-time selectable CRC engine
  G_CRC16 : if (CRC_LENGTH_G = 16) generate
    U_crc16 : entity work.crc16isf
      port map(
        data_in => r_iFSM.axiStream_s1.tData(63 downto 0),
        crc_en  => crcEn,
        rst     => crcRst,
        clk     => axisClk,
        crc_out => crcOut(CRC_LENGTH_G-1 downto 0));
  end generate G_CRC16;

  G_CRC24 : if (CRC_LENGTH_G = 24) generate
    U_crc24 : entity work.crc24isf
      port map(
        data_in => r_iFSM.axiStream_s1.tData(63 downto 0),
        crc_en  => crcEn,
        rst     => crcRst,
        clk     => axisClk,
        crc_out => crcOut(CRC_LENGTH_G-1 downto 0));
  end generate G_CRC24;

  G_CRC32 : if (CRC_LENGTH_G = 32) generate
    U_crc32 : entity work.crc32isf
      port map(
        data_in => r_iFSM.axiStream_s1.tData(63 downto 0),
        crc_en  => crcEn,
        rst     => crcRst,
        clk     => axisClk,
        crc_out => crcOut(CRC_LENGTH_G-1 downto 0));
  end generate G_CRC32;
--------------------------------------------------------------------------------

  fifoDataIn(FIFO_POS_FFO_C)    <= r_iFSM.axiStream_s2.tUser(AXIS_TUSER_POS_FFO_C);  -- FFO Marker
  fifoDataIn(FIFO_POS_SOF_C)    <= r_iFSM.axiStream_s2.tUser(AXIS_TUSER_POS_SOF_C);  -- SOF Marker
  fifoDataIn(FIFO_POS_TLAST_C)  <= r_iFSM.axiStream_s2.tLast;
  fifoDataIn(FIFO_POS_TVALID_C) <= r_iFSM.axiStream_s2.tValid;
  fifoDataIn(63 downto 0)       <= r_iFSM.axiStream_s2.tData(63 downto 0);

  fifoDataInD1 <= fifoDataIn when rising_edge(axisClk);

  fifoWrite_d1 <= fifoWrite    when rising_edge(axisClk);
  fifoWrite_d2 <= fifoWrite_d1 when rising_edge(axisClk);

  -- Built-in FIFO IP core
  U_FifoTx : FifoTx
    port map (
      srst        => r_oFSM.fifoRst,
      -- Write Ports 
      wr_clk      => axisClk,
      wr_en       => fifoWrite_d2,
      din         => fifoDataInD1,
      overflow    => fifoOvf,
      full        => open,
      wr_rst_busy => open,
      -- Read Ports
      underflow   => fifoUdf,
      rd_clk      => mgtTxClk,
      rd_en       => fifoRead,
      dout        => fifoDataOut,
      empty       => fifoEmpty,
      rd_rst_busy => open
      );

  -- FIFO overflow error latching (FIFO write side)
  process (axisClk) is
  begin
    if rising_edge(axisClk) then
      if (fifoErrRst = '1') then
        fifoOvfErr <= '0';
      elsif (fifoOvf = '1') then
        fifoOvfErr <= '1';
      end if;
    end if;
  end process;

  -- FIFO underflow error latching (FIFO read side)
  process (mgtTxClk) is
  begin
    if rising_edge(mgtTxClk) then
      if (fifoErrRst = '1') then
        fifoUdfErr <= '0';
      elsif (fifoUdf = '1') then
        fifoUdfErr <= '1';
      end if;
    end if;
  end process;

  comb_iFSM : process (axiStream, resyncRE, r_iFSM, crcOut) is
    variable v : InFsmRegType;
  begin
-- latch the current value
    v := r_iFSM;

-- Default assignments 
    v.axiStream_s1 := axiStream;
    v.axiStream_s2 := r_iFSM.axiStream_s1;
    v.crcRst       := '0';

    case r_iFSM.state is
--------------------------------------------------------------------------------
      when RESYNC_S =>
        v.fifoWrite := '0';

        if (axiStream.tUser(1) = '1') then
          v.state  := RUN_S;
          v.crcRst := '1';
          v.crcEn  := '1';
        end if;

--------------------------------------------------------------------------------
      when RUN_S =>
        v.fifoWrite := '1';
        v.wordCnt   := v.wordCnt + 1;
        if (v.wordCnt = FRAME_LENGTH_G-1) then
          v.axiStream_s1.tData(CRC_LENGTH_G-1 downto 0) := (others => '0');
        end if;
        if (v.wordCnt = FRAME_LENGTH_G) then
          v.wordCnt                                     := 0;
          v.crcRst                                      := '1';
          v.crcLatched                                  := crcOut(CRC_LENGTH_G-1 downto 0);
          v.axiStream_s2.tData(CRC_LENGTH_G-1 downto 0) := v.crcLatched;
        end if;

--------------------------------------------------------------------------------
      when others =>
        v.state := RESYNC_S;

    end case;
--------------------------------------------------------------------------------

    -- Reset
    if (resyncRE = '1') then
      --  v := IN_FSM_REG_INIT_C;
      v.state     := RESYNC_S;
      v.fifoWrite := '0';
      v.wordCnt   := 0;
      v.crcEn     := '0';
      v.crcRst    := '0';
    end if;

    -- Register the variable for next clock cycle
    rin_iFSM <= v;
    -- Registered Outputs   

    fifoWrite  <= v.fifoWrite;
    crcEn      <= v.crcEn;
    crcRst     <= v.crcRst;
    crcLatched <= v.crcLatched;
  end process comb_iFSM;

  seq_iFSM : process (axisClk) is
  begin
    if rising_edge(axisClk) then
      r_iFSM <= rin_iFSM after TPD_G;
    end if;
  end process seq_iFSM;

--------------------------------------------------------------------------------
  comb_oFSM : process (fifoDataOut, fifoEmpty, resyncRE, r_oFSM, crcLatched, linkInfo) is
    variable v : OutFsmRegType;
    variable i : natural;
  begin
    -- Latch the current value
    v := r_oFSM;

    -- Default values
    v.txData(IRIDIS_BTF_FIELD_C) := IRIDIS_BTF_ARRAY_C(BTF_B_IDX_C);
    v.txHeader                   := IRIDIS_K_HEADER_C;
    v.txDataValid                := '0';

    -- Reset the flags
    v.fifoRead := '0';

--------------------------------------------------------------------------------
    -- Gearbox Tx Sequence control
    if v.txSequenceHalt = '1' then
      -- Increment the counter
      v.txSequence := r_oFSM.txSequence + 1;

      -- Check if last cycle was a pause cycle
      if (r_oFSM.txSequence = 32) then
        -- Reset the counter
        v.txSequence := 0;
      end if;
    end if;

    v.txSequenceHalt := not v.txSequenceHalt;

--------------------------------------------------------------------------------
-- TX Protocol Engine
--------------------------------------------------------------------------------
    -- Check if not a TX gearbox "pause" cycle
    if(v.txSequence /= 32) then

      v.txDataValid := '1';

      case r_oFSM.state is

--------------------------------------------------------------------------------
        when RESYNC_S =>
          v.wordCnt                    := 0;
          v.fifoRst                    := '1';
          v.state                      := FIFO_RST_S;
          v.linkInfoSeq                := 0;
          v.txData(IRIDIS_BTF_FIELD_C) := IRIDIS_BTF_ARRAY_C(BTF_B_IDX_C + v.linkInfoSeq);
          v.txData(31 downto 0)        := linkInfo(v.linkInfoSeq);
          v.txHeader                   := IRIDIS_K_HEADER_C;

--------------------------------------------------------------------------------
        when FIFO_RST_S =>
          v.wordCnt := v.wordCnt + 1;
          if (v.wordCnt > 5) then
            v.state   := WAIT_FFO_S;
            v.fifoRst := '0';
          end if;
          v.txData(IRIDIS_BTF_FIELD_C) := IRIDIS_BTF_ARRAY_C(BTF_B_IDX_C);
          v.txHeader                   := IRIDIS_K_HEADER_C;

--------------------------------------------------------------------------------
        when WAIT_FFO_S =>
          v.wordCnt := 0;
          if (fifoEmpty = '0' and fifoDataOut(FIFO_POS_FFO_C) = '1') then
            v.txData(IRIDIS_BTF_FIELD_C) := IRIDIS_BTF_ARRAY_C(BTF_A_IDX_C);
            v.txHeader                   := IRIDIS_K_HEADER_C;
            v.state                      := RUN_S;
            v.prevFFO                    := '1';
          -- v.fifoRead := '1';
          else
            -- Send Link Idle Word if FIFO empty
            v.linkInfoSeq                := 0;
            v.txData(IRIDIS_BTF_FIELD_C) := IRIDIS_BTF_ARRAY_C(BTF_B_IDX_C + v.linkInfoSeq);
            v.txData(31 downto 0)        := linkInfo(v.linkInfoSeq);
            v.txHeader                   := IRIDIS_K_HEADER_C;
          end if;

--------------------------------------------------------------------------------
        when RUN_S =>

          if (fifoEmpty = '0' and fifoDataOut(FIFO_POS_FFO_C) = '1' and v.prevFFO /= '1') then
            v.txData(IRIDIS_BTF_FIELD_C) := IRIDIS_BTF_ARRAY_C(BTF_A_IDX_C);
            v.txHeader                   := IRIDIS_K_HEADER_C;
            v.prevFFO                    := '1';
            --v.fifoRead := '1';

          elsif (fifoEmpty = '1') then
            -- Send Link Idle Word if FIFO empty
            v.txData(IRIDIS_BTF_FIELD_C) := IRIDIS_BTF_ARRAY_C(BTF_B_IDX_C + v.linkInfoSeq);
            v.txData(31 downto 0)        := linkInfo(v.linkInfoSeq);
            v.txHeader                   := IRIDIS_K_HEADER_C;
            if (v.linkInfoSeq = LINK_INFO_CNT_G-1) then
              v.linkInfoSeq := 0;
            else
              v.linkInfoSeq := v.linkInfoSeq + 1;
            end if;
          -- Data word
          else
            v.txData   := fifoDataOut(63 downto 0);
            v.txHeader := IRIDIS_D_HEADER_C;
            v.fifoRead := '1';
            v.wordCnt  := v.wordCnt + 1;
            v.prevFFO  := '0';
            if (v.wordCnt = FRAME_LENGTH_G) then
              v.wordCnt := 0;
            end if;
          end if;

--------------------------------------------------------------------------------
        when others =>
          v.state := RESYNC_S;

      end case;
    end if;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

    -- Combinatorial outputs before the reset
    --fifoRead <= v.fifoRead; 

    -- Reset
    if (resyncRE = '1') then
      --  v := OUT_FSM_REG_INIT_C;
      v.prevFFO     := '0';
      v.linkInfoSeq := 0;
      v.wordCnt     := 0;
      v.state       := RESYNC_S;
      v.fifoRead    := '0';
      v.fifoRst     := '0';
    end if;

    -- Register the variable for next clock cycle
    rin_oFSM <= v;


    -- Registered Outputs   
    fifoRead        <= r_oFSM.fifoRead;
    protTxHeader    <= r_oFSM.txHeader;
    protTxData      <= r_oFSM.txData;
    protTxDataValid <= r_oFSM.txDataValid;
    protTxSequence  <= std_logic_vector(to_unsigned(r_oFSM.txSequence, 7));

  end process comb_oFSM;
--------------------------------------------------------------------------------
  seq_oFSM : process (mgtTxClk) is
  begin
    if rising_edge(mgtTxClk) then
      r_oFSM <= rin_oFSM after TPD_G;
    end if;
  end process seq_oFSM;

--------------------------------------------------------------------------------

-- Scramble the data for 64b66b gearbox
  U_Scrambler : entity work.Scrambler
    generic map (
      TPD_G            => TPD_G,
      DIRECTION_G      => "SCRAMBLER",
      DATA_WIDTH_G     => 64,
      SIDEBAND_WIDTH_G => 2,
      TAPS_G           => IRIDIS_SCRAMBLER_TAPS_C)
    port map (
      clk                        => mgtTxClk,
      rst                        => mgtTxInitDoneN,
      -- Input Interface
      inputValid                 => protTxDataValid,
      inputData                  => protTxData,
      inputSideband(1 downto 0)  => protTxHeader,
      -- Output Interface
      outputReady                => '1',
      outputData                 => mgtTxDataBitRev,
      outputSideband(1 downto 0) => mgtTxHeader);

  mgtTxSequence <= std_logic_vector(to_unsigned(r_oFSM.txSequence, 7)) when rising_edge(mgtTxClk);

  -- Bit-reverse the data since gearbox transmits data MSb first.
  mgtTxData <= bitReverse(mgtTxDataBitRev);

end architecture rtl;

--------------------------------------------------------------------------------
