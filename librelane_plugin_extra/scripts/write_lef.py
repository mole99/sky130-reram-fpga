# SPDX-FileCopyrightText: © 2026 Leo Moser <leo.moser@pm.me>
# SPDX-License-Identifier: Apache-2.0

import pya
import click

@click.command()
@click.argument(
    "input",
    type=click.Path(exists=True, file_okay=True, dir_okay=False),
)
@click.argument(
    "output",
    type=click.Path(exists=False, file_okay=True, dir_okay=False),
)
def write_lef(
    input: str,
    output: str,
):

    layout = pya.Layout()
    layout.read(input)
    
    top = "classic_fabric_reram"
    origin = (0, 0)
    size = (4216.360, 4128.960)
    foreign = top
    
    layers = ["li", "met1", "met2", "met3", "met4", "met5"]
    
    pins = [
        {
            "name": "FrameData[0]",
            "direction": "INPUT",
            "use": "SIGNAL",
            "antennagatearea": 0.159,
            "ports": [
                {
                    "layer": "met3",
                    "rect": (0.000, 4078.680, 0.600, 4079.280),
                }
            ]
        }
    ]
    
    with open(output, "w") as ofile:
        # Header
        ofile.write(f"""VERSION 5.7 ;
  NOWIREEXTENSIONATPIN ON ;
  DIVIDERCHAR "/" ;
  BUSBITCHARS "[]" ;
MACRO {top}
  CLASS BLOCK ;
  FOREIGN {foreign} ;
  ORIGIN {origin[0]:.3f} {origin[1]:.3f} ;
  SIZE {size[0]:.3f} BY {size[1]:.3f} ;\n""")
 
        # Pins
        for pin in pins:
            ofile.write(f"""  PIN {pin['name']}
    DIRECTION {pin['direction']} ;
    USE {pin['use']} ;
    ANTENNAGATEAREA {pin['antennagatearea']:.6f} ;\n""")
 
            for port in pin['ports']:
                        ofile.write(f"""    PORT
      LAYER {port['layer']} ;
        RECT {port['rect'][0]:.3f} {port['rect'][1]:.3f} {port['rect'][2]:.3f} {port['rect'][3]:.3f} ;
    END\n""")
 
            ofile.write(f"""  END {pin['name']}\n""")
 
        # Obstructions
        ofile.write(f"""  OBS\n""")
 
        for layer in layers:
            ofile.write(f"""      LAYER {layer} ;
        RECT {origin[0]:.3f} {origin[1]:.3f} {size[0]:.3f} {size[1]:.3f} ;\n""")
 
        ofile.write(f"""  END\n""")
 
        ofile.write(f"""END {top}
END LIBRARY\n""")

if __name__ == "__main__":
    write_lef()
