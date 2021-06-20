# Simple ILA example #########################################################################

##############################
# Get variables and procedures
##############################
source -quiet $::env(RUCKUS_DIR)/vivado_env_var.tcl
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Bypass the debug chipscope generation
return

############################
## Open the synthesis design
############################
open_run synth_1

###############################
## Set the name of the ILA core
###############################
set ilaName i_ila_InOut64b

##################
## Create the core
##################
CreateDebugCore ${ilaName}

#######################
## Set the record depth
#######################
set_property C_DATA_DEPTH 1024 [get_debug_cores ${ilaName}]

#################################
## Set the clock for the ILA core
#################################
SetDebugCoreClk ${ilaName} {U_algoTopWrapper/algoClk}

#######################
## Set the debug Probes
#######################
ConfigProbe ${ilaName} {*algoRst}

ConfigProbe ${ilaName} [get_nets -regexp {.*/.*sa_axiStreamIn_d3_ila_ruck\[([0-9]|1[0-7])\]\[tData\]\[([0-9]|[1-5][0-9]|6[0-3])\].*}]
ConfigProbe ${ilaName} [get_nets -regexp {.*/.*sa_axiStreamIn_d3_ila_ruck\[([0-9]|1[0-7])\]\[tValid\]}]

ConfigProbe ${ilaName} [get_nets -regexp {.*/.*sa_axiStreamOut_d3\[[0-3]\]\[tData\]\[([0-9]|[1-5][0-9]|6[0-3])\].*}]
ConfigProbe ${ilaName} [get_nets -regexp {.*/.*sa_axiStreamOut_d3\[[0-3]\]\[tValid\]}]

##########################
## Write the port map file
##########################
WriteDebugProbes ${ilaName}
