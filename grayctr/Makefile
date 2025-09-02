TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(PWD)/grayctr.sv
TOPLEVEL=grayctr
MODULE=test_bench

SIM=verilator
EXTRA_ARGS += --trace

export PARAM_WIDTH := 4

COMPILE_ARGS += $(foreach v,$(filter PARAM_%,$(.VARIABLES)),-G$(subst PARAM_,,$(v))=$($(v)))
COMPILE_ARGS += --trace-fst

include $(shell cocotb-config --makefiles)/Makefile.sim
