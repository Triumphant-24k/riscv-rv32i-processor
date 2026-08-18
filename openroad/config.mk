export DESIGN_NICKNAME = practice_rv32i
export DESIGN_NAME     = cpu_core
export PLATFORM        = sky130hd

PROJECT_HOME := $(abspath $(dir $(DESIGN_CONFIG))/..)

export VERILOG_FILES = \
    $(PROJECT_HOME)/src/alu.v \
    $(PROJECT_HOME)/src/control_unit.v \
    $(PROJECT_HOME)/src/cpu_core.v \
    $(PROJECT_HOME)/src/immediate_generator.v \
    $(PROJECT_HOME)/src/program_counter.v \
    $(PROJECT_HOME)/src/register_file.v

export SDC_FILE = $(PROJECT_HOME)/openroad/constraint.sdc

export CORE_UTILIZATION = 35
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 2
export PLACE_DENSITY_LB_ADDON = 0.10
