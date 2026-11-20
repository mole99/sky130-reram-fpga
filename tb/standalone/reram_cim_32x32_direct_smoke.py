# SPDX-FileCopyrightText: © 2026 BM Labs
# SPDX-License-Identifier: Apache-2.0

"""Standalone cocotb test for the ReRAM direct-interface smoke controller.

DESIGN_VIEW=synth (default) simulates the FABulous-synthesized user design.
DESIGN_VIEW=rtl simulates the same synthesizable sources before synthesis.
Neither mode instantiates or configures the complete FPGA fabric.
"""

import os
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge
from cocotb_tools.runner import get_runner


TEST_NAME = "reram_cim_32x32_direct_smoke"
THIS_DIR = Path(__file__).resolve().parent
REPO_ROOT = THIS_DIR.parents[1]
DESIGN_DIR = (
    REPO_ROOT / "user_designs" / "designs" / "classic" / TEST_NAME
)
MODEL_DIR = REPO_ROOT / "tb" / "models"
RERAM_BEHAVIORAL_MODEL = (
    REPO_ROOT
    / "ip"
    / "sky130_bmlabs_reram"
    / "verilog"
    / "behavioral"
    / "sky130_bmlabs_reram__cim32x32.sv"
)


def simulation_sources(design_view: str) -> list[Path]:
    sources: list[Path] = [
        RERAM_BEHAVIORAL_MODEL,
        MODEL_DIR / "RERAM_CIM_32x32_sim.sv",
    ]

    if design_view == "rtl":
        sources.extend(
            [
                DESIGN_DIR
                / "sky130_bmlabs_reram__cim32x32_direct_smoke_controller.sv",
                DESIGN_DIR / f"{TEST_NAME}.sv",
            ]
        )
    elif design_view == "synth":
        # The synthesized netlist contains FABulous logic-cell instances.  Use
        # the tile-library simulation definitions, but replace the black-box
        # ReRAM primitive with RERAM_CIM_32x32_sim.sv above.
        primitive_root = REPO_ROOT / "ip" / "fabulous-tiles" / "primitives"
        sources.extend(
            sorted(primitive_root.glob("**/yosys/primitives/*.v"))
        )
        sources.append(DESIGN_DIR / f"{TEST_NAME}_synth.v")
    else:
        raise ValueError(
            f"Unsupported DESIGN_VIEW={design_view!r}; use 'rtl' or 'synth'"
        )

    missing = [str(path) for path in sources if not path.is_file()]
    if missing:
        missing_text = "\n  ".join(missing)
        raise FileNotFoundError(
            "Required simulation files are missing:\n  " + missing_text
        )
    return sources


if __name__ == "__main__":
    simulator = os.getenv("SIM", "icarus")
    design_view = os.getenv("DESIGN_VIEW", "synth").lower()
    sources = simulation_sources(design_view)

    print(f"Simulating {TEST_NAME} ({design_view} view) with {simulator}")
    print("Sources:")
    for source in sources:
        print(f"  {source}")

    runner = get_runner(simulator)
    runner.build(
        sources=sources,
        hdl_toplevel=TEST_NAME,
        always=True,
        clean=True,
        timescale=("1ns", "1ps"),
        waves=True,
        build_args=["-g2012"] if simulator == "icarus" else [],
        build_dir=THIS_DIR / "sim_build" / f"{TEST_NAME}_{design_view}",
    )
    runner.test(
        hdl_toplevel=TEST_NAME,
        test_module=Path(__file__).stem,
        plusargs=["-fst"] if simulator == "icarus" else [],
        waves=True,
        test_dir=THIS_DIR,
    )


@cocotb.test()
async def test_set_reset_automatic_readback(dut):
    """Run SET/readback then RESET/readback and check controller status."""

    cocotb.start_soon(Clock(dut.clk1, 10, unit="ns").start())

    dut.rst.value = 1
    dut.start.value = 0
    await ClockCycles(dut.clk1, 10)

    dut.rst.value = 0
    await ClockCycles(dut.clk1, 5)

    # The controller includes a two-flop input synchronizer.  A two-cycle
    # pulse guarantees one clean synchronized rising edge.
    dut.start.value = 1
    await ClockCycles(dut.clk1, 2)
    dut.start.value = 0

    busy_seen = False
    for _ in range(5000):
        await RisingEdge(dut.clk1)
        busy_seen |= int(dut.busy.value) == 1
        if int(dut.done.value) == 1:
            break
    else:
        raise AssertionError("Controller did not finish within 5000 cycles")

    status = {
        "pass": int(getattr(dut, "pass").value),
        "fail": int(dut.fail.value),
        "failure_code": int(dut.failure_code.value),
        "accepted_count": int(dut.accepted_count.value),
        "result_count": int(dut.result_count.value),
        "set_mode": int(dut.set_result_mode.value),
        "set_column": int(dut.set_result_column.value),
        "reset_mode": int(dut.reset_result_mode.value),
        "reset_column": int(dut.reset_result_column.value),
    }

    # The RTL hierarchy retains the controller's complete 21-bit captures.
    # The synthesized top intentionally exposes only mode and column to keep
    # this FPGA test harness within the available I/O count.
    controller = getattr(dut, "i_controller", None)
    if controller is not None:
        status["set_raw"] = int(controller.set_auto_result_o.value)
        status["reset_raw"] = int(controller.reset_auto_result_o.value)
        status["set_count"] = status["set_raw"] & 0x3FFF
        status["reset_count"] = status["reset_raw"] & 0x3FFF
    dut._log.info("Completed direct ReRAM smoke sequence: %s", status)

    assert busy_seen, "busy never asserted"
    assert status["pass"] == 1
    assert status["fail"] == 0
    assert status["failure_code"] == 0
    assert status["accepted_count"] == 2
    assert status["result_count"] == 2
    assert status["set_mode"] == 0b11
    assert status["set_column"] == 1
    assert status["reset_mode"] == 0b00
    assert status["reset_column"] == 1

    # Completion status is intentionally sticky until reset.
    await ClockCycles(dut.clk1, 3)
    assert int(dut.done.value) == 1
    assert int(getattr(dut, "pass").value) == 1

    dut.rst.value = 1
    await ClockCycles(dut.clk1, 2)
    assert int(dut.done.value) == 0
    assert int(getattr(dut, "pass").value) == 0
    assert int(dut.fail.value) == 0



