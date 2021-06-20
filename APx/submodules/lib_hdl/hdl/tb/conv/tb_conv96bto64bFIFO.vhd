--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief Test bench for 64 b MGT word to 96 b Track Finding (TF) word conversion. 
--! @author glein
--! @date 2019-10-21
--! @version v.1.0
--=============================================================================

--! Standard library
library ieee;
--! Standard package
use ieee.std_logic_1164.all;
--! Signed/unsigned calculations
use ieee.numeric_std.all;
--! Math real only for precompliled ports
use ieee.math_real.all;

--! Xilinx library
library unisim;
--! Xilinx package
use unisim.vcomponents.all;

--! User package


--! @brief TB
entity tb_conv96bto64bFIFO is
end entity tb_conv96bto64bFIFO;

--! @brief TB
architecture behavior of tb_conv96bto64bFIFO is

  -- ########################### Types ###########################

  -- ########################### Constant Definitions ###########################
  constant CLK1_period : time := 2.778 ns; -- 360.0 MHz
  constant CLK2_period : time := 2.560 ns; -- 390.6 MHz

  -- ########################### Signal ###########################
  signal clk1    : std_logic := '0';
  signal rst1    : std_logic := '0';
  signal clk2    : std_logic := '0';
  signal rst2_s  : std_logic;
  signal TF_96b  : std_logic_vector(96-1 downto 0) := (others => '0'); --! 96 b TF word
  signal MGT_64b : std_logic_vector(64-1 downto 0); --! 64 b MGT word
  signal MGT_64b_vld : std_logic;
  signal MGT_64b_rdy : std_logic := '0';
  signal full    : std_logic;
  signal empty   : std_logic;
  signal wr_rst_busy : std_logic;
  signal rd_rst_busy : std_logic;

begin
  -- ########################### Assertion ###########################

  -- ########################### Instantiation ###########################
    uut : entity work.conv96bto64bFIFO generic map (
    USE_BRAM => true   )
    port map (
    clk1    => clk1,
    rst1    => rst1,
    clk2      => clk2,
    rst2_s    => rst2_s,
    TF_96b  => TF_96b,
    MGT_64b   => MGT_64b,
    MGT_64b_vld => MGT_64b_vld,
    MGT_64b_rdy => MGT_64b_rdy,
    full      => full,
    empty     => empty,
    wr_rst_busy => wr_rst_busy,
    rd_rst_busy => rd_rst_busy  );

  -- ########################### Port Map ##########################
  
  -- ########################### Processes ###########################
  -- Clock process definitions
  CLK1_process : process
  begin
    clk1 <= '0';
    wait for CLK1_period/2;
    clk1 <= '1';
    wait for CLK1_period/2;
  end process;
  CLK2_process : process
  begin
    clk2 <= '0';
    wait for CLK2_period/2;
    clk2 <= '1';
    wait for CLK2_period/2;
  end process;
  
  -- Stimulus process
  stim_proc : process
  begin
    -- Hold reset state
    rst1 <= '1';
    wait for 150 ns;
    rst1 <= '0';
    wait for 50 ns;
    -- Stimulus 
    MGT_64b_rdy <= '1'; -- Start to write
    TF_96b <= x"D555_4440_3333_2222_1111_0000"; -- 1.; TF_96b(95) is valid bit
    wait for CLK1_period*1;
    TF_96b <= x"BBBB_AAAA_9999_8880_7777_6660"; -- 2.; 
    wait for CLK1_period*1;
    TF_96b <= x"3232_1010_FFFF_EEEE_DDDD_CCC0"; -- Not valid
    wait for CLK1_period*1;
    TF_96b <= x"B232_1010_FFFF_EEEE_DDDD_CCC0"; -- 3.; 
    wait for CLK1_period*1;
    TF_96b <= x"FEFE_DCDC_BABA_9890_7676_5450"; -- 4.; 
    wait for CLK1_period*1;
    TF_96b <= x"D555_4441_3333_2222_1111_0001"; -- 1.; 
    wait for CLK1_period*1;
    TF_96b <= x"BBBB_AAAA_9999_8881_7777_6661"; -- 2.;
    wait for CLK1_period*1;
    TF_96b <= x"B232_1011_FFFF_EEEE_DDDD_CCC1"; -- 3.; 
    wait for CLK1_period*1;
    TF_96b <= x"FEFE_DCDC_BABA_9891_7676_5451"; -- 4.;
    wait for CLK1_period*1;
    TF_96b <= x"D555_4442_3333_2222_1111_0002"; -- 1.; 
    wait for CLK1_period*1;
    TF_96b <= x"BBBB_AAAA_9999_8882_7777_6662"; -- 2.;
    wait for CLK1_period*1;
    TF_96b <= x"B232_1012_FFFF_EEEE_DDDD_CCC2"; -- 3.; 
    wait for CLK1_period*1;
    TF_96b <= x"FEFE_DCDC_BABA_9892_7676_5452"; -- 4.;
    wait for CLK1_period*1;
    TF_96b <= x"7EFE_DCDC_BABA_9892_7676_5452"; -- Not valid
    wait for CLK1_period*14;
    TF_96b <= x"D555_4443_3333_2222_1111_0003"; -- 1.;
    MGT_64b_rdy <= '0';
    wait for CLK1_period*1;
    TF_96b <= x"BBBB_AAAA_9999_8883_7777_6663"; -- 2.;
    wait for CLK1_period*1;
    TF_96b <= x"B232_1013_FFFF_EEEE_DDDD_CCC3"; -- 3.; 
    wait for CLK1_period*1;
    TF_96b <= x"3232_1013_FFFF_EEEE_DDDD_CCC3"; -- Not valid
    wait for CLK1_period*1;
    TF_96b <= x"FEFE_DCDC_BABA_9893_7676_5453"; -- 4.;
    wait for CLK1_period*1;
    TF_96b <= x"8000_0000_0000_0000_0000_0000"; --  
    wait for CLK1_period*1;
    TF_96b <= x"FFFF_FFFF_FFFF_FFFF_FFFF_FFFF"; --  
    wait for CLK1_period*1;
    MGT_64b_rdy <= '1';
    TF_96b <= x"0000_0000_0000_0000_0000_0000"; -- Not valid
    wait for CLK1_period*20;
    MGT_64b_rdy <= '0';
    wait for CLK1_period*1;
    MGT_64b_rdy <= '1';
    wait for CLK1_period*4;
    TF_96b <= x"8000_0000_0000_0000_0000_0000"; -- 
    wait for CLK1_period*10;
    MGT_64b_rdy <= '0';
    wait for CLK1_period*100;

    wait;
  end process;

end behavior;
