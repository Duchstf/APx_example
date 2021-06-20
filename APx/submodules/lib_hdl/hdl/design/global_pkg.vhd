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
package global_pkg is

  -- ########################### Constants ###########################
  constant c_AXI_BIT_WIDTH   : integer := 64;  --! Number of bits of an AXI word
  constant c_NUMBER_OF_LINES : integer := 18;  --! Number of GT lines = Parallel processed tracks
  constant c_BITS_PER_TRACK  : integer := 96;  --! Number of bits per track
  constant c_ADDR_WIDTH      : integer := 13;  --! Number of track BRAM address bits
  constant c_HIST_BINS       : integer := 72;  --! Number of bins in a histogram
  constant c_HIST_BIN_WIDTH  : integer := 9;   --! Word width of bins

  -- ########################### Types ###########################
  type t_track_array     is array (0 to c_NUMBER_OF_LINES-1)   of std_logic_vector(c_BITS_PER_TRACK-1 downto 0);  --! Array of x tracks each y bits
  type t_track_array_ext is array (0 to c_NUMBER_OF_LINES*3-1) of std_logic_vector(c_BITS_PER_TRACK-1 downto 0);  --! Array of x tracks each y bits for the 3 copies
  type t_hist_array      is array (0 to c_HIST_BINS-1)         of std_logic_vector(c_HIST_BIN_WIDTH-1 downto 0);  --! Histogram array of x bins each y bits
  type t_hist_array_ext  is array (0 to c_HIST_BINS*3-1)       of std_logic_vector(c_HIST_BIN_WIDTH-1 downto 0);  --! Histogram array of x bins each y bits for the 3 copies

end package global_pkg;
