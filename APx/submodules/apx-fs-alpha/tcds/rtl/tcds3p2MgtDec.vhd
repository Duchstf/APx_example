library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library UNISIM;
use UNISIM.VComponents.all;

entity tcds3p2MgtDec is
  port (

    refclk_n : in std_logic;
    refclk_p : in std_logic;

    mgtRxN : in  std_logic;
    mgtRxP : in  std_logic;
    mgtTxN : out std_logic;
    mgtTxP : out std_logic;

    sysclk : in std_logic;

    mgtMasterRst : in std_logic;
    mgtTxRst     : in std_logic;
    mgtRxRst     : in std_logic;

    mgtDecErr : out std_logic;

    mgtBc0      : out std_logic;
    mgtL1A      : out std_logic;
    mgtResync   : out std_logic;
    mgtStart    : out std_logic;
    mgtStop     : out std_logic;
    mgtEC0      : out std_logic;
    mgtTestSync : out std_logic;


    mgtRxPrbsSel : in std_logic_vector(3 downto 0);
    mgtTxPrbsSel : in std_logic_vector(3 downto 0);

    mgtTxUsrClk : out std_logic;
    mgtRxUsrClk : out std_logic;

    mgtTxDoneOut : out std_logic;
    mgtRxDoneOut : out std_logic
    );
end tcds3p2MgtDec;

