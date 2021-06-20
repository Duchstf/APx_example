# Load RUCKUS library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load Source Code
loadSource -dir "$::DIR_PATH/rtl"

# Load IP cores
loadIpCore -dir "$::DIR_PATH/ip/"

if { $::env(VIVADO_VERSION) == 2018.2   } {
     loadBlockDesign -path "$::DIR_PATH/bd/2018.2/bd.bd"
} elseif { $::env(VIVADO_VERSION) == 2019.1   } {
    loadBlockDesign -path "$::DIR_PATH/bd/2019.1/bd.bd"
}

