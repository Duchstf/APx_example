library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_misc.all;

use work.StdRtlPkg.all;
use work.MgtPkg.all;

library unisim;
use unisim.vcomponents.all;

entity MgtWrapper is
  generic (
    TPD_G     : time    := 1 ns;
    MGT_IDX_G : integer := 0;
    MGT_CFG_G : tMgtCfgArr
    );
  port (
    clk_freerun : in  sl;
    mgtRxN      : in  sl;
    mgtRxP      : in  sl;
    mgtTxN      : out sl;
    mgtTxP      : out sl;

    mgtTxUsrClk : out sl;
    mgtTxData   : in  tMgtTxData;
    mgtRxData   : out tMgtRxData;
    mgtRxUsrClk : out sl;

    mgtRxPrbsErr     : out sl;
    mgtRxGearboxSlip : in  sl;

    mgtSlwCtrl   : in  tMgtSlwCtrl;
    mgtSlwStatus : out tMgtSlwStatus;

    qpllClk    : in slv(1 downto 0);
    qpllRefClk : in slv(1 downto 0);
    qpllLock   : in slv(1 downto 0);

    drpAddr : in  slv(9 downto 0);
    drpClk  : in  sl;
    drpDi   : in  slv(15 downto 0);
    drpEn   : in  sl;
    drpRst  : in  sl;
    drpWe   : in  sl;
    drpDo   : out slv(15 downto 0);
    drpRdy  : out sl
    );
end MgtWrapper;

