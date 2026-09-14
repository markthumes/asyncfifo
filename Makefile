TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(PWD)/asyncfifo_top.v $(PWD)/asyncfifo.sv $(PWD)/grayctr/grayctr.sv

TOPLEVEL=asyncfifo
MODULE=test_bench

SIM=verilator
EXTRA_ARGS += --trace

# Define Vivado variables
VIVADO = vivado
BD_NAME = fifo_bd

include $(shell cocotb-config --makefiles)/Makefile.sim

# Trigger Vivado CLI processing
ip: $(VERILOG_SOURCES)
	$(VIVADO) -mode batch -source vivado.tcl -tclargs $(BD_NAME) $(VERILOG_SOURCES)

export_ip:
	@echo "open_project ./fifo_project/fifo_project.xpr; open_bd_design [get_files $(BD_NAME).bd]; write_bd_tcl -force ./recreate_fifo_bd.tcl; close_project" | $(VIVADO) -mode batch -notrace



# Change to double colons (::) to append to cocotb's clean rule
clean::
	rm -rf .Xil/ vivado*.log vivado*.jou NA/ fifo_project/
	rm -rf $(BD_NAME).bd

