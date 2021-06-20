--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief Package for the according file
--! @author glein
--! @date 2018-06-01
--! @version v.1.0
--! @details
--! Constants, types, functions, ... 
--=============================================================================

--! Standard library
library ieee;
--! Standard package
use ieee.std_logic_1164.all;

--! @brief Package.
package track_gen_bram_pkg is

  -- ########################### Constants ###########################
  constant c_NUMBER_OF_LINES : integer := 18;  --! Number of GT lines = Parallel processed tracks
  constant c_BITS_PER_TRACK  : integer := 96;  --! Number of bits per track
  constant c_ADDR_WIDTH      : integer := 13;  --! Number of address bits

  -- ########################### Types ###########################
  type t_track_array is array (0 to c_NUMBER_OF_LINES-1) of std_logic_vector(c_BITS_PER_TRACK-1 downto 0);  --! Array of x tracks each y bits

end package track_gen_bram_pkg;
