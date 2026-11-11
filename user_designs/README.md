# User Designs

User designs are Verilog designs that run on the FPGA fabric.

## Requirements

Follow the installation instructions for Nix at LibreLane: https://librelane.readthedocs.io/en/stable/installation/nix_installation/index.html
This installs Nix and enables the FOSSi Foundation Nix cache.

Now, enable a Nix shell with Yosys and nextpnr:

```
nix-shell
```

## Implement the Designs

The user designs for both fabric families can be found under `user_designs/designs/`.

To build all user designs, run:

```
make all
```

To build individual user designs, select by name:

```
make counter
```

The following Make targets are available:

```
make counter-clean
make counter-synth
make counter-pnr
make counter-bit
make counter-hex
```

You can also enter the individual design directories and run make from there:

```
Commands:
 synth           ... Synthesize the user design
 pnr             ... Run Place and Route
 bitstream       ... Generate the bitstream
 clean           ... Delete all generated files
 help            ... Show this help message
```
