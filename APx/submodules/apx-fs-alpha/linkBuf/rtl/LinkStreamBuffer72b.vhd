library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiStreamPkg.all;
use work.LinkBufPkg.all;
use work.tcdsPkg.all;

entity LinkStreamBuffer72b is
  generic (
    TPD_G          : time    := 1 ns;
    FRAME_LENGTH_G : integer := 8
    );
  port (
    tcdsCmds : in tTcdsCmds;

    linkBufCtrl : in  tLinkBufCtrl;
    linkBufStat : out tLinkBufStat;

    -- AXI-S In/Out Ports
    axiStreamClk : in  sl;
    axiStreamIn  : in  AxiStreamMasterType;
    axiStreamOut : out AxiStreamMasterType;

    -- BRAM Slow Control Port
    clk  : in  sl               := '0';
    en   : in  sl               := '1';
    we   : in  sl               := '0';
    addr : in  slv(9 downto 0)  := (others => '0');
    din  : in  slv(71 downto 0) := (others => '0');
    dout : out slv(71 downto 0));
end entity LinkStreamBuffer72b;

architecture rtl of LinkStreamBuffer72b is

  type StateType is (
    RST_S,
    CAP_IDLE_S,
    CAP_ARMED_S,
    CAP_DLY_S,
    CAP_RUN_S,
    CAP_DONE_S,
    PB_ARMED_S,
    PB_DLY_S,
    PB_RUN_DATA_S
    );

  type RegType is record
    state        : StateType;
    pbFrameCyc   : integer range 0 to 255;
    pbFFO        : sl;
    pbFrameSOF   : sl;
    pbFrameEOF   : sl;
    pbFrameFFO   : sl;
    pbFrameValid : sl;
    capDly       : integer range 0 to 65535;
    capCnt       : integer range 0 to 1023;
    pbDly        : integer range 0 to 65535;
    pbCnt        : integer range 0 to 1023;
    ramAddr      : integer range 0 to 1023;
    ramAddrInc   : sl;
    ramAddrRst   : sl;
    ramWrEn      : sl;
    ramRst       : sl;
  end record;

  constant REG_INIT_C : RegType := (
    state        => RST_S,
    pbFrameCyc   => 0,
    pbFFO        => '0',
    pbFrameSOF   => '0',
    pbFrameEOF   => '0',
    pbFrameFFO   => '0',
    pbFrameValid => '0',
    capDly       => 0,
    capCnt       => 0,
    pbDly        => 0,
    pbCnt        => 0,
    ramAddr      => 0,
    ramAddrInc   => '0',
    ramAddrRst   => '1',                -- N.B.
    ramWrEn      => '0',
    ramRst       => '0');

  signal r   : RegType := REG_INIT_C;
  signal rin : RegType;

  signal enCapPb   : sl               := '1';
  signal rstCapPb  : sl               := '0';
  signal weCapPb   : sl               := '0';
  signal addrCapPb : slv(9 downto 0)  := (others => '0');
  signal dinCapPb  : slv(71 downto 0) := (others => '0');
  signal doutCapPb : slv(71 downto 0);
  signal capArmRE  : sl;

  component capPbRAM
    port (
      clka  : in  std_logic;
      rsta  : in  std_logic;
      ena   : in  std_logic;
      wea   : in  std_logic_vector(0 downto 0);
      addra : in  std_logic_vector(9 downto 0);
      dina  : in  std_logic_vector(71 downto 0);
      douta : out std_logic_vector(71 downto 0);
      clkb  : in  std_logic;
      rstb  : in  std_logic;
      enb   : in  std_logic;
      web   : in  std_logic_vector(0 downto 0);
      addrb : in  std_logic_vector(9 downto 0);
      dinb  : in  std_logic_vector(71 downto 0);
      doutb : out std_logic_vector(71 downto 0)
      );
  end component;

  signal capPbRst : sl;

  signal tcdsCmdsD1 : tTcdsCmds;

begin

  tcdsCmdsD1 <= tcdsCmds when rising_edge(axiStreamClk);

  U_capPbRAM : capPbRAM
    port map (
      -- BRAM Port A
      clka   => clk,
      ena    => en,
      wea(0) => we,
      rsta   => '0',
      addra  => addr,
      dina   => din,
      douta  => dout,
      -- BRAM Port B
      clkb   => axiStreamClk,
      enb    => enCapPb,
      web(0) => weCapPb,
      rstb   => rstCapPb,
      addrb  => addrCapPb,
      dinb   => dinCapPb,
      doutb  => doutCapPb);

  U_SyncCapPbRst : entity work.Synchronizer
    port map (
      clk     => axiStreamClk,
      dataIn  => linkBufCtrl.rst,
      dataOut => capPbRst
      );

  U_SyncEdgeCapArm : entity work.SynchronizerEdge
    port map (
      clk        => axiStreamClk,
      dataIn     => linkBufCtrl.capArm,
      risingEdge => capArmRE
      );

  comb : process (r, axiStreamIn, capPbRst, capArmRE, linkBufCtrl, tcdsCmdsD1) is
    variable v : RegType;
  begin
    -- Latch the current value
    v       := r;
    v.pbFFO := '0';

    case r.state is
--------------------------------------------------------------------------------
      when RST_S =>
        v.ramAddrInc := '0';
        v.ramAddrRst := '0';
        v.ramRst     := '0';

        if (linkBufCtrl.capPbSel = '0') then
          v.state := CAP_IDLE_S;
        else
          v.state := PB_ARMED_S;
        end if;

