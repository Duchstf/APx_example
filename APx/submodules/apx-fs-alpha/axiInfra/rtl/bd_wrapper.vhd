library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.StdRtlPkg.all;
use work.AxiLitePkg.all;
use work.i2cPkg.all;

entity bd_wrapper is
  generic (
    AURORA_LANES : integer := 2;
    TPD_G        : time    := 1 ns;
    XIL_DEVICE_G : string  := "7SERIES"
    );
  port (
    clk40  : out sl;
    clk80  : out sl;
    clk100 : out sl;

    refclk_c2c_clk_n : in  sl;
    refclk_c2c_clk_p : in  sl;
    clk_300_clk_n    : in  sl;
    clk_300_clk_p    : in  sl;
    gt_c2c_rx_rxn    : in  slv (AURORA_LANES-1 to 0);
    gt_c2c_rx_rxp    : in  slv (AURORA_LANES-1 to 0);
    gt_c2c_tx_txn    : out slv (AURORA_LANES-1 to 0);
    gt_c2c_tx_txp    : out slv (AURORA_LANES-1 to 0);

    I2C_C2C_scl_io : inout std_logic;
    I2C_C2C_sda_io : inout std_logic;

    mAxiClk          : out sl;
    mAxiRst          : out sl;
    mAxilWriteMaster : out AxiLiteWriteMasterType;
    mAxilWriteSlave  : in  AxiLiteWriteSlaveType;
    mAxilReadMaster  : out AxiLiteReadMasterType;
    mAxilReadSlave   : in  AxiLiteReadSlaveType
    );
end bd_wrapper;

