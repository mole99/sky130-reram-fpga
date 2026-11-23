# SPDX-FileCopyrightText: © 2025 Project Template Contributors
# SPDX-License-Identifier: Apache-2.0

import os
import re
import random
import logging
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.types import LogicArray, Logic
from cocotb.triggers import Timer, Edge, RisingEdge, FallingEdge, ClockCycles
from cocotb_tools.runner import get_runner

from cocotbext.spi import SpiBus, SpiConfig, SpiMaster

proj_path = Path(__file__).resolve().parent

sim = os.getenv("SIM", "icarus")
gl = os.getenv("GL", False)
pdk_root = os.getenv("PDK_ROOT", Path("~/.ciel").expanduser())
pdk = os.getenv("PDK", "sky130A")
scl = os.getenv("SCL", "sky130_fd_sc_hd")
pad = os.getenv("PAD", "sky130_fd_io")
tile_library = os.getenv("TILE_LIBRARY", "classic")
fabric = os.getenv("FABRIC", "classic_fabric_reram")

hdl_toplevel = "chip_top"
tb_toplevel = "chip_top_tb"

lookup = {
    "X0Y1/A" : "fabric_io_PAD_0",
    "X0Y1/B" : "fabric_io_PAD_1",
    "X0Y2/A" : "fabric_io_PAD_2",
    "X0Y2/B" : "fabric_io_PAD_3",
    "X0Y3/A" : "fabric_io_PAD_4",
    "X0Y3/B" : "fabric_io_PAD_5",
    "X0Y4/A" : "fabric_io_PAD_6",
    "X0Y4/B" : "fabric_io_PAD_7",
    "X0Y5/A" : "fabric_io_PAD_8",
    "X0Y5/B" : "fabric_io_PAD_9",
    "X0Y6/A" : "fabric_io_PAD_10",
    "X0Y6/B" : "fabric_io_PAD_11",
    "X0Y7/A" : "fabric_io_PAD_12",
    "X0Y7/B" : "fabric_io_PAD_13",
    "X0Y8/A" : "fabric_io_PAD_14",
    "X0Y8/B" : "fabric_io_PAD_15",
    "X0Y9/A" : "fabric_io_PAD_16",
    "X0Y9/B" : "fabric_io_PAD_17",
    "X0Y10/A" : "fabric_io_PAD_18",
    "X0Y10/B" : "fabric_io_PAD_19",
    "X0Y11/A" : "fabric_io_PAD_20",
    "X0Y11/B" : "fabric_io_PAD_21",
    "X0Y12/A" : "fabric_io_PAD_22",
    "X0Y12/B" : "fabric_io_PAD_23",
    "X0Y13/A" : "fabric_io_PAD_24",
    "X0Y13/B" : "fabric_io_PAD_25",
    "X0Y14/A" : "fabric_io_PAD_26",
    "X0Y14/B" : "fabric_io_PAD_27",
    "X0Y15/A" : "fabric_io_PAD_28",
    "X0Y15/B" : "fabric_io_PAD_29",
    "X0Y16/A" : "fabric_io_PAD_30",
    "X0Y16/B" : "fabric_io_PAD_31",
    "X0Y17/A" : "fabric_io_PAD_32",
    "X0Y17/B" : "fabric_io_PAD_33",
    "X0Y18/A" : "fabric_io_PAD_34",
    "X0Y18/B" : "fabric_io_PAD_35",
}


testcase = os.getenv("TESTCASE", "all_ones")

testcases = {
    # Note! There's a character limit for Icarus readmemh's path. It will start dropping the first characters.
    # I'm using relative paths here (from the sim_build directory) as with absolute paths the character
    # limit is reached in GitHub actions.
    "all_ones": {
        'flash1_slot0': f"../../user_designs/designs/{tile_library}/all_ones/all_ones.hex",
        'flash1_slot1': "",
    },

    "all_zeros": {
        'flash1_slot0': f"../../user_designs/designs/{tile_library}/all_zeros/all_zeros.hex",
        'flash1_slot1': "",
    },

    "counter_top": {
        'flash1_slot0': f"../../user_designs/designs/{tile_library}/counter_top/counter_top.hex",
        'flash1_slot1': "",
    },

    "trigger_slot": {
        'flash1_slot0': f"../../user_designs/designs/{tile_library}/trigger_slot1/trigger_slot1.hex",
        'flash1_slot1': f"../../user_designs/designs/{tile_library}/trigger_slot0/trigger_slot0.hex",
    },
}

enabled = testcases[testcase]

