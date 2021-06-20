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
use work.AxiStreamPkg.all; --! From surf/axi/axi-stream submodule

--! @brief TB
entity tb_conv64bto96bFIFO is
end entity tb_conv64bto96bFIFO;

--! @brief TB
architecture behavior of tb_conv64bto96bFIFO is

  -- ########################### Types ###########################

  -- ########################### Constant Definitions ###########################
  constant CLK1_period : time := 3.125 ns; -- 320.0 MHz
  constant CLK2_period : time := 4.450 ns; -- 224.7 MHz

  -- ########################### Signal ###########################
  signal clk1    : std_logic := '0';
  signal rst1    : std_logic := '0';
  signal clk2    : std_logic := '0';
  signal rst2_s  : std_logic := '0';
  signal axiStreamIn_64b      : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
  signal full    : std_logic :='0';
  signal axiStreamOut_96b     : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
  signal rd_en   : std_logic :='0';
  signal empty   : std_logic :='0';


begin
  -- ########################### Assertion ###########################

  -- ########################### Instantiation ###########################
    uut : entity work.conv64bto96bFIFO port map (
    clk1    => clk1,
    rst1    => rst1,
    clk2    => clk2,
    rst2_s  => rst2_s,
    axiStreamIn_64b => axiStreamIn_64b,
    full            => full,
    axiStreamOut_96b => axiStreamOut_96b,
    rd_en            => rd_en,
    empty            => empty );

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
    wait for 50 ns;
    rst1 <= '0';
    wait for 50 ns;
    rd_en <= '1';
    -- Stimulus 
    axiStreamIn_64b.tData(63 downto 0) <= x"FEDC_BA98_7654_3210"; -- 1.
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0011"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"0123_4567_89BA_CDEF"; -- 2. 
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"FFFF_FFFF_FFFF_FFFF"; -- NV
    axiStreamIn_64b.tValid             <= '0';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"00";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"FEDC_BA98_7654_3210"; -- 3.
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"1111_1111_1111_1111"; -- 1.
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0011"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"FFFF_FFFF_FFFF_FFFF"; -- NV
    axiStreamIn_64b.tValid             <= '0';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"00";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"2222_2222_1111_1111"; -- 2. 
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"2222_2222_2222_2222"; -- 3.
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"FFFF_FFFF_FFFF_FFFF"; -- NV
    axiStreamIn_64b.tValid             <= '0';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"00";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"3333_3333_3333_3333"; -- 1.
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0011"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"4444_4444_3333_3333"; -- 2. 
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"4444_4444_4444_4444"; -- 3.
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"FFFF_FFFF_FFFF_FFFF"; -- NV
    axiStreamIn_64b.tValid             <= '0';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"00";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"5555_5555_5555_5555"; -- 1.
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0011"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"FFFF_FFFF_FFFF_FFFF"; -- NV
    axiStreamIn_64b.tValid             <= '0';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"00";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"FFFF_FFFF_FFFF_FFFF"; -- NV
    axiStreamIn_64b.tValid             <= '0';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"00";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"6666_6666_5555_5555"; -- 2. 
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*1;
    axiStreamIn_64b.tData(63 downto 0) <= x"6666_6666_6666_6666"; -- 3.
    axiStreamIn_64b.tValid             <= '1';
    axiStreamIn_64b.tKeep( 7 downto 0) <= x"FF";
    axiStreamIn_64b.tLast              <= '0';
    axiStreamIn_64b.tUser( 7 downto 0) <= b"0000_0000"; -- tUser(0): SOF Signals start of frame; tUser(1): FFO Signals first frame of orbit; tUser(2): FRAME_ERR Signals frame error; tUser(3): CHKSM_ERR Signals frame checksum error; tUser(7:4): RSV_FLAGS Reserved for additional flags
    wait for CLK1_period*100;
    rd_en <= '0';

    wait;
  end process;

end behavior;