architecture RTL of bd_wrapper is

  component bd is
    port (
      clk_300_clk_n          : in  std_logic;
      clk_300_clk_p          : in  std_logic;
      axi_lite_awaddr        : out std_logic_vector (31 downto 0);
      axi_lite_awprot        : out std_logic_vector (2 downto 0);
      axi_lite_awvalid       : out std_logic;
      axi_lite_awready       : in  std_logic;
      axi_lite_wdata         : out std_logic_vector (31 downto 0);
      axi_lite_wstrb         : out std_logic_vector (3 downto 0);
      axi_lite_wvalid        : out std_logic;
      axi_lite_wready        : in  std_logic;
      axi_lite_bresp         : in  std_logic_vector (1 downto 0);
      axi_lite_bvalid        : in  std_logic;
      axi_lite_bready        : out std_logic;
      axi_lite_araddr        : out std_logic_vector (31 downto 0);
      axi_lite_arprot        : out std_logic_vector (2 downto 0);
      axi_lite_arvalid       : out std_logic;
      axi_lite_arready       : in  std_logic;
      axi_lite_rdata         : in  std_logic_vector (31 downto 0);
      axi_lite_rresp         : in  std_logic_vector (1 downto 0);
      axi_lite_rvalid        : in  std_logic;
      axi_lite_rready        : out std_logic;
      clk_100                : out std_logic;
      clk_40                 : out std_logic;
      clk_80                 : out std_logic;
      axi_lite_clk           : out std_logic;
      axi_lite_resetn        : out std_logic_vector (0 to 0);
      gt_c2c_rx_rxn          : in  std_logic_vector (0 to 1);
      gt_c2c_rx_rxp          : in  std_logic_vector (0 to 1);
      refclk_c2c_clk_n       : in  std_logic;
      refclk_c2c_clk_p       : in  std_logic;
      gt_c2c_tx_txn          : out std_logic_vector (0 to 1);
      gt_c2c_tx_txp          : out std_logic_vector (0 to 1);
      axiRstN                : in  std_logic;
      mgtAuroraPmaInit_0     : in  std_logic;
      mgtAuroraTxDiffCtrl_0  : in  std_logic_vector (9 downto 0);
      mgtAuroraTxPrbsSel_0   : in  std_logic_vector (7 downto 0);
      mgtAuroraRxPrbsSel_0   : in  std_logic_vector (7 downto 0);
      c2cStat_0              : out std_logic_vector (2 downto 0);
      AuroraCoreStat_0       : out std_logic_vector (3 downto 0);
      mgtAuroraLaneUp_0      : out std_logic_vector (0 to 1);
      mgtAuroraTxResetDone_0 : out std_logic_vector (1 downto 0);
      mgtAuroraRxResetDone_0 : out std_logic_vector (1 downto 0);
      mgtAuroraPrbsErr_0     : out std_logic_vector (1 downto 0)
      );
  end component bd;

  constant I2C_ADDR_G : integer range 0 to 1023 := 86;
  constant TENBIT_G   : integer range 0 to 1    := 0;
  constant FILTER_G   : integer range 2 to 512  := 4;

  constant ADDR_SIZE_G  : positive             := 1;
  constant DATA_SIZE_G  : positive             := 1;
  constant ENDIANNESS_G : integer range 0 to 1 := 0;

  type RamType is array (0 to 2**(8*ADDR_SIZE_G)-1) of slv(8*DATA_SIZE_G-1 downto 0);

  signal i2ci : i2c_in_type;
  signal i2co : i2c_out_type;

  signal ram    : RamType;
  signal addr   : slv(8*ADDR_SIZE_G-1 downto 0);
  signal wrEn   : sl;
  signal wrData : slv(8*DATA_SIZE_G-1 downto 0);
  signal rdEn   : sl;
  signal rdData : slv(8*DATA_SIZE_G-1 downto 0);

  signal I2C_C2C_sda_i : std_logic;
  signal I2C_C2C_sda_o : std_logic;
  signal I2C_C2C_sda_t : std_logic;

  --internal parallel interface ports
  signal reset    : std_logic;          --async reset
  signal rwaddr   : std_logic_vector(6 downto 0);  --7-bit i2c address
  signal rd_wr_b  : std_logic;          --rd/wr# direction select
  signal avalid   : std_logic;          --address valid flag
  signal wdataout : std_logic_vector(7 downto 0);  --write data output byte
  signal wdvalid  : std_logic;          --write data valid flag
  signal rdatain  : std_logic_vector(7 downto 0);  --read data input port
  signal rdvalid  : std_logic;          --read data load enable strobe
  signal rdclk    : std_logic;          --write clock for read data buffer reg

  signal sda_oe : std_logic;

  signal mAxiRstN : std_logic;

  signal c2cStat_0 : std_logic_vector (2 downto 0);
  signal clk_100   : std_logic;
  signal clk_40    : std_logic;
  signal clk_80    : std_logic;

  signal AuroraCoreStat_0 : std_logic_vector (3 downto 0);

  signal mgtAuroraLaneUp_0      : std_logic_vector (0 to 1);
  signal mgtAuroraPmaInit_0     : std_logic                     := '0';
  signal mgtAuroraPrbsErr_0     : std_logic_vector (1 downto 0);
  signal mgtAuroraRxPrbsSel_0   : std_logic_vector (7 downto 0) := (others => '0');
  signal mgtAuroraRxResetDone_0 : std_logic_vector (1 downto 0);
  signal mgtAuroraTxDiffCtrl_0  : std_logic_vector (9 downto 0) := "1000010000";
  signal mgtAuroraTxPrbsSel_0   : std_logic_vector (7 downto 0) := (others => '0');
  signal mgtAuroraTxResetDone_0 : std_logic_vector (1 downto 0);

  signal axiRstMasterN : sl := '1';

