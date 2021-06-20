library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;

use work.tcdsPkg.all;

entity algoCtrl is
  generic (
    TPD_G : time := 1 ns);
  port (
    algoClk   : in  sl;
    algoRst   : out sl;
    algoStart : out sl;
    algoDone  : in  sl;
    algoIdle  : in  sl;
    algoReady : in  sl;

    tcdsCmds : in tTcdsCmds;

    -- AXI-Lite Bus
    axiClk         : in  sl                     := '0';
    axiClkRst      : in  sl                     := '0';
    axiReadMaster  : in  AxiLiteReadMasterType  := AXI_LITE_READ_MASTER_INIT_C;
    axiReadSlave   : out AxiLiteReadSlaveType;
    axiWriteMaster : in  AxiLiteWriteMasterType := AXI_LITE_WRITE_MASTER_INIT_C;
    axiWriteSlave  : out AxiLiteWriteSlaveType);
end algoCtrl;

architecture rtl of algoCtrl is

  type RegType is record
    algoRstArm    : sl;
    algoRst       : sl;
    algoStart     : sl;
    algoRstDly    : slv(15 downto 0);
    algoStartDly  : slv(15 downto 0);
    axiReadSlave  : AxiLiteReadSlaveType;
    axiWriteSlave : AxiLiteWriteSlaveType;
  end record RegType;

  constant REG_INIT_C : RegType := (
    algoRstArm    => '0',
    algoRst       => '0',
    algoStart     => '0',
    algoRstDly    => (others => '0'),
    algoStartDly  => (others => '0'),
    axiReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
    axiWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C);

  signal r   : RegType := REG_INIT_C;
  signal rin : RegType;

  signal algoRstArmSync : sl;

  signal algoRstInt   : sl;
  signal algoStartInt : sl;

  signal bcCnt : unsigned(15 downto 0);

begin

  comb : process (axiClkRst, axiReadMaster, axiWriteMaster, r) is
    variable v      : RegType;
    variable axilEp : AxiLiteEndPointType;
  begin
    -- Latch the current value
    v := r;

    -- Determine the transaction type
    axiSlaveWaitTxn(axilEp, axiWriteMaster, axiReadMaster, v.axiWriteSlave, v.axiReadSlave);

    axiSlaveRegister(axilEp, x"0000", 0, v.algoRstArm);
    axiSlaveRegister(axilEp, x"0004", 0, v.algoRstDly);
    axiSlaveRegister(axilEp, x"0008", 0, v.algoStartDly);

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

  end process comb;

  seq : process (axiClk) is
  begin
    if (rising_edge(axiClk)) then
      r <= rin after TPD_G;
    end if;
  end process seq;

  U_Sync_AlgoRst : entity work.Synchronizer
    generic map(
      TPD_G => TPD_G
      )
    port map(
      clk     => algoClk,
      dataIn  => r.algoRstArm,
      dataOut => algoRstArmSync
      );

  process(algoClk) is
  begin
    if rising_edge(algoClk) then
      if (tcdsCmds.bc0 = '1') then
        bcCnt <= (others => '0');
      else
        bcCnt <= bcCnt + 1;
      end if;

      if (algoRstArmSync = '1') then
        algoRstInt   <= '1';
        algoStartInt <= '0';
      else

        if (r.algoRstDly = slv(bcCnt)) then
          algoRstInt <= '0';
        end if;

        if ((r.algoStartDly = slv(bcCnt) and algoRstInt = '0') or
            (r.algoStartDly = slv(bcCnt) and r.algoRstDly = slv(bcCnt))) then
          algoStartInt <= '1';
        end if;

      end if;

      algoRst   <= algoRstInt;
      algoStart <= algoStartInt;

    end if;
  end process;

end architecture rtl;
