library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.StdRtlPkg.all;

package LinkBufPkg is

  type tLinkBufCtrl is record
    rst      : sl;
    capPbSel : sl;
    capArm   : sl;
    capDly   : slv(15 downto 0);
    pbDly    : slv(15 downto 0);
  end record;

  constant LinkBufCtrlInit : tLinkBufCtrl := (
    rst      => '0',
    capPbSel => '0',
    capArm   => '0',
    capDly   => (others => '0'),
    pbDly    => (others => '0')
    );

  type tLinkBufStat is record
    done : sl;
  end record;

  type tLinkBufCtrlArr is array (integer range <>) of tLinkBufCtrl;
  type tLinkBufStatArr is array (integer range <>) of tLinkBufStat;

end package LinkBufPkg;
