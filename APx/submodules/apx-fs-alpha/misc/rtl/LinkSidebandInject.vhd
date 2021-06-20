library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiStreamPkg.all;

use work.ApxL1TPkg.all;

entity LinkSidebandInject is
  generic (
    N_OUTPUT_STREAMS : integer := 24;
    APX_L1T_CFG_G    : tApxL1TCfgArr
    );
  port (
    algoClk      : in  sl;
    algoRst      : in  sl;
    axiStreamIn  : in  AxiStreamMasterArray(0 to N_OUTPUT_STREAMS-1);
    axiStreamOut : out AxiStreamMasterArray(0 to N_OUTPUT_STREAMS-1)
    );
end LinkSidebandInject;

architecture rtl of LinkSidebandInject is

begin
  gen : for i in 0 to N_OUTPUT_STREAMS-1 generate
    process(algoClk) is
    begin
      if rising_edge(algoClk) then
        axiStreamOut <= axiStreamIn;
      end if;
    end process;
  end generate;

end rtl;
