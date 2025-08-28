import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock    import Clock

@cocotb.test()
async def test_bench(dut):
	dut._log.info("Starting test")
	cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
