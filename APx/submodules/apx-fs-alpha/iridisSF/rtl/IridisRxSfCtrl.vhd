library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.AxiStreamPkg.all;
use work.IridisPkg.all;
use work.MgtPkg.all;

use work.PrjSpecPkg.all;
use work.tcdsPkg.all;

entity IridisSfRxCtrl is
  generic (
    TPD_G     : time    := 1 ns;
    IDX_BTM_G : integer := 0;
    IDX_TOP_G : integer := 2;
    MGT_CFG_G : tMgtCfgArr
    );
  port (

    tcdsCmds : in tTcdsCmds;

    mgtRxClk         : in  slv(IDX_BTM_G to IDX_TOP_G);
    mgtRxInitDone    : in  slv(IDX_BTM_G to IDX_TOP_G);
    mgtRxGearboxSlip : out slv(IDX_BTM_G to IDX_TOP_G);
    mgtRxDataArr     : in  tMgtRxDataArr(IDX_BTM_G to IDX_TOP_G);

    -- AXI-Lite Bus
    axiClk         : in  sl;
    axiRst         : in  sl;
    axiReadMaster  : in  AxiLiteReadMasterType;
    axiReadSlave   : out AxiLiteReadSlaveType;
    axiWriteMaster : in  AxiLiteWriteMasterType;
    axiWriteSlave  : out AxiLiteWriteSlaveType;

    -- AXI-Stream In/Out Ports
    axiStreamClk : in  sl;
    axiStreamOut : out AxiStreamMasterArray(IDX_BTM_G to IDX_TOP_G)
    );
end entity IridisSfRxCtrl;

architecture rtl of IridisSfRxCtrl is

  constant ADDR_BIT_CNT_C : integer := 16;

  type RegType is record
    axiReadSlave  : AxiLiteReadSlaveType;
    axiWriteSlave : AxiLiteWriteSlaveType;
  end record RegType;

  constant REG_INIT_C : RegType := (
    axiReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
    axiWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C
    );

  signal r   : RegType := REG_INIT_C;
  signal rin : RegType;


  signal FFO           : slv(IDX_BTM_G to IDX_TOP_G);
  signal gearboxLocked : slv(IDX_BTM_G to IDX_TOP_G);
  signal protoErr      : slv(IDX_BTM_G to IDX_TOP_G);

  signal tcdsCmdsArr : tTcdsCmdsArr(IDX_BTM_G to IDX_TOP_G);

  signal fifoReady : slv(IDX_BTM_G to IDX_TOP_G);

begin

  genTcdsCmdFanut : for i in IDX_BTM_G to IDX_TOP_G generate
    tcdsCmdsArr(i) <= tcdsCmds when rising_edge(axiStreamClk);
  end generate;

  genIridisSfRx : for i in IDX_BTM_G to IDX_TOP_G generate
    genIridisSfRxEn : if (MGT_CFG_G(i).kind /= mgt_none) generate
      U_IridisSfRx : entity work.IridisSfRx
        generic map(
          TPD_G           => TPD_G,
          FRAME_LENGTH_G  => 6,
          CRC_LENGTH_G    => 16,
          LINK_INFO_CNT_G => 4)
        port map(

          -- Resync request (axis clk domain)
          resync => tcdsCmdsArr(i).bc0,

          -- Rx FIFO interface
          fifoRelease => tcdsCmdsArr(i).bc0,
          fifoReady   => fifoReady(i),

          -- MGT interface
          mgtRxClk         => mgtRxClk(i),
          mgtRxInitDone    => mgtRxInitDone(i),
          mgtRxHeaderValid => mgtRxDataArr(i).headervalid,
          mgtRxHeader      => mgtRxDataArr(i).header,
          mgtRxDataValid   => mgtRxDataArr(i).datavalid,
          mgtRxData        => mgtRxDataArr(i).data,
          mgtRxSlip        => mgtRxGearboxSlip(i),
          gearboxLocked    => gearboxLocked(i),

          -- AXI-stream/algo interface
          axisClk   => axiStreamClk,
          axiStream => axiStreamOut(i),

          -- Core Diagnostic Ports
          FFO      => FFO(i),
          protoErr => protoErr(i),

          linkInfo => open
          );
    end generate;
  end generate;

  comb : process (axiReadMaster, axiRst, axiWriteMaster, r, FFO, protoErr, gearboxLocked) is
    variable v      : RegType;
    variable axilEp : AxiLiteEndpointType;
  begin
-- Latch the current value
    v := r;

------------------------      
-- AXI-Lite Transactions
------------------------       

-- Determine the transaction type
    axiSlaveWaitTxn(axilEp, axiWriteMaster, axiReadMaster, v.axiWriteSlave, v.axiReadSlave);

    --axiSlaveRegister(axilEp, x"004", 0, v.scratchPad);
    for i in IDX_BTM_G to IDX_TOP_G loop
      axiSlaveRegisterR(axilEp, toSlv(((i-IDX_BTM_G)*256)+0, ADDR_BIT_CNT_C), 0, FFO(i));
      axiSlaveRegisterR(axilEp, toSlv(((i-IDX_BTM_G)*256)+0, ADDR_BIT_CNT_C), 1, protoErr(i));
      axiSlaveRegisterR(axilEp, toSlv(((i-IDX_BTM_G)*256)+0, ADDR_BIT_CNT_C), 2, gearboxLocked(i));

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
    axiReadSlave  <= r.axiReadSlave;
    axiWriteSlave <= r.axiWriteSlave;

  end process comb;

  seq : process (axiClk) is
  begin
    if (rising_edge(axiClk)) then
      r <= rin after TPD_G;
    end if;
  end process seq;

end architecture rtl;
