
library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.StdRtlPkg.all;


package MgtPkg is

  type tMgtTxData is record
    data : slv(63 downto 0);

    -- For 8b10b
    charisk      : slv(3 downto 0);
    chardispmode : slv(3 downto 0);
    chardispval  : slv(3 downto 0);
    -- For 64b66b
    header       : slv(1 downto 0);
    sequence     : slv(6 downto 0);
  end record;

  type tMgtRxData is record
    data : slv(63 downto 0);

    -- For 8b10b
    byteisaligned : sl;
    byterealign   : sl;
    commadet      : sl;
    rxchariscomma : slv(3 downto 0);
    charisk       : slv(3 downto 0);
    notintable    : slv(3 downto 0);
    disperr       : slv(3 downto 0);

    -- For 64b66b
    datavalid   : sl;
    header      : slv(1 downto 0);
    headervalid : sl;
  end record;

  type tMgtSlwCtrl is record
    mgtMasterRst   : sl;
    mgtRxRst       : sl;
    mgtTxRst       : sl;
    loopback       : slv(2 downto 0);
    rxPd           : sl;
    txPd           : sl;
    rxPolarity     : sl;
    txPolarity     : sl;
    txPrbsForceErr : sl;
    rxPrbsCntRst   : sl;
    rxPrbsSel      : slv(3 downto 0);
    txPrbsSel      : slv(3 downto 0);
    txDiffCtrl     : slv(4 downto 0);
    txMainCursor   : slv(6 downto 0);
    txPostCursor   : slv(4 downto 0);
    txPreCursor    : slv(4 downto 0);

    rxcdrfreqreset   : sl;
    rxcdrhold        : sl;
    rxcdrovrden      : sl;
    rxcdrreset       : sl;
    rxdfeagchold     : sl;
    rxdfeagcovrden   : sl;
    rxdfecfokfcnum   : slv(3 downto 0);
    rxdfecfokfen     : sl;
    rxdfecfokfpulse  : sl;
    rxdfecfokhold    : sl;
    rxdfecfokovren   : sl;
    rxdfekhhold      : sl;
    rxdfekhovrden    : sl;
    rxdfelfhold      : sl;
    rxdfelfovrden    : sl;
    rxdfelpmreset    : sl;
    rxdfetap10hold   : sl;
    rxdfetap10ovrden : sl;
    rxdfetap11hold   : sl;
    rxdfetap11ovrden : sl;
    rxdfetap12hold   : sl;
    rxdfetap12ovrden : sl;
    rxdfetap13hold   : sl;
    rxdfetap13ovrden : sl;
    rxdfetap14hold   : sl;
    rxdfetap14ovrden : sl;
    rxdfetap15hold   : sl;
    rxdfetap15ovrden : sl;
    rxdfetap2hold    : sl;
    rxdfetap2ovrden  : sl;
    rxdfetap3hold    : sl;
    rxdfetap3ovrden  : sl;
    rxdfetap4hold    : sl;
    rxdfetap4ovrden  : sl;
    rxdfetap5hold    : sl;
    rxdfetap5ovrden  : sl;
    rxdfetap6hold    : sl;
    rxdfetap6ovrden  : sl;
    rxdfetap7hold    : sl;
    rxdfetap7ovrden  : sl;
    rxdfetap8hold    : sl;
    rxdfetap8ovrden  : sl;
    rxdfetap9hold    : sl;
    rxdfetap9ovrden  : sl;
    rxdfeuthold      : sl;
    rxdfeutovrden    : sl;
    rxdfevphold      : sl;
    rxdfevpovrden    : sl;
    rxdfexyden       : sl;
    rxlpmen          : sl;
    rxlpmgchold      : sl;
    rxlpmgcovrden    : sl;
    rxlpmhfhold      : sl;
    rxlpmhfovrden    : sl;
    rxlpmlfhold      : sl;
    rxlpmlfklovrden  : sl;
    rxlpmoshold      : sl;
    rxlpmosovrden    : sl;

  end record;

  constant MgtTxData_Null_C : tMgtTxData := (
    data => (others => '0'),

    -- For 8b10b
    charisk      => (others => '0'),
    chardispmode => (others => '0'),
    chardispval  => (others => '0'),
    -- For 64b66b
    header       => (others => '0'),
    sequence     => (others => '0')
    );

  constant MgtRxData_Null_C : tMgtRxData := (
    data => (others => '0'),

    -- For 8b10b
    byteisaligned => '0',
    byterealign   => '0',
    commadet      => '0',
    rxchariscomma => (others => '0'),
    charisk       => (others => '0'),
    notintable    => (others => '0'),
    disperr       => (others => '0'),

    -- For 64b66b
    datavalid   => '0',
    header      => (others => '0'),
    headervalid => '0'
    );

  constant MgtSlwCtrlPowerOn_C : tMgtSlwCtrl := (

    mgtMasterRst   => '0',
    mgtRxRst       => '0',
    mgtTxRst       => '0',
    loopback       => "000",
    rxPd           => '0',
    txPd           => '0',
    rxPolarity     => '0',
    txPolarity     => '0',
    txPrbsForceErr => '0',
    rxPrbsCntRst   => '0',
    rxPrbsSel      => "0000",
    txPrbsSel      => "0000",

    txDiffCtrl   => "10000",
    txMainCursor => (others => '0'),
    txPostCursor => (others => '0'),
    txPreCursor  => (others => '0'),

    rxcdrfreqreset   => '0',
    rxcdrhold        => '0',
    rxcdrovrden      => '0',
    rxcdrreset       => '0',
    rxdfeagchold     => '0',
    rxdfeagcovrden   => '0',
    rxdfecfokfcnum   => "0000",
    rxdfecfokfen     => '0',
    rxdfecfokfpulse  => '0',
    rxdfecfokhold    => '0',
    rxdfecfokovren   => '0',
    rxdfekhhold      => '0',
    rxdfekhovrden    => '0',
    rxdfelfhold      => '0',
    rxdfelfovrden    => '0',
    rxdfelpmreset    => '0',
    rxdfetap10hold   => '0',
    rxdfetap10ovrden => '0',
    rxdfetap11hold   => '0',
    rxdfetap11ovrden => '0',
    rxdfetap12hold   => '0',
    rxdfetap12ovrden => '0',
    rxdfetap13hold   => '0',
    rxdfetap13ovrden => '0',
    rxdfetap14hold   => '0',
    rxdfetap14ovrden => '0',
    rxdfetap15hold   => '0',
    rxdfetap15ovrden => '0',
    rxdfetap2hold    => '0',
    rxdfetap2ovrden  => '0',
    rxdfetap3hold    => '0',
    rxdfetap3ovrden  => '0',
    rxdfetap4hold    => '0',
    rxdfetap4ovrden  => '0',
    rxdfetap5hold    => '0',
    rxdfetap5ovrden  => '0',
    rxdfetap6hold    => '0',
    rxdfetap6ovrden  => '0',
    rxdfetap7hold    => '0',
    rxdfetap7ovrden  => '0',
    rxdfetap8hold    => '0',
    rxdfetap8ovrden  => '0',
    rxdfetap9hold    => '0',
    rxdfetap9ovrden  => '0',
    rxdfeuthold      => '0',
    rxdfeutovrden    => '0',
    rxdfevphold      => '0',
    rxdfevpovrden    => '0',
    rxdfexyden       => '0',
    rxlpmen          => '1',            -- default: LPM mode
    rxlpmgchold      => '0',
    rxlpmgcovrden    => '0',
    rxlpmhfhold      => '0',
    rxlpmhfovrden    => '0',
    rxlpmlfhold      => '0',
    rxlpmlfklovrden  => '0',
    rxlpmoshold      => '0',
    rxlpmosovrden    => '0'
    );

  type tMgtSlwStatus is record
    txInitDone   : sl;
    rxInitDone   : sl;
    rxPrbsLocked : sl;
    rxcdrlock    : sl;
    rxcdrphdone  : sl;
  end record;


  type tRefClkCfg is record
    enabled : boolean;
    sector  : integer;
  end record;

  constant RefClkCfgOff_C : tRefclkCfg := (false, -1);

  type tQpllCfg is record
    enabled : boolean;
    refclk0 : integer;
    refclk1 : integer;
    sector  : integer;
  end record;

  constant QpllCfgOff_C : tQpllCfg := (false, -1, -1, -1);

  type tMgtKind is (mgt_none, gty_sym_25p78125, gty_sym_15p7, gty_sym_16p0);

  type tEncType is (enc_none, enc_64b66b, enc_8b10b);

  type tMgtCfg is record
    kind       : tMgtKind;
    sector     : integer;
    rxLineRate : integer;
    rx_enc     : tEncType;
    txLineRate : integer;
    tx_enc     : tEncType;
  end record;

  constant MgtCfgOff_C : tMgtCfg := (kind => mgt_none, sector => -1, rxLineRate => 0, txLineRate => 0, rx_enc => enc_none, tx_enc => enc_none);

  type tMgtTxDataArr is array (integer range <>) of tMgtTxData;
  type tMgtrxDataArr is array (integer range <>) of tMgtRxData;
  type tMgtSlwCtrlArr is array (integer range <>) of tMgtSlwCtrl;
  type tMgtSlwStatusArr is array (integer range <>) of tMgtSlwStatus;

  type tRefClkCfgArr is array (integer range <>) of tRefClkCfg;
  type tQpllCfgArr is array (integer range <>) of tQpllCfg;
  type tMgtCfgArr is array (integer range <>) of tMgtCfg;

  function sectorMinIdx (sector : integer; a : tRefClkCfgArr) return integer;
  function sectorMaxIdx (sector : integer; a : tRefClkCfgArr) return integer;

  function sectorMinIdx (sector : integer; a : tQpllCfgArr) return integer;
  function sectorMaxIdx (sector : integer; a : tQpllCfgArr) return integer;

  function sectorMinIdx (sector : integer; a : tMgtCfgArr) return integer;
  function sectorMaxIdx (sector : integer; a : tMgtCfgArr) return integer;