architecture rtl of MgtWrapper is

  component gty15p7g
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
      gtwiz_reset_qpll0lock_in           : in  std_logic_vector(0 downto 0);
      gtwiz_reset_rx_cdr_stable_out      : out std_logic_vector(0 downto 0);
      gtwiz_reset_tx_done_out            : out std_logic_vector(0 downto 0);
      gtwiz_reset_rx_done_out            : out std_logic_vector(0 downto 0);
      gtwiz_reset_qpll0reset_out         : out std_logic_vector(0 downto 0);
      gtwiz_userdata_tx_in               : in  std_logic_vector(63 downto 0);
      gtwiz_userdata_rx_out              : out std_logic_vector(63 downto 0);
      drpaddr_in                         : in  std_logic_vector(9 downto 0);
      drpclk_in                          : in  std_logic_vector(0 downto 0);
      drpdi_in                           : in  std_logic_vector(15 downto 0);
      drpen_in                           : in  std_logic_vector(0 downto 0);
      drprst_in                          : in  std_logic_vector(0 downto 0);
      drpwe_in                           : in  std_logic_vector(0 downto 0);
      gtyrxn_in                          : in  std_logic_vector(0 downto 0);
      gtyrxp_in                          : in  std_logic_vector(0 downto 0);
      loopback_in                        : in  std_logic_vector(2 downto 0);
      qpll0clk_in                        : in  std_logic_vector(0 downto 0);
      qpll0refclk_in                     : in  std_logic_vector(0 downto 0);
      qpll1clk_in                        : in  std_logic_vector(0 downto 0);
      qpll1refclk_in                     : in  std_logic_vector(0 downto 0);
      rxgearboxslip_in                   : in  std_logic_vector(0 downto 0);
      rxpd_in                            : in  std_logic_vector(1 downto 0);
      rxpolarity_in                      : in  std_logic_vector(0 downto 0);
      rxprbscntreset_in                  : in  std_logic_vector(0 downto 0);
      rxprbssel_in                       : in  std_logic_vector(3 downto 0);
      txdiffctrl_in                      : in  std_logic_vector(4 downto 0);
      txelecidle_in                      : in  std_logic_vector(0 downto 0);
      txheader_in                        : in  std_logic_vector(5 downto 0);
      txpd_in                            : in  std_logic_vector(1 downto 0);
      txpolarity_in                      : in  std_logic_vector(0 downto 0);
      txprbsforceerr_in                  : in  std_logic_vector(0 downto 0);
      txprbssel_in                       : in  std_logic_vector(3 downto 0);
      txsequence_in                      : in  std_logic_vector(6 downto 0);
      drpdo_out                          : out std_logic_vector(15 downto 0);
      drprdy_out                         : out std_logic_vector(0 downto 0);
      gtpowergood_out                    : out std_logic_vector(0 downto 0);
      gtytxn_out                         : out std_logic_vector(0 downto 0);
      gtytxp_out                         : out std_logic_vector(0 downto 0);
      rxdatavalid_out                    : out std_logic_vector(1 downto 0);
      rxheader_out                       : out std_logic_vector(5 downto 0);
      rxheadervalid_out                  : out std_logic_vector(1 downto 0);
      rxpmaresetdone_out                 : out std_logic_vector(0 downto 0);
      rxprbserr_out                      : out std_logic_vector(0 downto 0);
      rxprbslocked_out                   : out std_logic_vector(0 downto 0);
      rxstartofseq_out                   : out std_logic_vector(1 downto 0);
      txpmaresetdone_out                 : out std_logic_vector(0 downto 0);
      txprgdivresetdone_out              : out std_logic_vector(0 downto 0)
      );
  end component;


  component gty16g
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
      gtwiz_reset_qpll0lock_in           : in  std_logic_vector(0 downto 0);
      gtwiz_reset_rx_cdr_stable_out      : out std_logic_vector(0 downto 0);
      gtwiz_reset_tx_done_out            : out std_logic_vector(0 downto 0);
      gtwiz_reset_rx_done_out            : out std_logic_vector(0 downto 0);
      gtwiz_reset_qpll0reset_out         : out std_logic_vector(0 downto 0);
      gtwiz_userdata_tx_in               : in  std_logic_vector(63 downto 0);
      gtwiz_userdata_rx_out              : out std_logic_vector(63 downto 0);
      drpaddr_in                         : in  std_logic_vector(9 downto 0);
      drpclk_in                          : in  std_logic_vector(0 downto 0);
      drpdi_in                           : in  std_logic_vector(15 downto 0);
      drpen_in                           : in  std_logic_vector(0 downto 0);
      drprst_in                          : in  std_logic_vector(0 downto 0);
      drpwe_in                           : in  std_logic_vector(0 downto 0);
      gtyrxn_in                          : in  std_logic_vector(0 downto 0);
      gtyrxp_in                          : in  std_logic_vector(0 downto 0);
      loopback_in                        : in  std_logic_vector(2 downto 0);
      qpll0clk_in                        : in  std_logic_vector(0 downto 0);
      qpll0refclk_in                     : in  std_logic_vector(0 downto 0);
      qpll1clk_in                        : in  std_logic_vector(0 downto 0);
      qpll1refclk_in                     : in  std_logic_vector(0 downto 0);
      rxgearboxslip_in                   : in  std_logic_vector(0 downto 0);
      rxpd_in                            : in  std_logic_vector(1 downto 0);
      rxpolarity_in                      : in  std_logic_vector(0 downto 0);
      rxprbscntreset_in                  : in  std_logic_vector(0 downto 0);
      rxprbssel_in                       : in  std_logic_vector(3 downto 0);
      txdiffctrl_in                      : in  std_logic_vector(4 downto 0);
      txelecidle_in                      : in  std_logic_vector(0 downto 0);
      txheader_in                        : in  std_logic_vector(5 downto 0);
      txpd_in                            : in  std_logic_vector(1 downto 0);
      txpolarity_in                      : in  std_logic_vector(0 downto 0);
      txprbsforceerr_in                  : in  std_logic_vector(0 downto 0);
      txprbssel_in                       : in  std_logic_vector(3 downto 0);
      txsequence_in                      : in  std_logic_vector(6 downto 0);
      drpdo_out                          : out std_logic_vector(15 downto 0);
      drprdy_out                         : out std_logic_vector(0 downto 0);
      gtpowergood_out                    : out std_logic_vector(0 downto 0);
      gtytxn_out                         : out std_logic_vector(0 downto 0);
      gtytxp_out                         : out std_logic_vector(0 downto 0);
      rxdatavalid_out                    : out std_logic_vector(1 downto 0);
      rxheader_out                       : out std_logic_vector(5 downto 0);
      rxheadervalid_out                  : out std_logic_vector(1 downto 0);
      rxpmaresetdone_out                 : out std_logic_vector(0 downto 0);
      rxprbserr_out                      : out std_logic_vector(0 downto 0);
      rxprbslocked_out                   : out std_logic_vector(0 downto 0);
      rxstartofseq_out                   : out std_logic_vector(1 downto 0);
      txpmaresetdone_out                 : out std_logic_vector(0 downto 0);
      txprgdivresetdone_out              : out std_logic_vector(0 downto 0)
      );
  end component;

  component gty25g
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
      gtwiz_reset_qpll0lock_in           : in  std_logic_vector(0 downto 0);
      gtwiz_reset_rx_cdr_stable_out      : out std_logic_vector(0 downto 0);
      gtwiz_reset_tx_done_out            : out std_logic_vector(0 downto 0);
      gtwiz_reset_rx_done_out            : out std_logic_vector(0 downto 0);
      gtwiz_reset_qpll0reset_out         : out std_logic_vector(0 downto 0);
      gtwiz_userdata_tx_in               : in  std_logic_vector(63 downto 0);
      gtwiz_userdata_rx_out              : out std_logic_vector(63 downto 0);
      drpaddr_in                         : in  std_logic_vector(9 downto 0);
      drpclk_in                          : in  std_logic_vector(0 downto 0);
      drpdi_in                           : in  std_logic_vector(15 downto 0);
      drpen_in                           : in  std_logic_vector(0 downto 0);
      drprst_in                          : in  std_logic_vector(0 downto 0);
      drpwe_in                           : in  std_logic_vector(0 downto 0);
      gtyrxn_in                          : in  std_logic_vector(0 downto 0);
      gtyrxp_in                          : in  std_logic_vector(0 downto 0);
      loopback_in                        : in  std_logic_vector(2 downto 0);
      qpll0clk_in                        : in  std_logic_vector(0 downto 0);
      qpll0refclk_in                     : in  std_logic_vector(0 downto 0);
      qpll1clk_in                        : in  std_logic_vector(0 downto 0);
      qpll1refclk_in                     : in  std_logic_vector(0 downto 0);
      rxgearboxslip_in                   : in  std_logic_vector(0 downto 0);
      rxpd_in                            : in  std_logic_vector(1 downto 0);
      rxpolarity_in                      : in  std_logic_vector(0 downto 0);
      rxprbscntreset_in                  : in  std_logic_vector(0 downto 0);
      rxprbssel_in                       : in  std_logic_vector(3 downto 0);
      txdiffctrl_in                      : in  std_logic_vector(4 downto 0);
      txelecidle_in                      : in  std_logic_vector(0 downto 0);
      txheader_in                        : in  std_logic_vector(5 downto 0);
      txpd_in                            : in  std_logic_vector(1 downto 0);
      txpolarity_in                      : in  std_logic_vector(0 downto 0);
      txprbsforceerr_in                  : in  std_logic_vector(0 downto 0);
      txprbssel_in                       : in  std_logic_vector(3 downto 0);
      txsequence_in                      : in  std_logic_vector(6 downto 0);
      drpdo_out                          : out std_logic_vector(15 downto 0);
      drprdy_out                         : out std_logic_vector(0 downto 0);
      gtpowergood_out                    : out std_logic_vector(0 downto 0);
      gtytxn_out                         : out std_logic_vector(0 downto 0);
      gtytxp_out                         : out std_logic_vector(0 downto 0);
      rxdatavalid_out                    : out std_logic_vector(1 downto 0);
      rxheader_out                       : out std_logic_vector(5 downto 0);
      rxheadervalid_out                  : out std_logic_vector(1 downto 0);
      rxpmaresetdone_out                 : out std_logic_vector(0 downto 0);
      rxprbserr_out                      : out std_logic_vector(0 downto 0);
      rxprbslocked_out                   : out std_logic_vector(0 downto 0);
      rxstartofseq_out                   : out std_logic_vector(1 downto 0);
      txpmaresetdone_out                 : out std_logic_vector(0 downto 0);
      txprgdivresetdone_out              : out std_logic_vector(0 downto 0)
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
  signal gtwiz_reset_qpll0lock_in           : std_logic_vector(0 downto 0);
  signal gtwiz_reset_rx_cdr_stable_out      : std_logic_vector(0 downto 0);
  signal gtwiz_reset_tx_done_out            : std_logic_vector(0 downto 0);
  signal gtwiz_reset_rx_done_out            : std_logic_vector(0 downto 0);
  signal gtwiz_reset_qpll0reset_out         : std_logic_vector(0 downto 0);
  signal gtwiz_userdata_tx_in               : std_logic_vector(63 downto 0);
  signal gtwiz_userdata_rx_out              : std_logic_vector(63 downto 0);
  signal drpaddr_in                         : std_logic_vector(9 downto 0);
  signal drpclk_in                          : std_logic_vector(0 downto 0);
  signal drpdi_in                           : std_logic_vector(15 downto 0);
  signal drpen_in                           : std_logic_vector(0 downto 0);
  signal drprst_in                          : std_logic_vector(0 downto 0);
  signal drpwe_in                           : std_logic_vector(0 downto 0);
  signal gtyrxn_in                          : std_logic_vector(0 downto 0);
  signal gtyrxp_in                          : std_logic_vector(0 downto 0);
  signal loopback_in                        : std_logic_vector(2 downto 0);
  signal qpll0clk_in                        : std_logic_vector(0 downto 0);
  signal qpll0refclk_in                     : std_logic_vector(0 downto 0);
  signal qpll1clk_in                        : std_logic_vector(0 downto 0);
  signal qpll1refclk_in                     : std_logic_vector(0 downto 0);
  signal rxgearboxslip_in                   : std_logic_vector(0 downto 0);
  signal rxpd_in                            : std_logic_vector(1 downto 0);
  signal rxpolarity_in                      : std_logic_vector(0 downto 0);
  signal rxprbscntreset_in                  : std_logic_vector(0 downto 0);
  signal rxprbssel_in                       : std_logic_vector(3 downto 0);
  signal txdiffctrl_in                      : std_logic_vector(4 downto 0);
  signal txelecidle_in                      : std_logic_vector(0 downto 0);
  signal txheader_in                        : std_logic_vector(5 downto 0);
  signal txpd_in                            : std_logic_vector(1 downto 0);
  signal txpolarity_in                      : std_logic_vector(0 downto 0);
  signal txprbsforceerr_in                  : std_logic_vector(0 downto 0);
  signal txprbssel_in                       : std_logic_vector(3 downto 0);
  signal txsequence_in                      : std_logic_vector(6 downto 0);
  signal drpdo_out                          : std_logic_vector(15 downto 0);
  signal drprdy_out                         : std_logic_vector(0 downto 0);
  signal gtpowergood_out                    : std_logic_vector(0 downto 0);
  signal gtytxn_out                         : std_logic_vector(0 downto 0);
  signal gtytxp_out                         : std_logic_vector(0 downto 0);
  signal rxdatavalid_out                    : std_logic_vector(1 downto 0);
  signal rxheader_out                       : std_logic_vector(5 downto 0);
  signal rxheadervalid_out                  : std_logic_vector(1 downto 0);
  signal rxpmaresetdone_out                 : std_logic_vector(0 downto 0);
  signal rxprbserr_out                      : std_logic_vector(0 downto 0);
  signal rxprbslocked_out                   : std_logic_vector(0 downto 0);
  signal rxstartofseq_out                   : std_logic_vector(1 downto 0);
  signal txpmaresetdone_out                 : std_logic_vector(0 downto 0);
  signal txprgdivresetdone_out              : std_logic_vector(0 downto 0);

  signal mgtTxUsrClkInt : sl;
  signal mgtRxUsrClkInt : sl;

  signal mgtTxDataInt        : tMgtTxData;
  signal mgtRxDataInt        : tMgtRxData;
  signal mgtRxGearboxSlipInt : sl;

