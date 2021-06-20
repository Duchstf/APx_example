library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiStreamPkg.all;

use work.iridisPkg.all;
-- todo sync Resync
entity IridisSfRx is
  generic (
    TPD_G                : time                 := 1 ns;
    FRAME_LENGTH_G       : natural              := 6;
    FIFO_READ_LENGTH_G   : natural              := 6;
    FIFO_HOLD_LENGTH_G   : natural              := 0;
    FIFO_ACTIVE_LENGTH_G : natural              := 6;
    CRC_LENGTH_G         : integer              := 16;  -- Valid options [16, 24, 32]
    LINK_INFO_CNT_G      : integer range 0 to 7 := 4;
    ALIGN_SLIP_WAIT_G    : integer              := 32);
  port (

    -- Resync request (axis clk domain)
    resync : in sl;

    -- Rx FIFO interface
    fifoRelease : in  sl;
    fifoReady   : out sl;  -- indicates valid data at FIFO output port

    -- MGT interface
    mgtRxClk         : in  sl;
    mgtRxInitDone    : in  sl;
    mgtRxHeaderValid : in  sl;
    mgtRxHeader      : in  slv(1 downto 0);
    mgtRxDataValid   : in  sl;
    mgtRxData        : in  slv(63 downto 0);
    mgtRxSlip        : out sl;
    gearboxLocked    : out sl;

    -- AXI-stream/algo interface
    axisClk   : in  sl;
    axiStream : out AxiStreamMasterType;

    -- Core Diagnostic Ports
    fifoOvfErr : out sl;
    fifoUdfErr : out sl;
    fifoErrRst : in  sl := '0';
    FFO        : out sl;  -- First Frame of Orbit Flag (mgtRxClk domain), intended for link latency measurements
    protoErr   : out sl;  -- protocol error (mgtRxClk domain), indicates receipt of unmapped 66 word
    crcErr     : out sl;
    linkInfo   : out Slv32Array(LINK_INFO_CNT_G-1 downto 0)
    );
end entity IridisSfRx;

architecture rtl of IridisSfRx is

  component fifoRx
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
-- Input FSM register set (mgtRxClk clk domain)
  type StateTypeInFsm is (RESYNC_S, FIFO_RST_S, WAIT_FFO_S, RUN_S);

  type InFsmRegType is record
    fifoRst    : sl;
    fifoWrite  : sl;
    prevFFO    : sl;
    fifoDataIn : slv(71 downto 0);
    state      : StateTypeInFsm;
    fsmSeq     : integer range 0 to 65535;
    crcLatched : slv(CRC_LENGTH_G-1 downto 0);
    linkInfo   : Slv32Array(LINK_INFO_CNT_G-1 downto 0);
    protoErr   : sl;
  end record;

  constant IN_FSM_REG_INIT_C : InFsmRegType := (
    fifoRst    => '0',
    fifoWrite  => '0',
    prevFFO    => '0',
    fifoDataIn => (others => '0'),
    state      => RESYNC_S,
    fsmSeq     => 0,
    crcLatched => (others => '0'),
    linkInfo   => (others => x"00000000"),
    protoErr   => '0'
    );
--------------------------------------------------------------------------------
-- Output FSM register set (axis clk domain)
  type StateTypeOutFsm is (RESYNC_S, FIFO_RST_S, WAIT_FIFO_RELEASE_S, RUN_READ_S, RUN_HOLD_S);

  type OutFsmRegType is record
    state        : StateTypeOutFsm;
    fsmSeq       : integer range 0 to 65535;
    fifoDcSeq    : integer range 0 to 255;
    fifo_in_rst  : sl;
    fifoRead     : sl;
    crcEn        : sl;
    crcRst       : sl;
    crcCandidate : slv(CRC_LENGTH_G-1 downto 0);
    crcInFrame   : slv(CRC_LENGTH_G-1 downto 0);
    axiStream_s1 : AxiStreamMasterType;
    axiStream_s2 : AxiStreamMasterType;
  end record;

  constant OUT_FSM_REG_INIT_C : OutFsmRegType := (
    state        => RESYNC_S,
    fifoRead     => '0',
    fsmSeq       => 0,
    fifoDcSeq    => 0,
    fifo_in_rst  => '0',
    crcEn        => '0',
    crcRst       => '0',
    crcCandidate => (others => '0'),
    crcInFrame   => (others => '0'),
    axiStream_s1 => AXI_STREAM_MASTER_INIT_C,
    axiStream_s2 => AXI_STREAM_MASTER_INIT_C
    );
