# Standalone simulations

These tests simulate a user design directly and do not instantiate, configure,
or verify the complete FPGA fabric.

## ReRAM direct-interface smoke test

Initialize the repository submodules first. The test compiles the authoritative
BM Labs behavioral model directly from
`ip/sky130_bmlabs_reram/verilog/behavioral/sky130_bmlabs_reram__cim32x32.sv`;
it does not keep a duplicate model under `tb/`.

```console
git submodule update --init --recursive
```

First synthesize the user design from the repository's root Nix shell:

```console
cd user_designs/designs/classic/reram_cim_32x32_direct_smoke
make synth
```

Then run the synthesized-design cocotb test:

```console
cd ../../../../tb/standalone
python3 reram_cim_32x32_direct_smoke.py
```

To run synthesis, place-and-route, bitstream generation, and hex conversion,
use the dedicated user-design shell from the repository root:

```console
cd user_designs
nix-shell --run 'cd designs/classic/reram_cim_32x32_direct_smoke && make all'
```

For a quicker pre-synthesis check of the same controller and behavioral model:

```console
DESIGN_VIEW=rtl python3 reram_cim_32x32_direct_smoke.py
```

The test sends one SET command to row 2, column 1, consumes and validates its
automatic readback, then does the same for RESET. It checks command/result
counts, response mode and column, pass/fail status, sticky completion, and reset.

The supplied controller originally used asynchronous reset. The integrated
copy uses synchronous reset because the FABulous logic-cell library cannot map
asynchronous-reset flip-flops.

The current FPGA primitive exposes `ERROR0` and `ERROR1`, while the BM Labs
behavioral model has a three-bit error code. This SET/RESET smoke test still
detects its relevant failures through `ERROR_VALID` and the two exposed bits,
but preserving every three-bit code (notably `3'b100` and `3'b101`) requires a
separate primitive/tile-interface update.



