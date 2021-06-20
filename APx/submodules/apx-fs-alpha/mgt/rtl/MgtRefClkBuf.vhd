library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.StdRtlPkg.all;

library unisim;
use unisim.vcomponents.all;

entity MgtRefClkBuf is
  port (
    mgtRefClkP    : in  sl;
    mgtRefClkN    : in  sl;
    mgtRefClk     : out sl;
    mgtRefClkBufg : out sl := '0'
    );
end MgtRefClkBuf;

architecture rtl of MgtRefClkBuf is

  signal mgtRefClkIbufds : std_logic;

begin

  U_IBUFDS : IBUFDS_GTE4
    generic map (
      REFCLK_EN_TX_PATH  => '0',
      REFCLK_HROW_CK_SEL => "00",       -- 2'b00: ODIV2 = O
      REFCLK_ICNTL_RX    => "00"
      )
    port map (
      I     => mgtRefClkP,
      IB    => mgtRefClkN,
      CEB   => '0',
      ODIV2 => mgtRefClkIbufds,
      O     => mgtRefClk);

--  U_BUFG_GT : BUFG_GT
--    port map (
--      I       => mgtRefClkIbufds,
--      CE      => '1',
--      CEMASK  => '1',
--      CLR     => '0',
--      CLRMASK => '1',
--      DIV     => "000",
--      O       => mgtRefClkBufg);

end rtl;