--------------------------------------------------------------------------------  
-- Input FSM register set
  signal r_iFSM   : InFsmRegType := IN_FSM_REG_INIT_C;
  signal rin_iFSM : InFsmRegType;

-- Output FSM register set
  signal r_oFSM          : OutFsmRegType    := OUT_FSM_REG_INIT_C;
  signal rin_oFSM        : OutFsmRegType;
--------------------------------------------------------------------------------
  signal mgtRxDataBitRev : slv(63 downto 0) := (others => '0');
  signal mgtRxInitDoneN  : sl;

  signal gbLocked          : sl;
  signal unscramblerValid  : sl;
  signal unscrambledValid  : sl;
  signal unscrambledData   : slv(63 downto 0);
  signal unscrambledHeader : slv(1 downto 0);

  signal fifoWrite   : sl := '0';
  signal fifoWriteD1 : sl := '0';
  signal fifoRead    : sl;

  signal fifoEmpty     : sl;
  signal fifoDataIn    : slv(71 downto 0) := (others => '0');
  signal fifoDataInD1  : slv(71 downto 0) := (others => '0');
  signal fifoDataOut   : slv(71 downto 0) := (others => '0');
  signal fifoDataOutD1 : slv(71 downto 0) := (others => '0');

  signal fifoUdf : sl;
  signal fifoOvf : sl;

  signal crcOut     : slv(CRC_LENGTH_G-1 downto 0);
  signal crcLatched : slv(CRC_LENGTH_G-1 downto 0);
  signal crcEn      : sl;
  signal crcEnD1    : sl;
  signal crcRst     : sl;

  signal resyncD1 : sl;

begin
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  mgtRxInitDoneN <= not mgtRxInitDone;
  resyncD1       <= resync when rising_edge(axisClk);

  -- 64b66b Gearbox Aligner (SURF IP)
  U_Pgp3RxGearboxAligner : entity work.Pgp3RxGearboxAligner
    generic map (
      TPD_G       => TPD_G,
      SLIP_WAIT_G => ALIGN_SLIP_WAIT_G)
    port map (
      clk           => mgtRxClk,          -- [in]
      rst           => mgtRxInitDoneN,    -- [in]
      rxHeader      => mgtRxHeader,       -- [in]
      rxHeaderValid => mgtRxHeaderValid,  -- [in]
      slip          => mgtRxSlip,         -- [out]
      locked        => gbLocked);         -- [out]

  gearboxLocked <= gbLocked;

  -- Unscramble the data for 64b66b
  unscramblerValid <= gbLocked and mgtRxHeaderValid;

  -- Bit-reverse the data since gearbox modes transmit data MSb first.
  mgtRxDataBitRev <= bitReverse(mgtRxData);

  U_Scrambler : entity work.Scrambler
    generic map (
      TPD_G            => TPD_G,
      DIRECTION_G      => "DESCRAMBLER",
      DATA_WIDTH_G     => 64,
      SIDEBAND_WIDTH_G => 2,
      TAPS_G           => IRIDIS_SCRAMBLER_TAPS_C)
    port map (
      clk            => mgtRxClk,
      rst            => mgtRxInitDoneN,
      inputValid     => unscramblerValid,
      inputData      => mgtRxDataBitRev,
      inputSideband  => mgtRxHeader,
      outputValid    => unscrambledValid,
      outputData     => unscrambledData,
      outputSideband => unscrambledHeader);

-- Input FSM regiser set combinatorial logic   
  comb_iFSM : process (r_iFSM, resyncD1, unscrambledValid, unscrambledData, unscrambledHeader) is
    variable v   : InFsmRegType;
    variable btf : slv(7 downto 0);
  begin
    -- Latch the current value
    v := r_iFSM;

    -- Default values
    v.fifoWrite  := '0';
    v.fifoDataIn := (others => '0');
    v.protoErr   := '0';
    btf          := unscrambledData(IRIDIS_BTF_FIELD_C);

    case r_iFSM.state is
--------------------------------------------------------------------------------
      when RESYNC_S =>
        v.fsmSeq  := 0;
        v.fifoRst := '1';
        v.state   := FIFO_RST_S;
--------------------------------------------------------------------------------
      when FIFO_RST_S =>
        v.fsmSeq := v.fsmSeq + 1;
        if (v.fsmSeq > 5) then
          v.state   := WAIT_FFO_S;
          v.fifoRst := '0';
        end if;
