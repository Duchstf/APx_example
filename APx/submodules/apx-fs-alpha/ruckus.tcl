# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load APx-FS ruckus files
loadRuckusTcl "$::DIR_PATH/axiInfra"
loadRuckusTcl "$::DIR_PATH/mgt"
loadRuckusTcl "$::DIR_PATH/tcds"
loadRuckusTcl "$::DIR_PATH/linkBuf"
loadRuckusTcl "$::DIR_PATH/algoCtrl"
loadRuckusTcl "$::DIR_PATH/iridisSF"
loadRuckusTcl "$::DIR_PATH/apxL1T"
loadRuckusTcl "$::DIR_PATH/misc"
loadSource -path "$::DIR_PATH/algoSim/tb_algoTopWrapper.vhd"
