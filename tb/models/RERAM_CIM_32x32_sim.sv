// SPDX-FileCopyrightText: © 2026 BM Labs
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none

// Simulation implementation of Leo Moser's scalar RERAM_CIM_32x32 FPGA
// primitive.  It translates the scalar FABulous primitive boundary into the
// vector native/direct boundary of the BM Labs behavioral model.
module RERAM_CIM_32x32 #(
    parameter [15:0] TARGET_SET1       = '0,
    parameter [15:0] TARGET_SET2       = '0,
    parameter [15:0] TARGET_RESET1     = '0,
    parameter [15:0] TARGET_RESET2     = '0,
    parameter [ 9:0] NO_OF_CLK_CYCLES = '0,
    parameter [ 9:0] COUNTER_VALUE     = '0,
    parameter [ 6:0] TDC_TIME_OUT      = '0,
    parameter [ 1:0] TDC_DEAD_TIME     = '0
)(
    input  wire CLK,
    input  wire RST,
    input  wire CMD_VALID,
    output wire CMD_READY,
    input  wire MODE0,
    input  wire MODE1,
    input  wire ROW_INDEX0,
    input  wire ROW_INDEX1,
    input  wire ROW_INDEX2,
    input  wire ROW_INDEX3,
    input  wire ROW_INDEX4,
    input  wire COL_INDEX0,
    input  wire COL_INDEX1,
    input  wire COL_INDEX2,
    input  wire COL_INDEX3,
    input  wire COL_INDEX4,
    input  wire PWM_DATA0,
    input  wire PWM_DATA1,
    input  wire PWM_DATA2,
    input  wire PWM_DATA3,
    input  wire PWM_DATA4,
    input  wire PWM_DATA5,
    input  wire PWM_DATA6,
    input  wire PWM_DATA7,
    input  wire COMPUTE_LAST,
    input  wire COMPUTE_ALL_COLUMNS,
    output wire BUSY,
    output wire COMMAND_ACCEPTED,
    output wire COMPUTE_PENDING,
    output wire ERROR0,
    output wire ERROR1,
    output wire ERROR_VALID,
    output wire OPERATION_DONE,
    output wire PROGRAM_READBACK_ACTIVE,
    output wire RESULT_VALID,
    input  wire RESULT_READY,
    output wire RESULT_DATA0,
    output wire RESULT_DATA1,
    output wire RESULT_DATA2,
    output wire RESULT_DATA3,
    output wire RESULT_DATA4,
    output wire RESULT_DATA5,
    output wire RESULT_DATA6,
    output wire RESULT_DATA7,
    output wire RESULT_DATA8,
    output wire RESULT_DATA9,
    output wire RESULT_DATA10,
    output wire RESULT_DATA11,
    output wire RESULT_DATA12,
    output wire RESULT_DATA13,
    output wire RESULT_DATA14,
    output wire RESULT_DATA15,
    output wire RESULT_DATA16,
    output wire RESULT_DATA17,
    output wire RESULT_DATA18,
    output wire RESULT_DATA19,
    output wire RESULT_DATA20,
    output wire RESULT_LAST
);

    wire [2:0]  error;
    wire [20:0] result_data;
    tri Iref;
    tri Vcc_read;
    tri Vcomp;
    tri Bias_comp2;
    tri Vcc_wl_read;
    tri Vcc_wl_set;
    tri Vbias;
    tri Vcc_wl_reset;
    tri Vcc_set;
    tri VCC_SNEAK;
    tri dc_bias;

    sky130_bmlabs_reram__cim32x32 i_behavioral_model (
        .interface_sel                 (1'b0),
        .i_Levelsh_enable              (1'b0),
        .clk_i                         (CLK),
        .rst_i                         (RST),
        .i_cmd_valid                   (CMD_VALID),
        .o_cmd_ready                   (CMD_READY),
        .i_mode                        ({MODE1, MODE0}),
        .i_row_index                   ({ROW_INDEX4, ROW_INDEX3, ROW_INDEX2,
                                         ROW_INDEX1, ROW_INDEX0}),
        .i_col_index                   ({COL_INDEX4, COL_INDEX3, COL_INDEX2,
                                         COL_INDEX1, COL_INDEX0}),
        .i_pwm_data                    ({PWM_DATA7, PWM_DATA6, PWM_DATA5,
                                         PWM_DATA4, PWM_DATA3, PWM_DATA2,
                                         PWM_DATA1, PWM_DATA0}),
        .i_compute_last                (COMPUTE_LAST),
        .i_compute_all_columns         (COMPUTE_ALL_COLUMNS),
        .i_target_set1                 (TARGET_SET1),
        .i_target_set2                 (TARGET_SET2),
        .i_target_reset1               (TARGET_RESET1),
        .i_target_reset2               (TARGET_RESET2),
        .i_no_of_clk_cycles            (NO_OF_CLK_CYCLES),
        .i_counter_value               (COUNTER_VALUE),
        .i_tdc_time_out                (TDC_TIME_OUT),
        .i_tdc_dead_time               (TDC_DEAD_TIME),
        .o_busy                        (BUSY),
        .o_command_accepted            (COMMAND_ACCEPTED),
        .o_compute_pending             (COMPUTE_PENDING),
        .o_error                       (error),
        .o_error_valid                 (ERROR_VALID),
        .o_operation_done              (OPERATION_DONE),
        .o_program_readback_active     (PROGRAM_READBACK_ACTIVE),
        .o_result_valid                (RESULT_VALID),
        .i_result_ready                (RESULT_READY),
        .o_result_data                 (result_data),
        .o_result_last                 (RESULT_LAST),
        .wbs_stb_i                     (1'b0),
        .wbs_cyc_i                     (1'b0),
        .wbs_we_i                      (1'b0),
        .wbs_sel_i                     (4'b0),
        .wbs_dat_i                     (32'b0),
        .wbs_adr_i                     (32'b0),
        .wbs_dat_o                     (),
        .wbs_ack_o                     (),
        .stop_bit_i                    (32'b0),
        .ScanInCC                      (1'b0),
        .ScanInDL                      (1'b0),
        .ScanInDR                      (1'b1),
        .ScanOutCC                     (),
        .TM                            (1'b0),
        .Iref                          (Iref),
        .Vcc_read                      (Vcc_read),
        .Vcomp                         (Vcomp),
        .Bias_comp2                    (Bias_comp2),
        .Vcc_wl_read                   (Vcc_wl_read),
        .Vcc_wl_set                    (Vcc_wl_set),
        .Vbias                         (Vbias),
        .Vcc_wl_reset                  (Vcc_wl_reset),
        .Vcc_set                       (Vcc_set),
        .VCC_SNEAK                     (VCC_SNEAK),
        .dc_bias                       (dc_bias)
    );

    assign ERROR0 = error[0];
    assign ERROR1 = error[1];
    assign {RESULT_DATA20, RESULT_DATA19, RESULT_DATA18, RESULT_DATA17,
            RESULT_DATA16, RESULT_DATA15, RESULT_DATA14, RESULT_DATA13,
            RESULT_DATA12, RESULT_DATA11, RESULT_DATA10, RESULT_DATA9,
            RESULT_DATA8, RESULT_DATA7, RESULT_DATA6, RESULT_DATA5,
            RESULT_DATA4, RESULT_DATA3, RESULT_DATA2, RESULT_DATA1,
            RESULT_DATA0} = result_data;

endmodule

`default_nettype wire