--------------------------------------------------------------------------------
      when WAIT_FFO_S =>
        v.fsmSeq := 0;
        if (unscrambledValid = '1' and
            btf = IRIDIS_BTF_ARRAY_C(BTF_A_IDX_C) and
            unscrambledHeader = IRIDIS_K_HEADER_C) then
          v.state   := RUN_S;
          v.prevFFO := '1';
        end if;
--------------------------------------------------------------------------------
      when RUN_S =>                     -- Main RX Protocol Engine
        if (unscrambledValid = '1') then
          -- Line Idle Word (LIW-FFO) => BTF_A
          if (btf = IRIDIS_BTF_ARRAY_C(BTF_A_IDX_C) and unscrambledHeader = IRIDIS_K_HEADER_C) then
            v.fifoWrite  := '0';
            v.fsmSeq     := 0;
            v.prevFFO    := '1';
            v.crcLatched := unscrambledData(CRC_LENGTH_G-1 downto 0);

          -- (Regular) Line Idle Word (LIW) => BTF_B
          elsif (unscrambledHeader = IRIDIS_K_HEADER_C and btf = IRIDIS_BTF_ARRAY_C(BTF_B_IDX_C)) then
            v.fifoWrite   := '0';
            v.linkInfo(0) := unscrambledData(31 downto 0);
          -- (Regular) Line Idle Word (LIW) => BTF_C
          elsif (unscrambledHeader = IRIDIS_K_HEADER_C and btf = IRIDIS_BTF_ARRAY_C(BTF_C_IDX_C)) then
            v.fifoWrite   := '0';
            v.linkInfo(1) := unscrambledData(31 downto 0);
          -- (Regular) Line Idle Word (LIW) => BTF_D
          elsif (unscrambledHeader = IRIDIS_K_HEADER_C and btf = IRIDIS_BTF_ARRAY_C(BTF_D_IDX_C)) then
            v.fifoWrite   := '0';
            v.linkInfo(2) := unscrambledData(31 downto 0);
          -- (Regular) Line Idle Word (LIW) => BTF_E
          elsif (unscrambledHeader = IRIDIS_K_HEADER_C and btf = IRIDIS_BTF_ARRAY_C(BTF_E_IDX_C)) then
            v.fifoWrite   := '0';
            v.linkInfo(3) := unscrambledData(31 downto 0);
          -- Data word
          elsif (unscrambledHeader = IRIDIS_D_HEADER_C) then
            v.fifoWrite := '1';

            v.fifoDataIn(FIFO_POS_SOF_C) := '0';
            if (v.fsmSeq = 0) then
              v.fifoDataIn(FIFO_POS_SOF_C) := '1';  -- SOF
            end if;

            v.fifoDataIn(FIFO_POS_FFO_C) := '0';  -- FFO Marker

            if (v.prevFFO = '1') then
              v.fifoDataIn(FIFO_POS_FFO_C) := '1';  -- FFO Marker
              v.prevFFO                    := '0';
            end if;

            v.fsmSeq := v.fsmSeq + 1;

            v.fifoDataIn(63 downto 0)       := unscrambledData(63 downto 0);  --tData
            v.fifoDataIn(FIFO_POS_TLAST_C)  := '0';  -- tLast
            v.fifoDataIn(FIFO_POS_TVALID_C) := '1';  -- tValid

            if (v.fsmSeq = FRAME_LENGTH_G) then
              v.fifoDataIn(FIFO_POS_TLAST_C) := '1';  -- tLast
              v.fsmSeq                       := 0;
            end if;

--------------------------------------------------------------------------------
-- Unmapped word case 
          else
            v.protoErr := '1';
          end if;
        end if;
