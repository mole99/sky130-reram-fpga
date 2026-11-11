// Copyright 2026 Leo Moser
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

(* blackbox, keep *)
module RERAM_CIM_32x32 #(
    parameter [15:0] TARGET_SET1      = '0,
    parameter [15:0] TARGET_SET2      = '0,
    parameter [15:0] TARGET_RESET1    = '0,
    parameter [15:0] TARGET_RESET2    = '0,
    parameter [ 9:0] NO_OF_CLK_CYCLES = '0,
    parameter [ 9:0] COUNTER_VALUE    = '0,
    parameter [ 6:0] TDC_TIME_OUT     = '0,
    parameter [ 1:0] TDC_DEAD_TIME    = '0
)(
    // Clock and reset
    (* clkbuf_sink *) input wire CLK,
    input wire RST,
    
    // Command interface
    input  wire         CMD_VALID,
    output wire         CMD_READY,
    input  wire         MODE0,
    input  wire         MODE1,
    input  wire         ROW_INDEX0,
    input  wire         ROW_INDEX1,
    input  wire         ROW_INDEX2,
    input  wire         ROW_INDEX3,
    input  wire         ROW_INDEX4,
    input  wire         COL_INDEX0,
    input  wire         COL_INDEX1,
    input  wire         COL_INDEX2,
    input  wire         COL_INDEX3,
    input  wire         COL_INDEX4,
    input  wire         PWM_DATA0,
    input  wire         PWM_DATA1,
    input  wire         PWM_DATA2,
    input  wire         PWM_DATA3,
    input  wire         PWM_DATA4,
    input  wire         PWM_DATA5,
    input  wire         PWM_DATA6,
    input  wire         PWM_DATA7,
    input  wire         COMPUTE_LAST,
    input  wire         COMPUTE_ALL_COLUMNS,

    // Status outputs
    output wire         BUSY,
    output wire         COMMAND_ACCEPTED,
    output wire         COMPUTE_PENDING,
    output wire         ERROR0,
    output wire         ERROR1,
    output wire         ERROR_VALID,
    output wire         OPERATION_DONE,
    output wire         PROGRAM_READBACK_ACTIVE,

    // Result interface
    output wire         RESULT_VALID,
    input  wire         RESULT_READY,
    output wire         RESULT_DATA0,
    output wire         RESULT_DATA1,
    output wire         RESULT_DATA2,
    output wire         RESULT_DATA3,
    output wire         RESULT_DATA4,
    output wire         RESULT_DATA5,
    output wire         RESULT_DATA6,
    output wire         RESULT_DATA7,
    output wire         RESULT_DATA8,
    output wire         RESULT_DATA9,
    output wire         RESULT_DATA10,
    output wire         RESULT_DATA11,
    output wire         RESULT_DATA12,
    output wire         RESULT_DATA13,
    output wire         RESULT_DATA14,
    output wire         RESULT_DATA15,
    output wire         RESULT_DATA16,
    output wire         RESULT_DATA17,
    output wire         RESULT_DATA18,
    output wire         RESULT_DATA19,
    output wire         RESULT_DATA20,
    output wire         RESULT_LAST
);

endmodule