architecture rtl of tcds3p2MgtDec is

  component gty_3p2_8b10b
    port (
      gtwiz_userclk_tx_reset_in          : in  std_logic_vector(0 downto 0);
      gtwiz_userclk_tx_srcclk_out        : out std_logic_vector(0 downto 0);
      gtwiz_userclk_tx_usrclk_out        : out std_logic_vector(0 downto 0);
      gtwiz_userclk_tx_usrclk2_out       : out std_logic_vector(0 downto 0);
      gtwiz_userclk_tx_active_out        : out std_logic_vector(0 downto 0);
      gtwiz_userclk_rx_reset_in          : in  std_logic_vector(0 downto 0);
      gtwiz_userclk_rx_srcclk_out        : out std_logic_vector(0 downto 0);
      gtwiz_userclk_rx_usrclk_out        : out std_logic_vector(0 downto 0);
      gtwiz_userclk_rx_usrclk2_out       : out std_logic_vector(0 downto 0);
      gtwiz_userclk_rx_active_out        : out std_logic_vector(0 downto 0);
      gtwiz_buffbypass_tx_reset_in       : in  std_logic_vector(0 downto 0);
      gtwiz_buffbypass_tx_start_user_in  : in  std_logic_vector(0 downto 0);
      gtwiz_buffbypass_tx_done_out       : out std_logic_vector(0 downto 0);
      gtwiz_buffbypass_tx_error_out      : out std_logic_vector(0 downto 0);
      gtwiz_buffbypass_rx_reset_in       : in  std_logic_vector(0 downto 0);
      gtwiz_buffbypass_rx_start_user_in  : in  std_logic_vector(0 downto 0);
      gtwiz_buffbypass_rx_done_out       : out std_logic_vector(0 downto 0);
      gtwiz_buffbypass_rx_error_out      : out std_logic_vector(0 downto 0);
      gtwiz_reset_clk_freerun_in         : in  std_logic_vector(0 downto 0);
      gtwiz_reset_all_in                 : in  std_logic_vector(0 downto 0);
      gtwiz_reset_tx_pll_and_datapath_in : in  std_logic_vector(0 downto 0);
      gtwiz_reset_tx_datapath_in         : in  std_logic_vector(0 downto 0);
      gtwiz_reset_rx_pll_and_datapath_in : in  std_logic_vector(0 downto 0);
      gtwiz_reset_rx_datapath_in         : in  std_logic_vector(0 downto 0);
      gtwiz_reset_rx_cdr_stable_out      : out std_logic_vector(0 downto 0);
      gtwiz_reset_tx_done_out            : out std_logic_vector(0 downto 0);
      gtwiz_reset_rx_done_out            : out std_logic_vector(0 downto 0);
      gtwiz_userdata_tx_in               : in  std_logic_vector(31 downto 0);
      gtwiz_userdata_rx_out              : out std_logic_vector(31 downto 0);
      drpclk_in                          : in  std_logic_vector(0 downto 0);
      gtrefclk0_in                       : in  std_logic_vector(0 downto 0);
      gtyrxn_in                          : in  std_logic_vector(0 downto 0);
      gtyrxp_in                          : in  std_logic_vector(0 downto 0);
      rx8b10ben_in                       : in  std_logic_vector(0 downto 0);
      rxcommadeten_in                    : in  std_logic_vector(0 downto 0);
      rxmcommaalignen_in                 : in  std_logic_vector(0 downto 0);
      rxpcommaalignen_in                 : in  std_logic_vector(0 downto 0);
      rxprbscntreset_in                  : in  std_logic_vector(0 downto 0);
      rxprbssel_in                       : in  std_logic_vector(3 downto 0);
      tx8b10ben_in                       : in  std_logic_vector(0 downto 0);
      txctrl0_in                         : in  std_logic_vector(15 downto 0);
      txctrl1_in                         : in  std_logic_vector(15 downto 0);
      txctrl2_in                         : in  std_logic_vector(7 downto 0);
      txprbsforceerr_in                  : in  std_logic_vector(0 downto 0);
      txprbssel_in                       : in  std_logic_vector(3 downto 0);
      gtpowergood_out                    : out std_logic_vector(0 downto 0);
      gtytxn_out                         : out std_logic_vector(0 downto 0);
      gtytxp_out                         : out std_logic_vector(0 downto 0);
      rxbyteisaligned_out                : out std_logic_vector(0 downto 0);
      rxbyterealign_out                  : out std_logic_vector(0 downto 0);
      rxcommadet_out                     : out std_logic_vector(0 downto 0);
      rxctrl0_out                        : out std_logic_vector(15 downto 0);
      rxctrl1_out                        : out std_logic_vector(15 downto 0);
      rxctrl2_out                        : out std_logic_vector(7 downto 0);
      rxctrl3_out                        : out std_logic_vector(7 downto 0);
      rxpmaresetdone_out                 : out std_logic_vector(0 downto 0);
      rxprbserr_out                      : out std_logic_vector(0 downto 0);
      rxprbslocked_out                   : out std_logic_vector(0 downto 0);
      txpmaresetdone_out                 : out std_logic_vector(0 downto 0);
      txprgdivresetdone_out              : out std_logic_vector(0 downto 0);
      cpllfbclklost_out                  : out std_logic_vector(0 downto 0);
      cplllock_out                       : out std_logic_vector(0 downto 0);
      cpllrefclklost_out                 : out std_logic_vector(0 downto 0)
      );
  end component;

  signal gtwiz_userclk_tx_reset_in          : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_tx_srcclk_out        : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_tx_usrclk_out        : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_tx_usrclk2_out       : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_tx_active_out        : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_rx_reset_in          : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_rx_srcclk_out        : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_rx_usrclk_out        : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_rx_usrclk2_out       : std_logic_vector(0 downto 0);
  signal gtwiz_userclk_rx_active_out        : std_logic_vector(0 downto 0);
  signal gtwiz_buffbypass_tx_reset_in       : std_logic_vector(0 downto 0);
  signal gtwiz_buffbypass_tx_start_user_in  : std_logic_vector(0 downto 0);
  signal gtwiz_buffbypass_tx_done_out       : std_logic_vector(0 downto 0);
  signal gtwiz_buffbypass_tx_error_out      : std_logic_vector(0 downto 0);
  signal gtwiz_buffbypass_rx_reset_in       : std_logic_vector(0 downto 0);
  signal gtwiz_buffbypass_rx_start_user_in  : std_logic_vector(0 downto 0);
  signal gtwiz_buffbypass_rx_done_out       : std_logic_vector(0 downto 0);
  signal gtwiz_buffbypass_rx_error_out      : std_logic_vector(0 downto 0);
  signal gtwiz_reset_clk_freerun_in         : std_logic_vector(0 downto 0);
  signal gtwiz_reset_all_in                 : std_logic_vector(0 downto 0);
  signal gtwiz_reset_tx_pll_and_datapath_in : std_logic_vector(0 downto 0);
  signal gtwiz_reset_tx_datapath_in         : std_logic_vector(0 downto 0);
  signal gtwiz_reset_rx_pll_and_datapath_in : std_logic_vector(0 downto 0);
  signal gtwiz_reset_rx_datapath_in         : std_logic_vector(0 downto 0);
  signal gtwiz_reset_rx_cdr_stable_out      : std_logic_vector(0 downto 0);
  signal gtwiz_reset_tx_done_out            : std_logic_vector(0 downto 0);
  signal gtwiz_reset_rx_done_out            : std_logic_vector(0 downto 0);
  signal gtwiz_userdata_tx_in               : std_logic_vector(31 downto 0);
  signal gtwiz_userdata_rx_out              : std_logic_vector(31 downto 0);
  signal drpclk_in                          : std_logic_vector(0 downto 0);
  signal gtrefclk0_in                       : std_logic_vector(0 downto 0);
  signal gtyrxn_in                          : std_logic_vector(0 downto 0);
  signal gtyrxp_in                          : std_logic_vector(0 downto 0);
  signal rx8b10ben_in                       : std_logic_vector(0 downto 0);
  signal rxcommadeten_in                    : std_logic_vector(0 downto 0);
  signal rxmcommaalignen_in                 : std_logic_vector(0 downto 0);
  signal rxpcommaalignen_in                 : std_logic_vector(0 downto 0);
  signal rxprbscntreset_in                  : std_logic_vector(0 downto 0);
  signal rxprbssel_in                       : std_logic_vector(3 downto 0);
  signal tx8b10ben_in                       : std_logic_vector(0 downto 0);
  signal txctrl0_in                         : std_logic_vector(15 downto 0);
  signal txctrl1_in                         : std_logic_vector(15 downto 0);
  signal txctrl2_in                         : std_logic_vector(7 downto 0);
  signal txprbsforceerr_in                  : std_logic_vector(0 downto 0);
  signal txprbssel_in                       : std_logic_vector(3 downto 0);
  signal gtpowergood_out                    : std_logic_vector(0 downto 0);
  signal gtytxn_out                         : std_logic_vector(0 downto 0);
  signal gtytxp_out                         : std_logic_vector(0 downto 0);
  signal rxbyteisaligned_out                : std_logic_vector(0 downto 0);
  signal rxbyterealign_out                  : std_logic_vector(0 downto 0);
  signal rxcommadet_out                     : std_logic_vector(0 downto 0);
  signal rxctrl0_out                        : std_logic_vector(15 downto 0);
  signal rxctrl1_out                        : std_logic_vector(15 downto 0);
  signal rxctrl2_out                        : std_logic_vector(7 downto 0);
  signal rxctrl3_out                        : std_logic_vector(7 downto 0);
  signal rxpmaresetdone_out                 : std_logic_vector(0 downto 0);
  signal rxprbserr_out                      : std_logic_vector(0 downto 0);
  signal rxprbslocked_out                   : std_logic_vector(0 downto 0);
  signal txpmaresetdone_out                 : std_logic_vector(0 downto 0);
  signal txprgdivresetdone_out              : std_logic_vector(0 downto 0);
  signal cpllfbclklost_out                  : std_logic_vector(0 downto 0);
  signal cplllock_out                       : std_logic_vector(0 downto 0);
  signal cpllrefclklost_out                 : std_logic_vector(0 downto 0);

  signal refclk : std_logic;

