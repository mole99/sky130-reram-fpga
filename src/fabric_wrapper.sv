`default_nettype none

module fabric_wrapper #(
    parameter FRAME_BITS_PER_ROW = 32,
    parameter MAX_FRAMES_PER_COL = 20,
    
    parameter FABRIC_NUM_COLUMNS = 21,
    parameter FABRIC_NUM_ROWS = 20,
    
    parameter FABRIC_NUM_IO_WEST = (FABRIC_NUM_ROWS-2)*2
)(
    // Configuration
    input  logic [(FRAME_BITS_PER_ROW*FABRIC_NUM_ROWS)-1:0]    frame_data_i,
    input  logic [(MAX_FRAMES_PER_COL*FABRIC_NUM_COLUMNS)-1:0] frame_strobe_i,

    // Fabric is configured
    input                                configured_i,
    input                                sys_reset_i,

    // I/Os West
    input  [FABRIC_NUM_IO_WEST-1:0]      io_west_in_i,
    output [FABRIC_NUM_IO_WEST-1:0]      io_west_out_o,
    output [FABRIC_NUM_IO_WEST-1:0]      io_west_oe_o
);

    // Clock and reset
    wire         RERAM0_CLK;
    wire         RERAM0_RST;
    
    // Command interface
    wire         RERAM0_CMD_VALID;
    wire         RERAM0_CMD_READY;
    wire [1:0]   RERAM0_MODE;
    wire [4:0]   RERAM0_ROW_INDEX;
    wire [4:0]   RERAM0_COL_INDEX;
    wire [7:0]   RERAM0_PWM_DATA;
    wire         RERAM0_COMPUTE_LAST;
    wire         RERAM0_COMPUTE_ALL_COLUMNS;

    // Configuration inputs
    wire [15:0]  RERAM0_TARGET_SET1;
    wire [15:0]  RERAM0_TARGET_SET2;
    wire [15:0]  RERAM0_TARGET_RESET1;
    wire [15:0]  RERAM0_TARGET_RESET2;
    wire [9:0]   RERAM0_NO_OF_CLK_CYCLES;
    wire [9:0]   RERAM0_COUNTER_VALUE;
    wire [6:0]   RERAM0_TDC_TIME_OUT;
    wire [1:0]   RERAM0_TDC_DEAD_TIME;

    // Status outputs
    wire         RERAM0_BUSY;
    wire         RERAM0_COMMAND_ACCEPTED;
    wire         RERAM0_COMPUTE_PENDING;
    wire [2:0]   RERAM0_ERROR;
    wire         RERAM0_ERROR_VALID;
    wire         RERAM0_OPERATION_DONE;
    wire         RERAM0_PROGRAM_READBACK_ACTIVE;

    // Result interface
    wire         RERAM0_RESULT_VALID;
    wire         RERAM0_RESULT_READY;
    wire [20:0]  RERAM0_RESULT_DATA;
    wire         RERAM0_RESULT_LAST;

    // Clock and reset
    wire         RERAM1_CLK;
    wire         RERAM1_RST;
    
    // Command interface
    wire         RERAM1_CMD_VALID;
    wire         RERAM1_CMD_READY;
    wire [1:0]   RERAM1_MODE;
    wire [4:0]   RERAM1_ROW_INDEX;
    wire [4:0]   RERAM1_COL_INDEX;
    wire [7:0]   RERAM1_PWM_DATA;
    wire         RERAM1_COMPUTE_LAST;
    wire         RERAM1_COMPUTE_ALL_COLUMNS;

    // Configuration inputs
    wire [15:0]  RERAM1_TARGET_SET1;
    wire [15:0]  RERAM1_TARGET_SET2;
    wire [15:0]  RERAM1_TARGET_RESET1;
    wire [15:0]  RERAM1_TARGET_RESET2;
    wire [9:0]   RERAM1_NO_OF_CLK_CYCLES;
    wire [9:0]   RERAM1_COUNTER_VALUE;
    wire [6:0]   RERAM1_TDC_TIME_OUT;
    wire [1:0]   RERAM1_TDC_DEAD_TIME;

    // Status outputs
    wire         RERAM1_BUSY;
    wire         RERAM1_COMMAND_ACCEPTED;
    wire         RERAM1_COMPUTE_PENDING;
    wire [2:0]   RERAM1_ERROR;
    wire         RERAM1_ERROR_VALID;
    wire         RERAM1_OPERATION_DONE;
    wire         RERAM1_PROGRAM_READBACK_ACTIVE;

    // Result interface
    wire         RERAM1_RESULT_VALID;
    wire         RERAM1_RESULT_READY;
    wire [20:0]  RERAM1_RESULT_DATA;
    wire         RERAM1_RESULT_LAST;

    (* keep *) classic_fabric_reram classic_fabric_reram
    (
        .FrameData      (frame_data_i),
        .FrameStrobe    (frame_strobe_i),

        // I/Os
        .Tile_X0Y1_A_OUT_top  (io_west_in_i[0]),
        .Tile_X0Y1_A_IN_top   (io_west_out_o[0]),
        .Tile_X0Y1_A_EN_top   (io_west_oe_o[0]),

        .Tile_X0Y1_B_OUT_top  (io_west_in_i[1]),
        .Tile_X0Y1_B_IN_top   (io_west_out_o[1]),
        .Tile_X0Y1_B_EN_top   (io_west_oe_o[1]),

        .Tile_X0Y2_A_OUT_top  (io_west_in_i[2]),
        .Tile_X0Y2_A_IN_top   (io_west_out_o[2]),
        .Tile_X0Y2_A_EN_top   (io_west_oe_o[2]),

        .Tile_X0Y2_B_OUT_top  (io_west_in_i[3]),
        .Tile_X0Y2_B_IN_top   (io_west_out_o[3]),
        .Tile_X0Y2_B_EN_top   (io_west_oe_o[3]),

        .Tile_X0Y3_A_OUT_top  (io_west_in_i[4]),
        .Tile_X0Y3_A_IN_top   (io_west_out_o[4]),
        .Tile_X0Y3_A_EN_top   (io_west_oe_o[4]),

        .Tile_X0Y3_B_OUT_top  (io_west_in_i[5]),
        .Tile_X0Y3_B_IN_top   (io_west_out_o[5]),
        .Tile_X0Y3_B_EN_top   (io_west_oe_o[5]),

        .Tile_X0Y4_A_OUT_top  (io_west_in_i[6]),
        .Tile_X0Y4_A_IN_top   (io_west_out_o[6]),
        .Tile_X0Y4_A_EN_top   (io_west_oe_o[6]),

        .Tile_X0Y4_B_OUT_top  (io_west_in_i[7]),
        .Tile_X0Y4_B_IN_top   (io_west_out_o[7]),
        .Tile_X0Y4_B_EN_top   (io_west_oe_o[7]),

        .Tile_X0Y5_A_OUT_top  (io_west_in_i[8]),
        .Tile_X0Y5_A_IN_top   (io_west_out_o[8]),
        .Tile_X0Y5_A_EN_top   (io_west_oe_o[8]),

        .Tile_X0Y5_B_OUT_top  (io_west_in_i[9]),
        .Tile_X0Y5_B_IN_top   (io_west_out_o[9]),
        .Tile_X0Y5_B_EN_top   (io_west_oe_o[9]),

        .Tile_X0Y6_A_OUT_top  (io_west_in_i[10]),
        .Tile_X0Y6_A_IN_top   (io_west_out_o[10]),
        .Tile_X0Y6_A_EN_top   (io_west_oe_o[10]),

        .Tile_X0Y6_B_OUT_top  (io_west_in_i[11]),
        .Tile_X0Y6_B_IN_top   (io_west_out_o[11]),
        .Tile_X0Y6_B_EN_top   (io_west_oe_o[11]),

        .Tile_X0Y7_A_OUT_top  (io_west_in_i[12]),
        .Tile_X0Y7_A_IN_top   (io_west_out_o[12]),
        .Tile_X0Y7_A_EN_top   (io_west_oe_o[12]),

        .Tile_X0Y7_B_OUT_top  (io_west_in_i[13]),
        .Tile_X0Y7_B_IN_top   (io_west_out_o[13]),
        .Tile_X0Y7_B_EN_top   (io_west_oe_o[13]),

        .Tile_X0Y8_A_OUT_top  (io_west_in_i[14]),
        .Tile_X0Y8_A_IN_top   (io_west_out_o[14]),
        .Tile_X0Y8_A_EN_top   (io_west_oe_o[14]),

        .Tile_X0Y8_B_OUT_top  (io_west_in_i[15]),
        .Tile_X0Y8_B_IN_top   (io_west_out_o[15]),
        .Tile_X0Y8_B_EN_top   (io_west_oe_o[15]),

        .Tile_X0Y9_A_OUT_top  (io_west_in_i[16]),
        .Tile_X0Y9_A_IN_top   (io_west_out_o[16]),
        .Tile_X0Y9_A_EN_top   (io_west_oe_o[16]),

        .Tile_X0Y9_B_OUT_top  (io_west_in_i[17]),
        .Tile_X0Y9_B_IN_top   (io_west_out_o[17]),
        .Tile_X0Y9_B_EN_top   (io_west_oe_o[17]),

        .Tile_X0Y10_A_OUT_top  (io_west_in_i[18]),
        .Tile_X0Y10_A_IN_top   (io_west_out_o[18]),
        .Tile_X0Y10_A_EN_top   (io_west_oe_o[18]),

        .Tile_X0Y10_B_OUT_top  (io_west_in_i[19]),
        .Tile_X0Y10_B_IN_top   (io_west_out_o[19]),
        .Tile_X0Y10_B_EN_top   (io_west_oe_o[19]),

        .Tile_X0Y11_A_OUT_top  (io_west_in_i[20]),
        .Tile_X0Y11_A_IN_top   (io_west_out_o[20]),
        .Tile_X0Y11_A_EN_top   (io_west_oe_o[20]),

        .Tile_X0Y11_B_OUT_top  (io_west_in_i[21]),
        .Tile_X0Y11_B_IN_top   (io_west_out_o[21]),
        .Tile_X0Y11_B_EN_top   (io_west_oe_o[21]),

        .Tile_X0Y12_A_OUT_top  (io_west_in_i[22]),
        .Tile_X0Y12_A_IN_top   (io_west_out_o[22]),
        .Tile_X0Y12_A_EN_top   (io_west_oe_o[22]),

        .Tile_X0Y12_B_OUT_top  (io_west_in_i[23]),
        .Tile_X0Y12_B_IN_top   (io_west_out_o[23]),
        .Tile_X0Y12_B_EN_top   (io_west_oe_o[23]),

        .Tile_X0Y13_A_OUT_top  (io_west_in_i[24]),
        .Tile_X0Y13_A_IN_top   (io_west_out_o[24]),
        .Tile_X0Y13_A_EN_top   (io_west_oe_o[24]),

        .Tile_X0Y13_B_OUT_top  (io_west_in_i[25]),
        .Tile_X0Y13_B_IN_top   (io_west_out_o[25]),
        .Tile_X0Y13_B_EN_top   (io_west_oe_o[25]),

        .Tile_X0Y14_A_OUT_top  (io_west_in_i[26]),
        .Tile_X0Y14_A_IN_top   (io_west_out_o[26]),
        .Tile_X0Y14_A_EN_top   (io_west_oe_o[26]),

        .Tile_X0Y14_B_OUT_top  (io_west_in_i[27]),
        .Tile_X0Y14_B_IN_top   (io_west_out_o[27]),
        .Tile_X0Y14_B_EN_top   (io_west_oe_o[27]),

        .Tile_X0Y15_A_OUT_top  (io_west_in_i[28]),
        .Tile_X0Y15_A_IN_top   (io_west_out_o[28]),
        .Tile_X0Y15_A_EN_top   (io_west_oe_o[28]),

        .Tile_X0Y15_B_OUT_top  (io_west_in_i[29]),
        .Tile_X0Y15_B_IN_top   (io_west_out_o[29]),
        .Tile_X0Y15_B_EN_top   (io_west_oe_o[29]),

        .Tile_X0Y16_A_OUT_top  (io_west_in_i[30]),
        .Tile_X0Y16_A_IN_top   (io_west_out_o[30]),
        .Tile_X0Y16_A_EN_top   (io_west_oe_o[30]),

        .Tile_X0Y16_B_OUT_top  (io_west_in_i[31]),
        .Tile_X0Y16_B_IN_top   (io_west_out_o[31]),
        .Tile_X0Y16_B_EN_top   (io_west_oe_o[31]),

        .Tile_X0Y17_A_OUT_top  (io_west_in_i[32]),
        .Tile_X0Y17_A_IN_top   (io_west_out_o[32]),
        .Tile_X0Y17_A_EN_top   (io_west_oe_o[32]),

        .Tile_X0Y17_B_OUT_top  (io_west_in_i[33]),
        .Tile_X0Y17_B_IN_top   (io_west_out_o[33]),
        .Tile_X0Y17_B_EN_top   (io_west_oe_o[33]),

        .Tile_X0Y18_A_OUT_top  (io_west_in_i[34]),
        .Tile_X0Y18_A_IN_top   (io_west_out_o[34]),
        .Tile_X0Y18_A_EN_top   (io_west_oe_o[34]),

        .Tile_X0Y18_B_OUT_top  (io_west_in_i[35]),
        .Tile_X0Y18_B_IN_top   (io_west_out_o[35]),
        .Tile_X0Y18_B_EN_top   (io_west_oe_o[35]),
        
        // RERAM_CIM_32x32
        .Tile_X20Y6_EXT_CMD_READY (RERAM0_CMD_READY),
        .Tile_X20Y6_EXT_BUSY (RERAM0_BUSY),
        .Tile_X20Y6_EXT_COMMAND_ACCEPTED (RERAM0_COMMAND_ACCEPTED),
        .Tile_X20Y6_EXT_COMPUTE_PENDING (RERAM0_COMPUTE_PENDING),
        .Tile_X20Y6_EXT_ERROR0 (RERAM0_ERROR[0]),
        .Tile_X20Y6_EXT_ERROR1 (RERAM0_ERROR[1]),
        .Tile_X20Y6_EXT_ERROR2 (RERAM0_ERROR[2]),
        .Tile_X20Y6_EXT_ERROR_VALID (RERAM0_ERROR_VALID),
        .Tile_X20Y6_EXT_OPERATION_DONE (RERAM0_OPERATION_DONE),
        .Tile_X20Y6_EXT_PROGRAM_READBACK_ACTIVE (RERAM0_PROGRAM_READBACK_ACTIVE),
        .Tile_X20Y6_EXT_RESULT_VALID (RERAM0_RESULT_VALID),
        .Tile_X20Y6_EXT_RESULT_DATA0 (RERAM0_RESULT_DATA[0]),
        .Tile_X20Y6_EXT_RESULT_DATA1 (RERAM0_RESULT_DATA[1]),
        .Tile_X20Y6_EXT_RESULT_DATA2 (RERAM0_RESULT_DATA[2]),
        .Tile_X20Y6_EXT_RESULT_DATA3 (RERAM0_RESULT_DATA[3]),
        .Tile_X20Y6_EXT_RESULT_DATA4 (RERAM0_RESULT_DATA[4]),
        .Tile_X20Y6_EXT_RESULT_DATA5 (RERAM0_RESULT_DATA[5]),
        .Tile_X20Y6_EXT_RESULT_DATA6 (RERAM0_RESULT_DATA[6]),
        .Tile_X20Y6_EXT_RESULT_DATA7 (RERAM0_RESULT_DATA[7]),
        .Tile_X20Y6_EXT_RESULT_DATA8 (RERAM0_RESULT_DATA[8]),
        .Tile_X20Y6_EXT_RESULT_DATA9 (RERAM0_RESULT_DATA[9]),
        .Tile_X20Y6_EXT_RESULT_DATA10 (RERAM0_RESULT_DATA[10]),
        .Tile_X20Y6_EXT_RESULT_DATA11 (RERAM0_RESULT_DATA[11]),
        .Tile_X20Y6_EXT_RESULT_DATA12 (RERAM0_RESULT_DATA[12]),
        .Tile_X20Y6_EXT_RESULT_DATA13 (RERAM0_RESULT_DATA[13]),
        .Tile_X20Y6_EXT_RESULT_DATA14 (RERAM0_RESULT_DATA[14]),
        .Tile_X20Y6_EXT_RESULT_DATA15 (RERAM0_RESULT_DATA[15]),
        .Tile_X20Y6_EXT_RESULT_DATA16 (RERAM0_RESULT_DATA[16]),
        .Tile_X20Y6_EXT_RESULT_DATA17 (RERAM0_RESULT_DATA[17]),
        .Tile_X20Y6_EXT_RESULT_DATA18 (RERAM0_RESULT_DATA[18]),
        .Tile_X20Y6_EXT_RESULT_DATA19 (RERAM0_RESULT_DATA[19]),
        .Tile_X20Y6_EXT_RESULT_DATA20 (RERAM0_RESULT_DATA[20]),
        .Tile_X20Y6_EXT_RESULT_LAST (RERAM0_RESULT_LAST),
        .Tile_X20Y6_EXT_CLK (RERAM0_CLK),
        .Tile_X20Y6_EXT_RST (RERAM0_RST),
        .Tile_X20Y6_EXT_CMD_VALID (RERAM0_CMD_VALID),
        .Tile_X20Y6_EXT_MODE0 (RERAM0_MODE[0]),
        .Tile_X20Y6_EXT_MODE1 (RERAM0_MODE[1]),
        .Tile_X20Y6_EXT_ROW_INDEX0 (RERAM0_ROW_INDEX[0]),
        .Tile_X20Y6_EXT_ROW_INDEX1 (RERAM0_ROW_INDEX[1]),
        .Tile_X20Y6_EXT_ROW_INDEX2 (RERAM0_ROW_INDEX[2]),
        .Tile_X20Y6_EXT_ROW_INDEX3 (RERAM0_ROW_INDEX[3]),
        .Tile_X20Y6_EXT_ROW_INDEX4 (RERAM0_ROW_INDEX[4]),
        .Tile_X20Y6_EXT_COL_INDEX0 (RERAM0_COL_INDEX[0]),
        .Tile_X20Y6_EXT_COL_INDEX1 (RERAM0_COL_INDEX[1]),
        .Tile_X20Y6_EXT_COL_INDEX2 (RERAM0_COL_INDEX[2]),
        .Tile_X20Y6_EXT_COL_INDEX3 (RERAM0_COL_INDEX[3]),
        .Tile_X20Y6_EXT_COL_INDEX4 (RERAM0_COL_INDEX[4]),
        .Tile_X20Y6_EXT_PWM_DATA0 (RERAM0_PWM_DATA[0]),
        .Tile_X20Y6_EXT_PWM_DATA1 (RERAM0_PWM_DATA[1]),
        .Tile_X20Y6_EXT_PWM_DATA2 (RERAM0_PWM_DATA[2]),
        .Tile_X20Y6_EXT_PWM_DATA3 (RERAM0_PWM_DATA[3]),
        .Tile_X20Y6_EXT_PWM_DATA4 (RERAM0_PWM_DATA[4]),
        .Tile_X20Y6_EXT_PWM_DATA5 (RERAM0_PWM_DATA[5]),
        .Tile_X20Y6_EXT_PWM_DATA6 (RERAM0_PWM_DATA[6]),
        .Tile_X20Y6_EXT_PWM_DATA7 (RERAM0_PWM_DATA[7]),
        .Tile_X20Y6_EXT_COMPUTE_LAST (RERAM0_COMPUTE_LAST),
        .Tile_X20Y6_EXT_COMPUTE_ALL_COLUMNS (RERAM0_COMPUTE_ALL_COLUMNS),
        .Tile_X20Y6_EXT_TARGET_SET10 (RERAM0_TARGET_SET1[0]),
        .Tile_X20Y6_EXT_TARGET_SET11 (RERAM0_TARGET_SET1[1]),
        .Tile_X20Y6_EXT_TARGET_SET12 (RERAM0_TARGET_SET1[2]),
        .Tile_X20Y6_EXT_TARGET_SET13 (RERAM0_TARGET_SET1[3]),
        .Tile_X20Y6_EXT_TARGET_SET14 (RERAM0_TARGET_SET1[4]),
        .Tile_X20Y6_EXT_TARGET_SET15 (RERAM0_TARGET_SET1[5]),
        .Tile_X20Y6_EXT_TARGET_SET16 (RERAM0_TARGET_SET1[6]),
        .Tile_X20Y6_EXT_TARGET_SET17 (RERAM0_TARGET_SET1[7]),
        .Tile_X20Y6_EXT_TARGET_SET18 (RERAM0_TARGET_SET1[8]),
        .Tile_X20Y6_EXT_TARGET_SET19 (RERAM0_TARGET_SET1[9]),
        .Tile_X20Y6_EXT_TARGET_SET110 (RERAM0_TARGET_SET1[10]),
        .Tile_X20Y6_EXT_TARGET_SET111 (RERAM0_TARGET_SET1[11]),
        .Tile_X20Y6_EXT_TARGET_SET112 (RERAM0_TARGET_SET1[12]),
        .Tile_X20Y6_EXT_TARGET_SET113 (RERAM0_TARGET_SET1[13]),
        .Tile_X20Y6_EXT_TARGET_SET114 (RERAM0_TARGET_SET1[14]),
        .Tile_X20Y6_EXT_TARGET_SET115 (RERAM0_TARGET_SET1[15]),
        .Tile_X20Y6_EXT_TARGET_SET20 (RERAM0_TARGET_SET2[0]),
        .Tile_X20Y6_EXT_TARGET_SET21 (RERAM0_TARGET_SET2[1]),
        .Tile_X20Y6_EXT_TARGET_SET22 (RERAM0_TARGET_SET2[2]),
        .Tile_X20Y6_EXT_TARGET_SET23 (RERAM0_TARGET_SET2[3]),
        .Tile_X20Y6_EXT_TARGET_SET24 (RERAM0_TARGET_SET2[4]),
        .Tile_X20Y6_EXT_TARGET_SET25 (RERAM0_TARGET_SET2[5]),
        .Tile_X20Y6_EXT_TARGET_SET26 (RERAM0_TARGET_SET2[6]),
        .Tile_X20Y6_EXT_TARGET_SET27 (RERAM0_TARGET_SET2[7]),
        .Tile_X20Y6_EXT_TARGET_SET28 (RERAM0_TARGET_SET2[8]),
        .Tile_X20Y6_EXT_TARGET_SET29 (RERAM0_TARGET_SET2[9]),
        .Tile_X20Y6_EXT_TARGET_SET210 (RERAM0_TARGET_SET2[10]),
        .Tile_X20Y6_EXT_TARGET_SET211 (RERAM0_TARGET_SET2[11]),
        .Tile_X20Y6_EXT_TARGET_SET212 (RERAM0_TARGET_SET2[12]),
        .Tile_X20Y6_EXT_TARGET_SET213 (RERAM0_TARGET_SET2[13]),
        .Tile_X20Y6_EXT_TARGET_SET214 (RERAM0_TARGET_SET2[14]),
        .Tile_X20Y6_EXT_TARGET_SET215 (RERAM0_TARGET_SET2[15]),
        .Tile_X20Y6_EXT_TARGET_RESET10 (RERAM0_TARGET_RESET1[0]),
        .Tile_X20Y6_EXT_TARGET_RESET11 (RERAM0_TARGET_RESET1[1]),
        .Tile_X20Y6_EXT_TARGET_RESET12 (RERAM0_TARGET_RESET1[2]),
        .Tile_X20Y6_EXT_TARGET_RESET13 (RERAM0_TARGET_RESET1[3]),
        .Tile_X20Y6_EXT_TARGET_RESET14 (RERAM0_TARGET_RESET1[4]),
        .Tile_X20Y6_EXT_TARGET_RESET15 (RERAM0_TARGET_RESET1[5]),
        .Tile_X20Y6_EXT_TARGET_RESET16 (RERAM0_TARGET_RESET1[6]),
        .Tile_X20Y6_EXT_TARGET_RESET17 (RERAM0_TARGET_RESET1[7]),
        .Tile_X20Y6_EXT_TARGET_RESET18 (RERAM0_TARGET_RESET1[8]),
        .Tile_X20Y6_EXT_TARGET_RESET19 (RERAM0_TARGET_RESET1[9]),
        .Tile_X20Y6_EXT_TARGET_RESET110 (RERAM0_TARGET_RESET1[10]),
        .Tile_X20Y6_EXT_TARGET_RESET111 (RERAM0_TARGET_RESET1[11]),
        .Tile_X20Y6_EXT_TARGET_RESET112 (RERAM0_TARGET_RESET1[12]),
        .Tile_X20Y6_EXT_TARGET_RESET113 (RERAM0_TARGET_RESET1[13]),
        .Tile_X20Y6_EXT_TARGET_RESET114 (RERAM0_TARGET_RESET1[14]),
        .Tile_X20Y6_EXT_TARGET_RESET115 (RERAM0_TARGET_RESET1[15]),
        .Tile_X20Y6_EXT_TARGET_RESET20 (RERAM0_TARGET_RESET2[0]),
        .Tile_X20Y6_EXT_TARGET_RESET21 (RERAM0_TARGET_RESET2[1]),
        .Tile_X20Y6_EXT_TARGET_RESET22 (RERAM0_TARGET_RESET2[2]),
        .Tile_X20Y6_EXT_TARGET_RESET23 (RERAM0_TARGET_RESET2[3]),
        .Tile_X20Y6_EXT_TARGET_RESET24 (RERAM0_TARGET_RESET2[4]),
        .Tile_X20Y6_EXT_TARGET_RESET25 (RERAM0_TARGET_RESET2[5]),
        .Tile_X20Y6_EXT_TARGET_RESET26 (RERAM0_TARGET_RESET2[6]),
        .Tile_X20Y6_EXT_TARGET_RESET27 (RERAM0_TARGET_RESET2[7]),
        .Tile_X20Y6_EXT_TARGET_RESET28 (RERAM0_TARGET_RESET2[8]),
        .Tile_X20Y6_EXT_TARGET_RESET29 (RERAM0_TARGET_RESET2[9]),
        .Tile_X20Y6_EXT_TARGET_RESET210 (RERAM0_TARGET_RESET2[10]),
        .Tile_X20Y6_EXT_TARGET_RESET211 (RERAM0_TARGET_RESET2[11]),
        .Tile_X20Y6_EXT_TARGET_RESET212 (RERAM0_TARGET_RESET2[12]),
        .Tile_X20Y6_EXT_TARGET_RESET213 (RERAM0_TARGET_RESET2[13]),
        .Tile_X20Y6_EXT_TARGET_RESET214 (RERAM0_TARGET_RESET2[14]),
        .Tile_X20Y6_EXT_TARGET_RESET215 (RERAM0_TARGET_RESET2[15]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES0 (RERAM0_NO_OF_CLK_CYCLES[0]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES1 (RERAM0_NO_OF_CLK_CYCLES[1]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES2 (RERAM0_NO_OF_CLK_CYCLES[2]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES3 (RERAM0_NO_OF_CLK_CYCLES[3]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES4 (RERAM0_NO_OF_CLK_CYCLES[4]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES5 (RERAM0_NO_OF_CLK_CYCLES[5]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES6 (RERAM0_NO_OF_CLK_CYCLES[6]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES7 (RERAM0_NO_OF_CLK_CYCLES[7]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES8 (RERAM0_NO_OF_CLK_CYCLES[8]),
        .Tile_X20Y6_EXT_NO_OF_CLK_CYCLES9 (RERAM0_NO_OF_CLK_CYCLES[9]),
        .Tile_X20Y6_EXT_COUNTER_VALUE0 (RERAM0_COUNTER_VALUE[0]),
        .Tile_X20Y6_EXT_COUNTER_VALUE1 (RERAM0_COUNTER_VALUE[1]),
        .Tile_X20Y6_EXT_COUNTER_VALUE2 (RERAM0_COUNTER_VALUE[2]),
        .Tile_X20Y6_EXT_COUNTER_VALUE3 (RERAM0_COUNTER_VALUE[3]),
        .Tile_X20Y6_EXT_COUNTER_VALUE4 (RERAM0_COUNTER_VALUE[4]),
        .Tile_X20Y6_EXT_COUNTER_VALUE5 (RERAM0_COUNTER_VALUE[5]),
        .Tile_X20Y6_EXT_COUNTER_VALUE6 (RERAM0_COUNTER_VALUE[6]),
        .Tile_X20Y6_EXT_COUNTER_VALUE7 (RERAM0_COUNTER_VALUE[7]),
        .Tile_X20Y6_EXT_COUNTER_VALUE8 (RERAM0_COUNTER_VALUE[8]),
        .Tile_X20Y6_EXT_COUNTER_VALUE9 (RERAM0_COUNTER_VALUE[9]),
        .Tile_X20Y6_EXT_TDC_TIME_OUT0 (RERAM0_TDC_TIME_OUT[0]),
        .Tile_X20Y6_EXT_TDC_TIME_OUT1 (RERAM0_TDC_TIME_OUT[1]),
        .Tile_X20Y6_EXT_TDC_TIME_OUT2 (RERAM0_TDC_TIME_OUT[2]),
        .Tile_X20Y6_EXT_TDC_TIME_OUT3 (RERAM0_TDC_TIME_OUT[3]),
        .Tile_X20Y6_EXT_TDC_TIME_OUT4 (RERAM0_TDC_TIME_OUT[4]),
        .Tile_X20Y6_EXT_TDC_TIME_OUT5 (RERAM0_TDC_TIME_OUT[5]),
        .Tile_X20Y6_EXT_TDC_TIME_OUT6 (RERAM0_TDC_TIME_OUT[6]),
        .Tile_X20Y6_EXT_TDC_DEAD_TIME0 (RERAM0_TDC_DEAD_TIME[0]),
        .Tile_X20Y6_EXT_TDC_DEAD_TIME1 (RERAM0_TDC_DEAD_TIME[1]),
        .Tile_X20Y6_EXT_RESULT_READY (RERAM0_RESULT_READY),
        
        // RERAM_CIM_32x32
        .Tile_X20Y14_EXT_CMD_READY (RERAM1_CMD_READY),
        .Tile_X20Y14_EXT_BUSY (RERAM1_BUSY),
        .Tile_X20Y14_EXT_COMMAND_ACCEPTED (RERAM1_COMMAND_ACCEPTED),
        .Tile_X20Y14_EXT_COMPUTE_PENDING (RERAM1_COMPUTE_PENDING),
        .Tile_X20Y14_EXT_ERROR0 (RERAM1_ERROR[0]),
        .Tile_X20Y14_EXT_ERROR1 (RERAM1_ERROR[1]),
        .Tile_X20Y14_EXT_ERROR2 (RERAM1_ERROR[2]),
        .Tile_X20Y14_EXT_ERROR_VALID (RERAM1_ERROR_VALID),
        .Tile_X20Y14_EXT_OPERATION_DONE (RERAM1_OPERATION_DONE),
        .Tile_X20Y14_EXT_PROGRAM_READBACK_ACTIVE (RERAM1_PROGRAM_READBACK_ACTIVE),
        .Tile_X20Y14_EXT_RESULT_VALID (RERAM1_RESULT_VALID),
        .Tile_X20Y14_EXT_RESULT_DATA0 (RERAM1_RESULT_DATA[0]),
        .Tile_X20Y14_EXT_RESULT_DATA1 (RERAM1_RESULT_DATA[1]),
        .Tile_X20Y14_EXT_RESULT_DATA2 (RERAM1_RESULT_DATA[2]),
        .Tile_X20Y14_EXT_RESULT_DATA3 (RERAM1_RESULT_DATA[3]),
        .Tile_X20Y14_EXT_RESULT_DATA4 (RERAM1_RESULT_DATA[4]),
        .Tile_X20Y14_EXT_RESULT_DATA5 (RERAM1_RESULT_DATA[5]),
        .Tile_X20Y14_EXT_RESULT_DATA6 (RERAM1_RESULT_DATA[6]),
        .Tile_X20Y14_EXT_RESULT_DATA7 (RERAM1_RESULT_DATA[7]),
        .Tile_X20Y14_EXT_RESULT_DATA8 (RERAM1_RESULT_DATA[8]),
        .Tile_X20Y14_EXT_RESULT_DATA9 (RERAM1_RESULT_DATA[9]),
        .Tile_X20Y14_EXT_RESULT_DATA10 (RERAM1_RESULT_DATA[10]),
        .Tile_X20Y14_EXT_RESULT_DATA11 (RERAM1_RESULT_DATA[11]),
        .Tile_X20Y14_EXT_RESULT_DATA12 (RERAM1_RESULT_DATA[12]),
        .Tile_X20Y14_EXT_RESULT_DATA13 (RERAM1_RESULT_DATA[13]),
        .Tile_X20Y14_EXT_RESULT_DATA14 (RERAM1_RESULT_DATA[14]),
        .Tile_X20Y14_EXT_RESULT_DATA15 (RERAM1_RESULT_DATA[15]),
        .Tile_X20Y14_EXT_RESULT_DATA16 (RERAM1_RESULT_DATA[16]),
        .Tile_X20Y14_EXT_RESULT_DATA17 (RERAM1_RESULT_DATA[17]),
        .Tile_X20Y14_EXT_RESULT_DATA18 (RERAM1_RESULT_DATA[18]),
        .Tile_X20Y14_EXT_RESULT_DATA19 (RERAM1_RESULT_DATA[19]),
        .Tile_X20Y14_EXT_RESULT_DATA20 (RERAM1_RESULT_DATA[20]),
        .Tile_X20Y14_EXT_RESULT_LAST (RERAM1_RESULT_LAST),
        .Tile_X20Y14_EXT_CLK (RERAM1_CLK),
        .Tile_X20Y14_EXT_RST (RERAM1_RST),
        .Tile_X20Y14_EXT_CMD_VALID (RERAM1_CMD_VALID),
        .Tile_X20Y14_EXT_MODE0 (RERAM1_MODE[0]),
        .Tile_X20Y14_EXT_MODE1 (RERAM1_MODE[1]),
        .Tile_X20Y14_EXT_ROW_INDEX0 (RERAM1_ROW_INDEX[0]),
        .Tile_X20Y14_EXT_ROW_INDEX1 (RERAM1_ROW_INDEX[1]),
        .Tile_X20Y14_EXT_ROW_INDEX2 (RERAM1_ROW_INDEX[2]),
        .Tile_X20Y14_EXT_ROW_INDEX3 (RERAM1_ROW_INDEX[3]),
        .Tile_X20Y14_EXT_ROW_INDEX4 (RERAM1_ROW_INDEX[4]),
        .Tile_X20Y14_EXT_COL_INDEX0 (RERAM1_COL_INDEX[0]),
        .Tile_X20Y14_EXT_COL_INDEX1 (RERAM1_COL_INDEX[1]),
        .Tile_X20Y14_EXT_COL_INDEX2 (RERAM1_COL_INDEX[2]),
        .Tile_X20Y14_EXT_COL_INDEX3 (RERAM1_COL_INDEX[3]),
        .Tile_X20Y14_EXT_COL_INDEX4 (RERAM1_COL_INDEX[4]),
        .Tile_X20Y14_EXT_PWM_DATA0 (RERAM1_PWM_DATA[0]),
        .Tile_X20Y14_EXT_PWM_DATA1 (RERAM1_PWM_DATA[1]),
        .Tile_X20Y14_EXT_PWM_DATA2 (RERAM1_PWM_DATA[2]),
        .Tile_X20Y14_EXT_PWM_DATA3 (RERAM1_PWM_DATA[3]),
        .Tile_X20Y14_EXT_PWM_DATA4 (RERAM1_PWM_DATA[4]),
        .Tile_X20Y14_EXT_PWM_DATA5 (RERAM1_PWM_DATA[5]),
        .Tile_X20Y14_EXT_PWM_DATA6 (RERAM1_PWM_DATA[6]),
        .Tile_X20Y14_EXT_PWM_DATA7 (RERAM1_PWM_DATA[7]),
        .Tile_X20Y14_EXT_COMPUTE_LAST (RERAM1_COMPUTE_LAST),
        .Tile_X20Y14_EXT_COMPUTE_ALL_COLUMNS (RERAM1_COMPUTE_ALL_COLUMNS),
        .Tile_X20Y14_EXT_TARGET_SET10 (RERAM1_TARGET_SET1[0]),
        .Tile_X20Y14_EXT_TARGET_SET11 (RERAM1_TARGET_SET1[1]),
        .Tile_X20Y14_EXT_TARGET_SET12 (RERAM1_TARGET_SET1[2]),
        .Tile_X20Y14_EXT_TARGET_SET13 (RERAM1_TARGET_SET1[3]),
        .Tile_X20Y14_EXT_TARGET_SET14 (RERAM1_TARGET_SET1[4]),
        .Tile_X20Y14_EXT_TARGET_SET15 (RERAM1_TARGET_SET1[5]),
        .Tile_X20Y14_EXT_TARGET_SET16 (RERAM1_TARGET_SET1[6]),
        .Tile_X20Y14_EXT_TARGET_SET17 (RERAM1_TARGET_SET1[7]),
        .Tile_X20Y14_EXT_TARGET_SET18 (RERAM1_TARGET_SET1[8]),
        .Tile_X20Y14_EXT_TARGET_SET19 (RERAM1_TARGET_SET1[9]),
        .Tile_X20Y14_EXT_TARGET_SET110 (RERAM1_TARGET_SET1[10]),
        .Tile_X20Y14_EXT_TARGET_SET111 (RERAM1_TARGET_SET1[11]),
        .Tile_X20Y14_EXT_TARGET_SET112 (RERAM1_TARGET_SET1[12]),
        .Tile_X20Y14_EXT_TARGET_SET113 (RERAM1_TARGET_SET1[13]),
        .Tile_X20Y14_EXT_TARGET_SET114 (RERAM1_TARGET_SET1[14]),
        .Tile_X20Y14_EXT_TARGET_SET115 (RERAM1_TARGET_SET1[15]),
        .Tile_X20Y14_EXT_TARGET_SET20 (RERAM1_TARGET_SET2[0]),
        .Tile_X20Y14_EXT_TARGET_SET21 (RERAM1_TARGET_SET2[1]),
        .Tile_X20Y14_EXT_TARGET_SET22 (RERAM1_TARGET_SET2[2]),
        .Tile_X20Y14_EXT_TARGET_SET23 (RERAM1_TARGET_SET2[3]),
        .Tile_X20Y14_EXT_TARGET_SET24 (RERAM1_TARGET_SET2[4]),
        .Tile_X20Y14_EXT_TARGET_SET25 (RERAM1_TARGET_SET2[5]),
        .Tile_X20Y14_EXT_TARGET_SET26 (RERAM1_TARGET_SET2[6]),
        .Tile_X20Y14_EXT_TARGET_SET27 (RERAM1_TARGET_SET2[7]),
        .Tile_X20Y14_EXT_TARGET_SET28 (RERAM1_TARGET_SET2[8]),
        .Tile_X20Y14_EXT_TARGET_SET29 (RERAM1_TARGET_SET2[9]),
        .Tile_X20Y14_EXT_TARGET_SET210 (RERAM1_TARGET_SET2[10]),
        .Tile_X20Y14_EXT_TARGET_SET211 (RERAM1_TARGET_SET2[11]),
        .Tile_X20Y14_EXT_TARGET_SET212 (RERAM1_TARGET_SET2[12]),
        .Tile_X20Y14_EXT_TARGET_SET213 (RERAM1_TARGET_SET2[13]),
        .Tile_X20Y14_EXT_TARGET_SET214 (RERAM1_TARGET_SET2[14]),
        .Tile_X20Y14_EXT_TARGET_SET215 (RERAM1_TARGET_SET2[15]),
        .Tile_X20Y14_EXT_TARGET_RESET10 (RERAM1_TARGET_RESET1[0]),
        .Tile_X20Y14_EXT_TARGET_RESET11 (RERAM1_TARGET_RESET1[1]),
        .Tile_X20Y14_EXT_TARGET_RESET12 (RERAM1_TARGET_RESET1[2]),
        .Tile_X20Y14_EXT_TARGET_RESET13 (RERAM1_TARGET_RESET1[3]),
        .Tile_X20Y14_EXT_TARGET_RESET14 (RERAM1_TARGET_RESET1[4]),
        .Tile_X20Y14_EXT_TARGET_RESET15 (RERAM1_TARGET_RESET1[5]),
        .Tile_X20Y14_EXT_TARGET_RESET16 (RERAM1_TARGET_RESET1[6]),
        .Tile_X20Y14_EXT_TARGET_RESET17 (RERAM1_TARGET_RESET1[7]),
        .Tile_X20Y14_EXT_TARGET_RESET18 (RERAM1_TARGET_RESET1[8]),
        .Tile_X20Y14_EXT_TARGET_RESET19 (RERAM1_TARGET_RESET1[9]),
        .Tile_X20Y14_EXT_TARGET_RESET110 (RERAM1_TARGET_RESET1[10]),
        .Tile_X20Y14_EXT_TARGET_RESET111 (RERAM1_TARGET_RESET1[11]),
        .Tile_X20Y14_EXT_TARGET_RESET112 (RERAM1_TARGET_RESET1[12]),
        .Tile_X20Y14_EXT_TARGET_RESET113 (RERAM1_TARGET_RESET1[13]),
        .Tile_X20Y14_EXT_TARGET_RESET114 (RERAM1_TARGET_RESET1[14]),
        .Tile_X20Y14_EXT_TARGET_RESET115 (RERAM1_TARGET_RESET1[15]),
        .Tile_X20Y14_EXT_TARGET_RESET20 (RERAM1_TARGET_RESET2[0]),
        .Tile_X20Y14_EXT_TARGET_RESET21 (RERAM1_TARGET_RESET2[1]),
        .Tile_X20Y14_EXT_TARGET_RESET22 (RERAM1_TARGET_RESET2[2]),
        .Tile_X20Y14_EXT_TARGET_RESET23 (RERAM1_TARGET_RESET2[3]),
        .Tile_X20Y14_EXT_TARGET_RESET24 (RERAM1_TARGET_RESET2[4]),
        .Tile_X20Y14_EXT_TARGET_RESET25 (RERAM1_TARGET_RESET2[5]),
        .Tile_X20Y14_EXT_TARGET_RESET26 (RERAM1_TARGET_RESET2[6]),
        .Tile_X20Y14_EXT_TARGET_RESET27 (RERAM1_TARGET_RESET2[7]),
        .Tile_X20Y14_EXT_TARGET_RESET28 (RERAM1_TARGET_RESET2[8]),
        .Tile_X20Y14_EXT_TARGET_RESET29 (RERAM1_TARGET_RESET2[9]),
        .Tile_X20Y14_EXT_TARGET_RESET210 (RERAM1_TARGET_RESET2[10]),
        .Tile_X20Y14_EXT_TARGET_RESET211 (RERAM1_TARGET_RESET2[11]),
        .Tile_X20Y14_EXT_TARGET_RESET212 (RERAM1_TARGET_RESET2[12]),
        .Tile_X20Y14_EXT_TARGET_RESET213 (RERAM1_TARGET_RESET2[13]),
        .Tile_X20Y14_EXT_TARGET_RESET214 (RERAM1_TARGET_RESET2[14]),
        .Tile_X20Y14_EXT_TARGET_RESET215 (RERAM1_TARGET_RESET2[15]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES0 (RERAM1_NO_OF_CLK_CYCLES[0]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES1 (RERAM1_NO_OF_CLK_CYCLES[1]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES2 (RERAM1_NO_OF_CLK_CYCLES[2]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES3 (RERAM1_NO_OF_CLK_CYCLES[3]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES4 (RERAM1_NO_OF_CLK_CYCLES[4]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES5 (RERAM1_NO_OF_CLK_CYCLES[5]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES6 (RERAM1_NO_OF_CLK_CYCLES[6]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES7 (RERAM1_NO_OF_CLK_CYCLES[7]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES8 (RERAM1_NO_OF_CLK_CYCLES[8]),
        .Tile_X20Y14_EXT_NO_OF_CLK_CYCLES9 (RERAM1_NO_OF_CLK_CYCLES[9]),
        .Tile_X20Y14_EXT_COUNTER_VALUE0 (RERAM1_COUNTER_VALUE[0]),
        .Tile_X20Y14_EXT_COUNTER_VALUE1 (RERAM1_COUNTER_VALUE[1]),
        .Tile_X20Y14_EXT_COUNTER_VALUE2 (RERAM1_COUNTER_VALUE[2]),
        .Tile_X20Y14_EXT_COUNTER_VALUE3 (RERAM1_COUNTER_VALUE[3]),
        .Tile_X20Y14_EXT_COUNTER_VALUE4 (RERAM1_COUNTER_VALUE[4]),
        .Tile_X20Y14_EXT_COUNTER_VALUE5 (RERAM1_COUNTER_VALUE[5]),
        .Tile_X20Y14_EXT_COUNTER_VALUE6 (RERAM1_COUNTER_VALUE[6]),
        .Tile_X20Y14_EXT_COUNTER_VALUE7 (RERAM1_COUNTER_VALUE[7]),
        .Tile_X20Y14_EXT_COUNTER_VALUE8 (RERAM1_COUNTER_VALUE[8]),
        .Tile_X20Y14_EXT_COUNTER_VALUE9 (RERAM1_COUNTER_VALUE[9]),
        .Tile_X20Y14_EXT_TDC_TIME_OUT0 (RERAM1_TDC_TIME_OUT[0]),
        .Tile_X20Y14_EXT_TDC_TIME_OUT1 (RERAM1_TDC_TIME_OUT[1]),
        .Tile_X20Y14_EXT_TDC_TIME_OUT2 (RERAM1_TDC_TIME_OUT[2]),
        .Tile_X20Y14_EXT_TDC_TIME_OUT3 (RERAM1_TDC_TIME_OUT[3]),
        .Tile_X20Y14_EXT_TDC_TIME_OUT4 (RERAM1_TDC_TIME_OUT[4]),
        .Tile_X20Y14_EXT_TDC_TIME_OUT5 (RERAM1_TDC_TIME_OUT[5]),
        .Tile_X20Y14_EXT_TDC_TIME_OUT6 (RERAM1_TDC_TIME_OUT[6]),
        .Tile_X20Y14_EXT_TDC_DEAD_TIME0 (RERAM1_TDC_DEAD_TIME[0]),
        .Tile_X20Y14_EXT_TDC_DEAD_TIME1 (RERAM1_TDC_DEAD_TIME[1]),
        .Tile_X20Y14_EXT_RESULT_READY (RERAM1_RESULT_READY),

        // SYS_RESET
        .Tile_X0Y19_SYS_RESET_RESET_top(sys_reset_i)
    );

    (* keep *) sky130_bmlabs_reram__cim32x32 reram_0 (
        // Clock and reset
        .clk_i (RERAM0_CLK),
        .rst_i (RERAM0_RST),

        // Command interface
        .i_cmd_valid (RERAM0_CMD_VALID),
        .o_cmd_ready (RERAM0_CMD_READY),
        .i_mode (RERAM0_MODE),
        .i_row_index (RERAM0_ROW_INDEX),
        .i_col_index (RERAM0_COL_INDEX),
        .i_pwm_data (RERAM0_PWM_DATA),
        .i_compute_last (RERAM0_COMPUTE_LAST),
        .i_compute_all_columns (RERAM0_COMPUTE_ALL_COLUMNS),

        // Configuration inputs
        .i_target_set1 (RERAM0_TARGET_SET1),
        .i_target_set2 (RERAM0_TARGET_SET2),
        .i_target_reset1 (RERAM0_TARGET_RESET1),
        .i_target_reset2 (RERAM0_TARGET_RESET2),
        .i_no_of_clk_cycles (RERAM0_NO_OF_CLK_CYCLES),
        .i_counter_value (RERAM0_COUNTER_VALUE),
        .i_tdc_time_out (RERAM0_TDC_TIME_OUT),
        .i_tdc_dead_time (RERAM0_TDC_DEAD_TIME),

        // Status outputs
        .o_busy (RERAM0_BUSY),
        .o_command_accepted (RERAM0_COMMAND_ACCEPTED),
        .o_compute_pending (RERAM0_COMPUTE_PENDING),
        .o_error (RERAM0_ERROR),
        .o_error_valid (RERAM0_ERROR_VALID),
        .o_operation_done (RERAM0_OPERATION_DONE),
        .o_program_readback_active (RERAM0_PROGRAM_READBACK_ACTIVE),

        // Result interface
        .o_result_valid (RERAM0_RESULT_VALID),
        .i_result_ready (RERAM0_RESULT_READY),
        .o_result_data (RERAM0_RESULT_DATA),
        .o_result_last (RERAM0_RESULT_LAST),

        // Scan and test pins
        .ScanInCC ('0),
        .ScanInDL ('0),
        .ScanInDR ('0),
        .ScanOutCC (),
        .TM ('0),

        // Analog-pad pins; route on met3 with a matching-or-wider 1.30 um NDR
        .Iref (),           // 100 uA current reference
        .Vcc_read (),       // 0.3 V read rail
        .Vcomp (),          // 0.6 V comparator/reference bias
        .Bias_comp2 (),     // 0.6 V comparator bias
        .Vcc_wl_read (),    // 0.7 V wordline read rail
        .Vcc_wl_set (),     // 1.8 V wordline set rail
        .Vbias (),          // 1.8 V analog bias
        .Vcc_wl_reset (),   // 2.6 V wordline reset rail
        .Vcc_set (),        // 3.3 V array set rail
        .dc_bias ()         // externally driven; value is design-specific
    );

    (* keep *) sky130_bmlabs_reram__cim32x32 reram_1 (
        // Clock and reset
        .clk_i (RERAM1_CLK),
        .rst_i (RERAM1_RST),

        // Command interface
        .i_cmd_valid (RERAM1_CMD_VALID),
        .o_cmd_ready (RERAM1_CMD_READY),
        .i_mode (RERAM1_MODE),
        .i_row_index (RERAM1_ROW_INDEX),
        .i_col_index (RERAM1_COL_INDEX),
        .i_pwm_data (RERAM1_PWM_DATA),
        .i_compute_last (RERAM1_COMPUTE_LAST),
        .i_compute_all_columns (RERAM1_COMPUTE_ALL_COLUMNS),

        // Configuration inputs
        .i_target_set1 (RERAM1_TARGET_SET1),
        .i_target_set2 (RERAM1_TARGET_SET2),
        .i_target_reset1 (RERAM1_TARGET_RESET1),
        .i_target_reset2 (RERAM1_TARGET_RESET2),
        .i_no_of_clk_cycles (RERAM1_NO_OF_CLK_CYCLES),
        .i_counter_value (RERAM1_COUNTER_VALUE),
        .i_tdc_time_out (RERAM1_TDC_TIME_OUT),
        .i_tdc_dead_time (RERAM1_TDC_DEAD_TIME),

        // Status outputs
        .o_busy (RERAM1_BUSY),
        .o_command_accepted (RERAM1_COMMAND_ACCEPTED),
        .o_compute_pending (RERAM1_COMPUTE_PENDING),
        .o_error (RERAM1_ERROR),
        .o_error_valid (RERAM1_ERROR_VALID),
        .o_operation_done (RERAM1_OPERATION_DONE),
        .o_program_readback_active (RERAM1_PROGRAM_READBACK_ACTIVE),

        // Result interface
        .o_result_valid (RERAM1_RESULT_VALID),
        .i_result_ready (RERAM1_RESULT_READY),
        .o_result_data (RERAM1_RESULT_DATA),
        .o_result_last (RERAM1_RESULT_LAST),

        // Scan and test pins
        .ScanInCC ('0),
        .ScanInDL ('0),
        .ScanInDR ('0),
        .ScanOutCC (),
        .TM ('0),

        // Analog-pad pins; route on met3 with a matching-or-wider 1.30 um NDR
        .Iref (),           // 100 uA current reference
        .Vcc_read (),       // 0.3 V read rail
        .Vcomp (),          // 0.6 V comparator/reference bias
        .Bias_comp2 (),     // 0.6 V comparator bias
        .Vcc_wl_read (),    // 0.7 V wordline read rail
        .Vcc_wl_set (),     // 1.8 V wordline set rail
        .Vbias (),          // 1.8 V analog bias
        .Vcc_wl_reset (),   // 2.6 V wordline reset rail
        .Vcc_set (),        // 3.3 V array set rail
        .dc_bias ()         // externally driven; value is design-specific
    );

endmodule
