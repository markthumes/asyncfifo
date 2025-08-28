TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(PWD)/cordic.sv
TOPLEVEL=cordic
MODULE=test_bench

SIM=verilator
EXTRA_ARGS += --trace

include $(shell cocotb-config --makefiles)/Makefile.sim
