# Load RUCKUS environment and library
puts $::env(RUCKUS_DIR)
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load SURF ruckus.tcl file
loadRuckusTcl $::env(TOP_DIR)/submodules/surf

# Load APx-FS ruckus.tcl file
loadRuckusTcl $::env(TOP_DIR)/submodules/apx-fs-alpha

# Load lib_hdl ruckus.tcl file
loadRuckusTcl $::env(TOP_DIR)/submodules/lib_hdl

# Load local source Code and constraints
loadSource      -dir "$::DIR_PATH/rtl/"
loadConstraints -dir "$::DIR_PATH/constraints/"
