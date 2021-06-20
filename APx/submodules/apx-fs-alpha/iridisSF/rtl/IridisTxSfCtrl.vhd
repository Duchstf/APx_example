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

entity IridisSfTxCtrl is
  generic (
    TPD_G     : time    := 1 ns;
    IDX_BTM_G : integer := 0;
    IDX_TOP_G : integer := 2;
    MGT_CFG_G : tMgtCfgArr
    );
  port (

    tcdsCmds : in tTcdsCmds;

    mgtTxClk      : in  slv(IDX_BTM_G to IDX_TOP_G);
    mgtTxInitDone : in  slv(IDX_BTM_G to IDX_TOP_G);
    mgtTxDataArr  : out tMgtTxDataArr(IDX_BTM_G to IDX_TOP_G);

    -- AXI-Lite Bus
    axiClk         : in  sl;
    axiRst         : in  sl;
    axiReadMaster  : in  AxiLiteReadMasterType;
    axiReadSlave   : out AxiLiteReadSlaveType;
    axiWriteMaster : in  AxiLiteWriteMasterType;
    axiWriteSlave  : out AxiLiteWriteSlaveType;

    -- AXI-Stream In/Out Ports
    axiStreamClk : in sl;
    axiStream    : in AxiStreamMasterArray(IDX_BTM_G to IDX_TOP_G)
    );
end entity IridisSfTxCtrl;

architecture rtl of IridisSfTxCtrl is

  constant ADDR_BIT_CNT_C  : integer := 16;
  constant LINK_INFO_CNT_G : integer := 4;

  type RegType is record
    resync        : slv(IDX_BTM_G to IDX_TOP_G);
    axiReadSlave  : AxiLiteReadSlaveType;
    axiWriteSlave : AxiLiteWriteSlaveType;
  end record RegType;

  constant REG_INIT_C : RegType := (
    resync        => (others => '0'),
    axiReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
    axiWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C
    );

  signal r   : RegType := REG_INIT_C;
  signal rin : RegType;

  signal linkInfo    : Slv32Array(LINK_INFO_CNT_G-1 downto 0) := (others => x"00000000");
  signal tcdsCmdsArr : tTcdsCmdsArr(IDX_BTM_G to IDX_TOP_G);

begin

  genTcdsCmdFanut : for i in IDX_BTM_G to IDX_TOP_G generate
    tcdsCmdsArr(i) <= tcdsCmds when rising_edge(axiStreamClk);
  end generate;

  genIridisSfTx : for i in IDX_BTM_G to IDX_TOP_G generate
    genIridisSfTxEn : if (MGT_CFG_G(i).kind /= mgt_none) generate

      U_IridisSfTx : entity work.IridisSfTx
        generic map(
          TPD_G           => TPD_G,
          FRAME_LENGTH_G  => 6,
          CRC_LENGTH_G    => 16,
          LINK_INFO_CNT_G => 4)
        port map(

          resync => r.resync(i),

          -- MGT interface
          mgtTxClk      => mgtTxClk(i),
          mgtTxInitDone => mgtTxInitDone(i),
          mgtTxHeader   => mgtTxDataArr(i).header,
          mgtTxData     => mgtTxDataArr(i).data,
          mgtTxSequence => mgtTxDataArr(i).sequence,

          -- AXI-stream/algo interface
          axisClk   => axiStreamClk,
          axiStream => axiStream(i),
          linkInfo  => linkInfo
          );
    end generate;
  end generate;

  comb : process (axiReadMaster, axiRst, axiWriteMaster, r) is
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

    for i in IDX_BTM_G to IDX_TOP_G loop
      axiSlaveRegister(axilEp, toSlv(((i-IDX_BTM_G)*256)+0, ADDR_BIT_CNT_C), 0, v.resync(i));

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
