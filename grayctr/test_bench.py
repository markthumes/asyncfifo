import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock    import Clock

@cocotb.test()
async def test_bench(dut):
    dut._log.info("Starting test")
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    dut.inc.value = 0
    for _ in range(4):
        await RisingEdge(dut.clk)

    width = dut.bin.value.n_bits
    dut._log.info(f"DUT WIDTH seen in cocotb = {width}")
    assert width == 4
    

    dut.inc.value = 1
    for _ in range(256):
        await RisingEdge(dut.clk)
