// SPDX-FileCopyrightText: © 2026 FABulous Contributors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module reram_cim_32x32 (
    input  wire       clk1,
    input  wire       rst,
    
    output [20:0] reram_output
);

    (* keep *)
    RERAM_CIM_32x32 #(
        .TARGET_SET1      (16'd0),
        .TARGET_SET2      (16'd0),
        .TARGET_RESET1    (16'd0),
        .TARGET_RESET2    (16'd0),
        .NO_OF_CLK_CYCLES (10'd0),
        .COUNTER_VALUE    (10'd0),
        .TDC_TIME_OUT     (6'd0),
        .TDC_DEAD_TIME    (2'd0)
    ) i_RERAM_CIM_32x32 (
        // Clock and reset
        .CLK  (clk1),
        .RST  (rst),
        
        // Command interface
        .CMD_VALID (1'b0),
        .CMD_READY (),
        .MODE0 (1'b0),
        .MODE1 (1'b0),
        .ROW_INDEX0 (1'b0),
        .ROW_INDEX1 (1'b0),
        .ROW_INDEX2 (1'b0),
        .ROW_INDEX3 (1'b0),
        .ROW_INDEX4 (1'b0),
        .COL_INDEX0 (1'b0),
        .COL_INDEX1 (1'b0),
        .COL_INDEX2 (1'b0),
        .COL_INDEX3 (1'b0),
        .COL_INDEX4 (1'b0),
        .PWM_DATA0 (1'b0),
        .PWM_DATA1 (1'b0),
        .PWM_DATA2 (1'b0),
        .PWM_DATA3 (1'b0),
        .PWM_DATA4 (1'b0),
        .PWM_DATA5 (1'b0),
        .PWM_DATA6 (1'b0),
        .PWM_DATA7 (1'b0),
        .COMPUTE_LAST (1'b0),
        .COMPUTE_ALL_COLUMNS (1'b0),

        // Status outputs
        .BUSY (),
        .COMMAND_ACCEPTED (),
        .COMPUTE_PENDING (),
        .ERROR0 (),
        .ERROR1 (),
        .ERROR_VALID (),
        .OPERATION_DONE (),
        .PROGRAM_READBACK_ACTIVE (),

        // Result interface
        .RESULT_VALID (),
        .RESULT_READY (1'b0),
        .RESULT_DATA0 (reram_output[0]),
        .RESULT_DATA1 (reram_output[1]),
        .RESULT_DATA2 (reram_output[2]),
        .RESULT_DATA3 (reram_output[3]),
        .RESULT_DATA4 (reram_output[4]),
        .RESULT_DATA5 (reram_output[5]),
        .RESULT_DATA6 (reram_output[6]),
        .RESULT_DATA7 (reram_output[7]),
        .RESULT_DATA8 (reram_output[8]),
        .RESULT_DATA9 (reram_output[9]),
        .RESULT_DATA10 (reram_output[10]),
        .RESULT_DATA11 (reram_output[11]),
        .RESULT_DATA12 (reram_output[12]),
        .RESULT_DATA13 (reram_output[13]),
        .RESULT_DATA14 (reram_output[14]),
        .RESULT_DATA15 (reram_output[15]),
        .RESULT_DATA16 (reram_output[16]),
        .RESULT_DATA17 (reram_output[17]),
        .RESULT_DATA18 (reram_output[18]),
        .RESULT_DATA19 (reram_output[19]),
        .RESULT_DATA20 (reram_output[20]),
        .RESULT_LAST   ()
    );

endmodule
