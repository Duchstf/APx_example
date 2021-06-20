export BUILD_SCRIPT = $(PWD)/../submodules/ruckus/system_vivado.mk

# Define target output
target: bit

# Define Firmware Version Number
export PRJ_VERSION = 0x00000001

export PROJECT = top
export VIVADO_PROJECT_SIM = tb_algoTopWrapper
export VIVADO_PROJECT_SIM_TIME = 10000 ns # Simulation time with unit

#Define target part
export PRJ_PART = xcvu9p-flgc2104-1-e

export PARALLEL_SYNTH = 24

export TOP_DIR = $(abspath $(PWD)/..)
 
# !Caution! Timing failuire IGnore flag. Allows bitfile generation even if timing not met. 
export TIG = true

# Use top level makefile
include $(BUILD_SCRIPT)