--------------------------------------------------------------------------------
      when CAP_IDLE_S =>
        if (capArmRE = '1') then
          v.state := CAP_ARMED_S;
        end if;
--------------------------------------------------------------------------------
      when CAP_ARMED_S =>
        v.capDly := to_integer(unsigned(linkBufCtrl.capDly));
        if (tcdsCmdsD1.bc0 = '1') then
          v.state := CAP_DLY_S;
        end if;
----------------------------------------------------------------------------------
      when CAP_DLY_S =>
        if (v.capDly = 0) then
          v.state   := CAP_RUN_S;
          v.ramWrEn := '1';
        end if;
        v.capDly := v.capDly - 1;
--------------------------------------------------------------------------------
      when CAP_RUN_S =>
        v.ramWrEn    := '1';
        v.ramAddrInc := '1';
        v.capCnt     := v.capCnt + 1;
        if (1023 = v.capCnt) then
          v.state := CAP_DONE_S;
        end if;
--------------------------------------------------------------------------------
      when CAP_DONE_S =>
        v.ramWrEn    := '0';
        v.ramAddrInc := '0';
      -- todo assert capture done (go through rst proc to recapture)
--------------------------------------------------------------------------------
      when PB_ARMED_S =>
        v.pbCnt  := 0;
        v.ramRst := '1';
        v.pbDly  := to_integer(unsigned(linkBufCtrl.pbDly));
        if (tcdsCmdsD1.bc0 = '1') then
          v.state := PB_DLY_S;
        end if;
----------------------------------------------------------------------------------
      when PB_DLY_S =>
        if (v.pbDly = 0) then
          v.state      := PB_RUN_DATA_S;
          v.ramRst     := '0';
          v.ramAddrInc := '1';
          v.pbFFO      := '1';
        end if;
        v.pbDly := v.pbDly - 1;
      --------------------------------------------------------------------------------
      when PB_RUN_DATA_S =>
        v.pbCnt := v.pbCnt + 1;
        if (1023 = v.pbCnt) then
          v.state := PB_ARMED_S;
        end if;
--------------------------------------------------------------------------------
      when others =>

    end case;

    if (r.pbFFO = '1') then
      v.pbFrameCyc   := 0;
      v.pbFrameFFO   := '1';
      v.pbFrameSOF   := '1';
      v.pbFrameEOF   := '0';
      v.pbFrameValid := '1';
    elsif (v.pbFrameCyc = FRAME_LENGTH_G - 2) then
      v.pbFrameCyc   := v.pbFrameCyc + 1;
      v.pbFrameFFO   := '0';
      v.pbFrameSOF   := '0';
      v.pbFrameEOF   := '1';
      v.pbFrameValid := '1';
    elsif (v.pbFrameCyc = FRAME_LENGTH_G-1) then
      v.pbFrameCyc   := 0;
      v.pbFrameFFO   := '0';
      v.pbFrameSOF   := '1';
      v.pbFrameEOF   := '0';
      v.pbFrameValid := '1';
    else
      v.pbFrameCyc   := v.pbFrameCyc + 1;
      v.pbFrameFFO   := '0';
      v.pbFrameSOF   := '0';
      v.pbFrameEOF   := '0';
      v.pbFrameValid := '1';
    end if;
--------
-- Reset
--------
    if (capPbRst = '1') then
      v := REG_INIT_C;
    end if;

    if (v.ramRst = '1') then
      v.ramAddr := 0;
    elsif (v.ramAddrInc = '1') then
      v.ramAddr := v.ramAddr + 1;
    end if;

-- Register the variable for next clock cycle
    rin <= v;

-- Outputs 
    weCapPb   <= r.ramWrEn;
    addrCapPb <= std_logic_vector(to_unsigned(r.ramAddr, 10));
    rstCapPb  <= r.ramRst;

  end process comb;

  seq : process (axiStreamClk) is
  begin
    if (rising_edge(axiStreamClk)) then
      r <= rin after TPD_G;
    end if;
  end process seq;

  process(axiStreamClk) is
  begin
    if rising_edge(axiStreamClk) then

      dinCapPb(63 downto 0)  <= axiStreamIn.tData(63 downto 0);
      dinCapPb(64)           <= axiStreamIn.tValid;
      dinCapPb(65)           <= axiStreamIn.tLast;
      dinCapPb(71 downto 66) <= axiStreamIn.tUser(5 downto 0);
    end if;
  end process;

  process(axiStreamClk) is
  begin
    if rising_edge(axiStreamClk) then
      if (linkBufCtrl.capPbSel = '0') then
        axiStreamOut.tData(63 downto 0) <= axiStreamIn.tData(63 downto 0);
        axiStreamOut.tValid             <= axiStreamIn.tValid;
        axiStreamOut.tLast              <= axiStreamIn.tLast;
        axiStreamOut.tUser(7 downto 0)  <= axiStreamIn.tUser(7 downto 0);
      else
        axiStreamOut.tData(63 downto 0) <= doutCapPb(63 downto 0);
        axiStreamOut.tValid             <= r.pbFrameValid;
        axiStreamOut.tLast              <= r.pbFrameEOF;
        axiStreamOut.tUser(0)           <= r.pbFrameSOF;
        axiStreamOut.tUser(1)           <= r.pbFrameFFO;
        axiStreamOut.tUser(7 downto 2)  <= (others => '0');
      end if;
    end if;
  end process;

end architecture rtl;