end package MgtPkg;

package body MgtPkg is

-- RefClk Sector Index finder helper functions
  function sectorMinIdx (
    sector : integer; a : tRefClkCfgArr)
    return integer is
    --variable min : integer := a(a'low).sector;
    variable min : integer := 255;
  begin
    for i in a'range loop
      if (a(i).sector = sector) then
        if (i < min) then
          min := i;
        end if;
      end if;
    end loop;
    return min;
  -- return a(a'high).sector;
  end function sectorMinIdx;

  function sectorMaxIdx (
    sector : integer; a : tRefClkCfgArr)
    return integer is
    variable max : integer := -1;
  begin
    for i in a'range loop
      if (a(i).sector = sector) then
        if (i > max) then
          max := i;
        end if;
      end if;
    end loop;
    return max;
  end function sectorMaxIdx;

-- QpllClk Sector Index finder helper functions
  function sectorMinIdx (
    sector : integer; a : tQpllCfgArr)
    return integer is
    variable min : integer := 255;
  begin
    for i in a'range loop
      if (a(i).sector = sector) then
        if (i < min) then
          min := i;
        end if;
      end if;
    end loop;
    return min;
  end function sectorMinIdx;

  function sectorMaxIdx (
    sector : integer; a : tQpllCfgArr)
    return integer is
    variable max : integer := -1;
  begin
    for i in a'range loop
      if (a(i).sector = sector) then
        if (i > max) then
          max := i;
        end if;
      end if;
    end loop;
    return max;
  end function sectorMaxIdx;

-- MgtClk Sector Index finder helper functions
  function sectorMinIdx (
    sector : integer; a : tMgtCfgArr)
    return integer is
    variable min : integer := 255;
  begin
    for i in a'range loop
      if (a(i).sector = sector) then
        if (i < min) then
          min := i;
        end if;
      end if;
    end loop;
    return min;
  end function sectorMinIdx;

  function sectorMaxIdx (
    sector : integer; a : tMgtCfgArr)
    return integer is
    variable max : integer := -1;
  begin
    for i in a'range loop
      if (a(i).sector = sector) then
        if (i > max) then
          max := i;
        end if;
      end if;
    end loop;
    return max;
  end function sectorMaxIdx;

end package body MgtPkg;

