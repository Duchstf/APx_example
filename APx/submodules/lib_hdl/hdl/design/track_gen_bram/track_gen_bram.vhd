--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief Track generator based on BRAMs.
--! @author glein
--! @date 2018-06-01
--! @version v.1.0
--! @details
--! Track values based on coe file for BRAM initialization. 
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
use work.global_pkg.all;

--! @brief Top entity with a FPGA-independent interface.
entity track_gen_bram is
  generic (
    g_read_cnt_length : integer range 0 to 7039 := 7039); --! Default is 64 events times 110 tracks per event (25 Gbps)
  port(
    -- Reset
    reset     : in  std_logic; --! Reset
    -- Track out port based on internal counter
    clka      : in  std_logic; --! Clock port A
    ena       : in  std_logic; --! Enable port A
    addra     : out std_logic_vector(c_ADDR_WIDTH-1 downto 0); --! Adress port A
    douta_arr : out t_track_array;     --! Track array A
    vlda      : out std_logic; --! Valid port A
    -- Track out port based on internal counter
    clkb      : in  std_logic; --! Clock port B
    enb       : in  std_logic; --! Enable port B
    addrb     : out std_logic_vector(c_ADDR_WIDTH-1 downto 0); --! Adress port B
    doutb_arr : out t_track_array;     --! Track array B
    vldb      : out std_logic ); --! Valid port B
end entity track_gen_bram;