begin
  mgtTxUsrClk <= mgtTxUsrClkInt;
  mgtRxUsrClk <= mgtRxUsrClkInt;

  process(mgtRxUsrClkInt) is
  begin
    if rising_edge(mgtRxUsrClkInt) then
      mgtRxGearboxSlipInt <= mgtRxGearboxSlip;
      mgtRxData           <= mgtRxDataInt;
    end if;
  end process;

  process(mgtTxUsrClkInt) is
  begin
    if rising_edge(mgtTxUsrClkInt) then
      mgtTxDataInt <= mgtTxData;
    end if;
  end process;

  gtwiz_userclk_tx_reset_in(0)          <= not (txprgdivresetdone_out(0) and txpmaresetdone_out(0));
  --gtwiz_userclk_tx_srcclk_out
  --gtwiz_userclk_tx_usrclk_out
  mgtTxUsrClkInt                        <= gtwiz_userclk_tx_usrclk2_out(0);
  --gtwiz_userclk_tx_active_out
  gtwiz_userclk_rx_reset_in(0)          <= not (rxpmaresetdone_out(0));
  --gtwiz_userclk_rx_srcclk_out
  --gtwiz_userclk_rx_usrclk_out
  mgtRxUsrClkInt                        <= gtwiz_userclk_rx_usrclk2_out(0);
  --gtwiz_userclk_rx_active_out
  gtwiz_buffbypass_tx_reset_in(0)       <= not gtwiz_userclk_tx_active_out(0);  --todo sync 
  gtwiz_buffbypass_tx_start_user_in(0)  <= '0';
  --gtwiz_buffbypass_tx_done_out
  --gtwiz_buffbypass_tx_error_out
  gtwiz_buffbypass_rx_reset_in(0)       <= not (rxpmaresetdone_out(0));  --todo sync 
  gtwiz_buffbypass_rx_start_user_in(0)  <= '0';
  --gtwiz_buffbypass_rx_done_out
  --gtwiz_buffbypass_rx_error_out
  gtwiz_reset_clk_freerun_in(0)         <= clk_freerun;
  gtwiz_reset_all_in(0)                 <= mgtSlwCtrl.mgtMasterRst;
  gtwiz_reset_tx_pll_and_datapath_in(0) <= mgtSlwCtrl.mgtTxRst;
  gtwiz_reset_tx_datapath_in(0)         <= '0';
  gtwiz_reset_rx_pll_and_datapath_in(0) <= mgtSlwCtrl.mgtRxRst;
  gtwiz_reset_rx_datapath_in(0)         <= '0';
  gtwiz_reset_qpll0lock_in(0)           <= qpllLock(0);
  --gtwiz_reset_rx_cdr_stable_out
  --gtwiz_reset_tx_done_out
  --gtwiz_reset_rx_done_out
  --gtwiz_reset_qpll0reset_out
  gtwiz_userdata_tx_in(63 downto 0)     <= mgtTxDataInt.data(63 downto 0);
  mgtRxDataInt.data(63 downto 0)        <= gtwiz_userdata_rx_out(63 downto 0);
  drpaddr_in                            <= drpAddr;
  drpclk_in(0)                          <= drpClk;
  drpdi_in                              <= drpDi;
  drpen_in(0)                           <= drpEn;
  drprst_in(0)                          <= drpRst;
  drpwe_in(0)                           <= drpWe;
  gtyrxn_in(0)                          <= mgtRxN;
  gtyrxp_in(0)                          <= mgtRxP;
  loopback_in                           <= mgtSlwCtrl.loopback;
  qpll0clk_in(0)                        <= qpllClk(0);
  qpll0refclk_in(0)                     <= qpllRefClk(0);
  qpll1clk_in(0)                        <= qpllClk(1);
  qpll1refclk_in(0)                     <= qpllRefClk(1);
  rxgearboxslip_in(0)                   <= mgtRxGearboxSlipInt;
  rxpd_in(0)                            <= mgtSlwCtrl.rxPd;
  rxpd_in(1)                            <= mgtSlwCtrl.rxPd;
  rxpolarity_in(0)                      <= mgtSlwCtrl.rxPolarity;
  rxprbscntreset_in(0)                  <= mgtSlwCtrl.rxPrbsCntRst;
  rxprbssel_in                          <= mgtSlwCtrl.rxPrbsSel;
  txdiffctrl_in                         <= mgtSlwCtrl.txDiffCtrl;
  txelecidle_in(0)                      <= mgtSlwCtrl.txPd;
  txheader_in(5 downto 2)               <= "0000";
  txheader_in(1 downto 0)               <= mgtTxDataInt.header(1 downto 0);
  txpd_in(0)                            <= mgtSlwCtrl.txPd;
  txpd_in(1)                            <= mgtSlwCtrl.txPd;
  txpolarity_in(0)                      <= mgtSlwCtrl.txPolarity;
  txprbsforceerr_in(0)                  <= mgtSlwCtrl.txPrbsForceErr;
  txprbssel_in                          <= mgtSlwCtrl.txPrbsSel;
  txsequence_in                         <= mgtTxDataInt.sequence(6 downto 0);
  drpDo                                 <= drpdo_out;
  drpRdy                                <= drprdy_out(0);
  --gtpowergood_out(0) <= powerGood
  mgtTxN                                <= gtytxn_out(0);
  mgtTxP                                <= gtytxp_out(0);
  mgtRxDataInt.datavalid                <= rxdatavalid_out(0);
  mgtRxDataInt.header(1 downto 0)       <= rxheader_out(1 downto 0);
  mgtRxDataInt.headervalid              <= rxheadervalid_out(0);
  --rxpmaresetdone_out
  mgtRxPrbsErr                          <= rxprbserr_out(0);
  mgtSlwStatus.rxPrbsLocked             <= rxprbslocked_out(0);
  --rxstartofseq_out
  --txpmaresetdone_out
  --txprgdivresetdone_out

