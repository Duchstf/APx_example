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
package mux64_pkg is

  -- ########################### Constants ###########################
  constant c_NUMBER_OF_STUBS : integer := 101;  --! Number of stubs per event
  constant c_BITS_PER_STUB   : integer := 36;   --! Number of bits per stub

  -- ########################### Types ###########################
  type t_stub_array is array (0 to c_NUMBER_OF_STUBS-1) of std_logic_vector(c_BITS_PER_STUB-1 downto 0);  --! Array of x stubs each y bits

end package mux64_pkg;