class PCF:
    "A class to read a PCF file and access the signals within cocotb."

    def __init__(self, dut, file, lookup):
        self.signals = {}
        self.top = dut._name
        print(f"Reading PCF file: {file}")
        with open(file, "r") as pcf_file:
            while line := pcf_file.readline():
                if match := re.match(r"\s*set_io\s+(?P<signal>\w+)(\[(?P<index>\d+)?\])?\s+X(?P<tilex>\d+)Y(?P<tiley>\d+)\/(?P<bel>\w+)", line):
                    signal = match.group("signal")
                    index = match.group("index")
                    tile_x = match.group("tilex")
                    tile_y = match.group("tiley")
                    bel = match.group("bel")

                    tile_bel = f"X{tile_x}Y{tile_y}/{bel}"
                    top_pad = lookup[tile_bel]
                    top_handle = eval(f"dut.{top_pad}", locals=dict(dut=dut))

                    if index is None:
                        index = 0
                    else:
                        index = int(index)
                    
                    # Add an index to a signal
                    if signal in self.signals:
                        self.signals[signal][index] = top_handle

                        # Sort by index
                        self.signals[signal] = dict(sorted(self.signals[signal].items()))
                    # Add a new signal
                    else:
                        self.signals[signal] = {
                             index: top_handle
                        }

    def write_gtkw(self, path, filter=None):
        "Write a gtkwave save file in order to view the selected signals"
        with open(path, "w") as outfile:
            outfile.write(f"@28\n")
            for signal_name, signal in self.signals.items():
                if filter is not None and signal_name in filter:
                    if len(signal) == 1:
                        outfile.write(f"#{{{signal_name}}} {self.top}.{signal[0]._name}\n")
                        outfile.write(f"@200\n")
                        outfile.write(f"-\n")
                        outfile.write(f"@28\n")
                    else:
                        bits = len(signal)
                        signals = [ self.top + "." + signal._name for index, signal in reversed(signal.items()) ]
                    
                        outfile.write(f"@c00022\n")
                        outfile.write(f"#{{{signal_name}[{bits-1}:0]}} {' '.join(signals)}\n")
                        outfile.write(f"@28\n")
                        for signal in signals:
                            outfile.write(f"{signal}\n")
                        outfile.write(f"@1401200\n")
                        outfile.write(f"-group_end\n")

                        outfile.write(f"@200\n")
                        outfile.write(f"-\n")

    def get(self, signal, index=None):
        "Get the value of a signal"
        #print(f"get {signal} {index}")
    
        # Get the full signal
        if index is None:
            return LogicArray("".join(str(bit.value) for bit in reversed(self.signals[signal].values())))
        # Get a single bit
        else:
            return Logic(self.signals[signal][index].value)
    
    def set(self, signal, value, index=None):
        "Set the value of a signal"
        #print(f"set {signal} {value} {index}")
        
        # Get the full signal
        if index is None:
            for index, bit in enumerate(reversed(value)):
                self.signals[signal][index].value = bit
        else:
            self.signals[signal][index].value = value

    def get_raw(self, signal, use, index=0):
        "Get the raw cocotb signal. Can be used for triggers."
        return self.signals[signal][index]

async def set_defaults(dut):
    dut.fpga_mode_PAD.value = 0

async def enable_power(dut):
    dut.vddio.value = 1
    dut.vssio.value = 0
    dut.vccd.value = 1
    dut.vssd.value = 0
    dut.vdda.value = 1
    dut.vssa.value = 0
    dut.vdda1.value = 1
    dut.vssa1.value = 0
    dut.vccd1.value = 1
    dut.vssd1.value = 0
    dut.vdda2.value = 1
    dut.vssa2.value = 0
    dut.vccd2.value = 1
    dut.vssd2.value = 0


async def start_clock(clock, freq=50):
    """Start the clock @ freq MHz"""
    c = Clock(clock, 1 / freq * 1000, "ns")
    cocotb.start_soon(c.start())


async def reset(reset, active_low=True, time_ns=500):
    """Reset dut"""
    cocotb.log.info("Reset asserted...")

    reset.value = not active_low
    await Timer(time_ns, "ns")
    reset.value = active_low

    cocotb.log.info("Reset deasserted.")


async def start_up(dut):
    """Startup sequence"""
    await set_defaults(dut)
    if gl:
        await enable_power(dut)
    await start_clock(dut.fpga_clk_PAD)
    await reset(dut.fpga_rst_n_PAD)


