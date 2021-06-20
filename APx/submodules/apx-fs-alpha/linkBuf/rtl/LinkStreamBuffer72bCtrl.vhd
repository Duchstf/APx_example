library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.AxiStreamPkg.all;
use work.LinkBufPkg.all;
use work.MgtPkg.all;
use work.ApxL1TPkg.all;

use work.PrjSpecPkg.all;
use work.tcdsPkg.all;

entity LinkStreamBufferCtrl is
  generic (
    TPD_G         : time    := 1 ns;
    IDX_BTM_G     : integer := 0;
    IDX_TOP_G     : integer := 1;
    BUF_POS_G     : string  := "RX";
    APX_L1T_CFG_G : tApxL1TCfgArr
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

    -- AXI-Stream In/Out Ports
    axiStreamClk : in  sl;
    axiStreamIn  : in  AxiStreamMasterArray(IDX_BTM_G to IDX_TOP_G);
    axiStreamOut : out AxiStreamMasterArray(IDX_BTM_G to IDX_TOP_G)
    );
end entity LinkStreamBufferCtrl;

architecture rtl of LinkStreamBufferCtrl is

  type RegType is record
    ramAxiAddrRst : slv(IDX_BTM_G to IDX_TOP_G);
    ramAxiWrData  : slv32Array(IDX_BTM_G to IDX_TOP_G);
    ramAxiWrEn    : slv(IDX_BTM_G to IDX_TOP_G);
    ramAxiRdEn    : slv(IDX_BTM_G to IDX_TOP_G);

    linkBufCtrlArr : tLinkBufCtrlArr(IDX_BTM_G to IDX_TOP_G);
    axiReadSlave   : AxiLiteReadSlaveType;
    axiWriteSlave  : AxiLiteWriteSlaveType;
  end record RegType;

  constant REG_INIT_C : RegType := (
    ramAxiAddrRst => (others => '0'),
    ramAxiWrData  => (others => (others => '0')),
    ramAxiWrEn    => (others => '0'),
    ramAxiRdEn    => (others => '0'),

    linkBufCtrlArr => (others => LinkBufCtrlInit),
    axiReadSlave   => AXI_LITE_READ_SLAVE_INIT_C,
    axiWriteSlave  => AXI_LITE_WRITE_SLAVE_INIT_C
    );

  signal r   : RegType := REG_INIT_C;
  signal rin : RegType;

  signal linkBufCtrlArr : tLinkBufCtrlArr(IDX_BTM_G to IDX_TOP_G);
  signal linkBufStatArr : tLinkBufStatArr(IDX_BTM_G to IDX_TOP_G);

  signal ramAxiAddrRst : slv(IDX_BTM_G to IDX_TOP_G);
  signal ramAxiWrData  : slv32Array(IDX_BTM_G to IDX_TOP_G);
  signal ramAxiRdData  : slv32Array(IDX_BTM_G to IDX_TOP_G);
  signal ramAxiWrEn    : slv(IDX_BTM_G to IDX_TOP_G);
  signal ramAxiRdEn    : slv(IDX_BTM_G to IDX_TOP_G);

  signal ramWe   : slv(IDX_BTM_G to IDX_TOP_G);
  signal ramAddr : slv10Array(IDX_BTM_G to IDX_TOP_G);
  signal ramDin  : slv72Array(IDX_BTM_G to IDX_TOP_G);
  signal ramDout : slv72Array(IDX_BTM_G to IDX_TOP_G);

  constant ADDR_BIT_CNT_C : integer := 12;

  signal tcdsCmdsArr : tTcdsCmdsArr(IDX_BTM_G to IDX_TOP_G);

