TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(PWD)/asyncfifo.sv $(PWD)/grayctr/grayctr.sv
TOPLEVEL=asyncfifo
MODULE=test_bench

SIM=verilator
EXTRA_ARGS += --trace

include $(shell cocotb-config --makefiles)/Makefile.sim
