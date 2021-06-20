--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief Wrapper for track word conversion. 
--! @author glein
--! @date 2019-06-18
--! @version v.1.0
--! @details
--! Convert pT and eta using HLS conversion modules and delay the rest.
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
use work.track_conv_pkg.all;

--! @brief Top entity with a FPGA-independent interface.
entity track_conv is
  port(
    clk                  : in  std_logic; --! Clock 
    rst                  : in  std_logic; --! Reset
    track_word_in        : in  t_track_word_sv;   --! Track word input from TF
    ap_start             : in  std_logic; --! ap_start
    ap_done              : out std_logic; --! ap_done using and
    ap_idle              : out std_logic; --! ap_idle using and
    ap_ready             : out std_logic; --! ap_ready using and
    track_word_converted : out t_track_word_sv; --! Track word output with converted pT and eta
    ap_vld               : out std_logic ); --! ap_vld using and
end entity track_conv;

--! @brief BRAMs with read counter
architecture struct of track_conv is

  -- ########################### Types ###########################

  -- ########################### Constant Definitions ###########################
  constant c_PT_ZERO_MSB   : integer :=  2; --! MSB(s) that are zreo for pT (0=512GeV, 1=256GeV, 2=128GeV)
  constant c_PT_WIDTH_HLS  : integer := 10; --! Width from HLS implementation
  constant c_ETA_WIDTH_HLS : integer :=  7; --! Width from HLS implementation 

  -- ########################### Signal ###########################
  signal sv_ap_done  : std_logic_vector(1 downto 0); --! Using add to reduce output to 1 bit
  signal sv_ap_idle  : std_logic_vector(1 downto 0); --! Using add to reduce output to 1 bit
  signal sv_ap_ready : std_logic_vector(1 downto 0); --! Using add to reduce output to 1 bit
  signal sv_ap_vld   : std_logic_vector(1 downto 0); --! Using add to reduce output to 1 bit

begin
  -- ########################### Assertion ###########################

  -- ########################### Instantiation ###########################
  i_p_T : entity work.p_T -- p_T conversion  -------------------------------------------------------------
  port map(
    ap_clk           => clk, -- IN STD_LOGIC;
    ap_rst           => rst, -- IN STD_LOGIC;
    ap_start         => ap_start, -- IN STD_LOGIC;
    ap_done          => sv_ap_done(0), -- OUT STD_LOGIC;
    ap_idle          => sv_ap_idle(0), -- OUT STD_LOGIC;
    ap_ready         => sv_ap_ready(0), -- OUT STD_LOGIC;
    in_val_V         => track_word_in(c_PT_WIDTH-2 downto 0), -- IN STD_LOGIC_VECTOR (13 downto 0); -- Without sign bit
    recipro_V        => track_word_converted(c_PT_WIDTH_HLS+c_PT_ZERO_MSB-1 downto c_PT_ZERO_MSB), -- OUT STD_LOGIC_VECTOR (xx downto 0); -- Without sign bit and MSB
    recipro_V_ap_vld => sv_ap_vld(0) -- OUT STD_LOGIC
  );
  i_eta : entity work.eta -- eta conversion  -------------------------------------------------------------
  port map(
    ap_clk           => clk, -- IN STD_LOGIC;
    ap_rst           => rst, -- IN STD_LOGIC;
    ap_start         => ap_start, -- IN STD_LOGIC;
    ap_done          => sv_ap_done(1), -- OUT STD_LOGIC;
    ap_idle          => sv_ap_idle(1), -- OUT STD_LOGIC;
    ap_ready         => sv_ap_ready(1), -- OUT STD_LOGIC;
    indexTanLambda_V => track_word_in(c_PT_WIDTH-2+c_PHI_WIDTH+c_ETA_WIDTH downto c_PT_WIDTH+c_PHI_WIDTH), -- IN STD_LOGIC_VECTOR (14 downto 0); -- Without sign bit
    out_eta_V        => track_word_converted(c_PT_WIDTH-2+c_PHI_WIDTH+c_ETA_WIDTH downto c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH-c_ETA_WIDTH_HLS), -- OUT STD_LOGIC_VECTOR (xx downto 0); -- Without sign bit
    out_eta_V_ap_vld => sv_ap_vld(1) -- OUT STD_LOGIC
  );

  -- ########################### Port Map ##########################
  ap_done  <= sv_ap_done(0)  and sv_ap_done(1);
  ap_idle  <= sv_ap_idle(0)  and sv_ap_idle(1);
  ap_ready <= sv_ap_ready(0) and sv_ap_ready(1);
  ap_vld   <= sv_ap_vld(0)   and sv_ap_vld(1);
  
  -- ########################### Processes ###########################
  --! @brief Gernerating registers to delay signals
  p_reg : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then -- synchronous reset (high active)
        track_word_converted(c_TRACK_WORD_WIDTH-1 downto c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH) <= (others=>'0'); -- Rest of track word
        track_word_converted(c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH)               <= '0';           -- Sign bit of eta; todo: check if it is not 2's complement
        track_word_converted(c_PT_WIDTH-2+c_PHI_WIDTH+c_ETA_WIDTH-c_ETA_WIDTH_HLS downto c_PT_WIDTH+c_PHI_WIDTH) <= (others=>'0'); -- LSB(s) of eta
        track_word_converted(c_PT_WIDTH-1+c_PHI_WIDTH downto c_PT_WIDTH)         <= (others=>'0'); -- Phi vector
        track_word_converted(c_PT_WIDTH-1)                                       <= '0';           -- Sign bit of pT
        track_word_converted(c_PT_WIDTH-2 downto c_PT_WIDTH_HLS+c_PT_ZERO_MSB)   <= (others=>'0'); -- MSB(s) of pT
        track_word_converted(c_PT_ZERO_MSB-1 downto 0)                           <= (others=>'0'); -- LSB(s) of pT
      else
        track_word_converted(c_TRACK_WORD_WIDTH-1 downto c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH) <= track_word_in(c_TRACK_WORD_WIDTH-1 downto c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH); -- Rest of track word
        track_word_converted(c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH)       <= track_word_in(c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH); -- Sign bit of eta; todo: check if it is not 2's complement
        track_word_converted(c_PT_WIDTH-2+c_PHI_WIDTH+c_ETA_WIDTH-c_ETA_WIDTH_HLS downto c_PT_WIDTH+c_PHI_WIDTH) <= (others=>'0'); -- LSB(s) of eta
        track_word_converted(c_PT_WIDTH-1+c_PHI_WIDTH downto c_PT_WIDTH)         <= track_word_in(c_PT_WIDTH-1+c_PHI_WIDTH downto c_PT_WIDTH); -- Phi vector
        track_word_converted(c_PT_WIDTH-1)                                       <= track_word_in(c_PT_WIDTH-1); -- Sign bit of pT
        track_word_converted(c_PT_WIDTH-2 downto c_PT_WIDTH_HLS+c_PT_ZERO_MSB)   <= (others=>'0'); -- MSB(s) of pT
        track_word_converted(c_PT_ZERO_MSB-1 downto 0)                           <= (others=>'0'); -- LSB(s) of pT
      end if;
    end if;
  end process p_reg;


end struct;