---
  mgtSlwStatus.txInitDone <= gtwiz_reset_tx_done_out(0) and gtwiz_buffbypass_tx_done_out(0);
  mgtSlwStatus.rxInitDone <= gtwiz_reset_rx_done_out(0) and gtwiz_buffbypass_rx_done_out(0);


  gen_mgt_15p7g : if (MGT_CFG_G(MGT_IDX_G).kind = gty_sym_15p7) generate
    U_gty15p7g : gty15p7g
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
        gtwiz_reset_qpll0lock_in           => gtwiz_reset_qpll0lock_in,
        gtwiz_reset_rx_cdr_stable_out      => gtwiz_reset_rx_cdr_stable_out,
        gtwiz_reset_tx_done_out            => gtwiz_reset_tx_done_out,
        gtwiz_reset_rx_done_out            => gtwiz_reset_rx_done_out,
        gtwiz_reset_qpll0reset_out         => gtwiz_reset_qpll0reset_out,
        gtwiz_userdata_tx_in               => gtwiz_userdata_tx_in,
        gtwiz_userdata_rx_out              => gtwiz_userdata_rx_out,
        drpaddr_in                         => drpaddr_in,
        drpclk_in                          => drpclk_in,
        drpdi_in                           => drpdi_in,
        drpen_in                           => drpen_in,
        drprst_in                          => drprst_in,
        drpwe_in                           => drpwe_in,
        gtyrxn_in                          => gtyrxn_in,
        gtyrxp_in                          => gtyrxp_in,
        loopback_in                        => loopback_in,
        qpll0clk_in                        => qpll0clk_in,
        qpll0refclk_in                     => qpll0refclk_in,
        qpll1clk_in                        => qpll1clk_in,
        qpll1refclk_in                     => qpll1refclk_in,
        rxgearboxslip_in                   => rxgearboxslip_in,
        rxpd_in                            => rxpd_in,
        rxpolarity_in                      => rxpolarity_in,
        rxprbscntreset_in                  => rxprbscntreset_in,
        rxprbssel_in                       => rxprbssel_in,
        txdiffctrl_in                      => txdiffctrl_in,
        txelecidle_in                      => txelecidle_in,
        txheader_in                        => txheader_in,
        txpd_in                            => txpd_in,
        txpolarity_in                      => txpolarity_in,
        txprbsforceerr_in                  => txprbsforceerr_in,
        txprbssel_in                       => txprbssel_in,
        txsequence_in                      => txsequence_in,
        drpdo_out                          => drpdo_out,
        drprdy_out                         => drprdy_out,
        gtpowergood_out                    => gtpowergood_out,
        gtytxn_out                         => gtytxn_out,
        gtytxp_out                         => gtytxp_out,
        rxdatavalid_out                    => rxdatavalid_out,
        rxheader_out                       => rxheader_out,
        rxheadervalid_out                  => rxheadervalid_out,
        rxpmaresetdone_out                 => rxpmaresetdone_out,
        rxprbserr_out                      => rxprbserr_out,
        rxprbslocked_out                   => rxprbslocked_out,
        rxstartofseq_out                   => rxstartofseq_out,
        txpmaresetdone_out                 => txpmaresetdone_out,
        txprgdivresetdone_out              => txprgdivresetdone_out
        );
  end generate;

  gen_mgt_16p0g : if (MGT_CFG_G(MGT_IDX_G).kind = gty_sym_16p0) generate
    U_gty16p0g : gty16g
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
        gtwiz_reset_qpll0lock_in           => gtwiz_reset_qpll0lock_in,
        gtwiz_reset_rx_cdr_stable_out      => gtwiz_reset_rx_cdr_stable_out,
        gtwiz_reset_tx_done_out            => gtwiz_reset_tx_done_out,
        gtwiz_reset_rx_done_out            => gtwiz_reset_rx_done_out,
        gtwiz_reset_qpll0reset_out         => gtwiz_reset_qpll0reset_out,
        gtwiz_userdata_tx_in               => gtwiz_userdata_tx_in,
        gtwiz_userdata_rx_out              => gtwiz_userdata_rx_out,
        drpaddr_in                         => drpaddr_in,
        drpclk_in                          => drpclk_in,
        drpdi_in                           => drpdi_in,
        drpen_in                           => drpen_in,
        drprst_in                          => drprst_in,
        drpwe_in                           => drpwe_in,
        gtyrxn_in                          => gtyrxn_in,
        gtyrxp_in                          => gtyrxp_in,
        loopback_in                        => loopback_in,
        qpll0clk_in                        => qpll0clk_in,
        qpll0refclk_in                     => qpll0refclk_in,
        qpll1clk_in                        => qpll1clk_in,
        qpll1refclk_in                     => qpll1refclk_in,
        rxgearboxslip_in                   => rxgearboxslip_in,
        rxpd_in                            => rxpd_in,
        rxpolarity_in                      => rxpolarity_in,
        rxprbscntreset_in                  => rxprbscntreset_in,
        rxprbssel_in                       => rxprbssel_in,
        txdiffctrl_in                      => txdiffctrl_in,
        txelecidle_in                      => txelecidle_in,
        txheader_in                        => txheader_in,
        txpd_in                            => txpd_in,
        txpolarity_in                      => txpolarity_in,
        txprbsforceerr_in                  => txprbsforceerr_in,
        txprbssel_in                       => txprbssel_in,
        txsequence_in                      => txsequence_in,
        drpdo_out                          => drpdo_out,
        drprdy_out                         => drprdy_out,
        gtpowergood_out                    => gtpowergood_out,
        gtytxn_out                         => gtytxn_out,
        gtytxp_out                         => gtytxp_out,
        rxdatavalid_out                    => rxdatavalid_out,
        rxheader_out                       => rxheader_out,
        rxheadervalid_out                  => rxheadervalid_out,
        rxpmaresetdone_out                 => rxpmaresetdone_out,
        rxprbserr_out                      => rxprbserr_out,
        rxprbslocked_out                   => rxprbslocked_out,
        rxstartofseq_out                   => rxstartofseq_out,
        txpmaresetdone_out                 => txpmaresetdone_out,
        txprgdivresetdone_out              => txprgdivresetdone_out
        );
  end generate;

  gen_mgt_25g : if (MGT_CFG_G(MGT_IDX_G).kind = gty_sym_25p78125) generate
    U_gty25g : gty25g
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
        gtwiz_reset_qpll0lock_in           => gtwiz_reset_qpll0lock_in,
        gtwiz_reset_rx_cdr_stable_out      => gtwiz_reset_rx_cdr_stable_out,
        gtwiz_reset_tx_done_out            => gtwiz_reset_tx_done_out,
        gtwiz_reset_rx_done_out            => gtwiz_reset_rx_done_out,
        gtwiz_reset_qpll0reset_out         => gtwiz_reset_qpll0reset_out,
        gtwiz_userdata_tx_in               => gtwiz_userdata_tx_in,
        gtwiz_userdata_rx_out              => gtwiz_userdata_rx_out,
        drpaddr_in                         => drpaddr_in,
        drpclk_in                          => drpclk_in,
        drpdi_in                           => drpdi_in,
        drpen_in                           => drpen_in,
        drprst_in                          => drprst_in,
        drpwe_in                           => drpwe_in,
        gtyrxn_in                          => gtyrxn_in,
        gtyrxp_in                          => gtyrxp_in,
        loopback_in                        => loopback_in,
        qpll0clk_in                        => qpll0clk_in,
        qpll0refclk_in                     => qpll0refclk_in,
        qpll1clk_in                        => qpll1clk_in,
        qpll1refclk_in                     => qpll1refclk_in,
        rxgearboxslip_in                   => rxgearboxslip_in,
        rxpd_in                            => rxpd_in,
        rxpolarity_in                      => rxpolarity_in,
        rxprbscntreset_in                  => rxprbscntreset_in,
        rxprbssel_in                       => rxprbssel_in,
        txdiffctrl_in                      => txdiffctrl_in,
        txelecidle_in                      => txelecidle_in,
        txheader_in                        => txheader_in,
        txpd_in                            => txpd_in,
        txpolarity_in                      => txpolarity_in,
        txprbsforceerr_in                  => txprbsforceerr_in,
        txprbssel_in                       => txprbssel_in,
        txsequence_in                      => txsequence_in,
        drpdo_out                          => drpdo_out,
        drprdy_out                         => drprdy_out,
        gtpowergood_out                    => gtpowergood_out,
        gtytxn_out                         => gtytxn_out,
        gtytxp_out                         => gtytxp_out,
        rxdatavalid_out                    => rxdatavalid_out,
        rxheader_out                       => rxheader_out,
        rxheadervalid_out                  => rxheadervalid_out,
        rxpmaresetdone_out                 => rxpmaresetdone_out,
        rxprbserr_out                      => rxprbserr_out,
        rxprbslocked_out                   => rxprbslocked_out,
        rxstartofseq_out                   => rxstartofseq_out,
        txpmaresetdone_out                 => txpmaresetdone_out,
        txprgdivresetdone_out              => txprgdivresetdone_out
        );
  end generate;
end rtl;

