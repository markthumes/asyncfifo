import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock    import Clock

async def write(dut):
    dut.wr_rstn.value = 0;
    for _ in range(2):
        await RisingEdge(dut.wr_clk)

    dut.wr_rstn.value = 1;
    for _ in range(2):
        await RisingEdge(dut.wr_clk)

    dut.wr_en.value = 1;
    for v in [0xaa, 0xff]:
        dut.wr_data.value = v
        await RisingEdge(dut.wr_clk)
    dut.wr_en.value = 0;
    for v in range(3):
        await RisingEdge(dut.wr_clk)

async def read(dut):
    dut.rd_rstn.value = 0;
    for _ in range(2):
        await RisingEdge(dut.rd_clk)
    dut.rd_rstn.value = 1;

    dut.rd_en.value = 1;

    for _ in range(18):
        await RisingEdge(dut.rd_clk)
    dut.rd_en.value = 0;

    for _ in range(2):
        await RisingEdge(dut.rd_clk)

@cocotb.test()
async def test_bench(dut):
    dut._log.info("Starting test")
    cocotb.start_soon(Clock(dut.wr_clk, 10, units="ns").start())
    cocotb.start_soon(Clock(dut.rd_clk, 10, units="ns").start())

    write_task = cocotb.start_soon(write(dut))
    read_task =  cocotb.start_soon(read(dut))
    await write_task
    await read_task