begin

  U_IBUFDS : IBUFDS_GTE4
    generic map (
      REFCLK_EN_TX_PATH  => '0',
      REFCLK_HROW_CK_SEL => "00",       -- 2'b00: ODIV2 = O
      REFCLK_ICNTL_RX    => "00"
      )
    port map (
      I     => refclk_p,
      IB    => refclk_n,
      CEB   => '0',
      ODIV2 => open,
      O     => refclk);

-----

  mgtTxUsrClk <= gtwiz_userclk_tx_usrclk2_out(0);
  mgtRxUsrClk <= gtwiz_userclk_rx_usrclk2_out(0);

  mgtTxDoneOut <= gtwiz_reset_tx_done_out(0);
  mgtRxDoneOut <= gtwiz_reset_rx_done_out(0);

  gtwiz_userclk_tx_reset_in(0) <= not (txprgdivresetdone_out(0) and txpmaresetdone_out(0));
  gtwiz_userclk_rx_reset_in(0) <= not (rxpmaresetdone_out(0));

  gtwiz_buffbypass_tx_reset_in(0)      <= not gtwiz_userclk_tx_active_out(0);  --todo sync      
  gtwiz_buffbypass_tx_start_user_in(0) <= '0';

  gtwiz_buffbypass_rx_reset_in(0)      <= not (rxpmaresetdone_out(0));  --todo sync 
  gtwiz_buffbypass_rx_start_user_in(0) <= '0';

  gtwiz_reset_clk_freerun_in(0)         <= sysclk;
  gtwiz_reset_all_in(0)                 <= mgtMasterRst;
  gtwiz_reset_tx_pll_and_datapath_in(0) <= mgtTxRst;
  gtwiz_reset_tx_datapath_in(0)         <= '0';
  gtwiz_reset_rx_pll_and_datapath_in(0) <= mgtRxRst;
  gtwiz_reset_rx_datapath_in(0)         <= '0';

  gtwiz_userdata_tx_in  <= (others => '0');
  drpclk_in(0)          <= sysclk;
  gtrefclk0_in(0)       <= refclk;
  gtyrxn_in(0)          <= mgtRxN;
  gtyrxp_in(0)          <= mgtRxP;
  rx8b10ben_in(0)       <= '1';
  rxcommadeten_in(0)    <= '1';
  rxmcommaalignen_in(0) <= '1';
  rxpcommaalignen_in(0) <= '1';
  rxprbscntreset_in(0)  <= '0';
  rxprbssel_in          <= mgtRxPrbsSel;
  tx8b10ben_in(0)       <= '1';
  txctrl0_in            <= (others => '0');
  txctrl1_in            <= (others => '0');
  txctrl2_in            <= (others => '0');
  txprbsforceerr_in(0)  <= '0';
  txprbssel_in          <= mgtTxPrbsSel;
  mgtTxN                <= gtytxn_out(0);
  mgtTxP                <= gtytxp_out(0);

  U_gty_3p2_8b10b : gty_3p2_8b10b
    port map (
      gtwiz_userclk_tx_reset_in          => gtwiz_userclk_tx_reset_in,
      gtwiz_userclk_tx_srcclk_out        => gtwiz_userclk_tx_srcclk_out,
      gtwiz_userclk_tx_usrclk_out        => gtwiz_userclk_tx_usrclk_out,
      gtwiz_userclk_tx_usrclk2_out       => gtwiz_userclk_tx_usrclk2_out,
      gtwiz_userclk_tx_active_out        => gtwiz_userclk_tx_active_out,
      gtwiz_userclk_rx_reset_in          => gtwiz_userclk_rx_reset_in,
      gtwiz_userclk_rx_srcclk_out        => gtwiz_userclk_rx_srcclk_out,
      gtwiz_userclk_rx_usrclk_out        => gtwiz_userclk_rx_usrclk_out,
      gtwiz_userclk_rx_usrclk2_out       => gtwiz_userclk_rx_usrclk2_out,
      gtwiz_userclk_rx_active_out        => gtwiz_userclk_rx_active_out,
      gtwiz_buffbypass_tx_reset_in       => gtwiz_buffbypass_tx_reset_in,
      gtwiz_buffbypass_tx_start_user_in  => gtwiz_buffbypass_tx_start_user_in,
      gtwiz_buffbypass_tx_done_out       => gtwiz_buffbypass_tx_done_out,
      gtwiz_buffbypass_tx_error_out      => gtwiz_buffbypass_tx_error_out,
      gtwiz_buffbypass_rx_reset_in       => gtwiz_buffbypass_rx_reset_in,
      gtwiz_buffbypass_rx_start_user_in  => gtwiz_buffbypass_rx_start_user_in,
      gtwiz_buffbypass_rx_done_out       => gtwiz_buffbypass_rx_done_out,
      gtwiz_buffbypass_rx_error_out      => gtwiz_buffbypass_rx_error_out,
      gtwiz_reset_clk_freerun_in         => gtwiz_reset_clk_freerun_in,
      gtwiz_reset_all_in                 => gtwiz_reset_all_in,
      gtwiz_reset_tx_pll_and_datapath_in => gtwiz_reset_tx_pll_and_datapath_in,
      gtwiz_reset_tx_datapath_in         => gtwiz_reset_tx_datapath_in,
      gtwiz_reset_rx_pll_and_datapath_in => gtwiz_reset_rx_pll_and_datapath_in,
      gtwiz_reset_rx_datapath_in         => gtwiz_reset_rx_datapath_in,
      gtwiz_reset_rx_cdr_stable_out      => gtwiz_reset_rx_cdr_stable_out,
      gtwiz_reset_tx_done_out            => gtwiz_reset_tx_done_out,
      gtwiz_reset_rx_done_out            => gtwiz_reset_rx_done_out,
      gtwiz_userdata_tx_in               => gtwiz_userdata_tx_in,
      gtwiz_userdata_rx_out              => gtwiz_userdata_rx_out,
      drpclk_in                          => drpclk_in,
      gtrefclk0_in                       => gtrefclk0_in,
      gtyrxn_in                          => gtyrxn_in,
      gtyrxp_in                          => gtyrxp_in,
      rx8b10ben_in                       => rx8b10ben_in,
      rxcommadeten_in                    => rxcommadeten_in,
      rxmcommaalignen_in                 => rxmcommaalignen_in,
      rxpcommaalignen_in                 => rxpcommaalignen_in,
      rxprbscntreset_in                  => rxprbscntreset_in,
      rxprbssel_in                       => rxprbssel_in,
      tx8b10ben_in                       => tx8b10ben_in,
      txctrl0_in                         => txctrl0_in,
      txctrl1_in                         => txctrl1_in,
      txctrl2_in                         => txctrl2_in,
      txprbsforceerr_in                  => txprbsforceerr_in,
      txprbssel_in                       => txprbssel_in,
      gtpowergood_out                    => gtpowergood_out,
      gtytxn_out                         => gtytxn_out,
      gtytxp_out                         => gtytxp_out,
      rxbyteisaligned_out                => rxbyteisaligned_out,
      rxbyterealign_out                  => rxbyterealign_out,
      rxcommadet_out                     => rxcommadet_out,
      rxctrl0_out                        => rxctrl0_out,
      rxctrl1_out                        => rxctrl1_out,
      rxctrl2_out                        => rxctrl2_out,
      rxctrl3_out                        => rxctrl3_out,
      rxpmaresetdone_out                 => rxpmaresetdone_out,
      rxprbserr_out                      => rxprbserr_out,
      rxprbslocked_out                   => rxprbslocked_out,
      txpmaresetdone_out                 => txpmaresetdone_out,
      txprgdivresetdone_out              => txprgdivresetdone_out,
      cpllfbclklost_out                  => cpllfbclklost_out,
      cplllock_out                       => cplllock_out,
      cpllrefclklost_out                 => cpllrefclklost_out
      );

  process (gtwiz_userclk_rx_usrclk2_out(0)) is
  begin
    if rising_edge(gtwiz_userclk_rx_usrclk2_out(0)) then
      if (gtwiz_userdata_rx_out(7 downto 0) /= x"BC") then
        mgtDecErr <= '1';
      else
        mgtDecErr <= '0';
      end if;

      mgtBC0      <= gtwiz_userdata_rx_out(8);
      mgtL1A      <= gtwiz_userdata_rx_out(9);
      mgtResync   <= gtwiz_userdata_rx_out(10);
      mgtStart    <= gtwiz_userdata_rx_out(11);
      mgtStop     <= gtwiz_userdata_rx_out(12);
      mgtEC0      <= gtwiz_userdata_rx_out(13);
      mgtTestSync <= gtwiz_userdata_rx_out(14);

    end if;

  end process;

end rtl;