@cocotb.test(skip=testcase!="all_ones")
async def test_all_ones(dut):
    """Load bitstream that sets all ones"""

    testname = "all_ones"

    pcf = PCF(dut, proj_path / f"../fabrics/{fabric}/constraints.pcf", lookup)
    pcf.write_gtkw(f"{testname}.gtkw", ["all"])

    # Create a logger for this testbench
    logger = logging.getLogger("my_testbench")

    logger.info("Setting defaults...")

    # FPGA config mode
    # if mode == 0: SPI controller
    # if mode == 1: SPI receiver
    dut.fpga_mode_PAD.value = 0

    logger.info("Startup sequence...")

    # Start up
    await start_up(dut)

    logger.info("Running the test...")

    # Wait for a number of clock cycles
    await ClockCycles(dut.fpga_clk_PAD, 10000)
    
    # Wait for done
    await FallingEdge(dut.fpga_config_busy_PAD)
    await ClockCycles(dut.fpga_clk_PAD, 1)

    assert pcf.get("all").to_unsigned() == LogicArray.from_signed(-1, len(pcf.get("all")))

    logger.info("Done!")

@cocotb.test(skip=testcase!="all_zeros")
async def test_all_zeros(dut):
    """Load bitstream that sets all zeros"""

    testname = "all_zeros"

    pcf = PCF(dut, proj_path / f"../fabrics/{fabric}/constraints.pcf", lookup)
    pcf.write_gtkw(f"{testname}.gtkw", ["all"])

    # Create a logger for this testbench
    logger = logging.getLogger("my_testbench")

    logger.info("Setting defaults...")

    # FPGA config mode
    # if mode == 0: SPI controller
    # if mode == 1: SPI receiver
    dut.fpga_mode_PAD.value = 0

    logger.info("Startup sequence...")

    # Start up
    await start_up(dut)

    logger.info("Running the test...")

    # Wait for a number of clock cycles
    await ClockCycles(dut.fpga_clk_PAD, 10000)
    
    # Wait for done
    await FallingEdge(dut.fpga_config_busy_PAD)
    await ClockCycles(dut.fpga_clk_PAD, 1)

    assert pcf.get("all").to_unsigned() == LogicArray.from_unsigned(0, len(pcf.get("all")))

    logger.info("Done!")

@cocotb.test(skip=testcase!="counter_top")
async def test_counter_top(dut):
    """Load bitstream that counts"""

    testname = "counter_top"

    pcf = PCF(dut, proj_path / f"../fabrics/{fabric}/constraints.pcf", lookup)
    pcf.write_gtkw(f"{testname}.gtkw", ["clk1", "rst", "c"])

    # Create a logger for this testbench
    logger = logging.getLogger("my_testbench")

    logger.info("Setting defaults...")

    # FPGA config mode
    # if mode == 0: SPI controller
    # if mode == 1: SPI receiver
    dut.fpga_mode_PAD.value = 0

    logger.info("Startup sequence...")

    # Start up
    await start_up(dut)

    logger.info("Running the test...")
    
    # Wait for done
    await FallingEdge(dut.fpga_config_busy_PAD)
    
    # Start a clock on clk1
    clock = pcf.get_raw("clk1", "OUT")
    cocotb.start_soon(Clock(clock, 10, 'ns').start())
    
    pcf.set("rst", Logic(1), index=0)
    await ClockCycles(clock, 10)
    pcf.set("rst", Logic(0), index=0)

    # Wait for a number of clock cycles
    NUM_CYCLES = 123
    await ClockCycles(clock, NUM_CYCLES)

    assert pcf.get("c").to_unsigned() == NUM_CYCLES-1

    logger.info("Done!")

@cocotb.test(skip=testcase!="trigger_slot")
async def test_trigger_slot(dut):
    """Load bitstream that loads another bitstream"""

    testname = "trigger_slot"

    pcf = PCF(dut, proj_path / f"../fabrics/{fabric}/constraints.pcf", lookup)
    pcf.write_gtkw(f"{testname}.gtkw", ["clk1", "a"])

    # Create a logger for this testbench
    logger = logging.getLogger("my_testbench")

    logger.info("Setting defaults...")

    # FPGA config mode
    # if mode == 0: SPI controller
    # if mode == 1: SPI receiver
    dut.fpga_mode_PAD.value = 0

    logger.info("Startup sequence...")

    # Start up
    await start_up(dut)

    logger.info("Running the test...")
    
    # Wait for done
    await FallingEdge(dut.fpga_config_busy_PAD)
    await ClockCycles(dut.fpga_clk_PAD, 1)

    assert pcf.get("a").to_unsigned() == LogicArray.from_unsigned(0, len(pcf.get("a")))

    # Wait for done
    await FallingEdge(dut.fpga_config_busy_PAD)
    await ClockCycles(dut.fpga_clk_PAD, 1)

    assert pcf.get("a").to_unsigned() == LogicArray.from_signed(-1, len(pcf.get("a")))

    # Wait for done
    await FallingEdge(dut.fpga_config_busy_PAD)
    await ClockCycles(dut.fpga_clk_PAD, 1)

    assert pcf.get("a").to_unsigned() == LogicArray.from_unsigned(0, len(pcf.get("a")))

    logger.info("Done!")


