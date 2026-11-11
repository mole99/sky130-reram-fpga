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

(*FABulous, BelMap,
    TARGET_SET1=0,
    TARGET_SET1_1=1,
    TARGET_SET1_2=2,
    TARGET_SET1_3=3,
    TARGET_SET1_4=4,
    TARGET_SET1_5=5,
    TARGET_SET1_6=6,
    TARGET_SET1_7=7,
    TARGET_SET1_8=8,
    TARGET_SET1_9=9,
    TARGET_SET1_10=10,
    TARGET_SET1_11=11,
    TARGET_SET1_12=12,
    TARGET_SET1_13=13,
    TARGET_SET1_14=14,
    TARGET_SET1_15=15,
    
    TARGET_SET2=16,
    TARGET_SET2_1=17,
    TARGET_SET2_2=18,
    TARGET_SET2_3=19,
    TARGET_SET2_4=20,
    TARGET_SET2_5=21,
    TARGET_SET2_6=22,
    TARGET_SET2_7=23,
    TARGET_SET2_8=24,
    TARGET_SET2_9=25,
    TARGET_SET2_10=26,
    TARGET_SET2_11=27,
    TARGET_SET2_12=28,
    TARGET_SET2_13=29,
    TARGET_SET2_14=30,
    TARGET_SET2_15=31,
    
    TARGET_RESET1=32,
    TARGET_RESET1_1=33,
    TARGET_RESET1_2=34,
    TARGET_RESET1_3=35,
    TARGET_RESET1_4=36,
    TARGET_RESET1_5=37,
    TARGET_RESET1_6=38,
    TARGET_RESET1_7=39,
    TARGET_RESET1_8=40,
    TARGET_RESET1_9=41,
    TARGET_RESET1_10=42,
    TARGET_RESET1_11=43,
    TARGET_RESET1_12=44,
    TARGET_RESET1_13=45,
    TARGET_RESET1_14=46,
    TARGET_RESET1_15=47,
    
    TARGET_RESET2=48,
    TARGET_RESET2_1=49,
    TARGET_RESET2_2=50,
    TARGET_RESET2_3=51,
    TARGET_RESET2_4=52,
    TARGET_RESET2_5=53,
    TARGET_RESET2_6=54,
    TARGET_RESET2_7=55,
    TARGET_RESET2_8=56,
    TARGET_RESET2_9=57,
    TARGET_RESET2_10=58,
    TARGET_RESET2_11=59,
    TARGET_RESET2_12=60,
    TARGET_RESET2_13=61,
    TARGET_RESET2_14=62,
    TARGET_RESET2_15=63,
    
    NO_OF_CLK_CYCLES=64,
    NO_OF_CLK_CYCLES_1=65,
    NO_OF_CLK_CYCLES_2=66,
    NO_OF_CLK_CYCLES_3=67,
    NO_OF_CLK_CYCLES_4=68,
    NO_OF_CLK_CYCLES_5=69,
    NO_OF_CLK_CYCLES_6=70,
    NO_OF_CLK_CYCLES_7=71,
    NO_OF_CLK_CYCLES_8=72,
    NO_OF_CLK_CYCLES_9=73,

    COUNTER_VALUE=74,
    COUNTER_VALUE_1=75,
    COUNTER_VALUE_2=76,
    COUNTER_VALUE_3=77,
    COUNTER_VALUE_4=78,
    COUNTER_VALUE_5=79,
    COUNTER_VALUE_6=80,
    COUNTER_VALUE_7=81,
    COUNTER_VALUE_8=82,
    COUNTER_VALUE_9=83,
    
    TDC_TIME_OUT=84,
    TDC_TIME_OUT_1=85,
    TDC_TIME_OUT_2=86,
    TDC_TIME_OUT_3=87,
    TDC_TIME_OUT_4=88,
    TDC_TIME_OUT_5=89,
    TDC_TIME_OUT_6=90,
        
    TDC_DEAD_TIME=91,
    TDC_DEAD_TIME_1=92
*)
module RERAM_CIM_32x32 #(
    parameter N_CONFIG_BITS = 92+1
)(	
    // Fabric side
    
    // Clock and reset
    input wire CLK,
    input wire RST,
    
    // Command interface
    input  wire         CMD_VALID,
    output wire         CMD_READY,
    input  wire [1:0]   MODE,
    input  wire [4:0]   ROW_INDEX,
    input  wire [4:0]   COL_INDEX,
    input  wire [7:0]   PWM_DATA,
    input  wire         COMPUTE_LAST,
    input  wire         COMPUTE_ALL_COLUMNS,

    // Status outputs
    output wire         BUSY,
    output wire         COMMAND_ACCEPTED,
    output wire         COMPUTE_PENDING,
    output wire [2:0]   ERROR,
    output wire         ERROR_VALID,
    output wire         OPERATION_DONE,
    output wire         PROGRAM_READBACK_ACTIVE,

    // Result interface
    output wire         RESULT_VALID,
    input  wire         RESULT_READY,
    output wire [20:0]  RESULT_DATA,
    output wire         RESULT_LAST,

    // External side

    // Clock and reset
    (* FABulous, EXTERNAL *) output wire EXT_CLK,
    (* FABulous, EXTERNAL *) output wire EXT_RST,
    
    // Command interface
    (* FABulous, EXTERNAL *) output wire         EXT_CMD_VALID,
    (* FABulous, EXTERNAL *) input  wire         EXT_CMD_READY,
    (* FABulous, EXTERNAL *) output wire [1:0]   EXT_MODE,
    (* FABulous, EXTERNAL *) output wire [4:0]   EXT_ROW_INDEX,
    (* FABulous, EXTERNAL *) output wire [4:0]   EXT_COL_INDEX,
    (* FABulous, EXTERNAL *) output wire [7:0]   EXT_PWM_DATA,
    (* FABulous, EXTERNAL *) output wire         EXT_COMPUTE_LAST,
    (* FABulous, EXTERNAL *) output wire         EXT_COMPUTE_ALL_COLUMNS,

    // Configuration inputs
    (* FABulous, EXTERNAL *) output wire [15:0]  EXT_TARGET_SET1,
    (* FABulous, EXTERNAL *) output wire [15:0]  EXT_TARGET_SET2,
    (* FABulous, EXTERNAL *) output wire [15:0]  EXT_TARGET_RESET1,
    (* FABulous, EXTERNAL *) output wire [15:0]  EXT_TARGET_RESET2,
    (* FABulous, EXTERNAL *) output wire [9:0]   EXT_NO_OF_CLK_CYCLES,
    (* FABulous, EXTERNAL *) output wire [9:0]   EXT_COUNTER_VALUE,
    (* FABulous, EXTERNAL *) output wire [6:0]   EXT_TDC_TIME_OUT,
    (* FABulous, EXTERNAL *) output wire [1:0]   EXT_TDC_DEAD_TIME,

    // Status outputs
    (* FABulous, EXTERNAL *) input  wire         EXT_BUSY,
    (* FABulous, EXTERNAL *) input  wire         EXT_COMMAND_ACCEPTED,
    (* FABulous, EXTERNAL *) input  wire         EXT_COMPUTE_PENDING,
    (* FABulous, EXTERNAL *) input  wire [2:0]   EXT_ERROR,
    (* FABulous, EXTERNAL *) input  wire         EXT_ERROR_VALID,
    (* FABulous, EXTERNAL *) input  wire         EXT_OPERATION_DONE,
    (* FABulous, EXTERNAL *) input  wire         EXT_PROGRAM_READBACK_ACTIVE,

    // Result interface
    (* FABulous, EXTERNAL *) input  wire         EXT_RESULT_VALID,
    (* FABulous, EXTERNAL *) output wire         EXT_RESULT_READY,
    (* FABulous, EXTERNAL *) input  wire [20:0]  EXT_RESULT_DATA,
    (* FABulous, EXTERNAL *) input  wire         EXT_RESULT_LAST,
    
    (* FABulous, GLOBAL *) input [N_CONFIG_BITS-1:0] ConfigBits // Config bits as vector
);
    // Configuration bits
    wire [15:0] TARGET_SET1;
    wire [15:0] TARGET_SET2;
    wire [15:0] TARGET_RESET1;
    wire [15:0] TARGET_RESET2;
    wire [ 9:0] NO_OF_CLK_CYCLES;
    wire [ 9:0] COUNTER_VALUE;
    wire [ 6:0] TDC_TIME_OUT;
    wire [ 1:0] TDC_DEAD_TIME;
    
	  assign TARGET_SET1      = ConfigBits[15:0];
	  assign TARGET_SET2      = ConfigBits[31:16];
    assign TARGET_RESET1    = ConfigBits[47:32];
    assign TARGET_RESET2    = ConfigBits[63:48];
    assign NO_OF_CLK_CYCLES = ConfigBits[73:64];
    assign COUNTER_VALUE    = ConfigBits[83:74];
    assign TDC_TIME_OUT     = ConfigBits[90:84];
    assign TDC_DEAD_TIME    = ConfigBits[92:91];

    // Fabric -> External and External -> Fabric
    
    // Clock and reset
  	  assign EXT_CLK = CLK;
  	  assign EXT_RST = RST;
    
    // Command interface
  	  assign EXT_CMD_VALID            = CMD_VALID;
    assign CMD_READY                = EXT_CMD_READY;
  	  assign EXT_MODE                 = MODE;
  	  assign EXT_ROW_INDEX            = ROW_INDEX;
  	  assign EXT_COL_INDEX            = COL_INDEX;
  	  assign EXT_PWM_DATA             = PWM_DATA;
  	  assign EXT_COMPUTE_LAST         = COMPUTE_LAST;
  	  assign EXT_COMPUTE_ALL_COLUMNS  = COMPUTE_ALL_COLUMNS;
    
    // Configuration inputs
  	  assign EXT_TARGET_SET1      = TARGET_SET1;
	  assign EXT_TARGET_SET2      = TARGET_SET2;
    assign EXT_TARGET_RESET1    = TARGET_RESET1;
    assign EXT_TARGET_RESET2    = TARGET_RESET2;
    assign EXT_NO_OF_CLK_CYCLES = NO_OF_CLK_CYCLES;
    assign EXT_COUNTER_VALUE    = COUNTER_VALUE;
    assign EXT_TDC_TIME_OUT     = TDC_TIME_OUT;
    assign EXT_TDC_DEAD_TIME    = TDC_DEAD_TIME;
    
    // Status outputs
    assign BUSY                     = EXT_BUSY;
    assign COMMAND_ACCEPTED         = EXT_COMMAND_ACCEPTED;
    assign COMPUTE_PENDING          = EXT_COMPUTE_PENDING;
    assign ERROR                    = EXT_ERROR;
    assign ERROR_VALID              = EXT_ERROR_VALID;
    assign OPERATION_DONE           = EXT_OPERATION_DONE;
    assign PROGRAM_READBACK_ACTIVE  = EXT_PROGRAM_READBACK_ACTIVE;

    // Result interface
    assign RESULT_VALID     = EXT_RESULT_VALID;
    assign EXT_RESULT_READY = RESULT_READY;
    assign RESULT_DATA      = EXT_RESULT_DATA;
    assign RESULT_LAST      = EXT_RESULT_LAST;

endmodule
