library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.StdRtlPkg.all;
use work.AxiStreamPkg.all;

package iridisPkg is

  constant AXIS_TUSER_POS_SOF_C : integer := 0;
  constant AXIS_TUSER_POS_FFO_C : integer := 1;

  constant FIFO_POS_FFO_C    : integer := 67;
  constant FIFO_POS_SOF_C    : integer := 66;
  constant FIFO_POS_TLAST_C  : integer := 65;
  constant FIFO_POS_TVALID_C : integer := 64;

-- Block Type Field (BTF)

  constant BTF_A_IDX_C : integer := 0;
  constant BTF_B_IDX_C : integer := 1;
  constant BTF_C_IDX_C : integer := 2;
  constant BTF_D_IDX_C : integer := 3;
  constant BTF_E_IDX_C : integer := 4;
  constant BTF_F_IDX_C : integer := 5;
  constant BTF_G_IDX_C : integer := 6;
  constant BTF_H_IDX_C : integer := 7;
  constant BTF_I_IDX_C : integer := 8;

  -- Define K code Block Type Fields (BTF)
  constant IRIDIS_BTF_ARRAY_C : Slv8Array(0 to 8) := (
    X"EE",                              -- BTF_A_IDX_C
    X"DD",                              -- BTF_B_IDX_C
    X"CC",                              -- BTF_C_IDX_C
    X"BB",                              -- BTF_D_IDX_C
    X"AA",                              -- BTF_E_IDX_C
    X"99",                              -- BTF_F_IDX_C
    X"88",                              -- BTF_G_IDX_C
    X"77",                              -- BTF_H_IDX_C
    X"66"                               -- BTF_I_IDX_C
    );

  constant IRIDIS_D_HEADER_C : slv(1 downto 0) := "01";
  constant IRIDIS_K_HEADER_C : slv(1 downto 0) := "10";

  constant IRIDIS_SCRAMBLER_TAPS_C : IntegerArray(0 to 1) := (0 => 39, 1 => 58);

  subtype IRIDIS_BTF_FIELD_C is natural range 63 downto 56;

end package iridisPkg;