begin

  genTcdsCmdFanut : for i in IDX_BTM_G to IDX_TOP_G generate
    tcdsCmdsArr(i) <= tcdsCmds when rising_edge(axiStreamClk);
  end generate;

  genLinkStreamBuf72b : for i in IDX_BTM_G to IDX_TOP_G generate

    U_AxiBufCtrl : entity work.AxiBufCtrl
      generic map(
        TPD_G => TPD_G
        )
      port map(
        clk => axiClk,

        -- AXI  Control Ports
        axiAddrRst => ramAxiAddrRst(i),
        axiWrData  => ramAxiWrData(i),
        axiRdData  => ramAxiRdData(i),
        axiWrEn    => ramAxiWrEn(i),
        axiRdEn    => ramAxiRdEn(i),

        -- BRAM Slow Control Ports
        ramWe   => ramWe(i),
        ramAddr => ramAddr(i),
        ramDin  => ramDin(i),
        ramDout => ramDout(i));

    genBufPosRx : if BUF_POS_G = "RX" generate
      genLinkStreamBuf72bEn : if (APX_L1T_CFG_G(i).linkBufKindRx = buf_72b) generate
        U_LinkStreamBuffer72b : entity work.LinkStreamBuffer72b
          generic map(
            TPD_G          => TPD_G,
            FRAME_LENGTH_G => APX_L1T_CFG_G(i).frameLengthRx
            )
          port map(
            tcdsCmds => tcdsCmdsArr(i),

            linkBufCtrl => linkBufCtrlArr(i),
            linkBufStat => linkBufStatArr(i),

            axiStreamClk => axiStreamClk,
            axiStreamIn  => axiStreamIn(i),
            axiStreamOut => axiStreamOut(i),

            clk  => axiClk,
            we   => ramWe(i),
            addr => ramAddr(i),
            din  => ramDin(i),
            dout => ramDout(i)
            );
      end generate;
    end generate;

    genBufPosTx : if BUF_POS_G = "TX" generate
      genLinkStreamBuf72bEn : if (APX_L1T_CFG_G(i).linkBufKindTx = buf_72b) generate
        U_LinkStreamBuffer72b : entity work.LinkStreamBuffer72b
          generic map(
            TPD_G          => TPD_G,
            FRAME_LENGTH_G => APX_L1T_CFG_G(i).frameLengthTx
            )
          port map(
            tcdsCmds => tcdsCmdsArr(i),

            linkBufCtrl => linkBufCtrlArr(i),
            linkBufStat => linkBufStatArr(i),

            axiStreamClk => axiStreamClk,
            axiStreamIn  => axiStreamIn(i),
            axiStreamOut => axiStreamOut(i),

            clk  => axiClk,
            we   => ramWe(i),
            addr => ramAddr(i),
            din  => ramDin(i),
            dout => ramDout(i)
            );
      end generate;
    end generate;
  end generate;

  comb : process (axiReadMaster, axiRst, axiWriteMaster, r, ramAxiRdData) is
    variable v      : RegType;
    variable axilEp : AxiLiteEndpointType;
  begin
-- Latch the current value
    v := r;

    -- Clear one shot signals
    v.ramAxiAddrRst := (others => '0');
    v.ramAxiWrEn    := (others => '0');
    v.ramAxiRdEn    := (others => '0');

------------------------      
-- AXI-Lite Transactions
------------------------       

-- Determine the transaction type
    axiSlaveWaitTxn(axilEp, axiWriteMaster, axiReadMaster, v.axiWriteSlave, v.axiReadSlave);

    for i in IDX_BTM_G to IDX_TOP_G loop

      axiSlaveRegister(axilEp, toSlv(((i-IDX_BTM_G)*64)+0, ADDR_BIT_CNT_C), 0, v.linkBufCtrlArr(i).rst);
      axiSlaveRegister(axilEp, toSlv(((i-IDX_BTM_G)*64)+0, ADDR_BIT_CNT_C), 1, v.linkBufCtrlArr(i).capPbSel);
      axiSlaveRegister(axilEp, toSlv(((i-IDX_BTM_G)*64)+4, ADDR_BIT_CNT_C), 2, v.linkBufCtrlArr(i).capArm);
      axiSlaveRegister(axilEp, toSlv(((i-IDX_BTM_G)*64)+8, ADDR_BIT_CNT_C), 0, v.linkBufCtrlArr(i).capDly);
      axiSlaveRegister(axilEp, toSlv(((i-IDX_BTM_G)*64)+12, ADDR_BIT_CNT_C), 0, v.linkBufCtrlArr(i).pbDly);

      axiSlaveRegister(axilEp, toSlv(((i-IDX_BTM_G)*64)+16, ADDR_BIT_CNT_C), 0, v.ramAxiAddrRst(i));
      axiSlaveRegister(axilEp, toSlv(((i-IDX_BTM_G)*64)+20, ADDR_BIT_CNT_C), 0, v.ramAxiWrData(i));
      axiWrDetect(axilEp, toSlv(((i-IDX_BTM_G)*64)+20, ADDR_BIT_CNT_C), v.ramAxiWrEn(i));
      axiSlaveRegisterR(axilEp, toSlv(((i-IDX_BTM_G)*64)+24, ADDR_BIT_CNT_C), 0, ramAxiRdData(i));
      axiRdDetect(axilEp, toSlv(((i-IDX_BTM_G)*64)+24, ADDR_BIT_CNT_C), v.ramAxiRdEn(i));

    end loop;
-- Close the transaction
    axiSlaveDefault(axilEp, v.axiWriteSlave, v.axiReadSlave, AXI_RESP_DECERR_C);

--------
-- Reset
--------
    if (axiRst = '1') then
      --  v := REG_INIT_C;
      v.axiReadSlave  := AXI_LITE_READ_SLAVE_INIT_C;
      v.axiWriteSlave := AXI_LITE_WRITE_SLAVE_INIT_C;
    end if;

-- Register the variable for next clock cycle
    rin <= v;

-- Outputs 
    axiReadSlave  <= r.axiReadSlave;
    axiWriteSlave <= r.axiWriteSlave;

    ramAxiAddrRst <= r.ramAxiAddrRst;
    ramAxiWrData  <= r.ramAxiWrData;
    ramAxiWrEn    <= r.ramAxiWrEn;
    ramAxiRdEn    <= r.ramAxiRdEn;

    linkBufCtrlArr <= r.linkBufCtrlArr;

  end process comb;

  seq : process (axiClk) is
  begin
    if (rising_edge(axiClk)) then
      r <= rin after TPD_G;
    end if;
  end process seq;

end architecture rtl;