--------------------------------------------------------------------------------
    end case;

    -- Reset
    if (resyncD1 = '1') then
      --v := IN_FSM_REG_INIT_C;

      v.fifoRst   := '0';
      v.fifoWrite := '0';
      v.prevFFO   := '0';
      v.state     := RESYNC_S;
      v.fsmSeq    := 0;
      v.protoErr  := '0';
    end if;

    -- Register the variable for next clock cycle
    rin_iFSM <= v;

    -- Registered Outputs   
    fifoWrite  <= r_iFSM.fifoWrite;
    fifoDataIn <= r_iFSM.fifoDataIn;
    FFO        <= r_iFSM.prevFFO;
    protoErr   <= r_iFSM.protoErr;
    crcLatched <= r_iFSM.crcLatched;
    linkInfo   <= r_iFSM.linkInfo;

  end process comb_iFSM;

  seq_iFSM : process (mgtRxClk) is
  begin
    if rising_edge(mgtRxClk) then
      r_iFSM <= rin_iFSM after TPD_G;
    end if;
  end process seq_iFSM;

  fifoDataInD1 <= fifoDataIn when rising_edge(mgtRxClk);
  fifoWriteD1  <= fifoWrite  when rising_edge(mgtRxClk);

  -- Built-in FIFO IP core
  U_FifoRx : FifoRx
    port map (
      srst        => r_iFSM.fifoRst,
      -- Write Ports
      wr_clk      => mgtRxClk,
      wr_en       => fifoWriteD1,
      din         => fifoDataInD1,
      full        => open,
      overflow    => fifoOvf,
      -- Read Ports
      rd_clk      => axisClk,
      rd_en       => fifoRead,
      dout        => fifoDataOut,
      empty       => fifoEmpty,
      underflow   => fifoUdf,
      wr_rst_busy => open,
      rd_rst_busy => open
      );

  -- FIFO overflow error latching (FIFO write side)
  process (mgtRxClk) is
  begin
    if rising_edge(mgtRxClk) then
      if (fifoErrRst = '1') then
        fifoOvfErr <= '0';
      elsif (fifoOvf = '1') then
        fifoOvfErr <= '1';
      end if;
    end if;
  end process;

  -- FIFO underflow error latching (FIFO read side)
  process (axisClk) is
  begin
    if rising_edge(axisClk) then
      if (fifoErrRst = '1') then
        fifoUdfErr <= '0';
      elsif (fifoUdf = '1') then
        fifoUdfErr <= '1';
      end if;
    end if;
  end process;

  fifoDataoutD1 <= fifoDataOut when rising_edge(axisClk);

  axiStream <= r_oFSM.axiStream_s2;

  fifoReady <= (not fifoEmpty and not r_ofsm.fifo_in_rst) when rising_edge(axisClk);
  crcEnD1   <= crcEn                                      when rising_edge(axisClk);
--------------------------------------------------------------------------------
-- Build-time selectable CRC engine
  G_CRC16 : if (CRC_LENGTH_G = 16) generate
    U_crc16 : entity work.crc16isf
      port map(
        data_in => r_oFSM.axiStream_s1.tData(63 downto 0),
        crc_en  => crcEnD1,
        rst     => crcRst,
        clk     => axisClk,
        crc_out => crcOut(CRC_LENGTH_G-1 downto 0));
  end generate G_CRC16;

  G_CRC24 : if (CRC_LENGTH_G = 24) generate
    U_crc24 : entity work.crc24isf
      port map(
        data_in => r_oFSM.axiStream_s1.tData(63 downto 0),
        crc_en  => crcEnD1,
        rst     => crcRst,
        clk     => axisClk,
        crc_out => crcOut(CRC_LENGTH_G-1 downto 0));
  end generate G_CRC24;

  G_CRC32 : if (CRC_LENGTH_G = 32) generate
    U_crc32 : entity work.crc32isf
      port map(
        data_in => r_oFSM.axiStream_s1.tData(63 downto 0),
        crc_en  => crcEnD1,
        rst     => crcRst,
        clk     => axisClk,
        crc_out => crcOut(CRC_LENGTH_G-1 downto 0));
  end generate G_CRC32;
--------------------------------------------------------------------------------
-- Output FSM regiser set combinatorial logic   
  comb_oFSM : process (resyncD1, r_oFSM, crcOut, fifoRelease, fifoDataOut, fifoDataOutD1) is
    variable v : OutFsmRegType;
  begin
-- latch the current value
    v := r_oFSM;

-- Default assignments 
    v.axiStream_s1.tUser(2) := '0';     -- CRC Err Flag
    v.axiStream_s1.tUser(1) := '0';     -- FFO Flag
    v.axiStream_s1.tUser(0) := '0';     -- SOF Flag
    v.axiStream_s1.tLast    := '0';     -- EOF Flag
    v.axiStream_s1.tValid   := '0';     -- AXI-stream data valid flag

    v.axiStream_s1.tData(63 downto 0) := fifoDataOutD1(63 downto 0);
    v.fifo_in_rst                     := '0';
    v.axiStream_s2                    := r_oFSM.axiStream_s1;

    v.crcRst := '0';

    case r_oFSM.state is
--------------------------------------------------------------------------------
      when RESYNC_S =>
        v.fifoRead  := '0';
        v.fsmSeq    := 0;
        v.fifoDcSeq := 0;
        v.state     := FIFO_RST_S;
