library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.StdRtlPkg.all;
use work.MgtPkg.all;

package ApxL1TPkg is

  type tLinkBufKind is (buf_none, buf_72b);

  type tApxL1TCfg is record
    sector           : integer;
    linkBufKindRx    : tLinkBufKind;
    frameLengthRx    : integer;
    fifoReadLengthRx : integer;
    fifoHoldLengthRx : integer;
    crcLengthRx      : integer;
    linkBufKindTx    : tLinkBufKind;
    frameLengthTx    : integer;
    fifoReadLengthTx : integer;
    fifoHoldLengthTx : integer;
    crcLengthTx      : integer;
  end record;

  type tApxL1TCfgArr is array (integer range <>) of tApxL1TCfg;

  function sectorMinIdx (sector : integer; a : tApxL1TCfgArr) return integer;
  function sectorMaxIdx (sector : integer; a : tApxL1TCfgArr) return integer;

end package APxL1TPkg;

package body ApxL1TPkg is

--  Sector Index finder helper functions
  function sectorMinIdx (
    sector : integer; a : tApxL1TCfgArr)
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
    sector : integer; a : tApxL1TCfgArr)
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

end package body ApxL1TPkg;