def chip_top_runner():
    sources = []
    defines = {"BITSTREAM_FLASH": True, "SIM": True}
    includes = [proj_path / "../src/"]

    sources.append(proj_path / "chip_top_tb.v")
    sources.append(proj_path / "spiflash_powered.v")

    # Set the LibreLane PDK/SCL/PAD defines
    defines[f"PDK_{pdk.replace('-','_')}"] = True
    defines[f"SCL_{scl}"] = True
    defines[f"PAD_{pad}"] = True

    if gl:
        # SCL models
        sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v")
        if scl != "gf180mcu_as_sc_mcu7t3v3":
            sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / "primitives.v")

        # We use the powered netlist
        sources.append(proj_path / f"../final/pnl/{hdl_toplevel}.pnl.v")

        defines.update({"FUNCTIONAL": True, "USE_POWER_PINS": True})
    else:
        sources.append(proj_path / "../src/double_wide_openframe_project_wrapper.v")
        sources.append(proj_path / "../src/chip_core.sv")

        sources.append(proj_path / "../src/fabric_wrapper.sv")
        
        sources.append(proj_path / "../ip/fabric_config/fabric_config.sv")
        sources.append(proj_path / "../ip/fabric_spi/fabric_spi_controller.sv")
        sources.append(proj_path / "../ip/fabric_spi/fabric_spi_receiver.sv")

        defines.update({"FUNCTIONAL": True, "USE_POWER_PINS": False})

    sources += [
        # IO pad models
        Path(pdk_root) / pdk / f"libs.ref/{pad}/verilog/{pad}.v",
        
        # ReRAM model
        proj_path / "../ip/sky130_bmlabs_reram/verilog/behavioral/sky130_bmlabs_reram__cim32x32.sv",
    ]
    
    # Tiles
    
    tiles_path = Path(proj_path / "../ip" / "fabulous-tiles")
    primitives_path = Path(tiles_path) / "primitives"
    tile_library_path = Path(tiles_path) / "tiles" / tile_library

    extra_tiles_path = Path(proj_path / "../ip" / "extra-tiles")
    extra_primitives_path = Path(extra_tiles_path) / "primitives"
    extra_tile_library_path = Path(extra_tiles_path) / "tiles" / tile_library

    primitives_files = list(primitives_path.glob('**/fabulous/*.v'))
    tile_files = list(tile_library_path.glob(f'**/macro/{pdk}/fabulous/*.v'))
    
    primitives_files += list(extra_primitives_path.glob('**/fabulous/*.v'))
    tile_files += list(extra_tile_library_path.glob(f'**/macro/{pdk}/fabulous/*.v'))

    sources.extend(primitives_files)
    sources.extend(tile_files)

    # Add models pack
    sources.append(tiles_path / "models_pack.v")

    # Add custom cells
    sources.append(tiles_path / "custom.v")

    # Add fabric netlist
    sources.append(proj_path / f'../fabrics/{fabric}/macro/{pdk}/fabulous/{fabric}.v')


    build_args = []

    if sim == "icarus":
        # For debugging
        # build_args = ["-Winfloop", "-pfileline=1"]
        pass

    if sim == "verilator":
        build_args = ["--timing", "--trace", "--trace-fst", "--trace-structs"]

    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel=tb_toplevel,
        defines=defines,
        always=True,
        includes=includes,
        build_args=build_args,
        waves=True,
    )

    plusargs = []

    if enabled["flash1_slot0"]:
        plusargs += [f'+flash1_slot0={enabled["flash1_slot0"]}']
    if enabled["flash1_slot1"]:
        plusargs += [f'+flash1_slot1={enabled["flash1_slot1"]}']

    runner.test(
        hdl_toplevel=tb_toplevel,
        test_module="chip_top_tb,",
        plusargs=plusargs,
        waves=True,
    )


if __name__ == "__main__":
    chip_top_runner()