--------------------------------------------------------------------------------
      when FIFO_RST_S =>
        v.fifo_in_rst := '1';
        v.fifoRead    := '0';
        v.fsmSeq      := v.fsmSeq + 1;
        v.fifoDcSeq   := 0;
        if (v.fsmSeq > 5) then
          v.state := WAIT_FIFO_RELEASE_S;
        end if;
--------------------------------------------------------------------------------
      when WAIT_FIFO_RELEASE_S =>
        v.fifoRead  := '0';
        v.fsmSeq    := 0;
        v.fifoDcSeq := 0;
        if (fifoRelease = '1') then
          v.fifoRead := '1';
          v.state    := RUN_READ_S;
          v.crcEn    := '1';
        end if;
--------------------------------------------------------------------------------
      when RUN_READ_S =>
        v.axiStream_s1.tUser(1) := fifoDataOutD1(67);  -- FFO Flag
        v.axiStream_s1.tUser(0) := fifoDataOutD1(66);  -- SOF Flag
        v.axiStream_s1.tLast    := fifoDataOutD1(65);  -- EOF Flag
        v.axiStream_s1.tValid   := fifoDataOutD1(64);

        v.fifoRead := '1';
        v.fsmSeq   := v.fsmSeq + 1;

        v.crcEn := '1';

        if (v.fsmSeq = 1) then
          v.crcRst       := '1';
          v.crcCandidate := crcOut;
          if (FIFO_HOLD_LENGTH_G = 0) then
            if (v.crcInFrame /= v.crcCandidate) then
              v.axiStream_s2.tUser(2) := '1';  -- CRC Err Flag
            end if;
          end if;
        end if;

        if (FIFO_HOLD_LENGTH_G /= 0) then
          v.fifoDcSeq := v.fifoDcSeq + 1;
          if (v.fifoDcSeq = FIFO_READ_LENGTH_G) then
            v.state     := RUN_HOLD_S;
            v.fifoDcSeq := 0;
            --    v.crcEn     := '0';
            v.fifoRead  := '0';
          end if;
        end if;

        if (v.fsmSeq = FRAME_LENGTH_G) then
          v.fsmSeq                                      := 0;
          v.crcInFrame                                  := v.axiStream_s1.tData(CRC_LENGTH_G-1 downto 0);
          v.axiStream_s1.tData(CRC_LENGTH_G-1 downto 0) := (others => '0');
        end if;
--------------------------------------------------------------------------------
      when RUN_HOLD_S =>

        v.axiStream_s1.tValid := '0';

        if (v.fsmSeq = 0 and v.fifoDcSeq = 0) then
          v.crcCandidate := crcOut;
          if (v.crcInFrame /= v.crcCandidate) then
            v.axiStream_s2.tUser(2) := '1';  -- CRC Err Flag
          end if;
        end if;

        v.axiStream_s1.tValid := '0';
        v.fifoRead            := '0';
        v.fifoDcSeq           := v.fifoDcSeq+ 1;
        v.crcEn               := '0';

        if (v.fifoDcSeq = FIFO_HOLD_LENGTH_G) then
          v.state     := RUN_READ_S;
          v.fifoDcSeq := 0;
          --v.crcEn     := '1';
          v.fifoRead  := '1';
        end if;
--------------------------------------------------------------------------------
      when others =>
        v.state := RESYNC_S;

    end case;
--------------------------------------------------------------------------------

    -- Reset
    if (resyncD1 = '1') then
      --  v := OUT_FSM_REG_INIT_C;
      v.state       := RESYNC_S;
      v.fsmSeq      := 0;
      v.fifoDcSeq   := 0;
      v.fifo_in_rst := '0';
      v.fifoRead    := '0';
      v.crcEn       := '0';
      v.crcRst      := '0';
    end if;

    -- Register the variable for next clock cycle
    rin_oFSM <= v;
    -- Registered Outputs   

    fifoRead <= r_oFSM.fifoRead;
    crcEn    <= v.crcEn;
    crcRst   <= v.crcRst;
    --crcErr   <= v.axiStream_s2.tUser(2);

  end process comb_oFSM;

  crcErr <= r_oFSM.axiStream_s2.tUser(2);

  seq_oFSM : process (axisClk) is
  begin
    if rising_edge(axisClk) then
      r_oFSM <= rin_oFSM after TPD_G;
    end if;
  end process seq_oFSM;

end architecture rtl;

--------------------------------------------------------------------------------
