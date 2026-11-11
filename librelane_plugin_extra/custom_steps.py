import io
import os
import sys
import yaml
import pathlib
import textwrap
from glob import glob
from decimal import Decimal
from typing import Callable, List, Literal, Mapping, Tuple, Union, Optional, Dict, Any
from librelane.steps import Step, OdbpyStep, OpenROADStep
from librelane.steps.klayout import KLayoutStep
from librelane.steps.step import (
    ViewsUpdate,
    MetricsUpdate,
)
from librelane.steps.common_variables import io_layer_variables
from librelane.flows import Flow, FlowError
from librelane.state import DesignFormat, State
from librelane.common import Path, aggregate_metrics
from librelane.config import Variable
from librelane.logging import (
    verbose,
    debug,
    info,
    rule,
    success,
    warn,
    err,
    subprocess,
)
from librelane.steps import (
    Yosys,
    OpenROAD,
    Magic,
    KLayout,
    Odb,
    Netgen,
    Checker,
    Verilator,
    Misc,
)

DesignFormat(
    "oas",
    "oas",
    "OASIS Stream",
    alts=["OASIS"],
    multiple=True,
).register()


@Step.factory.register()
class WriteLEF(KLayoutStep):
    """
    Writes LEF from GDS.
    """

    id = "KLayout.WriteLEF"
    name = "Write LEF"
    long_name = "Writes LEF from GDS using KLayout"

    inputs = [
        DesignFormat.GDS,
    ]
    outputs = [
        DesignFormat.LEF
    ]

    def run(self, state_in: State, **kwargs) -> Tuple[ViewsUpdate, MetricsUpdate]:
        views_updates: ViewsUpdate = {}

        gds_in = state_in[DesignFormat.GDS]
        lef_out = os.path.join(
            self.step_dir,
            f"{self.config['DESIGN_NAME']}.{DesignFormat.LEF.extension}",
        )
        
        script = os.path.join(os.path.dirname(__file__), "scripts", "write_lef.py")

        self.run_pya_script(
            [
                sys.executable,
                script,
                gds_in,
                lef_out,
            ]
        )

        views_updates[DesignFormat.LEF] = Path(lef_out)

        return views_updates, {}


@Step.factory.register()
class ConvertOASIS(KLayoutStep):
    """
    Convert GDS to OASIS.
    """

    id = "KLayout.ConvertOASIS"
    name = "Convert OASIS"
    long_name = "Convert GDS to OASIS using KLayout"

    inputs = [
        DesignFormat.GDS,
    ]
    outputs = [
        DesignFormat.OASIS
    ]

    def run(self, state_in: State, **kwargs) -> Tuple[ViewsUpdate, MetricsUpdate]:
        views_updates: ViewsUpdate = {}

        gds_in = state_in[DesignFormat.GDS]
        oas_out = os.path.join(
            self.step_dir,
            f"{self.config['DESIGN_NAME']}.{DesignFormat.OASIS.extension}",
        )
        
        script = os.path.join(os.path.dirname(__file__), "scripts", "convert_oasis.py")

        self.run_pya_script(
            [
                sys.executable,
                script,
                gds_in,
                oas_out,
            ]
        )

        views_updates[DesignFormat.OASIS] = Path(oas_out)

        return views_updates, {}