begin

  mAxiRst <= not mAxiRstN;

  clk100 <= clk_100;
  clk40  <= clk_40;
  clk80  <= clk_80;

  i2cRegSlave_1 : entity work.i2cRegSlave
    generic map (
      TENBIT_G             => TENBIT_G,
      I2C_ADDR_G           => I2C_ADDR_G,
      OUTPUT_EN_POLARITY_G => 0,
      FILTER_G             => FILTER_G,
      ADDR_SIZE_G          => ADDR_SIZE_G,
      DATA_SIZE_G          => DATA_SIZE_G,
      ENDIANNESS_G         => ENDIANNESS_G)
    port map (
      sRst   => reset,
      clk    => clk_100,
      addr   => addr,
      wrEn   => wrEn,
      wrData => wrData,
      rdEn   => rdEn,
      rdData => rdData,
      i2ci   => i2ci,
      i2co   => i2co);

  I2C_C2C_sda_io <= i2co.sda when i2co.sdaoen = '0' else 'Z';
  i2ci.sda       <= I2C_C2C_sda_io;

  I2C_C2C_scl_io <= i2co.scl when i2co.scloen = '0' else 'Z';
  i2ci.scl       <= I2C_C2C_scl_io;

  ram_proc : process (clk_100) is
  begin
    if (rising_edge(clk_100)) then
      if (wrEn = '1') then
        axiRstMasterN <= wrData(0);
      end if;
    end if;
  end process ram_proc;

  bd_i : component bd
    port map (
      axiRstN => axiRstMasterN,

      axi_lite_clk       => mAxiClk,
      axi_lite_resetn(0) => mAxiRstN,

      axi_lite_araddr(31 downto 0) => mAxilReadMaster.araddr,
      axi_lite_arprot              => mAxilReadMaster.arprot,
      axi_lite_arready             => mAxilReadSlave.arready,
      axi_lite_arvalid             => mAxilReadMaster.arvalid,
      axi_lite_awaddr(31 downto 0) => mAxilWriteMaster.awaddr,
      axi_lite_awprot              => mAxilWriteMaster.awprot,
      axi_lite_awready             => mAxilWriteSlave.awready,
      axi_lite_awvalid             => mAxilWriteMaster.awvalid,
      axi_lite_bready              => mAxilWriteMaster.bready,
      axi_lite_bresp(1 downto 0)   => mAxilWriteSlave.bresp,
      axi_lite_bvalid              => mAxilWriteSlave.bvalid,
      axi_lite_rdata(31 downto 0)  => mAxilReadSlave.rdata,
      axi_lite_rready              => mAxilReadMaster.rready,
      axi_lite_rresp(1 downto 0)   => mAxilReadSlave.rresp,
      axi_lite_rvalid              => mAxilReadSlave.rvalid,
      axi_lite_wdata(31 downto 0)  => mAxilWriteMaster.wdata,
      axi_lite_wready              => mAxilWriteSlave.wready,
      axi_lite_wstrb(3 downto 0)   => mAxilWriteMaster.wstrb,
      axi_lite_wvalid              => mAxilWriteMaster.wvalid,

      clk_40  => clk_40,
      clk_80  => clk_80,
      clk_100 => clk_100,

      clk_300_clk_n    => clk_300_clk_n,
      clk_300_clk_p    => clk_300_clk_p,
      gt_c2c_rx_rxn    => gt_c2c_rx_rxn,
      gt_c2c_rx_rxp    => gt_c2c_rx_rxp,
      gt_c2c_tx_txn    => gt_c2c_tx_txn,
      gt_c2c_tx_txp    => gt_c2c_tx_txp,
      refclk_c2c_clk_n => refclk_c2c_clk_n,
      refclk_c2c_clk_p => refclk_c2c_clk_p,

      c2cStat_0(2 downto 0)        => c2cStat_0(2 downto 0),
      AuroraCoreStat_0(3 downto 0) => AuroraCoreStat_0(3 downto 0),

      mgtAuroraLaneUp_0                  => mgtAuroraLaneUp_0,
      mgtAuroraPmaInit_0                 => mgtAuroraPmaInit_0,
      mgtAuroraPrbsErr_0(1 downto 0)     => mgtAuroraPrbsErr_0(1 downto 0),
      mgtAuroraRxPrbsSel_0(7 downto 0)   => mgtAuroraRxPrbsSel_0(7 downto 0),
      mgtAuroraRxResetDone_0(1 downto 0) => mgtAuroraRxResetDone_0(1 downto 0),
      mgtAuroraTxDiffCtrl_0(9 downto 0)  => mgtAuroraTxDiffCtrl_0(9 downto 0),
      mgtAuroraTxPrbsSel_0(7 downto 0)   => mgtAuroraTxPrbsSel_0(7 downto 0),
      mgtAuroraTxResetDone_0(1 downto 0) => mgtAuroraTxResetDone_0(1 downto 0)

      );

end RTL;