--! @brief BRAMs with read counter
architecture struct of track_gen_bram is

  -- ########################### Types ###########################

  -- ########################### Constant Definitions ###########################
  constant c_VLDA_DELAY : integer := 1; --! Number of delayed cycles at start for the valid
  constant c_VLDB_DELAY : integer := 1; --! Number of delayed cycles at start for the valid

  -- ########################### Signal ###########################
  signal su_addra_c    : unsigned(addrb'length-1 downto 0);  --! Counter
  signal su_addra_c_d1 : unsigned(addrb'length-1 downto 0);  --! Counter delayed by 1
  signal su_addra_c_d2 : unsigned(addrb'length-1 downto 0);  --! Counter delayed by 2
  signal su_addra_c_d3 : unsigned(addrb'length-1 downto 0);  --! Counter delayed by 3
  signal sv_addra_gen  : std_logic_vector(c_ADDR_WIDTH-1 downto 0);  --! Generated address of BRAM read port
  signal su_addrb_c    : unsigned(addrb'length-1 downto 0);  --! Counter
  signal su_addrb_c_d1 : unsigned(addrb'length-1 downto 0);  --! Counter delayed by 1
  signal su_addrb_c_d2 : unsigned(addrb'length-1 downto 0);  --! Counter delayed by 2
  signal su_addrb_c_d3 : unsigned(addrb'length-1 downto 0);  --! Counter delayed by 3
  signal sv_addrb_gen  : std_logic_vector(c_ADDR_WIDTH-1 downto 0);  --! Generated address of BRAM read port
  signal sv_dina_arr   : std_logic_vector(c_NUMBER_OF_LINES*c_BITS_PER_TRACK-1 downto 0);  --! Vector according to the track array to concatenate the input 
  signal sv_douta_arr  : std_logic_vector(c_NUMBER_OF_LINES*c_BITS_PER_TRACK-1 downto 0);  --! Vector according to the track array to concatenate the output
  signal sv_doutb_arr  : std_logic_vector(c_NUMBER_OF_LINES*c_BITS_PER_TRACK-1 downto 0);  --! Vector according to the track array to concatenate the output 
  signal su_vlda_c     : unsigned(c_VLDA_DELAY-1 downto 0) := (others => '0');  --! Counter for delaying valid
  signal su_vldb_c     : unsigned(c_VLDB_DELAY-1 downto 0) := (others => '0');  --! Counter for delaying valid

begin
  -- ########################### Assertion ###########################
  assert g_read_cnt_length <= 7039 report "Maximum depth of BRAM exceeded!" severity failure; -- Covered by range

  -- ########################### Instantiation ###########################
  i_blk_mem_gen_2970bx6144 : entity work.blk_mem_gen_1728bx7040
    port map (
      clka  => clka,
      ena   => ena,
      wea   => "0",
      addra => sv_addra_gen,
      dina  => (others => '0'),
      douta => sv_douta_arr,
      clkb  => clkb,
      enb   => enb,
      web   => "0",
      addrb => sv_addrb_gen,
      dinb  => (others => '0'),
      doutb => sv_doutb_arr);

  -- ########################### Port Map ##########################
  sv_addra_gen <= std_logic_vector(su_addra_c);
  addra        <= std_logic_vector(su_addra_c_d2); -- Adapt the delay for correct aligment
  sv_addrb_gen <= std_logic_vector(su_addrb_c);
  addrb        <= std_logic_vector(su_addrb_c_d2); -- Adapt the delay for correct aligment
  douta_arr <= (sv_douta_arr(1727 downto 1632), sv_douta_arr(1631 downto 1536), sv_douta_arr(1535 downto 1440),
                sv_douta_arr(1439 downto 1344), sv_douta_arr(1343 downto 1248), sv_douta_arr(1247 downto 1152), sv_douta_arr(1151 downto 1056), sv_douta_arr(1055 downto 0960),
                sv_douta_arr(0959 downto 0864), sv_douta_arr(0863 downto 0768), sv_douta_arr(0767 downto 0672), sv_douta_arr(0671 downto 0576), sv_douta_arr(0575 downto 0480),
                sv_douta_arr(0479 downto 0384), sv_douta_arr(0383 downto 0288), sv_douta_arr(0287 downto 0192), sv_douta_arr(0191 downto 0096), sv_douta_arr(0095 downto 0000));
  doutb_arr <= (sv_doutb_arr(1727 downto 1632), sv_doutb_arr(1631 downto 1536), sv_doutb_arr(1535 downto 1440),
                sv_doutb_arr(1439 downto 1344), sv_doutb_arr(1343 downto 1248), sv_doutb_arr(1247 downto 1152), sv_doutb_arr(1151 downto 1056), sv_doutb_arr(1055 downto 0960),
                sv_doutb_arr(0959 downto 0864), sv_doutb_arr(0863 downto 0768), sv_doutb_arr(0767 downto 0672), sv_doutb_arr(0671 downto 0576), sv_doutb_arr(0575 downto 0480),
                sv_doutb_arr(0479 downto 0384), sv_doutb_arr(0383 downto 0288), sv_doutb_arr(0287 downto 0192), sv_doutb_arr(0191 downto 0096), sv_doutb_arr(0095 downto 0000));

  -- ########################### Processes ###########################
  --! @brief Gernerating address for BRAM
  p_addra_gen : process(clka)
  begin
    if rising_edge(clka) then
      if reset = '1' then -- synchronous reset (high active)
        su_addra_c    <= (others => '0');
        su_addra_c_d1 <= (others => '0');
        su_addra_c_d2 <= (others => '0');
        su_addra_c_d3 <= (others => '0');
      elsif ena = '1' then
        if to_integer(su_addra_c) < g_read_cnt_length-1 then
          su_addra_c <= su_addra_c + 1;
        else
          su_addra_c <= (others => '0');
        end if;
        su_addra_c_d1 <= su_addra_c;
        su_addra_c_d2 <= su_addra_c_d1;
        su_addra_c_d3 <= su_addra_c_d2;
      end if;
    end if;
  end process p_addra_gen;
  --! @brief Gernerating address for BRAM
  p_addrb_gen : process(clkb)
  begin
    if rising_edge(clkb) then
      if reset = '1' then -- synchronous reset (high active)
        su_addrb_c    <= (others => '0');
        su_addrb_c_d1 <= (others => '0');
        su_addrb_c_d2 <= (others => '0');
        su_addrb_c_d3 <= (others => '0');
      elsif enb = '1' then
        if to_integer(su_addrb_c) < g_read_cnt_length-1 then
          su_addrb_c <= su_addrb_c + 1;
        else
          su_addrb_c <= (others => '0');
        end if;
        su_addrb_c_d1 <= su_addrb_c;
        su_addrb_c_d2 <= su_addrb_c_d1;
        su_addrb_c_d3 <= su_addrb_c_d2;
      end if;
    end if;
  end process p_addrb_gen;
  --! @brief Delayed valid generation at startup
  p_delay_vlda : process(clka)
  begin
    if rising_edge(clka) then
      if ena = '1' and su_vlda_c < c_VLDA_DELAY then
        su_vlda_c <= su_vlda_c + 1;
        vlda <= '0';
      elsif su_vlda_c = c_VLDA_DELAY then
        vlda <= '1';
      else
        vlda <= '0';
      end if;
    end if;
  end process p_delay_vlda;
  --! @brief Delayed valid generation at startup
  p_delay_vldb : process(clkb)
  begin
    if rising_edge(clkb) then
      if enb = '1' and su_vldb_c < c_VLDB_DELAY then
        su_vldb_c <= su_vldb_c + 1;
        vldb <= '0';
      elsif su_vldb_c = c_VLDB_DELAY then
        vldb <= '1';
      else
        vldb <= '0';
      end if;
    end if;
  end process p_delay_vldb;

end struct;
