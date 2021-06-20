library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;

entity AxiBufCtrl is
  generic (
    TPD_G : time := 1 ns
    );
  port (
    clk : in std_logic;

    -- AXI  Control Ports
    axiAddrRst : in  sl;
    axiWrData  : in  slv(31 downto 0);
    axiRdData  : out slv(31 downto 0);
    axiWrEn    : in  sl;
    axiRdEn    : in  sl;

    -- BRAM Slow Control Ports
    ramWe   : out sl;
    ramAddr : out slv(9 downto 0);
    ramDin  : out slv(71 downto 0);
    ramDout : in  slv(71 downto 0));
end AxiBufCtrl;

architecture rtl of AxiBufCtrl is

  type RegType is record
    wrCycle       : integer range 0 to 2;
    rdCycle       : integer range 0 to 2;
    ramWe         : sl;
    ramAddrIncr   : sl;
    ramAddrIncrD1 : sl;
    ramAddr       : unsigned(9 downto 0);
    ramDin        : slv(71 downto 0);
  end record;

  constant REG_INIT_C : RegType := (
    wrCycle       => 0,
    rdCycle       => 0,
    ramWe         => '0',
    ramAddrIncr   => '0',
    ramAddrIncrD1 => '0',
    ramAddr       => (others => '0'),
    ramDin        => (others => '0'));

  signal r   : RegType := REG_INIT_C;
  signal rin : RegType;

begin

  comb : process (r, axiAddrRst, axiWrData, axiWrEn, axiRdEn, ramDout) is
    variable v : RegType;
  begin
    -- Latch the current value
    v := r;

    v.ramAddrIncr := '0';
    v.ramWe       := '0';

    case (v.wrCycle) is
      when 0      => v.ramDin(31 downto 0)  := axiWrData;
      when 1      => v.ramDin(63 downto 32) := axiWrData;
      when others => v.ramDin(71 downto 64) := axiWrData(7 downto 0);
    end case;

    case (v.rdCycle) is
      when 0      => axiRdData             <= ramDout(31 downto 0);
      when 1      => axiRdData             <= ramDout(63 downto 32);
      when others => axiRdData(7 downto 0) <= ramDout(71 downto 64);
                     axiRdData(31 downto 8) <= (others => '0');
    end case;

    if (axiWrEn = '1') then
      if (v.wrCycle = 2) then
        v.wrCycle     := 0;
        v.ramAddrIncr := '1';
        v.ramWe       := '1';
      else
        v.wrCycle := v.wrCycle + 1;
      end if;
    end if;

    if (axiRdEn = '1') then
      if (v.rdCycle = 2) then
        v.rdCycle     := 0;
        v.ramAddrIncr := '1';
      else
        v.rdCycle := v.rdCycle + 1;
      end if;
    end if;

    if (v.ramAddrIncrD1 = '1') then
      v.ramAddr := v.ramAddr + 1;
    end if;

    v.ramAddrIncrD1 := v.ramAddrIncr;
--------
-- Reset
--------
    if (axiAddrRst = '1') then
      v := REG_INIT_C;
    end if;

-- Register the variable for next clock cycle
    rin <= v;

-- Outputs
    ramAddr <= slv(r.ramAddr);
    ramWe   <= r.ramWe;
    ramDin  <= r.ramDin;
  end process comb;

  seq : process (clk) is
  begin
    if (rising_edge(clk)) then
      r <= rin after TPD_G;
    end if;
  end process seq;

end rtl;
