--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief Testbench barrel shifter.
--! @author glein
--! @date 2018-05-03
--! @version v.1.0
--! @details
--! This is module is the testbench for the barrel shifter. 
--=============================================================================

--! Standard library
library ieee;
--! Standard types
use ieee.std_logic_1164.all;
--! Signed/unsigned calculations
use ieee.numeric_std.all;
--! Math real only for precompliled ports
use ieee.math_real.all;

--! Simulation only
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--! User package
use work.mux64_pkg.all;

entity tb_mux64 is
end tb_mux64;

--! @brief Testbench architecture with clock and stimuli processes
architecture behavior of tb_mux64 is
  constant g_dout_width  : integer := 64;
  constant g_shift_width : integer := 64;
  signal clock_i         : std_logic;
  signal reset_i         : std_logic;
  signal din_arr_i       : t_stub_array := (others => (others => '0') );
  signal din_valid_i     : std_logic;
  signal din_ready_o     : std_logic;
  signal dout_o          : std_logic_vector (g_dout_width-1 downto 0);
  signal dout_valid_o    : std_logic;
  signal dout_ready_i    : std_logic;
  signal shift_cnt_o     : std_logic_vector (integer(floor(sqrt(real(c_NUMBER_OF_STUBS*c_BITS_PER_STUB/g_dout_width)))) downto 0);

  -- Clock period definitions
  constant CLK_period : time := 2.56 ns;


begin

-- Instantiate the Unit Under Test (UUT)
  uut : entity work.mux64 generic map (
    g_dout_width  => g_dout_width,
    g_shift_width => g_shift_width)
    port map (
      clock_i      => clock_i,
      reset_i      => reset_i,
      din_arr_i    => din_arr_i,
      din_valid_i  => din_valid_i,
      din_ready_o  => din_ready_o,
      dout_o       => dout_o,
      dout_valid_o => dout_valid_o,
      dout_ready_i => dout_ready_i,
      shift_cnt_o  => shift_cnt_o);

  -- Clock process definitions
  CLK_process : process
  begin
    clock_i <= '0';
    wait for CLK_period/2;
    clock_i <= '1';
    wait for CLK_period/2;
  end process;
  
  -- Stimulus process
  stim_proc : process
  begin
    -- Hold reset state for 100 ns.
    reset_i               <= '1';
    din_valid_i           <= '0';
    dout_ready_i          <= '0';
    -- Remainding din_arr_i
    for i in 2 to 98 loop
       din_arr_i(i) <= din_arr_i(i-1) + x"1_1111_1111";
       wait for 1 ps;
    end loop;
    wait for 100 ns;
    -- Stimulus 
    din_arr_i(0)    <= x"9_8765_4321";
    din_arr_i(1)    <= x"2_10fe_dcba";
    din_arr_i(99)   <= x"a_bcde_f012";
    din_arr_i(100)  <= x"1_2345_6789";
    reset_i               <= '0';
    wait for CLK_period;
    dout_ready_i          <= '1';
    wait for CLK_period*1;
    din_valid_i           <= '1';
    wait for CLK_period*5;
    dout_ready_i          <= '0';
    wait for CLK_period*2;
    dout_ready_i          <= '1';
    wait for CLK_period*1;

    wait;
  end process;

end behavior;
