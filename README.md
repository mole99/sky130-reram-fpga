# sky130 ReRAM FPGA

A FABulous FPGA with ReRAM primitives for CIM (Compute in Memory) in a double-wide OpenFrame padframe designed by Leo Moser.

This design was developed in collaboration with BM Labs, with the tapeout sponsored in part by ChipFoundry.

<div align="center">
  <table>
    <tr>
      <td align="center"><img src="img/logos/bm-lab-logo-white.jpg" alt="BM LABS Logo" width="200"/></td>
      <td align="center"><img src="img/logos/chip_foundry_logo.png" alt="ChipFoundry Logo" width="200"/></td>
    </tr>
  </table>
</div>

The FPGA fabric has the following primitives available:

|    Primitive    | Available |                          Description                         |
|:---------------:|:---------:|:------------------------------------------------------------:|
| FABULOUS_LC     | 2160      | Logic cell with LUT4+FF and carry-chain.                     |
| IOBUF           | 36        | Input/output buffer.                                         |
| RAM_32x4_2R_1W  | 36        | Memory with two read ports and one write port (32x4).        |
| RERAM_CIM_32x32 | 2         | CIM ReRAM primitives with 32x32 bits.                        |
| MACC_8x8_20     | 18        | Multiply accumulate (8-bit multiplication, 20-bit addition). |
| GBUF            | 4         | Global buffer to supply clock, reset and enable to the LCs.  |
| SYS_RESET       | 1         | Can be used to reset the design after configuration.         |

The RERAM_CIM_32x32 primitives are connected to the `sky130_bmlabs_reram__cim32x32` IPs from BM Labs.

The `classic_fabric_reram` FPGA fabric uses tiles from the [fabulous-tiles](https://github.com/mole99/fabulous-tiles) tile library and can be found under `fabrics/`
The fabric is implemented with LibreLane using the FABulous plugin for LibreLane: [librelane_plugin_fabulous](https://github.com/mole99/librelane_plugin_fabulous).
See below for more information about stitching the fabric. 

## Requirements

> [!NOTE]
> Make sure to clone the repository with submodules!
>
>```console
>git clone --recurse-submodules <url>.git
>```
> or initialize the submodules after cloning:
>
>```console
> git submodule update --init --recursive
>```

For information on installing Nix with the FOSSi Foundation cache, please refer to the LibreLane documentation: https://librelane.readthedocs.io/en/stable/installation/nix_installation/index.html

## Stitch the Fabric

As a prerequisite make sure that the tiles for the tile library that you are using have been implemented in `ip/fabulous-tiles`.
If that is the case, you can proceed by enabling a Nix shell with LibreLane in this repository:

```
nix-shell
```

In order to implement the FPGA fabric, run:

```
make classic_fabric_reram
```

After a fabrics has been implemented you can view it either in OpenROAD or KLayout by appending `-openroad` or `-klayout` to the fabric name.
For example, to view `classic_fabric_reram` in OpenROAD, run: `make classic_fabric_reram-openroad`.

Afterwards, you can copy the fabric files to the `user_design` directory.

```
make classic_fabric_reram-copy
```

## Implement the User Designs

Please see the README in `user_designs/` on how to implement the user designs for the fabric.

## Simulate the Fabric

After you have generated the bitstreams for the user designs you can simulate the fabric.
You will again need the Nix shell from the root of this repository.

Again, use `PDK`, `FABRIC` and `TILE_LIBRARY` accordingly.

There are two ways to simulate the fabric:

#### RTL "Emulation"

In this case, "emulation" means that we simulate the fabric, however, without uploading the bitstream.
The configuration bits of the fabric are already initialized with the user design bitstream.
This has the benefit that simulation is much faster: no need to upload the bitstream and the Verilog simulator can prune dead branches. However, the disadvantage is that only a single user design can be run per simulation.

To emulate a user design, simply set EMULATE to its name:

```
export EMULATE=counter
```

Then, run the simulation using cocotb:

```
cd tb; python3 fabric_tb.py
```

#### RTL Simulation

To start the RTL simulation, simply run cocotb:

```
cd tb; python3 fabric_tb.py
```

And it will run all available test cases for the selected fabric and tile library.

## Copyright & License

© 2026 Leo Moser

Apache License, version 2.0.
